# Configure the Maven Exec Plugin

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


