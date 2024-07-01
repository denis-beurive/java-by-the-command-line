# Install the JDK and Maven

JDK: https://jdk.java.net/

> You just need to unzip the archive somewhere.

Maven: https://maven.apache.org/download.cgi

> You just need to unzip the archive somewhere.

# Configure the environment (for PowerShell terminal)

Open a PowerShell terminal.

Set the `JAVE_HOME` environment variable. Below, the PowerShell command to do that *locally* (in the current interpreter's window):

	$env:JAVE_HOME = "C:\Users\denis\Documents\java\jdk-22.0.1"

> The value of `JAVA_HOME` is the path to the directory that contains the JDK. This directory contains the following (sub) directories: `bin/` and `lib/` (among others).

Add the path to the Java executable tools (`java.exe`, among others):

	$env:Path += ";C:\Users\denis\Documents\java\jdk-22.0.1\bin"

> You can search for the executable `java.exe`:
> 
> `Get-Childitem –Path 'C:\\' -Include java.exe -File -Recurse -ErrorAction SilentlyContinue | Select-Object FullName | Select-String -Pattern "\\java.exe\}?$" -AllMatches`

Add the path to the Maven executable (`mvn.cmd`):

	$env:Path += ";C:\Users\denis\Documents\java\apache-maven-3.9.7\bin"

> You can search for the executable `mvn.cmd`:
> 
> `Get-Childitem –Path 'C:\\' -Include mvn.cmd -File -Recurse -ErrorAction SilentlyContinue | Select-Object FullName | Select-String -Pattern "\\mvn.cmd\}?$" -AllMatches`

Let `$env:ROOT_DIR` be the top of the project directory. Below, the project structure:

You can put all these setup commands into a startup script. Below, the content of the script [start.ps1](start.ps1):

	$env:JAVE_HOME = "C:\Users\denis\Documents\java\jdk-22.0.1"
	$env:Path += ";C:\Users\denis\Documents\java\jdk-22.0.1\bin"
	$env:Path += ";C:\Users\denis\Documents\java\apache-maven-3.9.7\bin"
	$env:ROOT_DIR=$PSScriptRoot

To "load" this script, execute the following command:

	powershell.exe -NoExit -ExecutionPolicy Bypass -File .\start.ps1

> You can check the environment: `$env:Path; $env:JAVE_HOME; $env:ROOT_DIR`

# Compiling and executing

Using the command line:

* Just one source file: [here](example-1)
* Two source files: [here](example-2)
* Create and execute a JAR: [here](example-3)
* Use a JAR as a library: [here](example-4)
* Create a basic project for Maven: [here](example-5)
* Add and use a library using Maven: [here](example-6)

