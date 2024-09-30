# Configure the Maven Exec Plugin

Repository: [Maven Exec Plugin](https://mvnrepository.com/artifact/org.codehaus.mojo/exec-maven-plugin)

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

Using "executions": this allows configuring several ways to execute "something".

```xml
        <plugin>
            <groupId>org.codehaus.mojo</groupId>
            <artifactId>exec-maven-plugin</artifactId>
            <version>3.4.1</version>
            <executions>

              <!--
              Configuration pour la commande "mvn exec:exec@exec-execution".

              Please, be aware of the command line!

              mvn exec:exec@exec-execution
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

> Execution:
> * `mvn exec:exec@exec-execution`
> * `mvn exec:java@java-execution`
