# proxy

1. 通过[shadowsocks](https://zh.wikipedia.org/wiki/Shadowsocks)可以简单了解一下socks5协议等的基本原理。
2. 通过这篇博客理解shadowsocks等的工作原理，可以根据里面的说明给git、terminal等软件单独配置代理，[代理工作原理](https://xdev.in/posts/mac-proxy/)。如果使用了proxy，那么需要给git正确的配置，否则无法连接到github。
3. 墙的一种原理是污染DNS，让一些域名的IP无法被解析出来。



## Linux配置clash代理的方式

[这篇文章专门讲述了需要额外下载clashdashboard来访问ui界面](https://www.modb.pro/db/399645)

通过一个url来访问服务时，在hostname和端口确定的情况下，输入不同的目录会访问到不同的服务，因此一定要阅读清楚对应的文章，确定自己访问的是正确的url。

[使用clash搭建透明网关实现旁路科学上网，就是一种比较复杂的代理方式，这篇文章介绍了很多代理的玩法，比如smartDNS和透明网关等](https://little-star.love/posts/5d083060/)
