# Configure the Maven Compiler Plugin

Repository: [Maven Compiler Plugin](https://mvnrepository.com/artifact/org.apache.maven.plugins/maven-compiler-plugin)

```xml
        <plugin>
          <artifactId>maven-compiler-plugin</artifactId>
          <version>3.13.0</version>
          <configuration>
            <compileSourceRoots>
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
        </plugin>
```

