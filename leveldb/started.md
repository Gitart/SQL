## LevelDB


```go
package main

import (
	"github.com/syndtr/goleveldb/leveldb"
	"fmt"
	"strconv"
	// "time"
	"log"
)


func main(){
	  // batchInsert(1000000)     //10 000 000 ~2 min
	 fmt.Println(GetS("foo:900000"))
}


// Batch insert
func batchInsert(cnt int){
	db, _ := leveldb.OpenFile("db", nil)
   defer db.Close()

	batch := new(leveldb.Batch)

   log.Println("Start")
   for i:=0; i<cnt;i++{
	    s:= strconv.Itoa(i)
	    batch.Put([]byte("foo:"+s), []byte("value = "+s ))
   }
   db.Write(batch, nil)
   log.Println("Finish...")
}


// Добавление
func Test2(){
for i:=0; i<1000;i++{
// fmt.Println("------------",i)
	 // ti:=time.Now().Format("15:40:50")
	 s:= strconv.Itoa(i)
     Add("Z1:"+s,"Привет дорогой друг товарщ ID"+s)
     fmt.Println("------------",s)
}
 
    Add("Z1:TY","Привет дорогой друг товарщ2")
	fmt.Println(GetS("Z1"))

	Add("Z1","Привет дорогой друг товарщ")
	fmt.Println(GetS("Z1"))
}


// Добавление
func Test1(){
	
   Add("Z1:TY","Привет дорогой друг товарщ2")
	fmt.Println(GetS("Z1"))

	Add("Z1","Привет дорогой друг товарщ")
	fmt.Println(GetS("Z1"))
}


// Добавление
func Add(key, val string){
   db, _ := leveldb.OpenFile("db", nil)
   defer db.Close()
   db.Put([]byte(key), []byte(val), nil)
}


// Получение 
func GetS(key string) string {
	db, _ := leveldb.OpenFile("db", nil)
   defer db.Close()
   data, _ := db.Get([]byte(key), nil)
   return string([]byte(data))
}

// Получение 
func Get(key string) []byte {
	db, _ := leveldb.OpenFile("db", nil)
   defer db.Close()
   data, _ := db.Get([]byte(key), nil)
   return []byte(data)
}
```
