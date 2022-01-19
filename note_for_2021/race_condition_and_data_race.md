data race的定义如下：

[data race定义](https://docs.oracle.com/cd/E19205-01/820-0619/6ncbk8g6g/index.html)

![image-20211204203514800](C:\Users\cserbo\AppData\Roaming\Typora\typora-user-images\image-20211204203514800.png)

data race出现的三个条件：

1. 同一个进程里面的两个或者多个线程并发的访问同一个内存位置(多核时是并行的)；
2. 至少有一个访问是写操作；
3. 这些线程不使用任何任何的互斥锁来控制他们对那个内存位置的访问。

[race condition](https://stackoverflow.com/questions/11276259/are-data-races-and-race-condition-actually-the-same-thing-in-context-of-conc)：stackoverflow上这个问题对race condition和data race的解释比较清楚。

[race condition & data race](https://blog.regehr.org/archives/490)：这篇博客对这两个概念的解释也挺好，基本上与上面两个相同，记住这个概念，按照这个去回答。

