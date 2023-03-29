# Cmake

cmake是一个跨平台的buildsystem generator（最初是一个makefile生成器），可以生成各种各样的build system，比如ninja，xcode等。在cmake的语境中make、ninja等也叫做生成器

使用cmake编译项目的流程是：首先使用cmake生成一个project buildsystem(例如，使用一个简单的cmake < path-to-source > 命令)；之后可以选择直接使用对应的编译工具（例如，使用make）build和install项目，或者使用cmake --build和cmake --install命令来build和install项目。

## BuildSystem定义

> A buildsystem describes how to build a project's executables and libraries from its source code using a build tool to automate the process. it maybe a makefile, a Visual Studio project, a Xcode project, a Ninja build system, or a custom build system.


