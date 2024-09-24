# Example 7: create one module

## introductino

We create a module, called "`com.company.module`", that exports 2 packages:

* `com.company.config`
* `com.company.terminal`

> See the module descriptor "[module-info.java](module-info.java)".

For this example, we _arbitrarily_ choose to organize the source as follows:

	└───src
	    ├───application
	    │   └───com
	    │       └───company
	    │           └───app
	    │                   Main.java
	    │
	    └───modules
	        │   module-info.java
	        │
	        └───com
	            └───company
	                ├───config
	                │       File.java
	                │
	                └───terminal
	                        Dev.java
	                        Prod.java
	                        Test.java

* The sources for the module lies under the directory `src/modules`.
* The sources for the application lies under the directory `src/application`.

> Please note that we therefore have two source paths (`src/modules` and `src/application`). See the option
  [--source-path](https://docs.oracle.com/en/java/javase/22/docs/specs/man/javac.html#option-source-path).

And we _arbitrarily_ choose to organize the compiled resources as follows:

	├───output
	│   ├───application
	│   │   └───com
	│   │       └───company
	│   │           └───app
	│   │                   Main.class
	│   │
	│   └───modules
	│       │   module-info.class
	│       │
	│       └───com
	│           └───company
	│               ├───config
	│               │       File.class
	│               │
	│               └───terminal
	│                       Dev.class
	│                       Prod.class
	│                       Test.class
	└───src
	    ├───application
	    │   └───com
	    │       └───company
	    │           └───app
	    └───modules
	        └───com
	            └───company
	                ├───config
	                └───terminal

The (compiled) module will be put under the directory `output/modules`.
The (compiled) application will be put under the directory `output/application`.

## Compile the module

	# PowerShell syntax (for UNIX shell: replace "`" by "\", for MSDOS: replace "`" by "^")
	javac -d output/modules `
	      --source-path src/modules `
	      src/modules/module-info.java `
	      src/modules/com/company/config/*.java src/modules/com/company/terminal/*.java

> Replace `^` by `\` if you are using a UNIX shell instead of a Windows terminal.

or (using PowerShell to generate the paths to all `.java` files):

	&"javac" -d $env:ROOT_DIR\output\modules --source-path $env:ROOT_DIR\src\modules @(Get-ChildItem -Recurse -Path $env:ROOT_DIR\src\modules -Filter *.java).FullName

* `-d`: Sets the destination directory. 
* `--source-path`: Specifies where to find source files. Except when compiling multiple modules
  together, this is the source code path used to search for class or interface definitions.

> A directory path `output/modules/com.company.module` will be created by the compiler.

## Compile the application

	# PowerShell syntax (for UNIX shell: replace "`" by "\", for MSDOS: replace "`" by "^")
	javac -d output/application `
	      --module-path output/modules `
	      --add-modules com.company.module `
	      --source-path src/application `
	      src/application/com/company/app/Main.java

> Replace `^` by `\` if you are using a UNIX shell instead of a Windows terminal.

Please note that:

* We have to tell the compiler where to look for modules. This is done by using the option `--module-path`.
* We have to tell the compiler what modules we are using. This is done by using the option `--add-modules`.

## Run the application

	# PowerShell syntax (for UNIX shell: replace "`" by "\", for MSDOS: replace "`" by "^")
	java --class-path output/application `
	     --module-path output/modules `
	     --add-modules com.company.module `
	     com.company.app.Main

Please note that:

* We have to tell the JVM where to look for modules. This is done by using the option `--module-path`.
* We have to tell the JVM what modules we are using. This is done by using the option `--add-modules`.
  Please keep in mind that there is no relation between the name of a module and what it contains.
  That is to say: the module name "`com.company.module`" does not indicate that this module contains the package "`com.company.terminal`".
