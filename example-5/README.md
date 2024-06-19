# Example 5

URL: https://www.tutorialspoint.com/maven/maven_overview.htm

Create a basic directory structure for the project:

```powershell
mvn archetype:generate `
    "-DgroupId=org.beurive.project_group" `
    "-DartifactId=project" `
    "-DarchetypeArtifactId=maven-archetype-quickstart" `
    "-DarchetypeVersion=1.4" `
    "-DinteractiveMode=false"

mvn dependency:resolve-plugins

```

> Please note that:
>
> Maven stores all software components into the directory `$env:HOMEPATH\.m2`.
> You can remove this directory: `Remove-Item -LiteralPath "$env:HOMEPATH\.m2" -Force -Recurse`
>
> You can see the "full" Maven XML specification.
> 
> ```powershell
> cd project
> mvn -B help:effective-pom
> # or
> @(mvn -B help:effective-pom | Select-String -Pattern "^(\[INFO\]|Effective POMs)" -NotMatch | Out-String).Trim()
> ```

The created directory structure is:

    $env:ROOT_DIR
        │
        └───project
            │   pom.xml
            │
            └───src
                ├───main
                │   └───java
                │       └───org
                │           └───beurive
                │               └───project-group
                │                       App.java
                │
                └───test
                    └───java
                        └───org
                            └───beurive
                                └───project-group
                                        AppTest.java


Before you can compile the project, you probably need to change the file `pom.xml`.

Since:

```powershell
PS C:\> javac --version
javac 22.0.1
```

Set the `pom.xml` to:

```xml
  <properties>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    <maven.compiler.source>22</maven.compiler.source>
    <maven.compiler.target>22</maven.compiler.target>
  </properties>
```

Compile the test project: `mvn compile` or `mvn compile -X` (with debug)

