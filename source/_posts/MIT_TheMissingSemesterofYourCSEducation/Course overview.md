---
title: Course overview + the shell
categories:
- linux
---
MIT: The Missing Semester of Your CS Education
<!--more -->

<!--toc-->

# Course overview + the shell

[https://missing.csail.mit.edu/2020/course-shell/](https://missing.csail.mit.edu/2020/course-shell/)

[https://youtu.be/Z56Jmr9Z34Q](https://youtu.be/Z56Jmr9Z34Q)

# Motivation

As computer scientists, we know that computers are great at aiding in repetitive tasks. However, far too often, we forget that this applies just as much to our *use* of the computer as it does to the computations we want our programs to perform. We have a vast range of tools available at our fingertips that enable us to be more productive and solve more complex problems when working on any computer-related problem. Yet many of us utilize only a small fraction of those tools; we only know enough magical incantations by rote to get by, and blindly copy-paste commands from the internet when we get stuck.

This class is an attempt to address this.

We want to teach you how to make the most of the tools you know, show you new tools to add to your toolbox, and hopefully instill in you some excitement for exploring (and perhaps building) more tools on your own. This is what we believe to be the missing semester from most Computer Science curricula.

# Class structure

The class consists of 11 1-hour lectures, each one centering on a [particular topic](https://missing.csail.mit.edu/2020/). The lectures are largely independent, though as the semester goes on we will presume that you are familiar with the content from the earlier lectures. We have lecture notes online, but there will be a lot of content covered in class (e.g. in the form of demos) that may not be in the notes. We will be recording lectures and posting the recordings online.

We are trying to cover a lot of ground over the course of just 11 1-hour lectures, so the lectures are fairly dense. To allow you some time to get familiar with the content at your own pace, each lecture includes a set of exercises that guide you through the lecture’s key points. After each lecture, we are hosting office hours where we will be present to help answer any questions you might have. If you are attending the class online, you can send us questions at [missing-semester@mit.edu](mailto:missing-semester@mit.edu).

Due to the limited time we have, we won’t be able to cover all the tools in the same level of detail a full-scale class might. Where possible, we will try to point you towards resources for digging further into a tool or topic, but if something particularly strikes your fancy, don’t hesitate to reach out to us and ask for pointers!

# Topic 1: The Shell

## What is the shell?

Computers these days have a variety of interfaces for giving them commands; fanciful graphical user interfaces, voice interfaces, and even AR/VR are everywhere. These are great for 80% of use-cases, but they are often fundamentally restricted in what they allow you to do — you cannot press a button that isn’t there or give a voice command that hasn’t been programmed. To take full advantage of the tools your computer provides, we have to go old-school and drop down to **a textual interface: The Shell.**

## Using the shell (ls)

`which` 查看程序地址

`$PATH` 文件位置

## Navigating in the shell (cd)

文件权限问题，文件夹的`x`是可以，是指程序可不可以进去到该文件夹去search

`man` 命令

`mkdir` 命令

`cp` 命令

绝对路径和相对路径

## Connecting programs (管道)

这个地方用途较广泛，需要多看，多练习

这里主要是使用管道的功能,在完善下管道的使用

## A versatile and powerful tool （sys文件）

`sudo` view/delete/update any files on linux

`/sys` file control laptop system-level configuration, such as the state of various system LEDs (your path might be different):

```bash
$ sudo find -L /sys/class/backlight -maxdepth 2 -name '*brightness*'
/sys/class/backlight/thinkpad_screen/brightness
$ cd /sys/class/backlight/thinkpad_screen
$ sudo echo 3 > brightness
An error occurred while redirecting file 'brightness'
open: Permission denied
```

```bash
$ echo 1 | sudo tee /sys/class/leds/input6::scrolllock/brightness

#双冒号 "::" 在Linux中通常用于表示名称空间或层次结构的分隔符。让我用更详细的示例来解释它的含义：
#假设你有一个LED灯设备，命名为 "input6::scrolllock"。这个名字中的双冒号 "::" 表示设备名称的两个不同层次或命名空间的部分。
#"input6" 可能表示设备的输入接口或编号。
#"scrolllock" 可能表示设备的功能或状态，例如滚动锁定灯。
#这种命名约定可以帮助人们更清晰地理解设备的性质和层次结构。例如，它告诉你这个LED设备与输入接口6有关，同时它是一个控制滚动锁定状态的LED。
#当你执行 sudo tee /sys/class/leds/input6::scrolllock/brightness 命令时，它在 /sys/class/leds 路径下的 input6::scrolllock 设备的 brightness 文件中写入数据。这个文件通常用于控制LED的亮度或状态。所以，双冒号 "::" 在这里用于分隔设备的不同部分，以便更好地描述和管理设备。
```

`tee`  将命令的输出写入文件并在终端显示

# Next steps

下一章通过shell完成更复杂的自动化任务

# Exercises

All classes in this course are accompanied by a series of exercises. Some give you a specific task to do, while others are open-ended, like “try using X and Y programs”. We highly encourage you to try them out.

We have not written solutions for the exercises. If you are stuck on anything in particular, feel free to send us an email describing what you’ve tried so far, and we will try to help you out.

1. For this course, you need to be using a Unix shell like Bash or ZSH. If you are on Linux or macOS, you don’t have to do anything special. If you are on Windows, you need to make sure you are not running cmd.exe or PowerShell; you can use [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/) or a Linux virtual machine to use Unix-style command-line tools. To make sure you’re running an appropriate shell, you can try the command `echo $SHELL`. If it says something like `/bin/bash` or `/usr/bin/zsh`, that means you’re running the right program.
2. Create a new directory called `missing` under `/tmp`. 
3. Look up the `touch` program. The `man` program is your friend.
4. Use `touch` to create a new file called `semester` in `missing`.
5. Write the following into that file, one line at a time:  
    
    ```
    #!/bin/sh
    curl --head --silent https://missing.csail.mit.edu
    
    ```
    
    The first line might be tricky to get working. It’s helpful to know that `#` starts a comment in Bash, and `!` has a special meaning even within double-quoted (`"`) strings. Bash treats single-quoted strings (`'`) differently: they will do the trick in this case. See the Bash [quoting](https://www.gnu.org/software/bash/manual/html_node/Quoting.html) manual page for more information.
    
6. Try to execute the file, i.e. type the path to the script (`./semester`) into your shell and press enter. Understand why it doesn’t work by consulting the output of `ls` (hint: look at the permission bits of the file).
7. Run the command by explicitly starting the `sh` interpreter, and giving it the file `semester` as the first argument, i.e. `sh semester`. Why does this work, while `./semester` didn’t?
8. Look up the `chmod` program (e.g. use `man chmod`).
9. Use `chmod` to make it possible to run the command `./semester` rather than having to type `sh semester`. How does your shell know that the file is supposed to be interpreted using `sh`? See this page on the [shebang](https://en.wikipedia.org/wiki/Shebang_(Unix)) line for more information.
10. Use `|` and `>` to write the “last modified” date output by `semester` into a file called `last-modified.txt` in your home directory.
11. Write a command that reads out your laptop battery’s power level or your desktop machine’s CPU temperature from `/sys`. Note: if you’re a macOS user, your OS doesn’t have sysfs, so you can skip this exercise.