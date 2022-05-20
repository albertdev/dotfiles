== Making a grep-like output and writing it to disk
How to search in a bunch of log files and write a file which can be loaded in Vim using `:lfile`:

```
Select-String $(Get-Content .\allids.dat) *.log | Out-File -Encoding utf8 -Width 30000 allids.lst
```
