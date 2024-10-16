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
    cd "$env:ROOT_DIR"

    # Create the directory that contains the files to package.
    mkdir "package-files"
    mv app.jar "package-files"

    jpackage --input "package-files" `
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

    cd "$env:ROOT_DIR"

    # Create the directory that contains the files to package.
    mkdir "package-files"
    mv app.jar "package-files"

    jpackage --input "package-files" `
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

Copy the configuration file `main.wxs` (the WIX main project file).

    Get-Content "$TempDir\config\main.wxs"
    cp "$TempDir\config\main.wxs" main.wxs
    Remove-Item "$TempDir" -Recurse -Force

Then, we need to customize the WIX main project file (`main.wxs`), as mentioned in the [previously mentioned link](https://stackoverflow.com/questions/67784565/jpackage-update-path-environment-variable). Please note that we copy the procedure here in order to make sure that it won't disappear.

Replace:

```xml
<Feature Id="DefaultFeature" Title="!(loc.MainFeatureTitle)" Level="1">
  <ComponentGroupRef Id="Shortcuts"/>
  <ComponentGroupRef Id="Files"/>
  <ComponentGroupRef Id="FileAssociations"/>
</Feature>
```

By:

```xml
<Feature Id="DefaultFeature" Title="!(loc.MainFeatureTitle)" Level="1">
  <ComponentGroupRef Id="Shortcuts"/>
  <ComponentGroupRef Id="Files"/>
  <ComponentGroupRef Id="FileAssociations"/>
  <Component Id="pathEnvironmentVariable" Guid="{YOUR_GUID}" KeyPath="yes" Directory="TARGETDIR">
    <Environment Id="MyPathVariable" Name="Path" Value="[INSTALLDIR]" Action="set" System="no" Permanent="no" Part="last" Separator=";" />
  </Component>
</Feature>
```

Make sure to replace `YOUR_GUID` with the GUID generated with the [generator tool](https://www.guidgen.com/).

Create the directory where you put all the resource files for WIX. Then put the WIX main project file (`main.wxs`) in this directory.

    cd "$env:ROOT_DIR"
    mkdir "resource-files"
    mv main.wxs "resource-files"

Then rebuild the MSI installer. But this time, you set the path to the directory that contains the resources.

    $MainClass="com.beurive.HelloWorld"
    $MainJar="app.jar"

    cd "$env:ROOT_DIR"

    jpackage --input "package-files" `
             --resource-dir "resource-files" `
             --name ex15 `
             --main-jar "$MainJar" `
             --main-class "$MainClass" `
             --win-console `
             --type msi `
             --temp temp `
             --verbose

> Please note that we don't have to specify the path to a temporary directory (`--temp`) because we don't need it.

> Please note the output:
> 
> ```
> [10:23:16.558] Using custom package resource [Main WiX project file] (loaded from main.wxs).
> [10:23:16.558] Using default package resource overrides.wxi [Overrides WiX project file] (add overrides.wxi to the resource-dir to customize).
> ```

# Add file association

We want to add an item in the context menu that appears when the user right-clicks a file in File Explorer.

To do that, add the following XML bloc wihtin the tags `<Feature></Feature>` (in the file ).

```xml
      <!-- Configure the registry in order to integrate the application into the Explorer popup menu -->
      <Component Id='RegistryKeyFileAsoc' Guid='ef396834-58d5-45a2-ae66-e465f8338b38' Directory="INSTALLDIR">
        <!-- Specify the text and icon of the item that appears in the context menu when the user right-clicks
             a file in File Explorer -->
        <RegistryKey Root="HKCR" Key="*\shell\ex15" Action="create">
          <RegistryValue Type="string" Value="Exécuter ex15" KeyPath="yes" />
          <!-- <RegistryValue Name="Icon" Type="string" Value="C:\\PRG.exe,0" /> -->
        </RegistryKey>

        <!-- Specify the command to execute when the user selects the application in the context menu -->
        <RegistryKey Root="HKCR" Key="*\shell\ex15\command" Action="create">
          <RegistryValue Type="string" Value="&quot;[INSTALLDIR]ex15.exe&quot; &quot;%1&quot;" />
        </RegistryKey>
      </Component>
```

> Please, keep in mind that you must change the values for the parameters `Guid` (with the [generator tool](https://www.guidgen.com/).

The complete WIX main project file (`main.wxs`) is accessible [here](doc/main.wxs).

The result of this configuration can be seen in the registry by executing the command below:

    reg query HKCR /f "ex15" /s

Result:

![](doc/ex15-reg-query-1.png)

