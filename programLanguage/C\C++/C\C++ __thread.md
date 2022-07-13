# __thread修饰符

__thread是gcc内置的线程局部存储设施，存取效率可以和全局变量相比。**__thread变量每一个线程有一份独立实体，各个线程的值互不干扰**。可以用来修饰那些带有全局性且值可能变，但是又不值得用全局变量保护的变量。

```C++
#include<iostream>
#include<pthread.h>
#include<unistd.h>
using namespace std;

const int i=5;
__thread int var=i;  // 在不同的线程里面有不同的存储位置

void* worker1(void* arg);
void* worker2(void* arg);


int main(){
    pthread_t pid1,pid2;
    //__thread int temp=5;  不能修饰局部变量 
    static __thread  int temp=10; //修饰函数内的static变量

    pthread_create(&pid1,NULL,worker1,NULL);
    pthread_create(&pid2,NULL,worker2,NULL);
    pthread_join(pid1,NULL);
    pthread_join(pid2,NULL);
    
    cout<< dec << temp<<endl; //输出10
    cout<< "addr3: " << hex << &var << " "<< var << endl; //在主线程里面访问var，输出5
    
    return 0;
}

void* worker1(void* arg){
    cout<<++var<<endl; //输出 6
    cout<< "addr1: " << hex << &var <<" " << ++var << endl; //输出7
    return nullptr;
}

void* worker2(void* arg){
    sleep(1); //等待线程1改变var值，验证是否影响线程2
    cout<< "addr2: " << hex << &var <<" " << ++var << endl; //输出6
    return nullptr;
}
```
