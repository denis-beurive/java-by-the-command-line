# Example 13: using "Maven modules"

## Create the prokect

Create the structures for the parent project:

	mvn archetype:generate `
		"-DgroupId=org.project" `
		"-DartifactId=app" `
	    "-DarchetypeGroupId=org.apache.maven.archetypes" `
	    "-DarchetypeArtifactId=maven-archetype-simple" `
	    "-DarchetypeVersion=1.5" `
	    "-DinteractiveMode=false"

Change the directory to the one that has been created (`./app`).

	cd app

Create the structures for the 3 "Maven modules":

	mvn archetype:generate `
	    "-DgroupId=org.vendor" `
	    "-DartifactId=org.vendor.module" `
	    "-DarchetypeArtifactId=maven-archetype-simple" `
	    "-DarchetypeVersion=1.5" `
	    "-DinteractiveMode=false"

	mvn archetype:generate `
	    "-DgroupId=org.company" `
	    "-DartifactId=org.company.module" `
	    "-DarchetypeArtifactId=maven-archetype-simple" `
	    "-DarchetypeVersion=1.5" `
	    "-DinteractiveMode=false"

	mvn archetype:generate `
	    "-DgroupId=org.supervision" `
	    "-DartifactId=application" `
	    "-DarchetypeArtifactId=maven-archetype-simple" `
	    "-DarchetypeVersion=1.5" `
	    "-DinteractiveMode=false"

We've created the following structure:

	app
	├───.mvn
	│   pom.xml
    │
	├───application
	│   ├───.mvn
	│   │    pom.xml
	│   │
	│   └───src
	│       └───main
	│           └───java
	│               └───org
	│                   └───supervision
    │
	├───org.company.module
	│   ├───.mvn
	│   │    pom.xml
	│   │
	│   └───src
	│       └───main
	│           └───java
	│               └───org
	│                   └───company
	└───org.vendor.module
	    ├───.mvn
	    │    pom.xml
	    │
	    └───src
	        └───main
	            └───java
	                └───org
	                    └───vendor

Now, let's modify the POMs...

### The "main" POM (located within the parent module)

First, we must declare "main" POM as being the one for the parent module.

```xml
  <!-- ================================================================ -->
  <!-- This project (a.k.a the "parent") does not contain source code ! -->
  <!-- Therefore, you *MUST* add the line below.                        -->
  <!-- ================================================================ -->

  <packaging>pom</packaging>
```

The module "`application`" depends on the modules "`org.company.module`" and "`org.vendor.module`".
Thus, this dependency relationship must be declared in the POM associated with the module "`application`"
(`application/pom.xml`).

```xml
  <dependencies>
    <dependency>
      <groupId>org.company</groupId>
      <artifactId>org.company.module</artifactId>
      <version>${project.version}</version>
    </dependency>
    <dependency>
      <groupId>org.vendor</groupId>
      <artifactId>org.vendor.module</artifactId>
      <version>${project.version}</version>
    </dependency>
  </dependencies>
```

> Please note that the tag "`<dependencies>`" describes the dependencies needed to build and execute the project.
> Keep in mind that these dependencies may include unit test utilities (among other things).



### The sub modules

The main POM (["`app/pom.xml`"](app/pom.xml)) defines the "Maven modules" managed by this project ("`application`", "`org.company.module`" and "`org.vendor.module`"). We need to declare these modules:

```xml
  <modules>
    <module>org.vendor.module</module>
    <module>org.company.module</module>
    <module>application</module>
  </modules>
```

And we also configure the Exec Maven Plugin:

```xml
        <plugin>
            <groupId>org.codehaus.mojo</groupId>
            <artifactId>exec-maven-plugin</artifactId>
            <version>3.4.1</version>
            <executions>

              <!--
              Configuration pour la commande "mvn exec:exec@exec-execution".
              -->
              <execution>
                <id>exec-execution</id>
                <goals>
                    <goal>exec</goal>
                </goals>

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
                    Set paths to Java modules
                    =========================

                    <modulepath/>: automatically creates the modulepath using all project
                                   dependencies, also adding the project build directory.
                    -->
                    <argument>--module-path</argument>
                    <modulepath/>
                    <argument>org.supervision.Main</argument>
                  </arguments>
                </configuration>
              </execution>

              <!--
              Configuration pour la commande "mvn exec:java@java-execution"

              Please, be aware of the command line!

              mvn exec:java@java-execution
              -->
              <execution>
                  <id>java-execution</id>
                  <goals>
                    <goal>java</goal>
                  </goals>
                  <configuration>
                    <mainClass>org.supervision.Main</mainClass>
                    <!--
                    See:
                    (1) https://www.mojohaus.org/exec-maven-plugin/examples/example-exec-or-java-change-classpath-scope.html
                    (2) https://www.mojohaus.org/exec-maven-plugin/exec-mojo.html#classpathScope
                    -->
                    <classpathScope>compile</classpathScope>
                  </configuration>
              </execution>
            </executions>
        </plugin>
```

## Compile

Compile/Package the application (create the JARs):

	mvn clean compile
	mvn clean package

Compile/Package only a given module or list of modules:

	mvn -pl org.vendor.module clean compile
	mvn -pl org.vendor.module clean package
	mvn -pl org.company.module clean compile
	mvn -pl org.company.module clean package
	mvn -pl org.vendor.module,org.company.module clean compile
	mvn -pl org.vendor.module,org.company.module clean package

> Note:
> * `-pl` <=> `--projects`
> * `-am` <=> `--also-make`

## Install

	mvn install

When you install the project, files are copied into the directory "`$env:HOMEPATH\.m2`" (notation PowerShell).

> Under an MSDOS terminal: "`%HOMEPATH%\.m2`".

## Execute

Change directory to the directory that contains the implementation of the application.

	cd application

Then run the following command:

	mvn exec:exec@exec-execution

or the following one:

	mvn exec:java@java-execution
