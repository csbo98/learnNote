# C\C++

## C\C++程序在Linux上执行的流程

C\C++程序在Linux执行时，都是由SHELL收集包括程序名在内的所有参数，然后调用fork生成新进程，在execve之前设置好标准输入输出和错误输出的文件，然后把相关参数传递给execve，由execve载入可执行文件然后开始从入口_start处开始执行，此后做传递环境变量、初始化全局变量等操作，最后调用main函数并且把命令行参数传递给它，开始执行程序。
[C\C++程序执行全流程](http://dbp-consulting.com/tutorials/debugging/linuxProgramStartup.html)

***

## 全局变量与局部变量初始化

1. 通常情况下，在C/C++中，程序不是直接进入main程序开始执行，而是首先执行一些其他的启动函数调用main函数，部分全局变量的初始化就在该函数中执行，该函数也会获取环境变量和命令行参数等；在main函数执行结束后，该启动函数还会调用一些析构函数或者是atexit()登记的一些函数。
2. C/C++中的一般的全局变量(主要是内置变量)在编译期完成初始化；而不是在程序运行时，main函数运行之前。(C/C++中一般的全局变量应该也分为动态初始化和静态初始化，动态初始化时应该也是在运行时完成初始化)
3. C++中类的全局变量是在程序运行时，main函数执行之前初始化的。

***

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

### 类成员初始化

上面那篇文章还有一个重要的点是类的成员的初始化，尤其是类的类成员变量的初始化，关于类的初始化一定要记住下面几个关键点：

1. C++11新标准规定，可以为数据成员提供一个类内初始值。**在创建对象时**，类内初始值将用于初始化数据成员，这个类内初始值只能使用等于号或者大括号给定。

```C++

class Stu{
public:
    Stu(int a, int b) : a(a), b(b) {}
    int a;
    int b;
};

class People{

public:

    People(int num)/*:vec(num) 这种方式是调用了vec的构造函数来初始化,应该是在创建对象的时候调用*/{
        cout << "before constructor" << endl;
        cout << "m_age: " << age << endl;
        // 验证在此之前，已经调用了vec的构造函数
        cout << "m_vec size:" << vec.size() << endl;
    }

private:

    int age = 100;
    // Stu stu(1,2);
    // vector<int> vec1(50); // 错误形式,在类内不能用()这种形式初始化类成员，只能在初始化列表里面这样用
    vector<int> vec2;
    vector<int> vec3{1, 2, 3, 4, 5};
    vector<int> vec4 = vector<int>(); // 对于任何成员，在类内都只能使用大括号和等号这两种初始化方式，为成员指定一个在创建对象时候的初始值
    Stu stu{1,2};
}; 
```

2. **无论何时**，只要类的对象被创建就会执行构造函数。
   **无论何时**，只要类的对象被创建就会执行构造函数。
   **无论何时**，只要类的对象被创建就会执行构造函数。

3. 类的初始化取决于构造函数中对数据成员的初始化，如果没有在构造函数的初始值列表中显式地初始化数据成员，**那么成员将在构造函数体之前执行默认初始化**，也就是说如果在构造函数的初始化列表里面显示初始化数据成员的话就没有默认初始化了。**构造函数体里面是对成员变量的赋值而不是初始化**

```C++
// 通过构造函数初始值列表初始化数据成员: 数据成员通过提供的初始值进行初始化
class Cat {
 public:
    int age;
    explicit Cat(int i) : age(i) {}
};

// 数据成员先进行默认初始化, 再通过构造函数参数进行赋值操作
// 这种方法虽然合法但是比较草率, 造成的影响依赖于数据成员的类型
class Dog {
 public:
    int age;
    explicit Dog(int i) {
        age = i;
    }
};
```

***

## Union联合体和结构体(匿名用法)

[union联合体匿名用法](https://www.cnblogs.com/guozqzzu/p/3626893.html)

[struct结构体匿名用法](https://docs.oracle.com/cd/E19205-01/820-1214/bkael/index.html)

***

## C\C++内敛汇编

C\C++语言中都可以插入汇编代码用于一些特殊的目的。阅读代码时偶尔会看到，在写操作系统实验中也会遇到一些。下面几篇博客对汇编代码都有一些简单的介绍，可以在需要的时候参考一下。

1. [C内敛汇编，可以了解纯汇编指令和可以与C变量建立关联的汇编指令的基本格式](https://akaedu.github.io/book/ch19s05.html)
2. [Linux Assembly，介绍了Intel汇编语法和AT&T的语法区别](http://www.linuxassembly.org/linasm.html#Command_Line_Arguments)
3. [这篇博客讲了基本汇编语法、扩展汇编语法和一些小例子帮助理解](http://www.delorie.com/djgpp/doc/brennan/brennan_att_inline_djgpp.html)

***

## C++类静态成员变量

静态成员变量可以用来实现多个对象共享数据的目标，用关键字static修饰，静态成员变量属于类而不属于某个具体的对象。

static成员变量**必须**在类声明的外部初始化，具体形式为：
```type class::name = value; // 静态成员变量初始化时不能再加static```

static成员变量的内存既不是在声明类时分配，也不是在创建对象时分配，而是**在初始化时分配**，也即没有在类外初始化的static成员变量不能使用。

static成员不占用对象的内存，而是在所有对象之外开辟内存，即使不创建对象也可以访问。static成员变量和普通的static变量一样，都在地址空间的全局数据区分配内存，**到程序结束时才释放**，也就是说，static成员变量不会随着对象的创建而分配内存，也不随着对象的销毁而释放内存。

```C++

#include <iostream>
using namespace std;

class Student{
public:
    Student(char *name, int age, float score);
    void show();
public:  //声明静态成员函数
    static int getTotal();
    static float getPoints();
private:
    static int m_total;  //总人数
    static float m_points;  //总成绩
private:
    char *m_name;
    int m_age;
    float m_score;
};

int Student::m_total = 0;
float Student::m_points = 0.0;

Student::Student(char *name, int age, float score): m_name(name), m_age(age), m_score(score){
    m_total++;
    m_points += score;
}
void Student::show(){
    cout<<m_name<<"的年龄是"<<m_age<<"，成绩是"<<m_score<<endl;
}
//定义静态成员函数
int Student::getTotal(){
    return m_total;
}
float Student::getPoints(){
    return m_points;
}

int main(){
    (new Student("小明", 15, 90.6)) -> show();
    (new Student("李磊", 16, 80.5)) -> show();
    (new Student("张华", 16, 99.0)) -> show();
    (new Student("王康", 14, 60.8)) -> show();

    int total = Student::getTotal();
    float points = Student::getPoints();
    cout<<"当前共有"<<total<<"名学生，总成绩是"<<points<<"，平均分是"<<points/total<<endl;

    return 0;
}
```

## C++静态成员函数

静态成员函数只能访问静态成员（普通成员函数可以访问所有的成员）。静态成员函数与普通成员函数的根本区别在于：普通成员函数有 this 指针，可以访问类中的任意成员；而静态成员函数没有 this 指针，只能访问静态成员（包括静态成员变量和静态成员函数），**没有this指针，就不知道指向那个对象，没法访问对象的成员变量**。

编译器在编译一个普通成员函数时，会隐式地增加一个形参 this，并把当前对象的地址赋值给 this，所以普通成员函数只能在创建对象后通过对象来调用，因为它需要当前对象的地址。而静态成员函数可以通过类来直接调用，编译器不会为它增加形参 this，它不需要当前对象的地址，所以不管有没有创建对象，都可以调用静态成员函数。

和静态成员变量类似，静态成员函数在声明时要加 static，在定义时不能加 static。

***

## C\C++中内存分配

malloc和new申请的内存必须要被对应的free和delete释放，不管是在函数内部申请的内存还是在函数外部申请的内存都是需要释放的。函数内部申请的内存不会因为函数返回就被释放。

**析构函数在对象被销毁的时候调用，new和delete与malloc和free的最大不同之处是用new分配内存会调用构造函数，用delete释放内存时会调用析构函数。**

***

## C++继承

继承可以理解一个类从另一个类获取成员变量和成员函数的过程。

以下是两种典型的使用继承的场景：

1) **当创建的新类与现有的类相似，只是多出若干成员变量或成员函数时**，可以使用继承，这样不但会减少代码量，而且新类会拥有基类的所有功能。

2) **当需要创建多个类，它们拥有很多相似的成员变量或成员函数时**，也可以使用继承。可以将这些类的共同成员提取出来，定义为基类，然后从基类继承，既可以节省代码，也方便后续修改成员。

```C++
class 派生类名:［继承方式］ 基类名{
    派生类新增加的成员
};
```

继承方式限定了基类成员在派生类中的访问权限，可以是 public、protected、private，默认为 private。protected 成员和 private 成员类似，都不能通过对象访问。但是当存在继承关系时，protected 和 private 就不一样了：**基类中的 protected 成员可以在派生类中使用，而基类中的 private 成员不能在派生类中使用**。

如果派生类中的成员(包括成员变量和成员函数)和基类中的成员重名，就会遮蔽从基类继承过来的成员。也即在派生类中使用该成员时(包括在定义派生类时使用，也包括通过派生类对象访问该成员)，会使用派生类中新增的成员。

**虚函数的作用**：虚函数的作用是允许在派生类中重新定义与基类同名的函数，**并且可以通过基类指针或引用来访问基类和派生类中的同名函数**。

当把基类的某个成员函数声明为虚函数后，允许在其派生类中对该函数重新定义，赋予它新的功能，并且可以通过指向基类的指针指向同一类族中不同类的对象，从而调用其中的同名函数。由虚函数实现的动态多态性就是：同一类族中不同类的对象，对同一函数调用作出不同的响应。

虚函数的使用方法是：

1. 在基类用virtual声明成员函数为虚函数。这样就可以在派生类中重新定义此函数，为它赋予新的功能，并能方便地被调用。在类外定义虚函数时，不必再加virtual。

2. 在派生类中重新定义此函数，要求函数名、函数类型、函数参数个数和类型全部与基类的虚函数相同，并根据派生类的需要重新定义函数体。
C++规定，当一个成员函数被声明为虚函数后，其派生类中的同名函数都自动成为虚函数。因此在派生类重新声明该虚函数时，可以加virtual，也可以不加，但习惯上一般在每一层声明该函数时都加virtual，使程序更加清晰。如果在派生类中没有对基类的虚函数重新定义，则派生类简单地继承其直接基类的虚函数。

3. 定义一个指向基类对象的指针变量，并使它指向同一类族中需要调用该函数的对象。

4. 通过该指针变量调用此虚函数，此时调用的就是指针变量指向的对象的同名函数。

***

## string与其它类型之间转换

```C++
    #include <sstream>
    // 借助stringstream类，将int类型转换为string类型
    int port;
    std::stringstream portstr;
    portstr << port;
```

***

## const与constexpr区别

const作用是声明变量是一个常量，它的值不能被改变，const对象的初始值可以是任意复杂的表达式。const对象可以在运行时初始化也可以在编译时初始化。
常量表达式就是指值不会改变并且在编译过程就能得到计算结果的表达式。constexpr是指定变量是一个常量表达式，**constexpr对象的初始值必须是一个常量表达式，且必须在编译时初始化。**

