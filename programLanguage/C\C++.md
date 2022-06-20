# C\C++

## C\C++程序在Linux上执行的流程

C\C++程序在Linux执行时，都是由SHELL收集包括程序名在内的所有参数，然后调用fork生成新进程，在execve之前设置好标准输入输出和错误输出的文件，然后把相关参数传递给execve，由execve载入可执行文件然后开始从入口_start处开始执行，此后做传递环境变量、初始化全局变量等操作，最后调用main函数并且把命令行参数传递给它，开始执行程序。
[C\C++程序执行全流程](http://dbp-consulting.com/tutorials/debugging/linuxProgramStartup.html)

## 全局变量与局部变量初始化

1. 通常情况下，在C/C++中，程序不是直接进入main程序开始执行，而是首先执行一些其他的启动函数调用main函数，部分全局变量的初始化就在该函数中执行，该函数也会获取环境变量和命令行参数等；在main函数执行结束后，该启动函数还会调用一些析构函数或者是atexit()登记的一些函数。
2. C/C++中的一般的全局变量(主要是内置变量)在编译期完成初始化；而不是在程序运行时，main函数运行之前。(C/C++中一般的全局变量应该也分为动态初始化和静态初始化，动态初始化时应该也是在运行时完成初始化)
3. C++中类的全局变量是在程序运行时，main函数执行之前初始化的。

## C++初始化规则详解

[这篇博客对C++的初始化有一个比较全面的总结，尤其是C++11标准中的列表初始化](https://segmentfault.com/a/1190000039844285)

对于类类型而言，使用列表初始化时，它会自动调用匹配的构造函数, 本质上还是给构造函数传参，进而调用对应的构造函数俩初始化; 类对象在被列表初始化时，会优先调用列表初始化构造函数，如果没有列表初始化构造函数则会根据提供的花括号值调用匹配的构造函数。在匹配构造函数时，编译器也是根据花括号内的值的类型和数目来匹配的。

其实跟重载函数的匹配有一点相似

从这里可以看出来，在使用列表初始化时，一定要注意参数的数目是否匹配；

```C++
#include <initializer_list>
#include <vector>
#include <iostream>

class Cat {
 public:
    // C++中，大多数容器类型可以直接赋值，原因很简单，他们都定义了对应的拷贝构造函数或者是重载了=操作符 
    std::vector<int> data;
    Cat() = default;
    // 接受初始化列表的构造函数
    Cat(std::initializer_list<int> list) {
        for (auto it = list.begin(); it != list.end(); ++it) {
            data.push_back(*it);
        }
    }

    Cat(std::vector<int> data) {
        this->data = data;
    }

    Cat(int a, int b, int c) {
        data.push_back(a);
        data.push_back(b);
        data.push_back(c);
        std::cout << "Cat(int a, int b, int c)" << std::endl;
    }

    void print() {
        for (auto it = data.begin(); it != data.end(); ++it) {
            std::cout << *it << " ";
        }
        std::cout << std::endl;
    }
};

int main() {
    // 在这个示例中，会首先选择列表初始化构造函数，如果没有才会调用只有一个形参的构造函数
    // Cat(std::vector<int> data)
    Cat cat1 = {{1, 2, 3, 4, 5}};
    Cat cat2{{1, 2, 3}};

    cat1.print();
    cat2.print();
    // 如果没有列表初始化构造函数，会调用Cat(int a, int b, int c)
    Cat cat3{1, 2, 3}; // Cat(int a, int b, int c)
    cat3.print();
}

```

下面是一个列表初始化函数返回值临时变量的例子：

```C++

#include <iostream> // 仅仅是把iostream里面的内容在这里做一个替换，所以include语句放在文件的那个地方都是可以的

// 一个使用列表初始化函数返回的临时变量的例子
// C++11之后，列表初始化可以应用于所有对象的初始化
std::vector<std::string> foo(int i) {
    if (i < 5) {
        return {};  // 返回一个空vector对象
    }
    return {"tomo", "cat", "tomocat"};  // 返回列表初始化的vector对象
}

int main() {

    std::vector<std::string> v = foo(5);

    // 在C++中，一般使用列表来对容器类型进行初始化，目的是像用列表初始化数组那样指明
    // 容器中的元素
    // 容器类型初始化使用列表应该是🈶由容器设计者设计的，而不是由编译器设计的
    // 在C++中，自己应该是不太会设计需要用到列表初始化的代码，关键在于使用STL容器时要会使用他们的
    // 规定好的列表初始化方式。
    std::vector<std::string> v{"tomo", "cat", "tomocat"};
    int arr[] = {1, 2, 3, 4, 5};
    std::set<std::string> s = {"tomo", "cat"};
    std::map<std::string, std::string> m = {{"k1", "v1"}, {"k2", "v2"}, {"k3", "v3"}};
    std::pair<std::string, std::string> p = {"tomo", "cat"};

    return 0;
}

```

## Union联合体和结构体(匿名用法)

[union联合体匿名用法](https://www.cnblogs.com/guozqzzu/p/3626893.html)

[struct结构体匿名用法](https://docs.oracle.com/cd/E19205-01/820-1214/bkael/index.html)

## C\C++内敛汇编

C\C++语言中都可以插入汇编代码用于一些特殊的目的。阅读代码时偶尔会看到，在写操作系统实验中也会遇到一些。下面几篇博客对汇编代码都有一些简单的介绍，可以在需要的时候参考一下。

1. [C内敛汇编，可以了解纯汇编指令和可以与C变量建立关联的汇编指令的基本格式](https://akaedu.github.io/book/ch19s05.html)
2. [Linux Assembly，介绍了Intel汇编语法和AT&T的语法区别](http://www.linuxassembly.org/linasm.html#Command_Line_Arguments)
3. [这篇博客讲了基本汇编语法、扩展汇编语法和一些小例子帮助理解](http://www.delorie.com/djgpp/doc/brennan/brennan_att_inline_djgpp.html)
