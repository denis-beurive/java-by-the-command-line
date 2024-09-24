# Example 9: create a "Java module" using Maven

## Create a basic directory structure for the project

	mvn archetype:generate `
	    "-DgroupId=org.company.module" `
	    "-DartifactId=project-module" `
	    "-DarchetypeArtifactId=maven-archetype-quickstart" `
	    "-DarchetypeVersion=1.4" `
	    "-DinteractiveMode=false"

	cd project-module
	mvn dependency:resolve-plugins

> See the [example 5](../example-5) for details.
>
> The directory structure is created under the directory `project-module`.

Now, set the following configuration to the file "`pom.xml`":

```xml
  <properties>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    <maven.compiler.source>23</maven.compiler.source>
    <maven.compiler.target>23</maven.compiler.target>
  </properties>
```

> See the [example 5](../example-5) for details.
>
> ```
> PS C:\Users\denis.beurive\Documents\dev\java-by-the-command-line\example-9\project-module> javac --version
> javac 23
> PS C:\Users\denis.beurive\Documents\dev\java-by-the-command-line\example-9\project-module> java --version
> openjdk 23 2024-09-17
> OpenJDK Runtime Environment (build 23+37-2369)
> OpenJDK 64-Bit Server VM (build 23+37-2369, mixed mode, sharing)
> ```

Please note that, if you use a recent version of the JDK, then you may need to upgrade the Maven plugins specified within the file `pom.xml`. For example:

```xml
  <dependencies>
    <dependency>
      <groupId>junit</groupId>
      <artifactId>junit</artifactId>
      <version>4.9</version>
      <scope>test</scope>
    </dependency>
  </dependencies>

  <build>
    <pluginManagement><!-- lock down plugins versions to avoid using Maven defaults (may be moved to parent pom) -->
      <plugins>

        <plugin>
          <artifactId>maven-surefire-plugin</artifactId>
          <version>3.5.0</version>
        </plugin>

      </plugins>
    </pluginManagement>
  </build>
```

## Implement the "Java module"

All you need to do in order to tell Maven that you are implementing a "Java module" is to create a "module information file" (`module-info.java`) in the rigth location (that is: `src/main/java/org`).

## Compile the module

Just run:

	mvn package

You can see that it build a JAR:

	Building jar: C:\...\example-9\project-module\target\project-module-1.0-SNAPSHOT.jar

But, it also create a "Java module":

	│
	└───target
	    │   project-module-1.0-SNAPSHOT.jar
	    │
	    └───classes
	        │   module-info.class
	        │
	        └───org
	            └───company
	                ├───config
	                │       File.class
	                │
	                └───terminal
	                        Dev.class
	                        Prod.class
	                        Test.class

Let's see what's inside the JAR file that has been created:

	PS C:\...\example-9\project-module\target> jar tvf .\project-module-1.0-SNAPSHOT.jar
	    97 Tue Sep 24 15:38:42 CEST 2024 META-INF/MANIFEST.MF
	     0 Tue Sep 24 15:38:42 CEST 2024 META-INF/
	     0 Tue Sep 24 15:38:40 CEST 2024 org/
	     0 Tue Sep 24 15:38:40 CEST 2024 org/company/
	     0 Tue Sep 24 15:38:40 CEST 2024 org/company/config/
	     0 Tue Sep 24 15:38:40 CEST 2024 org/company/terminal/
	     0 Tue Sep 24 15:38:42 CEST 2024 META-INF/maven/
	     0 Tue Sep 24 15:38:42 CEST 2024 META-INF/maven/org.company.module/
	     0 Tue Sep 24 15:38:42 CEST 2024 META-INF/maven/org.company.module/project-module/
	   224 Tue Sep 24 15:38:40 CEST 2024 module-info.class
	   842 Tue Sep 24 15:38:40 CEST 2024 org/company/config/File.class
	   601 Tue Sep 24 15:38:40 CEST 2024 org/company/terminal/Dev.class
	   605 Tue Sep 24 15:38:40 CEST 2024 org/company/terminal/Prod.class
	   605 Tue Sep 24 15:38:40 CEST 2024 org/company/terminal/Test.class
	  2741 Tue Sep 24 15:28:30 CEST 2024 META-INF/maven/org.company.module/project-module/pom.xml
	   109 Tue Sep 24 15:38:42 CEST 2024 META-INF/maven/org.company.module/project-module/pom.properties

We can see that this JAR contains a file named "`module-info.class`". Thus, it contains a "Java module".



