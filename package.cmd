SET PWD=%~dp0
SET PWD=%PWD:~0,-1%

powershell -command "Get-Date -Format \"yyyyMMdd-HHmm\"" > file.tmp
set /p NOW=<file.tmp
DEL file.tmp

powershell -command "Split-Path \"%PWD%\" -leaf" > file.tmp
set /p BNAME=<file.tmp
DEL file.tmp

SET ARCHIVE="%PWD%\..\java-by-the-command-line-%NOW%.tar.gz"

cd "%PWD%\.."
REM tar --exclude=.git --exclude=.gitignore --exclude=.idea -czvf %ARCHIVE% "%BNAME%\*"
tar -czvf %ARCHIVE% "%BNAME%\*"
echo "Archive: " %ARCHIVE%


