# Example 3: create and execute a JAR

## Compilation using the command line

	$env:ROOT_DIR
	    │
		└───src
		    ├───com
		    │   └───beurive
		    │           HelloWorld.java
		    │
		    └───org
		        └───beurive
		                World.java

Compilation:

```powershell
&"javac" -d $env:ROOT_DIR\class -cp $env:ROOT_DIR\class @(Get-ChildItem -Recurse -Path $env:ROOT_DIR\src -Filter *.java).FullName
```

## Creating a JAR file

### With the default Manifest

A default manifest is created. **This manifest does not declare any `main` method** (the `main` method 
is the application's entry point).
Thus, if you want to "execute the JAR file", then you need to tell the JVM which class contains the `main` method.

```powershell
cd $env:ROOT_DIR\class	
jar --create --file=app.jar org\beurive\World.class com\beurive\HelloWorld.class
```

> List the content: `jar --verbose --list --file=.\app.jar`
>
> Test it: `java -cp .\app.jar com.beurive.HelloWorld`

or

```powershell
cd $env:ROOT_DIR\class	
jar --create --file=app.jar .
```

> List the content: `jar --verbose --list --file=.\app.jar`
>
> Test it: `java -cp .\app.jar com.beurive.HelloWorld`

or

```powershell
cd $env:ROOT_DIR\.. # for example
jar --create --file=app.jar -C "$env:ROOT_DIR\class" org\beurive\World.class -C "$env:ROOT_DIR\class" com\beurive\HelloWorld.class
```

> `-C`: _change directory to the specified path_.
>
> You note that the option "`-C`" is used twice (`-C "$env:ROOT_DIR\class" org\beurive\World.class -C "$env:ROOT_DIR\class" com\beurive\HelloWorld.class`).
> This is not an error.
>
> List the content: `jar --verbose --list --file=.\app.jar`
>
> Test it: `java -cp .\app.jar com.beurive.HelloWorld`

or

```powershell
jar --create --file=app.jar -C "$env:ROOT_DIR\class" .
```

> List the content: `jar --verbose --list --file=.\app.jar`
>
> Test it: `java -cp .\app.jar com.beurive.HelloWorld`

List the content of the JAR file:

```powershell
jar --verbose --list --file=.\app.jar
```

Show the default manifest:

```powershell
jar --extract --verbose --file=app.jar META-INF/MANIFEST.MF
get-content META-INF/MANIFEST.MF
```

Result:

```powershell
Manifest-Version: 1.0
Created-By: 22.0.1 (Oracle Corporation)
```

"Execute" the JAR file:

```powershell
java -cp .\app.jar com.beurive.HelloWorld
```

### With a Manifest that declares the main class

```powershell
jar --create --file=app.jar --main-class=com.beurive.HelloWorld -C "$env:ROOT_DIR\class" .
```

Check the manifest:

```powershell
jar --extract --verbose --file=app.jar META-INF/MANIFEST.MF
get-content META-INF/MANIFEST.MF
```

Now you can "execute" the JAR without specifying the entry point:

```powershell
java -jar .\app.jar
```

### Modify an existing JAR Manifest

Take a JAR `app.jar` which manifest does not declare any main class.

The file `manifest.add` contains the fllowing text:

```powershell
Main-Class: com.beurive.HelloWorld
```

Execute this command:

```powershell
jar --update --file=app.jar --manifest=manifest.add -C $env:ROOT_DIR\class .
```

Check the (new) manifest:

```powershell
jar --extract --verbose --file=app.jar META-INF/MANIFEST.MF
get-content META-INF/MANIFEST.MF
```

Result:

```powershell
Manifest-Version: 1.0
Created-By: 22.0.1 (Oracle Corporation)
Main-Class: com.beurive.HelloWorld
```

Now you can "execute" the JAR without specifying the entry point:

```powershell
java -jar .\app.jar
```

