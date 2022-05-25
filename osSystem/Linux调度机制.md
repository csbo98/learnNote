# Linux调度机制

## Completely Fair Scheduler(CFS)

在CFS算法中，每一个CPU上都有一个run queue，这个run queue本质上是使用红黑树来实现的。使用红黑树来对「调度实体」(调度实体可以是一个线程、一个线程组、一个进程里面的全部线程)排序，排序的key是每一个「调度实体」的vruntime。vruntime指调度实体在CPU上“已经运行的时间”，它并不是真实的已经运行时间。

红黑树是中序遍历有序的，因此，每一次CFS调度器会调度run queue最左下的任务运行，CFS调度任务的流程如下：
>
> 1. 选择红黑树最左下的调度实体发射到CPU上执行；因为红黑树是中序遍历有序的，最左下的结点有最小的「spent execution time」；
> 2. 如果上述调度实体完成执行了，那么从系统和run queue红黑树中清除掉；
> 3. 如果上述调度实体达到了「maximum execution time」或者是因为自愿放弃时间片或别的原因停止运行，那么基于它新的「spent execution time」将其重新插入run queue红黑树。
> 4. 从红黑树中挑选新的最左下的调度实体发射到CPU上执行，重复上述迭代过程。

CFS并不是追求各个「调度实体」实际运行时间的绝对公平，应该是追求各个「调度实体」vruntime的绝对公平，这也应该就是「completely fair」的含义。

CFS默认情况下，是以线程作为调度单位的，可以使用cgroups为文件系统来把任务划分成组，以组为单位来调度。

[CFS调度器思想](https://www.kernel.org/doc/html/latest/scheduler/sched-design-CFS.html)
[CFS调度器一个理解](https://www.cnblogs.com/tianguiyu/articles/6091378.html)

## scheduling domain

调度域要解决的根本问题是：在一个multi-processor的系统中如何平衡各个CPU之间的负载，避免出现一些CPU负载很高另外一些CPU负载比较低的情况(或者是一些node负载很高，一些node负载很低)。在不同的CPU之间迁移进程存在一些开销，有些进程的迁移开销比较小，有些进程的迁移开销比较大，调度器必须做出合理的调度决策。

domain-based调度器希望通过一个新的数据结构(充分详细的描述了系统的结构和调度策略)解决上述问题：
> scheduling domain(struct sched_domain)是一组共享相同属性和调度策略的CPU，在这组CPU之间可以互相平衡负载。调度域是有层次结构的，一个multi-level system有多级调度域。
> 每一个调度域都包含一个或者多个CPU groups(struct sched_group)，这些group被调度域视作单个单元。当调度器尝试平衡域内的负载时，它会尝试平衡每一个CPU group所承担的负载，它不关心每一个CPU groups内部所发生的事情。

## CPU capacity

[CPU capacity是用来衡量CPU性能的，一般是用CPU的MIPS(每秒执行的百万指令数)来表示。CFS会使用这个每一个CPU的capacity来调度任务](https://github.com/torvalds/linux/blob/9269d27e519ae9a89be8d288f59d1ec573b0c686/Documentation/scheduler/sched-capacity.rst#52-rt)
