# JULIE Lab xerces

# NOTE

The current version on Maven Central unfortunately misses the dependency to `xml-apis`. Please add this dependency to your project when using this version of `xercelImpl`:
    
    <dependency>
        <groupId>xml-apis</groupId>
        <artifactId>xml-apis</artifactId>
        <version>1.4.01</version>
    </dependency>

## Introduction

Xerces is a wide-spread SAX XML parser implementation. It is also used by the Apache UIMA project for (de-)serialization of CAS data. Unfortunately, Xerces exhibits unfavorable behavior or even bugs in some rare cases. In respect to UIMA, one issue is that the UIMA CAS (document plus annotations) is serialized into an XML format called XMI. There, the actual document text is stored as an attribute value of an element called sofa. However, Xerces expects rather short attribute values (the default is set to 32 characters). Exceeding the default size causes the `XMLStringBuffer` to resize frequently. Even though the buffer size is doubled for each resize and should, in theory, quickly reach enough capacity to hold even large document text, in reality for each resizing the old buffer has to be copied into the new, larger buffer. This, firstly, takes quite some time and, secondly, even causes higher memory consumption than necessary because in the last steps of buffer growth the largest part of the document has to be held in memory twice.

## About this project

This repository mostly consist of the original source files downloaded from the [Apache Xerces](http://xerces.apache.org/mirrors.cgi#source) website. A minor change has been done to the `build.xml` file to make the project build with newer Java versions (tested with Java 8). Another change has been done to the class `org.apache.xerces.impl.XMLScanner`. There, the `XMLStringBuffer` responsible for attribute values is created by the default constructor.
To alleviate the sofa string situation, before buffer creation, the class now checks for a Java system property called `julielab.xerces.attributebuffersize`. For programmatic access there exists a constant `org.apache.xerces.impl.XMLScanner#ATTRIBUTE_BUFFER_SIZE`. To create larger buffers to begin with, this property must be set to some non-negative integer value (represented as a string since Java property values are always strings) before XML parser creation in the Java program. For efficiency reasons, one might want to set the property to `null` after the parsing in case Xerces is also used in other parts of the program where the buffer size should be set to the default.

## Upload to Maven Central

In order to make this project easily available, it is being uploaded to the Maven Central repository via the respective [Nexus](https://oss.sonatype.org/) web application. Xerces is an Ant project and not easily uploaded automatically. To facilitate the process, this project offers the `maven/makeMavenCentralFiles.sh` script and a `maven/pom.xml` file. The POM file cannot be used to actually manage the project, it is only there for the upload to the repository.
The script will create a new subdirectory `upload/` and put all required files there. Note that Maven Central expects all uploaded files to be signed by separate `.asc` files. To create those, the `gpg` programm must be installed and a private key must exist and the public key must have been uploaded to at least one appropriate server.
In the Nexus system, navigate to ''Staging upload'' and select the POM file in ''Select Staging Upload Mode''. Add all other files in the `upload/` directory as artifacts, including and especially the .asc files.
After that, check if everything went fine by looking into the ''Staging Repositories'' view (scroll to the very bottom to find your just created staging repository). When everything went fine (you will have to wait a moment for validation process to complete), select your repository and click ''release''.
