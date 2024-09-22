# Exemple 4: use a JAR as a library

This example shows how to use a JAR file as a library.

```powershell
jar --verbose --list --file=lib\math.jar
```

Result:

	     0 Sun Jun 16 12:45:48 CEST 2024 META-INF/
	    66 Sun Jun 16 12:45:48 CEST 2024 META-INF/MANIFEST.MF
	     0 Sun Jun 16 12:23:08 CEST 2024 org/
	     0 Sun Jun 16 12:23:08 CEST 2024 org/assoc/
	   250 Sun Jun 16 12:45:38 CEST 2024 org/assoc/Math.class

Compile the Java source:

```powershell
&"javac" -d $env:ROOT_DIR\class -cp ".\class;.\lib\math.jar" @(Get-ChildItem -Recurse -Path $env:ROOT_DIR\src -Filter *.java).FullName
```

> **Warning**: don't forget to put quotes around the value of the "`-cp`" option.
> If you don't put quotes, then the PowerShell interpreter will interpret the text "`.\lib\math.jar`" as a command.

Execute the class:

```powershell
java -cp ".\class;.\lib\math.jar" Main
```

Create a JAR that contains the application:

```powershell
jar --create --file=app.jar -C ./class .
```

Execute the application:

```powershell
java -cp ".\app.jar;.\lib\math.jar" Main
```

Let's declare the Main class and the class-path into the JAR manifest.

```powershell
PS C:\Users\denis> get-content manifest.add
Main-Class: Main
Class-Path: ./lib/math.jar

PS C:\Users\denis> jar --update --file=app.jar --manifest=manifest.add -C .\class .
```

Now, you can execute the JAR directry: 

```powershell
java -jar .\app.jar
```

> However, it should be better to add the JAR "`math.jar`" into the JAR "`app.jar`".
> But it is not possible to do so, unless you change the class loader.

