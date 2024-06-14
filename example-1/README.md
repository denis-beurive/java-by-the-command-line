# Example 1

## Compilation using the command line

	$env:ROOT_DIR
	    │
	    └───src
	        └───com
	            └───beurive
	                    HelloWorld.java

Compilation:

	cd $env:ROOT_DIR
	javac -d .\class .\src\com\beurive\HelloWorld.java

or

	cd $env:ROOT_DIR
	javac -d .\class .\src\com\beurive\*

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

	javap $env:ROOT_DIR\class\com\beurive\HelloWorld.class

## Execution

	cd $env:ROOT_DIR\class
	java com.beurive.HelloWorld

or, by specifying the class path within the command line:

	cd $env:ROOT_DIR\.. # for example
	java -cp $env:ROOT_DIR\class com.beurive.HelloWorld

or, by specifying the class path through the `CLASSPATH` environment variable:

	$env:CLASSPATH="$env:ROOT_DIR\class"
	java com.beurive.HelloWorld

