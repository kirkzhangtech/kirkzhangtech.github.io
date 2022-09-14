---
title: API Design Patterns
categories:
- WEB API

---

## 1. API介绍

### 1.1 什么是API

定义一组与系统交互的界面,是的用户有相对较小的权限操作系统

### 1.2 为什么API重要

不需要像GUI那样很"cosmetic"

### 1.3 什么是面向资源API

- RPC-API
RPC APIs are often designed in terms of interfaces and methods. As more and more of these are added over time, the end result can be an overwhelming and confusing API surface due to the fact that developers must learn each method individually. Obviously this is both time consuming and error-prone.
RPC的命名没有严格的要求，无状态的，随着RPC的接口增加，接口管理就会面临混乱结果
- HTTP-API
The architectural style of REST was introduced, primarily designed to work well with HTTP/1.1, but also to help tackle this problem. Its core principle is to define named resources that can be manipulated using a small number of methods. The resources and methods are known as nouns and verbs of APIs. With the HTTP protocol, the resource names naturally map to URLs, and methods naturally map to HTTP methods POST, GET, PUT, PATCH, and DELETE. This results in much fewer things to learn, since developers can focus on the resources and their relationship, and assume that they have the same small number of standard methods.
通常url就是资源的映射，对资源的CRUD就是对应HTTP的PATCH,POST,GET DELETE

> <https://cloud.google.com/apis/design/resources>

### 1.4 什么是"good"API

- Operational
你的API必须得work,高效。
- Expressive
你的method必须是具有描述意义的，告诉用户你能做什么
- Simple
Another common position on simplicity takes the old saying about the “common
case” (“Make the common case fast”) but focuses instead on usability while leaving
room for edge cases. This restatement is to “make the common case awesome and the
advanced case possible.” This means that whenever you add something that might
complicate an API for the benefit of an advanced user, it’s best to keep this complication sufficiently hidden from a typical user only interested in the common case. This
keeps the more frequent scenarios simple and easy, while still enabling more
advanced features for those who want them
- Predictable
方法和参数需要见名知意
APIs built using well-known, well-defined, clear

### summary

- Interfaces are contracts that define how two systems should interact with one another.
- APIs are special types of interfaces that define how two computer systems interact with one another, coming in many forms, such as downloadable libraries and web APIs.
- Web APIs are special because they expose functionality over a network, hiding the specific implementation or computational requirements needed for that functionality.
- Resource-oriented APIs are a way of designing APIs to reduce complexity byrelying on a standard set of actions, called methods, across a limited set of things, called resources.
- What makes APIs “good” is a bit ambiguous, but generally good APIs are operational, expressive, simple, and predictable.
- 对数据和系统的抽象会决定你的API -- 李沐
