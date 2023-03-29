## CPU内部各个部件时延

## 历年数据

[这个网站有历年CPU各个部件的时延数据，把访问L1的时间归一化到1ns，方便记忆](https://colin-scott.github.io/personal_website/research/interactive_latency.html)

1. 从数据中可以看出，分支预测失败的代价很小，在高级语言层面根本不必关心对循环和条件语句的优化。
2. mutex lock和unlock的代价远小于一次访存，因此不必过于考虑对锁的优化；至少其优先级应该小于对程序访存的优化，比如编写cache友好的代码（cacheline对齐等）。
3. 从数据中可以看出，访存的开销是访问L1的100倍左右，访问L2的开销大概是访问L1的几倍
4. SSD随机读取的时间与内存仍然相差很大，是内存的160倍左右；SSD顺序读取的时延是内存的16倍左右；disk顺序读取的时延是内存的几百倍



## 参考

1. [对CPU各部件时延数据的解读](https://www.zhihu.com/question/488790905/answer/2166887822)