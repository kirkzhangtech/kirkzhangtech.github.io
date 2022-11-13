---
title: maven官方文档手册
categories: 
- java
- maven
thumbnailImagePosition: bottom
# thumbnailImage: http://d1u9biwaxjngwg.cloudfront.net/cover-image-showcase/city-750.jpg
coverImage: https://user-images.githubusercontent.com/46363359/199011842-d35296a3-9d75-4649-90ab-acbf668efc2d.jpg
metaAlignment: center
coverMeta: out
---

> source page: <https://maven.apache.org/guides/getting-started/maven-in-five-minutes.html>

<!-- more -->

<!-- toc -->
# maven in five minutes

## instalation


Maven is a Java tool, so you must have Java installed in order to proceed.
[maven installation guide]()

```shell
mvn --version
```

## Creating a Project

You need somewhere for your project to reside. Create a directory somewhere and start a shell in that directory. On your command line, execute the following Maven goal:
```shell
mvn archetype:generate -DgroupId=com.mycompany.app \
                       -DartifactId=my-app \
                       -DarchetypeArtifactId=maven-archetype-quickstart \
                       -DarchetypeVersion=1.4 \
                       -DinteractiveMode=false
```
after you executation , maven gonna install some dependency jars for your project,You will notice that the generate goal created a directory with the same name given as the `artifactId`. Change into that directory.
and then you gonna see project struct.

## Build the Project

```shell
mvn package
```
The command line will print out various actions, and end with the following:
```shell
 ...
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  2.953 s
[INFO] Finished at: 2019-11-24T13:05:10+01:00
[INFO] ------------------------------------------------------------------------
```
Unlike the first command executed (archetype:generate), the second is simply a single word - package. Rather than a goal, this is a phase. A phase is a step in the build lifecycle, which is an ordered sequence of phases. When a phase is given, Maven executes every phase in the sequence up to and including the one defined. For example, if you execute the compile phase, the phases that actually get executed are:
1. validate
2. generate-sources
3. process-sources
4. generate-resources
5. process-resources
6. compile

You may test the newly compiled and packaged JAR with the following command:

```shell
java -cp target/my-app-1.0-SNAPSHOT.jar com.mycompany.app.App
```

Which will print the quintessential:

```shell
Hello World!
```

## Java 9 or later
By default your version of Maven might use an old version of the maven-compiler-plugin that is not compatible with Java 9 or later versions. To target Java 9 or later, you should at least use version 3.6.0 of the maven-compiler-plugin and set the maven.compiler.release property to the Java release you are targetting (e.g. 9, 10, 11, 12, etc.).

In the following example, we have configured our Maven project to use version 3.8.1 of maven-compiler-plugin and target Java 11:

```xml
    <properties>
        <maven.compiler.release>11</maven.compiler.release>
    </properties>
 
    <build>
        <pluginManagement>
            <plugins>
                <plugin>
                    <groupId>org.apache.maven.plugins</groupId>
                    <artifactId>maven-compiler-plugin</artifactId>
                    <version>3.8.1</version>
                </plugin>
            </plugins>
        </pluginManagement>
    </build>
```
To learn more about javac's --release option, see JEP 247

## Running Maven Tools

### Maven Phases

Although hardly a comprehensive list, these are the most common default lifecycle phases executed.

- validate: validate the project is correct and all necessary information is available
- compile: compile the source code of the project
- test: test the compiled source code using a suitable unit testing framework. These tests should not require the code be packaged or deployed
- package: take the compiled code and package it in its distributable format, such as a JAR.
- integration-test: process and deploy the package if necessary into an environment where integration tests can be run
- verify: run any checks to verify the package is valid and meets quality criteria
- install: install the package into the local repository, for use as a dependency in other projects locally
- deploy: done in an integration or release environment, copies the final package to the remote repository for sharing with other developers and projects.
There are two other Maven lifecycles of note beyond the default list above. They are
- clean: cleans up artifacts created by prior builds
- site: generates site documentation for this project

Phases are actually mapped to underlying goals. The specific goals executed per phase is dependant upon the packaging type of the project. For example, package executes jar:jar if the project type is a JAR, and war:war if the project type is - you guessed it - a WAR.

An interesting thing to note is that phases and goals may be executed in sequence.

```shell
mvn [options] [<goal(s)>] [<phase(s)>]

mvn clean dependency:copy-dependencies package

```
This command will clean the project, copy dependencies, and package the project (executing all phases up to package, of course).

### Generating the Site

```shell
mvn site
```
This phase generates a site based upon information on the project's pom. You can look at the documentation generated under target/site.

summary: 
1. mvn command list is mvn [option] [goals] [phase]
2. 第一节中介绍了如何初始化项目
3. maven项目的基本结构
4. 介绍了phase的概念
5. 提供了一个较为完整的项目的初始化，运行测试，打包编译的过程

# Maven Getting Started Guide

## What is Maven
At first glance Maven can appear to be many things, but in a nutshell Maven is an attempt to apply patterns to a project's build infrastructure in order to promote comprehension and productivity by providing a clear path in the use of best practices. Maven is essentially a project management and comprehension tool and as such provides a way to help with managing:
- Builds
- Documentation
- Reporting
- Dependencies
- SCMs
- Releases
- Distribution

If you want more background information on Maven you can check out The Philosophy of Maven and The History of Maven. Now let's move on to how you, the user, can benefit from using Maven.

summary : maven mainly scope of industry

## How can Maven benefit my development process?

Maven can provide benefits for your build process by employing standard conventions(n.[法]惯例;会议) and practices to accelerate your development cycle while at the same time helping you achieve a higher rate of success.
Now that we have covered a little bit of the history and purpose of Maven let's get into some real examples to get you up and running with Maven!

## How do I setup Maven?
We are going to jump headlong into creating your first Maven project! To create our first Maven project we are going to use Maven's archetype mechanism. An archetype is defined as an original pattern or model from which all other things of the same kind are made. In Maven, an archetype is a template of a project which is combined with some user input to produce a working Maven project that has been tailored to the user's requirements. We are going to show you how the archetype mechanism works now, but if you would like to know more about archetypes please refer to our Introduction to Archetypes.

On to creating your first project! In order to create the simplest of Maven projects, execute the following from the command line:

```shell
mvn -B archetype:generate -DgroupId=com.mycompany.app \
                          -DartifactId=my-app \
                          -DarchetypeArtifactId=maven-archetype-quickstart \
                          -DarchetypeVersion=1.4
```
Once you have executed this command, you will notice a few things have happened. First, you will notice that a directory named my-app has been created for the new project, and this directory contains a file named pom.xml that should look like this:

pom.xml contains the Project Object Model (POM) for this project. The POM is the basic unit of work in Maven. This is important to remember because Maven is inherently project-centric in that everything revolves around the notion of a project. In short, the POM contains every important piece of information about your project and is essentially one-stop-shopping for finding anything related to your project. Understanding the POM is important and new users are encouraged to refer to the Introduction to the POM.

This is a very simple POM but still displays the key elements every POM contains, so let's walk through each of them to familiarize you with the POM essentials:

- **project** This is the top-level element in all Maven pom.xml files.
- **modelVersion** This element indicates what version of the object model this POM is using. The version of the model itself changes very infrequently but it is mandatory in order to ensure stability of use if and when the Maven developers deem it necessary to change the model.
- **groupId** This element indicates the unique identifier of the organization or group that created the project. The groupId is one of the key identifiers of a project and is typically based on the fully qualified domain name of your organization. For example org.apache.maven.plugins is the designated groupId for all Maven plugins.
- **artifactId** This element indicates the unique base name of the primary artifact being generated by this project. The primary artifact for a project is typically a JAR file. Secondary artifacts like source bundles also use the artifactId as part of their final name. A typical artifact produced by Maven would have the form <artifactId>-<version>.<extension> (for example, myapp-1.0.jar).
- **version** This element indicates the version of the artifact generated by the project. Maven goes a long way to help you with version management and you will often see the SNAPSHOT designator in a version, which indicates that a project is in a state of development. We will discuss the use of snapshots and how they work further on in this guide.
- **name** This element indicates the display name used for the project. This is often used in Maven's generated documentation.
- **url** This element indicates where the project's site can be found. This is often used in Maven's generated documentation.
properties This element contains value placeholders accessible anywhere within a POM.
- **dependencies** This element's children list dependencies. The cornerstone of the POM.
- **build** This element handles things like declaring your project's directory structure and managing plugins.
For a complete reference of what elements are available for use in the POM please refer to our [POM](https://maven.apache.org/ref/3.8.6/maven-model/maven.html) Reference. Now let's get back to the project at hand.

As you can see, the project created from the archetype has a POM, a source tree for your application's sources and a source tree for your test sources. This is the standard layout for Maven projects (the application sources reside in ${basedir}/src/main/java and test sources reside in ${basedir}/src/test/java, where ${basedir} represents the directory containing pom.xml).

If you were to create a Maven project by hand this is the directory structure that we recommend using. This is a Maven convention and to learn more about it you can read our [Introduction to the Standard Directory Layout](https://maven.apache.org/guides/introduction/introduction-to-the-standard-directory-layout.html).

After the archetype generation of your first project you will also notice that the following directory structure has been created:

summary : archetype is a template of a project which is combined with some user input to produce a working Maven project that has been tailored to the user's requirements

## How do I compile my application sources?

Change to the directory where pom.xml is created by archetype:generate and execute the following command to compile your application sources:
The first time you execute this (or any other) command, Maven will need to download all the plugins and related dependencies it needs to fulfill the command. From a clean installation of Maven, this can take quite a while (in the output above, it took almost 4 minutes). If you execute the command again, Maven will now have what it needs, so it won't need to download anything new and will be able to execute the command much more quickly.

As you can see from the output, the compiled classes were placed in ${basedir}/target/classes, which is another standard convention employed by Maven. So, if you're a keen observer, you'll notice that by using the standard conventions, the POM above is very small and you haven't had to tell Maven explicitly where any of your sources are or where the output should go. By following the standard Maven conventions, you can get a lot done with very little effort! Just as a casual comparison, let's take a look at what you might have had to do in Ant to accomplish the same thing.

Now, this is simply to compile a single tree of application sources and the Ant script shown is pretty much the same size as the POM shown above. But we'll see how much more we can do with just that simple POM!

## How do I compile my test sources and run my unit tests?
Now you're successfully compiling your application's sources and now you've got some unit tests that you want to compile and execute (because every programmer always writes and executes their unit tests *nudge nudge wink wink*).

Execute the following command:
```shell
mvn test
```
Upon executing this command you should see output like the following:
Some things to notice about the output:

- Maven downloads more dependencies this time. These are the dependencies and plugins necessary for executing the tests (it already has the dependencies it needs for compiling and won't download them again).
- Before compiling and executing the tests Maven compiles the main code (all these classes are up to date because we haven't changed anything since we compiled last).
If you simply want to compile your test sources (but not execute the tests), you can execute the following:

```shell
mvn test-compile
```
Now that you can compile your application sources, compile your tests, and execute the tests, you'll want to move on to the next logical step so you'll be asking ...

## How do I create a JAR and install it in my local repository?

Making a JAR file is straight forward enough and can be accomplished by executing the following command:
```shell
mvn package
```
You can now take a look in the ${basedir}/target directory and you will see the generated JAR file.

Now you'll want to install the artifact you've generated (the JAR file) in your local repository (${user.home}/.m2/repository is the default location). For more information on repositories you can refer to our Introduction to Repositories but let's move on to installing our artifact! To do so execute the following command:

```shell
mvn install
```
Note that the surefire plugin (which executes the test) looks for tests contained in files with a particular naming convention. By default the tests included are:

- \*\*/*Test.java
- \*\*/Test*.java
- \*\*/*TestCase.java
And the default excludes are:

- \*\*/Abstract*Test.java
- \*\*/Abstract*TestCase.java

```shell
mvn site
```
and 
```shell
mvn clean  # This will remove the target directory with all the build data before starting so that it is fresh.
```

## What is a SNAPSHOT version?

The SNAPSHOT value refers to the 'latest' code along a development branch, and provides no guarantee the code is stable or unchanging. Conversely, the code in a 'release' version (any version value without the suffix SNAPSHOT) is unchanging.

In other words, a SNAPSHOT version is the 'development' version before the final 'release' version. The SNAPSHOT is "older" than its release.

During the release process, a version of x.y-SNAPSHOT changes to x.y. The release process also increments the development version to x.(y+1)-SNAPSHOT. For example, version 1.0-SNAPSHOT is released as version 1.0, and the new development version is version 1.1-SNAPSHOT.

## How do I use plugins?

Whenever you want to customise the build for a Maven project, this is done by adding or reconfiguring plugins.

For this example, we will configure the Java compiler to allow JDK 5.0 sources. This is as simple as adding this to your POM:
```xml
<build>
  <plugins>
    <plugin>
      <groupId>org.apache.maven.plugins</groupId>
      <artifactId>maven-compiler-plugin</artifactId>
      <version>3.3</version>
      <configuration>
        <source>1.5</source>
        <target>1.5</target>
      </configuration>
    </plugin>
  </plugins>
</build>
```

You'll notice that all plugins in Maven look much like a dependency - and in some ways they are. This plugin will be automatically downloaded and used - including a specific version if you request it (the default is to use the latest available).

The configuration element applies the given parameters to every goal from the compiler plugin. In the above case, the compiler plugin is already used as part of the build process and this just changes the configuration. It is also possible to add new goals to the process, and configure specific goals. For information on this, see the [Introduction to the Build Lifecycle](https://maven.apache.org/guides/introduction/introduction-to-the-lifecycle.html).

To find out what configuration is available for a plugin, you can see the [Plugins List](https://maven.apache.org/plugins/) and navigate to the plugin and goal you are using. For general information about how to configure the available parameters of a plugin, have a look at the [Guide to Configuring Plugins](https://maven.apache.org/guides/mini/guide-configuring-plugins.html).

## How do I add resources to my JAR?

Another common use case that can be satisfied which requires no changes to the POM that we have above is packaging resources in the JAR file. For this common task, Maven again relies on the Standard Directory Layout, which means by using standard Maven conventions you can package resources within JARs simply by placing those resources in a standard directory structure.

You see below in our example we have added the directory `${basedir}/src/main/resources` into which we place any resources we wish to package in our JAR. The simple rule employed by Maven is this: any directories or files placed within the `${basedir}/src/main/resources` directory are packaged in your JAR with the exact same structure starting at the base of the JAR.
```shell
my-app
|-- pom.xml
`-- src
    |-- main
    |   |-- java
    |   |   `-- com
    |   |       `-- mycompany
    |   |           `-- app
    |   |               `-- App.java
    |   `-- resources
    |       `-- META-INF
    |           `-- application.properties
    `-- test
        `-- java
            `-- com
                `-- mycompany
                    `-- app
                        `-- AppTest.java
```

So you can see in our example that we have a META-INF directory with an application.properties file within that directory. If you unpacked the JAR that Maven created for you and took a look at it you would see the following:
```shell
|-- META-INF
|   |-- MANIFEST.MF
|   |-- application.properties
|   `-- maven
|       `-- com.mycompany.app
|           `-- my-app
|               |-- pom.properties
|               `-- pom.xml
`-- com
    `-- mycompany
        `-- app
            `-- App.class
```
As you can see, the contents of ${basedir}/src/main/resources can be found starting at the base of the JAR and our application.properties file is there in the META-INF directory. You will also notice some other files there like META-INF/MANIFEST.MF as well as a pom.xml and pom.properties file. These come standard with generation of a JAR in Maven. You can create your own manifest if you choose, but Maven will generate one by default if you don't. (You can also modify the entries in the default manifest. We will touch on this later.) The pom.xml and pom.properties files are packaged up in the JAR so that each artifact produced by Maven is self-describing and also allows you to utilize the metadata in your own application if the need arises. One simple use might be to retrieve the version of your application. Operating on the POM file would require you to use some Maven utilities but the properties can be utilized using the standard Java API and look like the following:
```shell
#Generated by Maven
#Tue Oct 04 15:43:21 GMT-05:00 2005
version=1.0-SNAPSHOT
groupId=com.mycompany.app
artifactId=my-app
```
To add resources to the classpath for your unit tests, you follow the same pattern as you do for adding resources to the JAR except the directory you place resources in is ${basedir}/src/test/resources. At this point you would have a project directory structure that would look like the following:
```shell
my-app
|-- pom.xml
`-- src
    |-- main
    |   |-- java
    |   |   `-- com
    |   |       `-- mycompany
    |   |           `-- app
    |   |               `-- App.java
    |   `-- resources
    |       `-- META-INF
    |           |-- application.properties
    `-- test
        |-- java
        |   `-- com
        |       `-- mycompany
        |           `-- app
        |               `-- AppTest.java
        `-- resources
            `-- test.properties
```
In a unit test you could use a simple snippet of code like the following to access the resource required for testing:

```java
...
 
// Retrieve resource
InputStream is = getClass().getResourceAsStream( "/test.properties" );
 
// Do something with the resource
 
...
```