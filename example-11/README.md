# Example 10: using JavaFX - very simple example

## Configure the environment

First, you need to configure the environment as described in this document: [https://openjfx.io/openjfx-docs/#install-javafx](https://openjfx.io/openjfx-docs/#install-javafx). Basically, all you need to do is set the value for the environment variable "`PATH_TO_FX`".

> You need to adapt the PowrShell "start.ps1".

## Compile

	cd $env:ROOT_DIR
	javac --module-path $env:PATH_TO_FX --add-modules javafx.controls -d .\class .\src\com\beurive\HelloFx.java

or:

	cd $env:ROOT_DIR
	javac --module-path $env:PATH_TO_FX --add-modules javafx.controls -d .\class .\src\com\beurive\*

or:

	cd $env:ROOT_DIR
	&"javac" --module-path $env:PATH_TO_FX --add-modules javafx.controls -d $env:ROOT_DIR\class -cp $env:ROOT_DIR\class @(Get-ChildItem -Recurse -Path $env:ROOT_DIR\src -Filter *.java).FullName

## Run the application

	cd $env:ROOT_DIR\.. # for example
	java -cp $env:ROOT_DIR\class --module-path $env:PATH_TO_FX --add-modules javafx.controls com.beurive.HelloFX

> See: [Run HelloWorld using JavaFX SDK](https://openjfx.io/openjfx-docs/install-javafx)

