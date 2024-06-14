# Example 3

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

	&"javac" -d $env:ROOT_DIR\class -cp $env:ROOT_DIR\class @(Get-ChildItem -Recurse -Path $env:ROOT_DIR\src -Filter *.java).FullName

## Creating a JAR file

### With the default Manifest

A default manifest is created. **This manifest does not declare any main class**.

	cd $env:ROOT_DIR\class	
	jar --create --file=app.jar org\beurive\World.class com\beurive\HelloWorld.class

> List the content: `jar --verbose --list --file=.\app.jar`
>
> Test it: `java -cp .\app.jar com.beurive.HelloWorld`

or

	cd $env:ROOT_DIR\class	
	jar --create --file=app.jar .

> List the content: `jar --verbose --list --file=.\app.jar`
>
> Test it: `java -cp .\app.jar com.beurive.HelloWorld`

or

	jar --create --file=app.jar -C "$env:ROOT_DIR\class" org\beurive\World.class -C "$env:ROOT_DIR\class" com\beurive\HelloWorld.class

> `-C`: _change directory to the specified path_.
>
> List the content: `jar --verbose --list --file=.\app.jar`
>
> Test it: `java -cp .\app.jar com.beurive.HelloWorld`

or

	jar --create --file=app.jar -C "$env:ROOT_DIR\class" .

> List the content: `jar --verbose --list --file=.\app.jar`
>
> Test it: `java -cp .\app.jar com.beurive.HelloWorld`

List the content of the JAR file:

	jar --verbose --list --file=.\app.jar

Show the default manifest:

	jar --extract --verbose --file=app.jar META-INF/MANIFEST.MF
	get-content META-INF/MANIFEST.MF

Result:

	Manifest-Version: 1.0
	Created-By: 22.0.1 (Oracle Corporation)

Execute the JAR file:

	java -cp .\app.jar com.beurive.HelloWorld

### With a Manifest that declares the main class

	jar --create --file=app.jar --main-class=com.beurive.HelloWorld -C "$env:ROOT_DIR\class" .

Check the manifest:

	jar --extract --verbose --file=app.jar META-INF/MANIFEST.MF
	get-content META-INF/MANIFEST.MF

Now you can execute the JAR without specifying the entry point:

	java -jar .\app.jar

### Modify an existing JAR Manifest

Take a JAR `app.jar` which manifest does not declare any main class.

The file `manifest.add` contains the fllowing text:

	Main-Class: com.beurive.HelloWorld

Execute this command:

	jar --update --file=app.jar --manifest=manifest.add -C $env:ROOT_DIR\class .

Check the (new) manifest:

	jar --extract --verbose --file=app.jar META-INF/MANIFEST.MF
	get-content META-INF/MANIFEST.MF

Result:

	Manifest-Version: 1.0
	Created-By: 22.0.1 (Oracle Corporation)
	Main-Class: com.beurive.HelloWorld

Now you can execute the JAR without specifying the entry point:

	java -jar .\app.jar

