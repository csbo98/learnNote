

perf采集函数栈帧分为两步，第一步使用perf record命令采集数据；第二步使用perf report命令分析数据，或者将数据转换成火焰图分析

1. 第一步使用perf record命令采集指定进程的函数栈帧：

    -p选项指定进程pid

    --call-graph指定采集函数栈帧的方法，有fp、dwarf、lbr三个可以选择的方式。使用fp这种方式要求c/c++程序编译的时候不能指定`-fomit-frame-pointer`选项，否则无法采集到函数符号，只能看到一堆内存地址。一般使用fp采集不到函数符号信息的话，就使用dwarf或者lbr，只不过dwarf生成的文件比较大。

    -F选项指定采样频率

    --output选项指定采集数据的输出文件，如果不指定这个选项，默认的输出文件名为perf.data

```bash
perf record --call-graph dwarf -F 99 -p 517235 --output=output.data
```

使用perf record时也可以加上一个sleep命令指定采样时间，如果不加sleep命令，需要自己使用ctrl-c手动终止，或者直到程序运行结束：

```bash
perf record --call-graph dwarf -F 99 -p 517235 --output=output.data -- sleep 20
```



2. 第二步是分析数据

    分析数据可以使用perf report命令直接分析，会产生一个交互式窗口，能看到每个函数执行时间占比、通过鼠标点击就可以展开函数调用链，但是这种方式不直观

    --input选项指定数据文件

    ```bash
    perf report --input=input.data
    ```

    分析数据另外一种更加通用的方式是把数据转换成火焰图，观察火焰图，火焰图是可以用鼠标交互的。使用下面这条命令把数据转换成名为output.svg的火焰图，似乎后缀只能是.svg

    ```bash
    perf script --input=input.data | ./stackcollapse-perf.pl -all | ./flamegraph.pl > output.svg
    ```

    stackcollapse-perf.pl和flamegraph.pl两个脚本需要去github下载一下,这个github的readme也讲了这个流程：

    ```bash
    git clone https://github.com/brendangregg/FlameGraph.git
    ```

    