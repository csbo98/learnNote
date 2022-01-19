[详细的讲述了MBR bios和UEFI bios应该怎么安装](https://www.cnblogs.com/masbay/p/10745170.html)

[单纯讲UEFI bios的情况下应该怎么安装配置](https://www.cnblogs.com/masbay/p/10844857.html)

[良许Linux提供的一个博客，这个里面关于开机引导、easyBSD说的和前面一个有一点不一样，它使用easyBSD来设置了引导的问题，这里说了开机引导有可能直接进入windows，这一点和之前说的都不一样，，，这一篇也没有提到关闭boot secure的内容](https://segmentfault.com/a/1190000022741636?utm_source=sf-related)

[这篇教程里面写了怎么设置使用win来引导ubuntu以及在这种情况下后续删除ubuntu只需要删除ubuntu所在的分区，，，这一篇没有提到关闭boot secure，，，， 这篇文章验证自己关于分区的想法，Linux中目录是默认不可变的，安装时所谓的分区不过是将一些目录作为挂载点挂到不同的分区里面方便管理，那么自己这边就仅仅分一个/分区就可以，，，连boot都可以不划分，但是自己这边为了能够方便启动所以就放在C盘](https://zhuanlan.zhihu.com/p/101307629)



[戴尔这篇文章针对dell的机器讲了一下，也是一篇值得参考的优秀的解决方案](https://www.dell.com/support/kbdoc/zh-cn/000131253/%E5%A6%82%E4%BD%95%E5%9C%A8%E6%88%B4%E5%B0%94pc%E4%B8%8A%E4%BD%9C%E4%B8%BA%E5%8F%8C%E5%90%AF%E5%8A%A8%E5%AE%89%E8%A3%85ubuntu%E5%92%8Cwindows-8%E6%88%9610?lang=zh)



醉了，不仅上面的几个教程有些内容不一样，就是按照同一个教程来安装，不同的人结果也可能不一样，，，，，这次安装踩了不少的坑，在搜索教程的时候就应该输入自己电脑型号来搜索，这样可能更能够得到更匹配的结果，，，很多博主写的内容也并不是完全可信的，尽管他们可能安装正确，但对这个过程的理解有可能是错误的。
那么在搜索这种教程的时候，不需要完全按照某一个教程来做，如果能够搜索到与自己的电脑型号完全匹配的结果，那么照着做自然不会错，如果搜不到那就多看几篇教程然后自己就根据自己机器的情况灵活解决吧。


[删除ubuntu1](https://www.cnblogs.com/pualus/p/7835422.html)
[这也是关于ubuntu删除的，这个看起来更靠谱一些](https://houkaifa.com/2019/08/15/ubuntu-uninstall/)
[这个教程看起来不错，照着这个教程完全做一遍再开机应该没问题](https://blog.csdn.net/Spacegene/article/details/86659349)
很多东西可能与自己特定的电脑环境有关，比如删除ubuntu，我按照删除ubuntu、用easyUEFI删除ubuntu启动项(里面有两个，我就全部删除了)，然后开机就卡在gurb那个界面无法进入windows，输入exit再回车也不行，说是启动镜像错误。进入BISO查看，发现在boot sequence发现有ubuntu，而且这玩意在BIOS里面删除不掉，我把它删掉之后，重新开机发现是删除的windows boot manager，而且还对BIOS做了一个大的更改，都没把它弄好，气死。。。。。。后来只能制作一个PE系统使用优盘把windows的启动引导项修复好，然后重新进入BISO就能把ubuntu删除掉，这下是彻底把ubuntu删除干净了。


本来C盘的磁盘号是1，D盘的磁盘号是0，安装完ubuntu之后他俩的磁盘号自动互相换了一下，可能是这个原因，windows启动变快了？

因为U盘用来制作了一次PE启动盘，然后**把PE给硬盘格式化的三个分区都删掉又格式化成为一个**，所以可能导致了以下问题：
Rufus在第二次向U盘写入镜像的时候总是显示设备被占用，然后无法写入U盘，然后把rufus在它自己同目录下面产生的rufus_files
文件删除掉，重启了一下电脑，就可以向U盘写入。
