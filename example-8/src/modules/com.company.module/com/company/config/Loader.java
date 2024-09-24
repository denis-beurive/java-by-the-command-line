package com.company.config;
import java.io.IOException;

import com.vendor.File;  // <= dependency to "com.vendor.module"

public class Loader {

    public static String Load(String filePath) throws IOException {
    	return File.Load(filePath);
    }
}
