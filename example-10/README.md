# Example 10: using the Maven compiler plugin and the assembly module

The goal:
* Configure the compiler plugin in order to compile a project with a non-standard file structure.
* Use the assembly plugin to create a JAR that contains everything needed to execute the application.

> The Maven compiler plugin:
> * Documentation: [https://maven.apache.org/plugins/maven-compiler-plugin/compile-mojo.html](https://maven.apache.org/plugins/maven-compiler-plugin/compile-mojo.html)
> * Repository: [https://mvnrepository.com/artifact/org.apache.maven.plugins/maven-compiler-plugin](https://mvnrepository.com/artifact/org.apache.maven.plugins/maven-compiler-plugin)
>
> The Maven assembly module:
> * Documentation: [https://maven.apache.org/plugins/maven-assembly-plugin/](https://maven.apache.org/plugins/maven-assembly-plugin/)
> * Repository: [https://mvnrepository.com/artifact/org.apache.maven.plugins/maven-assembly-plugin](https://mvnrepository.com/artifact/org.apache.maven.plugins/maven-assembly-plugin)

As usual, create a POM.XML file:

	mvn archetype:generate `
	    "-DgroupId=org.company.test" `
	    "-DartifactId=project-test" `
	    "-DarchetypeArtifactId=maven-archetype-quickstart" `
	    "-DarchetypeVersion=1.4" `
	    "-DinteractiveMode=false"

	cd project-test
	mvn dependency:resolve-plugins

First, let's update the version on the plugin configured within the POM.XML file:

```xml
	<plugin>
		<artifactId>maven-compiler-plugin</artifactId>
		<version>3.13.0</version>
	</plugin>
```

> You need to execute: `mvn dependency:resolve-plugins` again.

Please note that we intentionally modify the traditional organization of the project's files:

	│   pom.xml
	│
	├───src
	│   ├───application
	│   │   └───com
	│   │       └───company
	│   │           └───app
	│   │                   Main.java
	│   │
	│   └───com.company.module
	│       │   module-info.java
	│       │
	│       └───com
	│           └───company
	│               ├───config
	│               │       Loader.java
	│               │
	│               └───terminal
	│                       Dev.java
	│                       Prod.java
	│                       Test.java

This file structure contains one "Java modules" and one application.

> Please note that you could not have created more than one "Java module" (in this case "`com.company.module`")
> in this project. In order to create a project that contains more than one "Java module", you need to use "Maven modules".
> Note: "Java modules" and "Maven modules" are distinct things.

Since the project's structure is not standard, it is necessary to configure the compiler plugin.

```xml
        <plugin>
          <artifactId>maven-compiler-plugin</artifactId>
          <version>3.13.0</version>

          <configuration>
            <compileSourceRoots>
              <compileSourceRoot>${project.basedir}/src/com.company.module</compileSourceRoot>
              <compileSourceRoot>${project.basedir}/src/application</compileSourceRoot>
            </compileSourceRoots>
            <compilerId>javac</compilerId>
            <debug>true</debug>
            <outputDirectory>${project.basedir}/target/classes</outputDirectory>
          </configuration>

        </plugin>
```

## Compile the project

	mvn compile

As expected, the result of the compilation is placed under the directory "target":

	└───target
	    ├───classes
	    │   │   module-info.class
	    │   │
	    │   └───com
	    │       └───company
	    │           ├───app
	    │           │       Main.class
	    │           │
	    │           ├───config
	    │           │       Loader.class
	    │           │
	    │           └───terminal
	    │                   Dev.class
	    │                   Prod.class
	    │                   Test.class

## run the application

	mvn exec:java -D"exec.mainClass=com.company.app.Main"

Using the java VM from the command line:

	java --class-path $env:ROOT_DIR\project-test\target\classes `
	     --module-path $env:ROOT_DIR\project-test\target\classes `
	     --add-modules com.company.module `
	     com.company.app.Main

## Create a JAR that contains all the dependencies

You first need to add and configure Maven assembly plugin:

```xml
        <plugin>
          <artifactId>maven-assembly-plugin</artifactId>
          <version>3.7.1</version>
          <configuration>
            <archive>
              <manifest>
                <mainClass>com.company.app.Main</mainClass>
              </manifest>
            </archive>
            <descriptorRefs>
              <descriptorRef>jar-with-dependencies</descriptorRef>
            </descriptorRefs>
          </configuration>
        </plugin>
```

> Don't forget tu run `mvn dependency:resolve-plugins`.

Then execute the following command:

	mvn clean compile assembly:single

The JAR has been generated:

	└───target
	    │   project-test-1.0-SNAPSHOT-jar-with-dependencies.jar
	    │
	    ├───archive-tmp
	    ├───classes
	    │   │   module-info.class
	    │   │
	    │   └───com
	    │       └───company
	    │           ├───app
	    │           │       Main.class
	    │           │
	    │           ├───config
	    │           │       Loader.class
	    │           │
	    │           └───terminal
	    │                   Dev.class
	    │                   Prod.class
	    │                   Test.class

Let's look at the JAR:

	jar --extract --verbose --file=target\project-test-1.0-SNAPSHOT-jar-with-dependencies.jar META-INF/MANIFEST.MF
	get-content META-INF/MANIFEST.MF
	jar -tvf target\project-test-1.0-SNAPSHOT-jar-with-dependencies.jar

The content of the manifest is:

	Manifest-Version: 1.0
	Created-By: Maven Archiver 3.6.1
	Build-Jdk-Spec: 23
	Main-Class: com.company.app.Main

And the content of the JAR is:

     0 Wed Sep 25 15:32:34 CEST 2024 META-INF/
   113 Wed Sep 25 15:32:34 CEST 2024 META-INF/MANIFEST.MF
     0 Wed Sep 25 15:32:34 CEST 2024 com/
     0 Wed Sep 25 15:32:34 CEST 2024 com/company/
     0 Wed Sep 25 15:32:34 CEST 2024 com/company/app/
     0 Wed Sep 25 15:32:34 CEST 2024 com/company/config/
     0 Wed Sep 25 15:32:34 CEST 2024 com/company/terminal/
   482 Wed Sep 25 15:32:34 CEST 2024 com/company/app/Main.class
   914 Wed Sep 25 15:32:34 CEST 2024 com/company/config/Loader.class
   601 Wed Sep 25 15:32:34 CEST 2024 com/company/terminal/Dev.class
   605 Wed Sep 25 15:32:34 CEST 2024 com/company/terminal/Prod.class
   605 Wed Sep 25 15:32:34 CEST 2024 com/company/terminal/Test.class
   239 Wed Sep 25 15:32:34 CEST 2024 module-info.class

The JAR contains everything needed to execute the application.

Execute the JAR:

	java -jar target\project-test-1.0-SNAPSHOT-jar-with-dependencies.jar



