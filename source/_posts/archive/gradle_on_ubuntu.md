---
title: Gradle On Ubuntu
categories: 
- archive
thumbnailImagePosition: bottom
coverImage: https://user-images.githubusercontent.com/46363359/199011820-d3673e76-0e62-44a0-84eb-9fa8867a6a5e.jpeg
metaAlignment: center
coverMeta: out
---

> source link: https://linuxize.com/post/how-to-install-gradle-on-ubuntu-20-04/

abstract: Gradle is a general-purpose tool used to build, automate, and deliver software. It is primarily used for Java, C++, and Swift projects.
<!-- more -->

Gradle combines the best features of Ant and Maven . Unlike its predecessors, which use XML for scripting, Gradle uses Groovy , a dynamic, object-oriented programming language for the Java platform to define the project and build scripts.

This guide explains how to install Gradle on Ubuntu 20.04. We’ll download the latest release of Gradle from their official website.


## Prerequisites
The instructions assume that you are logged in as root or user with [sudo privileges](https://linuxize.com/post/how-to-create-a-sudo-user-on-ubuntu/)

Installing OpenJDK
Gradle requires Java SE 8 or later to be installed on the machine.

Enter the following commands to install OpenJDK 11 :

```bash
sudo apt update
sudo apt install openjdk-11-jdk
```

Verify the Java installation by printing the Java version :
```bash
java -version

```
The output should look something like this:
```text
openjdk version "11.0.7" 2020-04-14
OpenJDK Runtime Environment (build 11.0.7+10-post-Ubuntu-3ubuntu1)
OpenJDK 64-Bit Server VM (build 11.0.7+10-post-Ubuntu-3ubuntu1, mixed mode, sharing)
```

## Downloading Gradle
At the time of writing this article, the latest version of Gradle is 6.5.1. Before continuing with the next step, check the Gradle releases page to see if a newer version is available.

Downloading the Gradle binary-only zip file in the `/tmp` directory using the following wget command:

```bash
VERSION=6.5.1
wget https://services.gradle.org/distributions/gradle-${VERSION}-bin.zip -P /tmp
```
Once the download is completed, unzip the file in the /opt/gradle directory:
```bash
sudo unzip -d /opt/gradle /tmp/gradle-${VERSION}-bin.zip
```
If you get an error saying “sudo: unzip: command not found”, install the unzip package with sudo apt install unzip.
Gradle is regularly updated with security patches and new features. To have more control over versions and updates, we’ll create a symbolic link named latest, which points to the Gradle installation directory:

```bash
sudo ln -s /opt/gradle/gradle-${VERSION} /opt/gradle/latest
```

Later, when upgrading Gradle, unpack the newer version and change the symlink to point to it.

Setting up the Environment Variables
We need to add the Gradle bin directory to the system PATH environment variable. To do so, open your text editor and create a new file named gradle.sh inside of the /etc/profile.d/ directory.

```bash
sudo nano /etc/profile.d/gradle.sh
```

Paste the following configuration:

```bash
/etc/profile.d/gradle.sh
export GRADLE_HOME=/opt/gradle/latest
export PATH=${GRADLE_HOME}/bin:${PATH}
```
here if you have self-gover system variables, please refer your setup 

Save and close the file. This script will be sourced at shell startup.



Make the script executable :
```bash
sudo chmod +x /etc/profile.d/gradle.sh
```
Load the environment variables in the current shell session using the source command:

```bash
source /etc/profile.d/gradle.sh
```
Verifying the Gradle Installation
To validate that Gradle is installed properly use the gradle -v command which will display the Gradle version:

```bash
gradle -v
```
You should see something like the following:

Welcome to Gradle 6.5.1!

Here are the highlights of this release:
 - Experimental file-system watching
 - Improved version ordering
 - New samples

For more details see https://docs.gradle.org/6.5.1/release-notes.html

```
------------------------------------------------------------
Gradle 6.5.1
------------------------------------------------------------

Build time:   2020-06-30 06:32:47 UTC
Revision:     66bc713f7169626a7f0134bf452abde51550ea0a

Kotlin:       1.3.72
Groovy:       2.5.11
Ant:          Apache Ant(TM) version 1.10.7 compiled on September 1 2019
JVM:          11.0.7 (Ubuntu 11.0.7+10-post-Ubuntu-3ubuntu1)
OS:           Linux 5.4.0-26-generic amd64
Copy
That’s it. You have installed the latest version of Gradle on your Ubuntu system, and you can start using it.
```

Conclusion
We’ve shown you how to install Gradle on Ubuntu 20.04. You can now visit the official Gradle Documentation page and learn how to get started with Gradle.

If you hit a problem or have feedback, leave a comment below.