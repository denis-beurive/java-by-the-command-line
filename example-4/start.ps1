# Usage:
# powershell.exe -NoExit -ExecutionPolicy Bypass -File .\start.ps1

$env:JAVE_HOME = "C:\Users\denis\Documents\java\jdk-22.0.1"
$env:Path += ";C:\Users\denis\Documents\java\jdk-22.0.1\bin"
$env:Path += ";C:\Users\denis\Documents\java\apache-maven-3.9.7\bin"
$env:ROOT_DIR=$PSScriptRoot
