# Example 8: create 2 modules, one module depends on the other

## Introduction

We create 2 modules:

* `com.company.module`
* `com.vendor.module`

And the module "`com.company.module`" depends on the module "`com.vendor.module`".

> If you look at [the code for the module "`com.company.module`"](src/modules/com.company.module/com/company/config/Loader.java), you will see the dependency:

```java
package com.company.config;
import java.io.IOException;

import com.vendor.File;  // <= dependency to "com.vendor.module"
```

Declaring the modules' dependency (in the file [modules/com.company.module/module-info.java](modules/com.company.module/module-info.java)):

	module com.company.module {
		exports com.company.config;
		exports com.company.terminal;
		requires com.vendor.module;
	}

> Please note the line "requires com.vendor.module;".

For this example, we _arbitrarily_ choose to organize the source as follows. Please note that this is a standard way to organize the sources. But you can choose another way to organize your project.


	└───src
	    ├───application
	    │   └───com
	    │       └───company
	    │           └───app
	    │                   Main.java
	    │
	    └───modules
	        ├───com.company.module
	        │   │   module-info.java
	        │   │
	        │   └───com
	        │       └───company
	        │           ├───config
	        │           │       Loader.java
	        │           │
	        │           └───terminal
	        │                   Dev.java
	        │                   Prod.java
	        │                   Test.java
	        │
	        └───com.vendor.module
	            │   module-info.java
	            │
	            └───com
	                └───vendor
	                        File.java

And we _arbitrarily_ choose to organize the compiled resources as follows:

	├───output
	│   ├───application
	│   │   └───com
	│   │       └───company
	│   │           └───app
	│   │                   Main.class
	│   │
	│   └───modules
	│       ├───com.company.module
	│       │   │   module-info.class
	│       │   │
	│       │   └───com
	│       │       └───company
	│       │           ├───config
	│       │           │       Loader.class
	│       │           │
	│       │           └───terminal
	│       │                   Dev.class
	│       │                   Prod.class
	│       │                   Test.class
	│       │
	│       └───com.vendor.module
	│           │   module-info.class
	│           │
	│           └───com
	│               └───vendor
	│                       File.class
	└───src
	    ├───application
	    │   └───com
	    │       └───company
	    │           └───app
	    └───modules
	        ├───com.company.module
	        │   └───com
	        │       └───company
	        │           ├───config
	        │           └───terminal
	        └───com.vendor.module
	            └───com
	                └───vendor

## Compilation

Because the module "`com.company.module`" depends on the module "`com.vendor.module`", we first compile the module "`com.vendor.module`".

First, compile the module "`com.vendor.module`":

	# PowerShell syntax (for UNIX shell: replace "`" by "\", for MSDOS: replace "`" by "^")
	javac -d output/modules/com.vendor.module `
	      --source-path src/modules/com.vendor.module `
	      src/modules/com.vendor.module/module-info.java `
	      src/modules/com.vendor.module/com/vendor/*.java

Then, compile the module "`com.company.module`":

	# PowerShell syntax (for UNIX shell: replace "`" by "\", for MSDOS: replace "`" by "^")
	javac -d output/modules/com.company.module `
	      --module-path output/modules `
	      --source-path src/modules/com.company.module `
	      src/modules/com.company.module/module-info.java `
	      src/modules/com.company.module/com/company/config/*.java src/modules/com.company.module/com/company/terminal/*.java

Please note that we indicate the path to the directory that contains the module needed by the module that is being compiled (see the option `--module-path`).

> Please remember that, in order to compile the module "`com.company.module`", we need the module "`com.vendor.module`".

Then compile the application that uses the 2 modules:

	# PowerShell syntax (for UNIX shell: replace "`" by "\", for MSDOS: replace "`" by "^")
	javac -d output/application `
	      --module-path output/modules `
	      --add-modules com.company.module `
	      --add-modules com.vendor.module `
	      --source-path src/application `
	      src/application/com/company/app/Main.java

## Run the application

	java --class-path output/application `
	     --module-path output/modules `
	     --add-modules com.company.module `
	     --add-modules com.vendor.module `
         com.company.app.Main

Please note that:

* We have to tell the JVM where to look for modules. This is done by using the option `--module-path`.
* We have to tell the JVM what modules we are using. This is done by using the option `--add-modules`.

