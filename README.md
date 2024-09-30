# Install the JDK and Maven

JDK: https://jdk.java.net/

> You just need to unzip the archive somewhere.

Maven: https://maven.apache.org/download.cgi

> You just need to unzip the archive somewhere.

# Configure the environment (for PowerShell terminal)

Open a PowerShell terminal.

> You can run the following command from a CMD console: `powershell`.

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

To "load" this script, execute the following command (from a CMD or a PoweShell terminal, for example):

	powershell.exe -NoExit -ExecutionPolicy Bypass -File .\start.ps1

> You can check the environment: `$env:Path; $env:JAVE_HOME; $env:ROOT_DIR`

If you need to configure more than one environment, then you can adapt the script to make it handle your needs:

	# Usage:
	#
	#    powershell.exe -NoExit -ExecutionPolicy Bypass -File .\start.ps1 [-env (env1|env2)]
	# 
	# Examples:
	#
	#    powershell.exe -NoExit -ExecutionPolicy Bypass -File .\start.ps1 -env env1
	#    powershell.exe -NoExit -ExecutionPolicy Bypass -File .\start.ps1 -env env2

	param([String]$env="env1") 

	Write-Host ([string]::Format("env = {0}", $env))

	if ($env -eq "env1") {
		$env:JAVE_HOME = "C:\Users\denis\Documents\java\jdk-22.0.1"
		$env:Path += ";C:\Users\denis\Documents\java\jdk-22.0.1\bin"
		$env:Path += ";C:\Users\denis\Documents\java\apache-maven-3.9.7\bin"
		$env:ROOT_DIR=$PSScriptRoot
	} elseif ($env -eq "env2") {
		$env:JAVE_HOME = "C:\Users\denis.beurive\Documents\java\jdk-23"
		$env:Path += ";C:\Users\denis.beurive\Documents\java\jdk-23\bin"
		$env:Path += ";C:\Users\denis.beurive\Documents\java\apache-maven-3.9.9\bin"
		$env:ROOT_DIR=$PSScriptRoot	
	} else {
		Write-Host "==========================================================="
		Write-Host ([string]::Format("Invalid environment ID `"{0}`"!", $env))
		Write-Host "The environment is not set properly !!!"
		Write-Host "==========================================================="
		Exit
	}

# Compiling and executing

Using the command line:

* Just one source file: [here](example-1)
* Two source files: [here](example-2)
* Create and execute a JAR: [here](example-3)
* Use a JAR as a library: [here](example-4)
* Create a basic project for Maven: [here](example-5)
* Add and use a library using Maven: [here](example-6)
* Create one module using Javac compiler directly: [here](example-7)
* Create 2 modules using Javac compiler directly, one module depends on the other: [here](example-8)
* Create a "Java module" using Maven: [example-9](example-9)
* Using the Maven compiler and the assembly modules: [example-10](example-10)
* Using JavaFX - very simple example: [example-11](example-11)
* Using JavaFX with Maven - very simple example: [example-12](example-12)

# Good notes

* [Maven Exec Plugin: yhy should I use `exec:exec` to run Java when `exec:java` exists?](notes/note-exec-1.md)
* [Configure the Maven Exec Plugin](notes/note-exec-2.md)
* [Configure the Maven compiler plugin](notes/note-compiler-1.md)
* [What is the difference in Maven between dependency and plugin tags in pom.xml?](https://stackoverflow.com/questions/11881663/what-is-the-difference-in-maven-between-dependency-and-plugin-tags-in-pom-xml)
* Where to find projects' archetypes ? [https://mvnrepository.com/artifact/org.apache.maven.archetypes/maven-archetype-simple](https://mvnrepository.com/artifact/org.apache.maven.archetypes/maven-archetype-simple)

# Troubleshooting

Execute in DEBUG mode:

	mvn -X ...

Check the package name for a given "`.class`" file:

	javap -c .\App.class

Show the class paths at compile time:

	mvn dependency:build-classpath -DincludeScope=compile

Show the class paths during tests:

	mvn dependency:build-classpath -DincludeScope=test
