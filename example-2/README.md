# Example 2

## Compilation using the command line

	$env:ROOT_DIR
	    │
		└───src
		    ├───com
		    │   └───beurive
		    │           HelloWorld.java
		    │
		    └───org
		        └───beurive
		                World.java

Compilation:

```powershell
cd $env:ROOT_DIR
javac -d .\class .\src\org\beurive\World.java
javac -d .\class -cp $env:ROOT_DIR\class .\src\com\beurive\HelloWorld.java
```

> Please note the use of the command-line option `-cp` (class path). _It is necessary to tell the compiler where to find the class files that contain the software objects referenced by the source file being compiled_.

or

```powershell
cd $env:ROOT_DIR
javac -d .\class -cp $env:ROOT_DIR\class .\src\org\beurive\*
javac -d .\class -cp $env:ROOT_DIR\class .\src\com\beurive\*
```

or:

```powershell
&"javac" -d $env:ROOT_DIR\class -cp $env:ROOT_DIR\class @(Get-ChildItem -Recurse -Path $env:ROOT_DIR\src -Filter *.java).FullName
```

The result is:

	$env:ROOT_DIR
		│
		├───class
		│   ├───com
		│   │   └───beurive
		│   │           HelloWorld.class
		│   │
		│   └───org
		│       └───beurive
		│               World.class
		│
		└───src
		    ├───com
		    │   └───beurive
		    │           HelloWorld.java
		    │
		    └───org
		        └───beurive
		                World.java

Look at the generated class:

```powershell
javap $env:ROOT_DIR\class\com\beurive\HelloWorld.class
javap $env:ROOT_DIR\class\org\beurive\World.class
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
