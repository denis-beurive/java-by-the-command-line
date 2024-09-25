# Example 12: using JavaFX with Maven - very simple example

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

	<plugin>
		<artifactId>maven-compiler-plugin</artifactId>
		<version>3.13.0</version>
	</plugin>

	<properties>
    	<project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    	<maven.compiler.source>23</maven.compiler.source>
    	<maven.compiler.target>23</maven.compiler.target>
	</properties>

We also need to tell the compiler (handled by the compiler plugin "`maven-compiler-plugin`") where to look for the JavaFX modules, and which modules to add:

            <compilerArgs>
              <arg>--module-path</arg>
              <arg>${env.PATH_TO_FX}</arg>
              <arg>--add-modules</arg>
              <arg>javafx.controls</arg>
            </compilerArgs>

Thus, the configuration for the compiler module is:

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

## Compile

	mvn compile

## Run the application

	mvn exec:java -D"exec.mainClass=org.company.App"




Using the java VM directly:

	cd $env:ROOT_DIR\.. # for example
	java -cp "$env:ROOT_DIR/fx-app/target\classes" --module-path $env:PATH_TO_FX --add-modules javafx.controls org.company.App


