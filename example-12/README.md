# Example 13: using the JavaFX Maven plugin

* [Maven repository](https://mvnrepository.com/artifact/org.openjfx/javafx-maven-plugin)



## Configure the environment

First, you need to configure the environment as described in this document: [https://openjfx.io/openjfx-docs/#install-javafx](https://openjfx.io/openjfx-docs/#install-javafx). Basically, all you need to do is set the value for the environment variable "`PATH_TO_FX`".

> You need to adapt the PowrShell "start.ps1".

## Create a basic POM.XML

	mvn archetype:generate `
	    "-DgroupId=org.company" `
	    "-DartifactId=fx-app" `
	    "-DarchetypeArtifactId=maven-archetype-quickstart" `
	    "-DarchetypeVersion=1.4" `
	    "-DinteractiveMode=false"

	cd fx-app
	mvn dependency:resolve-plugins

Configure the POM.XML file:

```xml
	<plugin>
		<artifactId>maven-compiler-plugin</artifactId>
		<version>3.13.0</version>
	</plugin>
```

```xml
	<properties>
    	<project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    	<maven.compiler.source>23</maven.compiler.source>
    	<maven.compiler.target>23</maven.compiler.target>
	</properties>
```

We also need to tell the compiler (handled by the compiler plugin "`maven-compiler-plugin`") where to look for the JavaFX modules, and which modules to add:

```xml
            <compilerArgs>
              <arg>--module-path</arg>
              <arg>${env.PATH_TO_FX}</arg>
              <arg>--add-modules</arg>
              <arg>javafx.controls</arg>
            </compilerArgs>
```

Thus, the configuration for the compiler module is:

```xml
        <plugin>
          <artifactId>maven-compiler-plugin</artifactId>
          <version>3.13.0</version>
          <configuration>
            <compileSourceRoots>
              <!-- not necessary since this project has a standard organisation -->
              <compileSourceRoot>${project.basedir}/src/main/java</compileSourceRoot>
            </compileSourceRoots>

            <compilerArgs>
              <arg>--module-path</arg>
              <arg>${env.PATH_TO_FX}</arg>
              <arg>--add-modules</arg>
              <arg>javafx.controls</arg>
            </compilerArgs>

            <compilerId>javac</compilerId>
            <debug>true</debug>
            <outputDirectory>${project.basedir}/target/classes</outputDirectory>
          </configuration>
```

## Compile

	mvn compile

## Run the application

	mvn exec:exec

> If you get an error, the run `mvn -X exec:exec`.

Please note that we have configured the [Maven Exec Plugin](https://www.mojohaus.org/exec-maven-plugin/).

The configuration is:

```xml
        <plugin>
            <groupId>org.codehaus.mojo</groupId>
            <artifactId>exec-maven-plugin</artifactId>
            <version>3.4.1</version>
            <configuration>
                <executable>java</executable>
                <arguments>
                    <!--
                     Set the class paths
                     ===================

                     <classpath/>: this will generate the classpath for us.

                     Please note that you could set the option more than once in order to add additional class paths.
                     -->
                    <argument>--class-path</argument>  
                    <classpath/>

                    <!--
                      Set paths to JavaFX modules
                      ===========================

                      <modulepath/>: automatically creates the modulepath using all project
                                     dependencies, also adding the project build directory.
                    -->
                    <argument>--module-path</argument>
                    <modulepath/> <!-- useless for this use case, but use it because it shows that we can set the option more than once -->
                    <argument>--module-path</argument>
                    <argument></argument> <!-- please note the "empty" <argument></argument>. -->
                    <argument>${env.PATH_TO_FX}</argument>

                    <argument>--add-modules</argument>
                    <argument>javafx.controls</argument>
                    <argument>org.company.App</argument>
                </arguments>
            </configuration>
        </plugin>
```

This configuration specifies:
* The class paths (`--class-path`).
* The path to the JavaFX modules (`--module-path`).
* The (JavaFX) modules to use (`--add-modules`).
* The main class used to bootstrap the applucation.

Using the java VM directly:

	cd $env:ROOT_DIR\.. # for example
	java -cp "$env:ROOT_DIR/fx-app/target\classes" --module-path $env:PATH_TO_FX --add-modules javafx.controls org.company.App

