
-- Коммерческое предложение
-- commoffer
CREATE TABLE coffer (
	id	         INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	dateadd          TEXT DEFAULT (strftime('%d-%m-%Y %H:%M','now','localtime')),
	duedate          TEXT,        -- дата оплаты - когда должен оплатить 
	customer         TEXT,        -- Заказчик 
	code	         TEXT,        -- код  
	title	         TEXT,        -- Наименование проекта 
	description	 TEXT,        -- Описание
	grp	         TEXT,        -- Группа 
	status	         TEXT,        -- статус (план, выполнен, откланен) 
	sum_total        NUMERIC,     -- Общая сумма
	sum_nds          NUMERIC,     -- Сумма без НДС 
	nds              NUMERIC,     -- Сумма НДС
	remark           TEXT         -- Примечание
);



-- Состоит коммерческое предложение
CREATE TABLE coitem (
	id	         INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	idoffer          integer,            -- связь с основной таблицей 
	code	         TEXT,               -- код   
	title	         TEXT,               -- Наименование товара, услуги 
	pic    	         TEXT,               -- линк на картинку  
	link   	         TEXT,               -- ссылка в интернете
	description	 TEXT,               -- описание
	grp	         TEXT,               -- Работа, товар, программное обеспечение  
	status	         TEXT,               -- статус (оплачен, неоплачен)  
	price 	         NUMERIC,            -- цена за единицу 
	qty 	         NUMERIC,            -- количество 
	sum 	         NUMERIC,            -- общая сумма  
	nds              NUMERIC,            -- сумма НДС
        remark           TEXT	             -- примечание 
);


-- Обновление
CREATE TRIGGER coitem_trg 
UPDATE OF qty ON coitem

BEGIN
    -- Обновление в текущей таблице суммарное поле
    UPDATE coitem 
	SET    sum = NEW.price * NEW.qty,                                                                   -- Текущая сумма
	       nds = (NEW.price * NEW.qty) * 0.2                                                            -- c HДС  /6  , без НДС *0.2 
	
	WHERE  id  = OLD.id; 

    -- Обновление в связной таблице общей суммы по текущему заказу
    UPDATE coffer 
    SET    sum_total = (SELECT SUM(sum)   FROM coitem  WHERE idoffer = OLD.idoffer),                -- Общая сумма
	   cnt_item  = (SELECT COUNT(sum) FROM coitem  WHERE idoffer = OLD.idoffer),                -- количество записей
	   sum_nds   = (SELECT COUNT(sum) FROM coitem  WHERE idoffer = OLD.idoffer)*0.2             -- НДС
    WHERE  id        = (SELECT idoffer    FROM coitem  WHERE id      = OLD.id) ;
	
    -- Запись в лог файл
    INSERT INTO logs (dat,operation) VALUES (DATETIME('now'), "Обновление выполненно успешно");
END;
