# shell

## oh my zsh + powerlevel10k + suggestion + iTerm2

[一篇完整的配置教程，过程非常简单](https://www.packetmania.net/2021/11/13/iTerm2-OMZ-Powerlevel10k/)

## 各种shell的初始化文件详解

[重点讲了zsh的相关的初始化文件核bash与zsh的初始化文件调用流程图](https://unix.stackexchange.com/questions/537637/sshing-into-system-with-zsh-as-default-shell-doesnt-run-etc-profile)

[zsh和bash在内的各种shell的初始化文件](https://github.com/pyenv/pyenv/wiki/Unix-shell-initialization#zsh)



## 命令执行过程

在shell中执行程序(比如执行一个python或者pip命令)时，首先要查找该程序(或者命令)的路径(os会搜索一个目录列表找到跟命令同名的可执行文件，目录列表存在一个叫PATH的环境变量里面)，这是为了找到该程序的可执行文件，从而在fork子进程之后exec该程序的内容到新创建的进程中，从而才能执行该程序。

所以在执行程序时，要么给出该程序的路径，要么让shell可以找得到该程序的路径。对于一个程序如果不给出该程序的路径，那么shell会按照顺序查找PATH环境变量中的各个目录，找到之后就执行对应的程序。PATH中的目录是从左往右搜索的，所以目录列表中开头目录中匹配到的可执行文件优于另外一个。

所以为了直接输入程序名字而不用输入路径，可以使用两种方法：

1. 把该程序所在的目录放入PATH环境变量中；
2. 把该程序可执行文件或者是符号连接放入到PATH环境变量中已有目录中的任何一个，这个是为什么很多程序编译之后执行make install命令就可以直接使用程序名字而不需要输入程序路径。

Unix系统上面的任何命令都是一个普通的用户程序，比如echo、ls等，shell执行它们的方法与执行自己的普通程序一样。

Python中的subprocess模块创建子进程的思路和“fork-exec”相似，但是把这个过程封装起来了，调用时只需要传入程序的路径和参数。subprocess模块启动子进程时，传入的参数只能来自一个文件，而不能是一个函数。这个模块可以调用任何shell命令，比如ls等（这些都是C程序，那自己写一个C程序应该也能这样用），在参数列表里面指定“shell = True”会把对应的命令传递给shell去处理；

在shell脚本中，默认情况下，命令都是按照顺序执行的，前面的命令执行完成才能执行后面的命令(这一点与在shell中只能有一个前台命令很相似)；

如果给命令加了&，让其在后台执行，那么多个命令是可以并行执行的。命令尾部加了&之后，启动的进程就会变成“后台任务”，它的特点是继承当前session的标准输出(stdout)和标准错误(stderr),所以，后台任务的输出依然同步的在命令行下显示；不在继承当前session的标准输入(stdin)。所以，“后台任务”与前台任务的区别只有一个：是否继承标准输入。所以，执行后台任务的同时，用户还可以输入其他命令。

## 内置命令

shell内置命令都是在运行shell进程的内部执行的,因为内置命令是shell程序的一部分。

## shell脚本中调用另一脚本的三种方式与区别

[shell脚本调用另一脚本](https://www.jianshu.com/p/54016c51ed94)

在shell中，shell脚本本身也可以作为一个进程，也就可以通过&在后台执行。

[shell脚本中exec、fork、source的区别](https://blog.csdn.net/simple_the_best/article/details/76285429)

[可以利用ssh在远程主机上执行命令](https://www.cnblogs.com/sparkdev/p/6842805.html)



### 特殊的true，false命令

[true,false和:都是可以用于条件判断的shell内置命令](https://blog.csdn.net/qingsong3333/article/details/77587315)



## ssh

主要用于登陆远程主机和执行命令(可以通过-J选项实现多级跳转或者通过端口转发实现多级跳转)，也可以提供一个安全的连接通道(比如把本地与远程主机的mysql连接放入ssh安全通道中，这可以通过-L选项提供的本地端口转发来实现)，也可以用于绕过防火墙访问别的端口(比如实验室的机器只开放了8401端口，那么访问机器上的其他端口也可以使用-L选项做本地转发来实现，可以在实验室机器上的其他端口搭建服务)

> It is intended to provide secure encrypted communications between two untrusted hosts over an insecure network.  X11 connections, arbitrary TCP ports and UNIX-domain sockets can also be forwarded over the secure channel.

本地端口转发定义：
> Specifies that connections to the given TCP port or Unix socket on the local (client) host are to be forwarded to the given host and port, or Unix socket, on the remote side.  This works by allocating a socket to listen to either a **TCP port** on the local side, optionally bound to the specified bind_address, or to a Unix socket.  Whenever a connection is made to the local port or socket, **the connection is forwarded over the secure channel**, and **a connection is made to either host port hostport, or the Unix socket remote_socket, from the remote machine**， 到本地端口的连接一定会先通过隧道转发到远程机器上，然后远程机器再建立一条连接到最终地址，所以host可以是远程主机可以连接上的任何主机，包括127.0.0.1、192.168.0.122这样的局域网地址。

要实现端口转发，**就需要先建立一条ssh连接(因为需要通过这条ssh连接来转发数据)，可以建立一个到本地的ssh连接也可以建立一个到某台远程机器上的ssh连接**，而且需要ssh连接的server能够与需要实现端口转发的机器直接互相通信，因为这一段通信不走ssh，而是一个传输层连接。在建立ssh连接时可以使用-J选项做跳转。

-J选项的最后一段通信应该都是通过建立TCP连接来实现的；

-D 动态端口转发主要目的是实现代理，将本地的某个端口作为ssh监听地址，ssh连接到远程可访问外网的某个机器，该机器上的sshd可以充当socks5 server，把本地的应用或者系统的代理设置为该端口，那么所有的数据都会从该代理地址发给远程sshd，它会把数据发送给最终的目的地址。隧道里面传输的是完整的应用层数据和协议，因此sshd知道应该向谁发送请求。其他两种端口转发在传输层起作用。

-R选项实现远程端口转发(通过创建一个socket监听远程主机上的TCP Port或者UNIX socket实现)：把到远程server上指定端口的连接通过ssh tunnel全部转发到本地(这个本地是指ssh client)，然后建立一个从local machine到指定的host:hostport的连接。这个远程端口转发可以实现任何内网穿透，不需要对局域网的IP地址和路由有任何要求，但似乎不太稳定，应该需要autossh来帮助实现穿透内网的稳定性。

不管是本地端口转发还是远程端口转发，都只能实现一对一的通信；而通过动态端口转发可以实现多对多的通信。
-L和-R都是把TCP传输层的数据直接转发到对应的端口，client需要使用本地的端口；而-D并不干扰正常的通信行为，通信可以像没有使用代理一样，不需要对client的IP和Port等信息作任何改变，隧道转发的是应用层的信息。

[讲解本地转发和远程转发比较好的一篇博客，它关于-g选项的解释不对，绑定非换回地址是由GateWayPorts配置选项控制的，不是-g选项](https://www.zsythink.net/archives/2450)

[基于ssh的三种端口转发都有讲的一篇博客](https://www.cnblogs.com/f-ck-need-u/p/10482832.html)

SSH不能直接实现UDP转发，所以需要在ssh client端把UDP转为TCP，然后在sshd server端把TCP转为UDP，再去请求服务。可以使用socat工具来实现UDP与TCP之间的互相转换[ssh实现UDP端口转发](https://www.cnblogs.com/wsjhk/p/11064992.html)

ssh的端口转发：**端口转发转发的是传输层的数据**，传输层的数据仅仅是数据包或者二进制流，与应用无关，所以端口转发适合任何应用。

以ssh来解释：

```bash
ssh -L 8401:dell-07:22 dell-01; # 建立一条到dell-01的ssh连接是必要的，因为需要通过这条ssh连接来转发数据；

ssh dell-07@localhost -p 8401;

```

第一条命令表示把到本地端口8401的连接全部转发到dell-07上的22端口(ssh是通过在本地开启一个socket监听本地对应的端口实现的)，在dell-07上有一个sshd在监听22端口。第二条命令是ssh想要连接本地的8401端口上的sshd服务。第二条命令的ssh中除了IP和Port以外的信息(user和options等)全都是ssh的应用层信息，一部分用于设置ssh程序，一部分发送给sshd服务器，**是ssh与sshd二者在应用层通信用的，比如dell-07这个用户名就是会被转发给dell-07上监听22端口程序的内容。**

## ssh高端玩法

[ssh配置、转发、免密等高端玩法](https://plantegg.github.io/2019/06/02/%E5%8F%B2%E4%B8%8A%E6%9C%80%E5%85%A8_SSH_%E6%9A%97%E9%BB%91%E6%8A%80%E5%B7%A7%E8%AF%A6%E8%A7%A3--%E6%94%B6%E8%97%8F%E4%BF%9D%E5%B9%B3%E5%AE%89/)

## mac上启动服务命令(以sshd为例)

```bash
# 启动服务
sudo launchctl load -w /System/Library/LaunchDaemons/ssh.plist

# 停止服务
sudo launchctl unload  /System/Library/LaunchDaemons/ssh.plist

# 查看服务
sudo launchctl list | grep sshd
```
