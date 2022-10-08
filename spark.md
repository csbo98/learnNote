# Spark

## Spark Architecture

![Spark Architecture](imageSet/spark%20arch.png)

每一个spark应用都是由一个driver program和一个或多个executor组成的。每一个executor都是一个JVM进程，仅执行它所属的应用的task。driver program负责应用内的调度。Spark Cluster Manager负责应用之间的调度。

## Spark核心概念：RDD

RDD 是 Spark 的核心概念，是弹性数据集（Resilient Distributed Datasets）的缩写。RDD 既是 Spark **面向开发者的编程模型**，又是 Spark **自身架构的核心元素**。

### 作为编程模型的RDD

Spark直接针对数据进行编程，**将大规模数据集合抽象成一个RDD对象**，然后在这个RDD上进行各种计算处理，得到一个新的RDD，继续计算处理，直到得到最后的结果数据。因此，可以把Spark理解成**面向对象的大数据计算**。

一个最简单的Spark编程示例如下：

```S
# 根据 HDFS 路径生成一个输入数据 RDD。
val textFile = sc.textFile("hdfs://...")   
# 在输入数据 RDD 上执行 3 个操作，得到一个新的 RDD。
val counts = textFile.flatMap(line => line.split(" ")).map(word => (word, 1)).reduceByKey(_ + _) 
# 将这个 RDD 保存到 HDFS。
counts.saveAsTextFile("hdfs://...")
```

RDD 上定义的函数分两种，一种是转换（transformation）函数，这种函数的返回值还是 RDD；另一种是执行（action）函数，这种函数不再返回 RDD。RDD 定义了很多转换操作函数，比如有计算 map(func)、过滤 filter(func)、合并数据集 union(otherDataset)、根据 Key 聚合 reduceByKey(func, [numPartitions])、连接数据集 join(otherDataset, [numPartitions])、分组 groupByKey([numPartitions]) 等十几个函数。

### 作为架构核心的RDD

跟 MapReduce 一样，Spark 也是对大数据进行分片计算，Spark 分布式计算的数据分片、任务调度都是以 RDD 为单位展开的，每个 RDD 分片都会分配到一个执行进程去处理。

## 参考

1. [我们并没有觉得MapReduce速度慢，直到Spark出现](https://time.geekbang.org/column/article/69822)
2. [Spark总体执行流程](https://blog.knoldus.com/understanding-the-working-of-spark-driver-and-executor/)