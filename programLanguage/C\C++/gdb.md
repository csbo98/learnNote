# gdb调试

## coredump文件生成

```bash
# 必须同时设置core文件大小和路径才能生成core文件
ulimit -c unlimited # ulimit命令用于设置是否生成core文件

# 下面这两条命令任意一个可用于设置coredump文件的位置，需要在root用户下才能设置
sysctl kernel.core_pattern 
echo "/www/coredump/core-%e-%p-%h-%t" > /proc/sys/kernel/core_pattern
# 参考man手册页获取core文件命名模版
```

## gdb常用命令

[GDB调试-从入门实践到原理](https://mp.weixin.qq.com/s/G8u1WH2K8NANohhpc6347A)
[GDB常用命令](https://www.zhihu.com/question/22196181/answer/2477857267)
