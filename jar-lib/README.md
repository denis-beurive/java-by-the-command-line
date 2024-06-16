# A simple JAR file

Compile the library:

```powershell
&"javac" -d $env:ROOT_DIR\class @(Get-ChildItem -Recurse -Path $env:ROOT_DIR\src -Filter *.java).FullName
```

> or just: javac -d $env:ROOT_DIR\class $env:ROOT_DIR\src\org\assoc\Math.java
>
> `-d`: Sets the destination directory (or class output directory) for class files.

Create the JAR file:

```powershell
jar --create --file=math.jar -C "$env:ROOT_DIR\class" .
```

Check the content of the JAR file:

```powershell
jar --verbose --list --file=math.jar
```

Result:

	     0 Sun Jun 16 12:45:48 CEST 2024 META-INF/
	    66 Sun Jun 16 12:45:48 CEST 2024 META-INF/MANIFEST.MF
	     0 Sun Jun 16 12:23:08 CEST 2024 org/
	     0 Sun Jun 16 12:23:08 CEST 2024 org/assoc/
	   250 Sun Jun 16 12:45:38 CEST 2024 org/assoc/Math.class

