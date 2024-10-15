# Example 15: build an MSI installer with JPackage

Let's take the simple Java application built from [example 3](../example-3).

# Compile the application

Create the JAR that contains the application:

	&"javac" -d $env:ROOT_DIR\class -cp $env:ROOT_DIR\class @(Get-ChildItem -Recurse -Path $env:ROOT_DIR\src -Filter *.java).FullName
	cd $env:ROOT_DIR\class	
	jar --create --file=app.jar org\beurive\World.class com\beurive\HelloWorld.class


# Create the installer

Let's create an MSI installer:

    $MainClass="com.beurive.HelloWorld"
    $MainJar="app.jar"

    jpackage --input . `
             --name ex15 `
             --main-jar "$MainJar" `
             --main-class "$MainClass" `
             --win-console `
             --type msi

With:

* `--input`: Path of the input directory that contains the files to be packaged (absolute path or relative to the current directory).
  All files in the input directory will be packaged into the application image.
* `--name`: Name of the application.
* `--main-jar`: The main JAR of the application; containing the main class (specified as a path relative to the input path).
* `--main-class`: Qualified name of the application main class to execute.
* `--win-console`: Creates a console launcher for the application, should be specified for application which requires console interactions.
* `--type`: Valid values are: {"app-image", "exe", "msi", "rpm", "deb", "pkg", "dmg"}

> See [The jpackage Command](https://docs.oracle.com/en/java/javase/23/docs/specs/man/jpackage.html) (_for JDK 23_).

This above command should create the file `ex15-1.0.msi`.

Once installed, the application should be find under the directory `C:\Program Files\ex15`.

We can run the application: `"C:\Program Files\ex15\ex15"`.

# Customize the PATH environment variable

OK, but we also need to set the `PATH` environment variable so that we can call the application from everywhere.

> See [JPackage update "PATH" environment variable](https://stackoverflow.com/questions/67784565/jpackage-update-path-environment-variable)

    $MainClass="com.beurive.HelloWorld"
    $MainJar="app.jar"
    $TempDir=([System.IO.Path]::GetTempPath()+'~'+([System.IO.Path]::GetRandomFileName())).Split('.')[0]
    "The temporary directory is: $TempDir"

    jpackage --input . `
             --name ex15 `
             --main-jar "$MainJar" `
             --main-class "$MainClass" `
             --win-console `
             --type msi `
             --temp "$TempDir"

With:

* `--temp`: Path of a new or empty directory used to create temporary files (absolute path or relative to the current directory).

> *WARNING*
>
> Do not specify the "temporary directory" (`--temp`) under the "input directory" (`--input`) ! Otherwise, you will
> get an infinite number of nested directories! _And you will have a hard time to figure out how the delete all!_
>
> Just in case you need to delete an extremely deep directory tree:
>
> ```python
> import os
> from typing import Final
> 
> root_directory: Final[str] = "C:\\Users\\denis\\Documents\\github\\java-by-the-command-line\\example-15\\temp"
> 
> def explore_tree(root: str) -> None:
>     for path, _, files in os.walk(root, topdown=False):
>         for name in files:
>             p: str = os.path.join(path, name)
>             print(f"del {p}")
>             os.remove(f"{os.path.join(path, name)}")
>         print(f"\nremove {path}\n")
>         os.rmdir(path)
> 
> explore_tree(root_directory)
> ```

Copy the configuration file `main.wxs`.

    Get-Content "$TempDir\config\main.wxs"
    cp "$TempDir\config\main.wxs" main.wxs
    Remove-Item "$TempDir" -Recurse -Force


