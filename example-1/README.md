# Example 1: the project is made of just one source file

## Compilation using the command line

	$env:ROOT_DIR
	    │
	    └───src
	        └───com
	            └───beurive
	                    HelloWorld.java

Compilation:

```powershell
cd $env:ROOT_DIR
javac -d .\class .\src\com\beurive\HelloWorld.java
```

or

```powershell
cd $env:ROOT_DIR
javac -d .\class .\src\com\beurive\*
```

or

```powershell
cd $env:ROOT_DIR
javac -d .\class .\src\**\*.java
```

The result is:

	$env:ROOT_DIR
	    │
	    ├───class
	    │   └───com
	    │       └───beurive
	    │               HelloWorld.class
	    │
	    └───src
	        └───com
	            └───beurive
	                    HelloWorld.java

Look at the generated class:

```powershell
javap $env:ROOT_DIR\class\com\beurive\HelloWorld.class
```

## Execution

```powershell
cd $env:ROOT_DIR\class
java com.beurive.HelloWorld
```

or, by specifying the class path within the command line:

```powershell
cd $env:ROOT_DIR\.. # for example
java -cp $env:ROOT_DIR\class com.beurive.HelloWorld
```

or, by specifying the class path through the `CLASSPATH` environment variable:

```powershell
$env:CLASSPATH="$env:ROOT_DIR\class"
java com.beurive.HelloWorld
```
