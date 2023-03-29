# CPU Cache

CPU cache是CPU用来减小从主存访问数据的时间开销的hardware cache。cache是更小和更快的memory，并且距离processor core更近，它存储着频繁被使用的内存位置的数据copy。cache给了一个main memory很快的假象。（TLB是MMU的一部分，与CPU cache没有直接关系，这个理解应该是对的）。

### 乱序执行（维基百科中看到了，插一下）：

乱序执行是在大多数高端处理器中使用的方案，去利用本会被浪费掉的指令周期。在这个方案中，处理器按照输入数据和执行单元的可用性控制的决定的顺序来执行指令，而不是指令在程序中的原始顺序。这样做，处理器可以避免在等待前一条指令完成时处于空闲状态，同时可以处理能够立即独立运行的下一条指令。另一个解决CPU stall的方法是同时多线程（也叫超线程）技术。

![image-20211125213615714](C:\Users\cserbo\AppData\Roaming\Typora\typora-user-images\image-20211125213615714.png)

## Associativity

内存中数据块的放置策略决定了主存中特定条目的副本将放在缓存的那个位置。常见的策略有三种，分别是direct mapped cache、fully associative cache和set associative cache。

1. direct mapped cache：主存中的每一个条目（位置）仅仅能放在cache中的一个特定位置。因此，也叫one-way set associative cache。假设x是缓存中的block number，y是内存的block number，n是缓存中block的数量，那么有x = y % n。
2. fully associative cache：主存中的每一个条目的副本可以放在cache中的任何位置。
3. set associative cache：是fully associative cache和direct mapped cache的结合，组间直接映射，组内全相联。主存中的每一项可以放在cache的N个位置当中的一个，这叫N-way set associative。

选择正确的associativity值涉及到trade-off。**cache中associativity越大，cache miss rate会越小，CPU会浪费更少的时间在读写主存上面。**但是，当associativity越大（也就是内存中一个位置在cache中可放置位置越多），要确定某个位置是否在cache中要搜索的cache entries也就越多，而检查更多位置需要power和chip area，很可能也要更多时间。通常的准则是加倍associativity（从direct mapped变为two-way，或从two-way变到four-way）和加倍cache size对提升cache hit rate有相同的效果。**减小cache的associativity，可以作为一个power-saving的方法。**

