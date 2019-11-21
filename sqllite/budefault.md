## Cretaed table wit field by deafult current time format 

```sql
CREATE TABLE `A0` (
	`Id`	     INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	`Datanow`    CHAR DEFAULT (strftime('%d - %m - %Y %H:%M:%S ','now','localtime')),
	`Seconds`    TEXT DEFAULT (strftime('%s-%W','now','localtime'))
);
```

## In contrusctor db admin
```sql
=(strftime('%d - %m - %Y %H:%M:%S ','now','localtime'))
```
## Remark  
If not set 'localtime' be no cuurent time +- 2 hource!

## Date And Time Functions

SQLite supports five date and time functions as follows:

1.  **date(***timestring, modifier, modifier, ...***)**
2.  **time(***timestring, modifier, modifier, ...***)**
3.  **datetime(***timestring, modifier, modifier, ...***)**
4.  **julianday(***timestring, modifier, modifier, ...***)**
5.  **strftime(***format, timestring, modifier, modifier, ...***)**

All five date and time functions take a time string as an argument. The time string is followed by zero or more modifiers. The strftime() function also takes a format string as its first argument.

The date and time functions use a subset of [IS0\-8601](http://en.wikipedia.org/wiki/ISO_8601) date and time formats. The date() function returns the date in this format: YYYY\-MM\-DD. The time() function returns the time as HH:MM:SS. The datetime() function returns "YYYY\-MM\-DD HH:MM:SS". The julianday() function returns the [Julian day](http://en.wikipedia.org/wiki/Julian_day) \- the number of days since noon in Greenwich on November 24, 4714 B.C. ( [Proleptic Gregorian calendar](http://en.wikipedia.org/wiki/Proleptic_Gregorian_calendar)). The strftime() routine returns the date formatted according to the format string specified as the first argument. The format string supports the most common substitutions found in the [strftime() function](http://opengroup.org/onlinepubs/007908799/xsh/strftime.html) from the standard C library plus two new substitutions, %f and %J. The following is a complete list of valid strftime() substitutions:


| **Format**   | **Equivalent strftime()** |
| --- | ----- |
| %d |   day of month: 00 |
| %f |   fractional seconds: SS.SSS |
| %H |   hour: 00\-24 |
| %j |   day of year: 001\-366 |
| %J |   Julian day number |
| %m |   month: 01\-12 |
| %M |   minute: 00\-59 |
| %s |   seconds since 1970\-01\-01 |
| %S |   seconds: 00\-59 |
| %w |   day of week 0\-6 with Sunday==0 |
| %W |   week of year: 00\-53 |
| %Y |   year: 0000\-9999 |
| %% |   % |

Notice that all other date and time functions can be expressed in terms of strftime():

| **Function**   | **Equivalent strftime()** |
| --- | ----- |
| date(...)      | strftime('%Y\-%m\-%d', ...) |
| time(...)      | strftime('%H:%M:%S', ...) |
| datetime(...)  | strftime('%Y\-%m\-%d %H:%M:%S', ...) |
| julianday(...) | strftime('%J', ...) |
