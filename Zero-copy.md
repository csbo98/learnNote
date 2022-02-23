所有的进程共享同一个内核地址空间。所有的read操作应该是把数据从IO设备读入到page cache之后，就可以从page cache写入到进程的用户地址空间；反过来write操作应该是仅仅把数据从进程的用户地址空间直接写到page cache当中。
### Zero copy
zero copy这个技术是用来减少数据传输过程中的数据拷贝操作。在使用了zero copy的数据传输过程中，**CPU不执行从一个内存区域拷贝数据到另一个内存区域的任务**或者**没有不必要的数据拷贝**。在一些耗时的数据传输任务中，利用zero copy技术，可以节省CPU时钟周期和内存带宽。例如通过网络以很高的速度传输大文件，如果不使用zero copy，那么在传输过程中会消耗大量的CPU时钟周期。



### mmap
[mmap详解](https://nieyong.github.io/wiki_cpu/mmap%E8%AF%A6%E8%A7%A3.html)
[mmap手册](https://man7.org/linux/man-pages/man2/mmap.2.html)
