# Csv_to_object
## csv
```
name,age,city
gaurav,23,karnal
vilok,23,hissar
a,25,aaaa
b,26,bbbb
```
## Input 
## => Output
* row object
```sh
data_array = CsvConverter.new(filename)
p data_array
=> #<CsvConverter:0x0000560f185b0158 @filename="person.csv",@filerows=[#<Person:0x0000560f181530b0 @name="gaurav", @age="23", @city="karnal">, #<Person:0x0000560f18157958 @name="vilok", @age="23",@city="hissar">, #<Person:0x0000560f1815f158 @name="person3",@age="25",@city="city3">, #<Person:0x0000560f18184048@name="person4", @age="26", @city="city4">]>
```

## single row object
```sh
p data_array.filerows[1]
=> #<Person:0x000055b511b73830 @name="vilok", @age="23", @city="hissar">
```

## row object methods
```
p data_array.filerows[0].name
=> "gaurav"
p data_array.filerows[0].age
=> "23"
p data_array.filerows[0].city
=> "karnal"
```
