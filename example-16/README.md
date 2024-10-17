# Example 16: build an MSI installer with JPackage for a JavaFX application

## Compoile and run

We take the basic code from the [example 11](../example-11).

Compile:

	cd $env:ROOT_DIR
	javac --module-path $env:PATH_TO_FX --add-modules javafx.controls -d .\class .\src\com\beurive\HelloFx.java

Create the JAR:

	jar --create --file=app.jar -C "$env:ROOT_DIR\class" .
	jar --verbose --list --file=.\app.jar

Run the application:

	cd $env:ROOT_DIR\.. # for example
	java -cp $env:ROOT_DIR\app.jar --module-path $env:PATH_TO_FX --add-modules javafx.controls com.beurive.HelloFX

## Package the application using JPackage

In order to package a JavaFX application, **you need the JMOD files** (https://jdk.java.net/javafx23/).

> See: https://inside.java/2023/11/14/package-javafx-native-exec/

Let's install the JMOD files under the directory `$env:PATH_TO_FX_JMODS`.

Example: `$env:PATH_TO_FX_JMODS=C:\Users\denis\Documents\java\javafx-jmods-23.0.1`.

We need to recompile the application using the "JMOD" instead of the modules:

	cd $env:ROOT_DIR
	Remove-Item $env:ROOT_DIR\class\* -Recurse -Force
	mkdir package-files
	javac --module-path $env:PATH_TO_FX_JMODS --add-modules javafx.controls -d .\class .\src\com\beurive\HelloFx.java
	jar --create --file=package-files\app.jar -C "$env:ROOT_DIR\class" .

> Please note:
> * the use of the parameter `--module-path $env:PATH_TO_FX_JMODS`.
> * we put the created JAR file into the directory `package-files`. This directory is used to store all files used by the application (see the option `--input` of JPackage).

Then we need to create 2 directories used by `JPackage`:

	cd $env:ROOT_DIR
	mkdir temp
	mkdir resource-files

> * The directory `temp` is created so that JPackage ca use it to store temporary files.
> * The directory `resource-files` is not used rigth now. It is created for later use, if we need to perform additional tasks, such as adding entries to the registry for example.

Then we call JPackage. Please note the use of options `--module-path` and `--add-modules`.

	$MainClass="com.beurive.HelloFX"
	$MainJar="app.jar"

	Write-Host "64bit process?:"$([Environment]::Is64BitProcess) ;Write-Host "64bit OS?:"$([Environment]::Is64BitOperatingSystem);

	cd "$env:ROOT_DIR"

	Remove-Item $env:ROOT_DIR\temp\* -Recurse -Force
	jpackage --input "package-files" `
	         --resource-dir "resource-files" `
	         --name ex16 `
	         --main-jar "$MainJar" `
	         --main-class "$MainClass" `
	         --module-path "$env:PATH_TO_FX_JMODS" `
	         --add-modules javafx.controls `
	         --win-console `
	         --type msi `
	         --temp temp `
	         --icon data\app.ico `
	         --win-menu `
	         --win-menu-group "example 16" `
	         --win-shortcut-prompt `
	         --win-shortcut `
	         --app-version "1.1.1" `
	         --description "This application illustrates the use of JPackage" `
	         --vendor "Examples corp" `
	         --copyright "GNU" `
	         --verbose
