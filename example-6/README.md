# Example 6: add and use a library using Maven

URL: [https://www.tutorialspoint.com/maven/maven_overview.htm](https://www.tutorialspoint.com/maven/maven_overview.htm)

Create a basic directory structure for the project (see [example 5](../example-5)).

Let's use an external librairy. For example: [Jackson Databind](https://github.com/FasterXML/jackson-databind)

Go to Maven Repository and look for the library: [https://mvnrepository.com/artifact/com.fasterxml.jackson.core/jackson-databind](https://mvnrepository.com/artifact/com.fasterxml.jackson.core/jackson-databind)

Choose, for example, the version `2.17.1`: [https://mvnrepository.com/artifact/com.fasterxml.jackson.core/jackson-databind/2.17.1](https://mvnrepository.com/artifact/com.fasterxml.jackson.core/jackson-databind/2.17.1)

Add the depedency to the file `pom.xml`.

```xml
  <dependencies>
    <dependency>
      <groupId>junit</groupId>
      <artifactId>junit</artifactId>
      <version>4.11</version>
      <scope>test</scope>
    </dependency>

    <!-- https://mvnrepository.com/artifact/com.fasterxml.jackson.core/jackson-databind -->
    <dependency>
        <groupId>com.fasterxml.jackson.core</groupId>
        <artifactId>jackson-databind</artifactId>
        <version>2.17.1</version>
    </dependency>
  </dependencies>
```

> If necessary, execute the following command into the PowerShell terminal: `mvn dependency:resolve-plugins`

Install the dependencies:

```powershell
PS C:\java-basic\example-6\project> mvn dependency:resolve
...
[INFO] The following files have been resolved:
[INFO]    junit:junit:jar:4.11:test -- module junit (auto)
[INFO]    org.hamcrest:hamcrest-core:jar:1.3:test -- module hamcrest.core (auto)
[INFO]    com.fasterxml.jackson.core:jackson-databind:jar:2.17.1:compile -- module com.fasterxml.jackson.databind
[INFO]    com.fasterxml.jackson.core:jackson-annotations:jar:2.17.1:compile -- module com.fasterxml.jackson.annotation
[INFO]    com.fasterxml.jackson.core:jackson-core:jar:2.17.1:compile -- module com.fasterxml.jackson.core
...
```

All dependencies are installed under the directory `$env:HOMEPATH\.m2`. You can find all the files related to the "Jackson" dependency:

```powershell
@(Get-ChildItem -Recurse -Path $env:HOMEPATH\.m2 -Filter *jackson*).FullName
```

Compile the application:

```powershell
mvn compile
```

> You can find the compiled classes: `@(Get-ChildItem -Recurse -Path $env:ROOT_DIR\project -Filter *.class).FullName`

Run the application. But before you can run the application, you must find the location of the classes from the Jackson library.

Maven installs all libraries (i.e. JAR) under the following directory: `$env:HOMEPATH\.m2\repository`.

> Please note that you can see it by yourself: `@(Get-ChildItem -Recurse -Path $env:HOMEPATH\.m2 -Filter *jackson*).FullName` => `C:\Users\denis\.m2\repository\com\fasterxml\jackson`.

Now, search for the JAR files:

```powershell
PS C:\java-basic\example-6\project> @(Get-ChildItem -Recurse -Path $env:HOMEPATH\.m2\repository\com\fasterxml\jackson -Filter *.jar).FullName

C:\Users\denis\.m2\repository\com\fasterxml\jackson\core\jackson-annotations\2.17.1\jackson-annotations-2.17.1.jar
C:\Users\denis\.m2\repository\com\fasterxml\jackson\core\jackson-core\2.17.1\jackson-core-2.17.1.jar
C:\Users\denis\.m2\repository\com\fasterxml\jackson\core\jackson-databind\2.17.1\jackson-databind-2.17.1.jar
```

Now, we can create the command line that runs the application. Please note that we use intermediate variables (`$j1`, `$j2` and `$j3`) in order to make the command line clearer.

```powershell
$j1=@(Get-ChildItem -Recurse -Path $env:HOMEPATH\.m2\repository\com\fasterxml\jackson -Filter jackson-annotations*.jar).FullName

$j2=@(Get-ChildItem -Recurse -Path $env:HOMEPATH\.m2\repository\com\fasterxml\jackson -Filter jackson-core*.jar).FullName

$j3=@(Get-ChildItem -Recurse -Path $env:HOMEPATH\.m2\repository\com\fasterxml\jackson -Filter jackson-databind*.jar).FullName

java -cp "$env:ROOT_DIR\project\target\classes;$j1;$j2;$j3" org.beurive.project_group.App
```

Or you can run the application using Maven:

```powershell
mvn exec:java -D"exec.mainClass"="org.beurive.project_group.App"
```



