# Kubernetes

k8s是一个全新的基于容器技术的分布式架构方案，目的是实现资源管理的自动化和跨数据中心的资源利用率最大化。另一种比较方便理解的解释：k8s是用于**自动部署、扩展、和管理“容器化应用程序”**的开源系统。

## k8s的基本概念

**Pod**：pod是k8s系统中资源分配和调度的最小单位，一个pod可以由多个容器组成。Pod中Pause容器的状态标识了一个Pod的状态，也即代表了Pod的生命周期。Pod中其余的容器共享Pause容器的命名空间，所以Pod内部的容器能够共享Pause容器的IP，以及实现文件共享。

**Label**：label是k8s系统中的一个核心概念，一个label表示一个key=value的键值对，key和value由用户指定。Label可以附加到Node、Pod、Service和RC等各种类型的**资源对象**上。这个label的含义和功能都跟微信收藏里面的那个label很相似。

**Service**：**Service 在 Kubernetes 中定义了一个服务的访问入口地址**，前端的应用（Pod）通过这个入口地址访问其背后的一组由 Pod 副本组成的集群实例，Service 与其后端 Pod 副本集群之间则是通过 Label Selector 来实现无缝对接的。

**Volume**：volume是Pod中能够被多个容器访问的共享目录。volume可以被定义在Pod上，然后被一个Pod里的多个容器挂载到具体的文件目录下面；volume的生命周期与Pod相同，与容器的生命周期不相关，当容器重启或者终止时，volume里面的数据也不会丢失。

**namespace**：namespace在很多情况下用于实现多租户的资源隔离。

**ConfigMap**：configmap是一种实现容器配置文件运行时更新的解决方案。

[这篇文章介绍了k8s的架构、常见概念和kubectl的用法](https://mp.weixin.qq.com/s/mUF0AEncu3T2yDqKyt-0Ow)

[这篇文章对k8s的各种基本概念有一个详细的介绍](https://mp.weixin.qq.com/s/ji0Pj00xeHOeispNhsPKZw)
