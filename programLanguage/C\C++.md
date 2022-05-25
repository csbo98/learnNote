# C\C++

## C\C++程序在Linux上执行的流程

C\C++程序在Linux执行时，都是由SHELL收集包括程序名在内的所有参数，然后调用fork生成新进程，在execve之前设置好标准输入输出和错误输出的文件，然后把相关参数传递给execve，由execve载入可执行文件然后开始从入口_start处开始执行，此后做传递环境变量、初始化全局变量等操作，最后调用main函数并且把命令行参数传递给它，开始执行程序。
[C\C++程序执行全流程](http://dbp-consulting.com/tutorials/debugging/linuxProgramStartup.html)

## 全局变量与局部变量初始化

1. 通常情况下，在C/C++中，程序不是直接进入main程序开始执行，而是首先执行一些其他的启动函数调用main函数，部分全局变量的初始化就在该函数中执行，该函数也会获取环境变量和命令行参数等；在main函数执行结束后，该启动函数还会调用一些析构函数或者是atexit()登记的一些函数。
2. C/C++中的一般的全局变量(主要是内置变量)在编译期完成初始化；而不是在程序运行时，main函数运行之前。(C/C++中一般的全局变量应该也分为动态初始化和静态初始化，动态初始化时应该也是在运行时完成初始化)
3. C++中类的全局变量是在程序运行时，main函数执行之前初始化的。

## Union联合体和结构体(匿名用法)

[union联合体匿名用法](https://www.cnblogs.com/guozqzzu/p/3626893.html)

[struct结构体匿名用法](https://docs.oracle.com/cd/E19205-01/820-1214/bkael/index.html)

## C\C++内敛汇编

C\C++语言中都可以插入汇编代码用于一些特殊的目的。阅读代码时偶尔会看到，在写操作系统实验中也会遇到一些。下面几篇博客对汇编代码都有一些简单的介绍，可以在需要的时候参考一下。

1. [C内敛汇编，可以了解纯汇编指令和可以与C变量建立关联的汇编指令的基本格式](https://akaedu.github.io/book/ch19s05.html)
2. [Linux Assembly，介绍了Intel汇编语法和AT&T的语法区别](http://www.linuxassembly.org/linasm.html#Command_Line_Arguments)
3. [这篇博客讲了基本汇编语法、扩展汇编语法和一些小例子帮助理解](http://www.delorie.com/djgpp/doc/brennan/brennan_att_inline_djgpp.html)
