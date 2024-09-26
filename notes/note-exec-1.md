# Why should I use exec:exec to run Java when exec:java exists?

`exec:java` runs the Java code in the same JVM as Maven. We might want to run it in a different JVM. E.g., if we want Maven and our program to have a different classpath, we need different JVMs. For this, we would `use exec:exec`.

Source: [https://www.naukri.com/code360/library/maven-exec-plugin](https://www.naukri.com/code360/library/maven-exec-plugin)

