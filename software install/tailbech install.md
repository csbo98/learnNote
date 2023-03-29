# tailbench install

## 帮助链接

[一个避坑指南](https://github.com/deltavoid/Tailbench)

## 编译过程

首先设置config.sh和makefile.config，configs.sh中的数据目录配置成数据集所在的目录
然后编译harness,使用harness里面的build.sh编译

harness可能需要使用高版本g++编译，不能使用低于gcc5的版本

## tailbench编译记录

x86&arm编译成功: xipian sphinx specjbb  

x86编译成功：masstree silo img-dnn

arm运行成功：sphinx xapian

x86运行成功：masstree img-dnn silo sphinx xapian

### xapian

   换用低版本的gcc解决，比如gcc-5.5,(x86和arm上面通过使用gcc-5.5和下载zlib相关包之后可以顺利安装)
   uuid-dev libxapian-dev  zlib1g zlib1g.dev
   安装成功后，需要对xapian的动态链接库文件做软链接才能运行
   **运行情况：所有平台都是undefined symbol错误**

### sphinx

把动态链接文件加入到LD_LIBRARY_PATH,需要修改Makefile在43行增加一个空格
需要的包：bison swig

### specjbb:无版权，无法使用

### shore: arm平台不支持，Unsupported platform aarch64-unknown-linux-gnu

在x86上需要的依赖包：autoconf automake libreadline-dev
x86上应该是需要一条一条指令分别编译

### silo

silo目录下BUILD指出了需要的包,全部下载即可;arm centos不能安装libdb++, **寻找源代码包，从源代码包编译安装,从别处寻找rpm包尝试**

### masstree

可以选择使用或者不使用tcmalloc
把x86汇编改成aarch64汇编
最终错误为：segmentation fault

### img-dnn

x86下载libopencv-dev包；编译成功
arm需要设置opencv.pc的路径;需要手动编译opencv3.2

### moses

安装boost库;;; 下一个要解决的问题是更新double-conversion库支持arm64
