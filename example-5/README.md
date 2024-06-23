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


Before you can compile the project, you probably need to change the file `pom.xml`. We need to set: _source_, _target_, _release_ parameters.

* `--source` option specifies the version of the Java source code that your program is written in. For example, if your code uses features introduced in Java 11, you would use --source 11 to indicate that. The default value is the version of the javac compiler itself.
* `--target` option specifies the version of the JVM that your compiled code should be compatible with. For example, if you want your code to run on a JVM that supports Java 8, you would use --target 1.8. The default value is the version of the javac compiler itself.
* `--release` option is similar to --source and--target, and it allows you to specify the version of the Java platform that your code should be compatible with. For example, if you want your code to be compatible with Java 17, you would use --release 17. This option was introduced in Java 9[2].

> From the pretty good article: [What the heck are these javac source/target/release options?](https://medium.com/@rostyslav.ivankiv/what-the-heck-are-these-javac-source-target-release-options-d43c3a68dd63)

Since:

```powershell
PS C:\> javac --version
javac 22.0.1
```

Set the `pom.xml` to (for example):

```xml
  <properties>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    <maven.compiler.source>22</maven.compiler.source>
    <maven.compiler.target>22</maven.compiler.target>
  </properties>
```

Compile the test project: `mvn compile` or `mvn compile -X` (with debug)

