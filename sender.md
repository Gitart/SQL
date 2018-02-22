## Send

```sql
USE [Wir]
GO
/****** Object:  Trigger [dbo].[UpdateTaxi]    Script Date: 02/07/2014 15:51:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
  Author:          Савченко Артур
  Create date:   04-09-2009
  Change date:   07-02-2014
  Description:     Процесс утверждения - отклонения заявки на такси
*/

ALTER TRIGGER [dbo].[UpdateTaxi]
          ON  [dbo].[W_Taxi]
         FOR  UPDATE
AS

-- Определение переменных
DECLARE @Dep                Int             -- Код отдела в справочнике
DECLARE @Serv               Nvarchar(100)   -- Имя в сети
DECLARE @Depchif            Nvarchar(100)   -- Наименование департмента
DECLARE @Fio                Nvarchar(100)   -- Фио сотрудника в справочнике
DECLARE @Emp                Nvarchar(100)   -- Имя сотрудника в сети
DECLARE @Depname            Nvarchar(100)   -- Наименование отдела
Declare @Approval           Int             -- Признак подтверждения диретором
Declare @ID                 Int             -- Номер закза в системе
DECLARE @Nomer              Int             -- Номер заявки в системе
DECLARE @Reason             Nvarchar(200)   -- Причина поездки
DECLARE @Marchrut           Nvarchar(200)   -- Маршрут
DECLARE @DateWork           Datetime        -- Дата планируемой поездки
DECLARE @DataStr            Nvarchar(MAX)   -- Тело письма для нашей компании
DECLARE @DataStrTaxi        Nvarchar(2000)  -- Тело письма для службы такси
DECLARE @TemaPisma          Nvarchar(100)   -- Тема письма
DECLARE @UserMail           Nvarchar(100)   -- Адрес инициатора
DECLARE @reasons            Nvarchar(100)   -- Причина отказа если была
DECLARE @Dateorders         Datetime        -- Дата заказа
DECLARE @Employee           Nvarchar(100)   -- Сотрудник
DECLARE @Meta               Nvarchar(200)   -- мета
DECLARE @Lins               Int             -- Длина имени пользователя
DECLARE @Numberstr          Nvarchar(20)    -- Номер строковой для
DECLARE @EmployeefullName   Nvarchar(100) --Имя сотрудника и фамилия
DECLARE @PositionName       Nvarchar(100) --Имя сотрудника и фамилия

-- Определение данных для сообщения
SELECT @id               = id,
       @Emp              = Employee,
       @Approval         = Approval,
       @reasons          = Reasons,
       @Meta             = Meta,
       @Marchrut         = Marchrut,
       @DateWork         = DateWork ,
       @EmployeefullName = Employee1
  FROM Inserted

-- Получение данных о заказчике
   SELECT @Depname        = Department_name,
          @Fio            = Fio_full,
          @PositionName   = Position_name,
          @UserMail       = Emailwork
   FROM   WTS.DBO.A_user
   WHERE  Serv            = @Emp

-- Получение адреса шефа
   SELECT @Depchif = Emailwork
   FROM   WTS.DBO.A_user
   WHERE  ID       = @Approval

-- SELECT * FROM  WTS.DBO.a_User
-- Получение департмента
/* SELECT @Depchif = MailBoss, @Depname = Naz  FROM WTS.DBO.S_Department  WHERE ID       = @Dep */
-- SELECT @Depname = Naz    FROM WTS.DBO.S_Department  WHERE ID       = @Dep
-- SELECT * FROM WTS.DBO.S_Department
-- SELECT * FROM W_TAXI

-- Преобразование номера замовлення такси в символьную переменную
-- В теле письма єтого делать нельзя (т.к. могут быть пустые выравжения)
SET @Numberstr    = CONVERT(NVARCHAR(20),@Id)

-- Если менялся стаус замовлення
IF UPDATE (Approval)
   BEGIN
        -- УТВЕРЖДЕНА
        IF  @Approval=1
            BEGIN
                 -- Тема письма для нас и для службы такси
                 SET @TemaPisma = 'Замовлення на таксі від "Wir Ukraine" номер ' + @Numberstr + ' затверджено'

-- Формирование тела сообщения для утверждения директором
SET @DataStr = '<HTML dir="ltr">
                 <HEAD>
                       <meta http-equiv="Content-Language" content="ua">
                       <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
                       <title>Winner System Doc Flow</title>

                       <style type="text/css">
                              .s1{display:block; width:700px; font-family:calibri; background-color:yellow; }
                              .s2{display:block; width:400px; font-family:calibri;}
                       </style>
                  </HEAD>
                  <BODY> ' +
                         '<strong style="color:#3399FF; font-family:calibri; font-size:20px;">Замовлення на поїздку службою таксі # ' +  ISNULL (@Numberstr,'NA')   + '</strong><br>' +
                         '<hr style="width:400px; float:left; text-align:left; color:#3399FF;"><pre> ' +
                         'Працівник______________________ <strong>' + ISNULL (@Fio,'')                              + '</strong> <br> ' +
                         'Посада_________________________ <strong>' + ISNULL (@Positionname,'')                     + '</strong> <br> ' +
                         'Мета поїздки___________________ <strong>' + ISNULL (@Meta,    'Треба з`ясувать мету')     + '</strong> <br> ' +
                         'Маршрут _______________________ <strong>' + ISNULL (@Marchrut,'Треба зясувать маршрут')   + '</strong> <br> ' +
                         'Дата запланованої поїздки______ <strong>' + ISNULL (CONVERT(NVARCHAR(30), @DateWork),'')  + '</strong> <br> ' +
                         'Статус_________________________ <strong style="font-size:20px;color:green;">ЗАТВЕРДЖЕНО</strong><br>' +
                         '</pre>' +
                         '<h4><a href="http://portal.wir.ua/Apps/Taxi/taxiapproval.aspx?id=' + @Numberstr + '&m=0">Вашу заявку можна побачіть тут</a></h4> <br><br>'  +
                         '<small>З повагою,cистема єлектронного документообігу. <br><br> Winner Imports Ukraine - ' + CONVERT(NVARCHAR(4),YEAR(GETDATE())) + '</small>' +
                 '</BODY>' +
                 '</HTML>'

              -- Сообщение админотделу
                 EXEC SENDERERS 'Asurzhavska@wier.com', @TemaPisma, @DataStr

              -- Проверка рассылки
                 EXEC SENDERERS 'asavchenko@wier.com',  @TemaPisma,  @Datastr

              -- Сообщение смамому пользователю о подтвержденной заявке
                 EXEC SENDERERS  @UserMail, @TemaPisma, @Datastr

                 UPDATE W_TAXI
                 SET    Department = @Dep,
                        DepName    = @Depname,
                        Employee1  = @Fio,
                        Priznak    = 1
                  WHERE ID         = @id
   END

      -- ОТКЛОНЕННА
     IF  @Approval=2
             BEGIN
                 -- Тема письма для нас и для службы такси
                 SET @TemaPisma = 'Замовлення на таксі від "Wier Ukraine" номер ' + @Numberstr + ' відмовлено'

-- Формирование тела сообщения для утверждения директором
SET @DataStr = '<HTML dir="ltr">
                 <HEAD>
                       <meta http-equiv="Content-Language" content="ua">
                       <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
                       <title>Winner System Doc Flow</title>

                       <style type="text/css">
                              .s1{display:block; width:700px; font-family:calibri; background-color:yellow; }
                              .s2{display:block; width:400px; font-family:calibri;}
                       </style>
                  </HEAD>
                  <BODY> ' +
                         '<strong style="color:#3399FF; font-family:calibri; font-size:20px;">Замовлення на поїздку службою таксі # ' +  ISNULL (@Numberstr,'NA')   + '</strong><br>' +
                         '<hr style="width:400px; float:left; text-align:left; color:#3399FF;"><pre> ' +
                         'Працівник______________________ <strong>' + ISNULL (@Fio,'')                              + '</strong> <br> ' +
                         'Посада_________________________ <strong>' + ISNULL (@Positionname,'')                     + '</strong> <br> ' +
                         'Мета поїздки___________________ <strong>' + ISNULL (@Meta,    'Треба з`ясувать мету')     + '</strong> <br> ' +
                         'Маршрут _______________________ <strong>' + ISNULL (@Marchrut,'Треба зясувать маршрут')   + '</strong> <br> ' +
                         'Дата запланованої поїздки______ <strong>' + ISNULL (CONVERT(NVARCHAR(30), @DateWork),'')  + '</strong> <br> ' +
                         'Статус замовлення______________ <strong style="font-size:20px;color:red;">ВІДМОВЛЕНО</strong><br>' +
                         '</pre>' +
                         '<h4><a href="http://portal.wier.ua/Apps/Taxi/taxiapproval.aspx?id=' + @Numberstr + '&m=0">Причину відмови можна побачіть тут</a></h4> <br><br>'  +
                         '<small>З повагою,cистема єлектронного документообігу. <br><br> Winner Imports Ukraine - ' + CONVERT(NVARCHAR(4),YEAR(GETDATE())) + '</small>' +
                 '</BODY>' +
                 '</HTML>'

                 -- Сообщение мне для контроля
                 EXEC SENDERERS 'asavchenko@wier.ua',    @TemaPisma,  @Datastr

                 -- Сообщение смамому пользователю о подтвержденной заявке
                 EXEC SENDERERS  @UserMail, @TemaPisma, @Datastr

                 -- Обновление такси
                 UPDATE W_TAXI
                 SET    Department = @Dep,
                        DepName    = @depname,
                        Employee1  = @Fio,
                        Priznak    = 2
                        WHERE   ID = @ID

   END
END

-- Обновление информации по заказу такси основной информацией
  UPDATE  T
  SET     T.ID_EMPLOYEE  = U.ID,
          T.Employee1    = U.FIO_FULL,
          T.Department   = U.Dep,
          T.Costcenter   = U.Costcenter,
          T.Status       =  CASE T.Approval  WHEN -1 THEN 'Waiting'
                                             WHEN  1 THEN 'Approval'
                                             WHEN  2 THEN 'Reject'
                                             WHEN  0 THEN 'Other'
                                             ELSE         'Unknown'
                              END
  FROM    W_TAXI     T,
          A_WTS_USER U
  WHERE   T.EMPLOYEE = U.SERV
  AND     T.ID = @ID
  ```
