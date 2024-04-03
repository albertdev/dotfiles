## Making a grep-like output and writing it to disk
How to search in a bunch of log files and write a file which can be loaded in Vim using `:lfile`:

```
Select-String $(Get-Content .\allids.dat) *.log | Out-File -Encoding utf8 -Width 30000 allids.lst
```

## Turning an expression into something like a function
Suppose you have a PowerShell function or script which returns an object. You want to write a JSON file to disk and then output that JSON. This needs
to be invoked often on different files where you don't want to go and modify the snippet you paste into your shell for every file (because you risk
breaking the expression), but you're also too lazy to define a properly named function or might not want to pollute the current session.

One trick is to define a scriptblock with parameters and immediately invoke it:

```
Invoke-Command -ScriptBlock { param($file) .\Get-ProgramVersion.ps1 $file | Convertto-json | out-file -Encoding utf8 result.json ; cat .\result.json ; Write-Output "" } -ArgumentList "c:\path\to\program-release.zip"
```

Now only that last parameter needs changing, which can be easily done using PSReadLine's "UnixWordRubout" (Ctrl+W) shortcut.
