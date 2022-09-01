# paper set

WSC就是google那种数据中心，整个数据中心就像一台计算机一样对外提供服务。数据中心中的机器可以运行各种各样不同的应用程序，可以同时运行latency-critical job和background job，针对这些job需要做好调度保证应用性能与数据中心资源的利用率。
云计算数据中心则和WSC完全不同，云计算数据中心中，把数据中心中的所有机器通过虚拟化变成一个一个的VM，最终这些VM会租给完全不相干的客户使用(这是一个最简单的场景)。
超算和WSC相似，整体作为一台高性能计算机来使用。不同的是，WSC利用请求级并行技术而超算利用线程级并行技术或数据级并行技术。

## CLITE: Efficient and QoS-Aware Co-location of Multiple Latency-Critical Jobs for Warehouse Scale Computers

this paper aims to co-locate mutiple latency-critical jobs with mutiple background jobs while: (1)meeting the QOS requirements of all latency-critical jobs, and (2)maximizing the performance of the background jobs.

与parties相比，能最大化bg job的性能，效率更高、能寻找到最优解并且鲁棒性强。

parties找不到最优解的根源是「explore only one dimension (resource) at a time and change the amount in small steps for one LC job」，在这篇论文的figure 2给出的例子中解释了为什么parties会失效。

BO方法是怎么把性能和配置对应起来的呢？？？给了一个当前的负载，怎么就能够给它找到合适的配置呢？？？
