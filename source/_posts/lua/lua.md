---
title: Lua Reference Manual
categories:
- lua
thumbnailImagePosition: bottom
# thumbnailImage: http://d1u9biwaxjngwg.cloudfront.net/cover-image-showcase/city-750.jpg
coverImage: https://user-images.githubusercontent.com/46363359/198887282-458603de-a3f5-46c0-a866-488f3ac00b14.jpg
metaAlignment: center
coverMeta: out
---
> 原文链接: https://www.lua.org/manual/5.4/

Lua is a powerful, efficient, lightweight, embeddable scripting language. It supports procedural programming, object-oriented programming, functional programming, data-driven programming, and data description.

<!-- more -->
<!-- toc -->


# 1 – Introduction

Lua combines simple procedural syntax with powerful data description constructs based on associative(`adj.联合的`) arrays and extensible semantics. Lua is dynamically typed, runs by interpreting bytecode with a register-based virtual machine, and has automatic memory management with a generational garbage collection, making it ideal for configuration, scripting, and rapid prototyping.

Lua is implemented as a library, written in clean C, the common subset of Standard C and C++. The Lua distribution includes a host program called lua, which uses the Lua library to offer a complete, standalone Lua interpreter, for interactive or batch use. Lua is intended to be used both as a powerful, lightweight, embeddable scripting language for any program that needs one, and as a powerful but lightweight and efficient stand-alone language.

As an extension language, Lua has no notion of a "main" program: it works embedded in a host client, called the embedding program or simply the host. (Frequently, this host is the stand-alone lua program.) The host program can invoke functions to execute a piece of Lua code, can write and read Lua variables, and can register C functions to be called by Lua code. Through the use of C functions, Lua can be augmented to cope with a wide range of different domains, thus creating customized programming languages sharing a syntactical framework.

Lua is free software, and is provided as usual with no guarantees, as stated in its license. The implementation described in this manual is available at Lua's official web site, www.lua.org.

Like any other reference manual, this document is dry in places. For a discussion of the decisions(n.决定) behind the design of Lua, see the technical papers available at Lua's web site. For a detailed introduction to programming in Lua, see Roberto's book, Programming in Lua.

summary:</br>
1. lua is dynamic, interprete language.with a register-based virtual machine,automatic memory management, GC,making it ideal for configuration, scripting, and rapid prototyping </br>
2. no main function,embeded a host client that host program which execute lua code, lua could call C function(code)
