# 图算法

虽然图分为有向图和无向图，但是二者并无本质区别。无向图可以看作是有向图的一个特例，二者在存储上没有任何区别。任何适用于有向图的算法也同时适用于无向图。

与图有关的算法在分析时间复杂度时，通常从图中的结点数N和边的数量M着手做分析，深度优先搜索的时间复杂度是 O(V+E)，其中 V 是节点数，E 是边数，(这应该有个前提是每一个节点仅仅被便遍历一次)。它的空间复杂度主要由存储数据的内存空间和递归调用深度决定。

## 1. 遍历

对图的遍历和对树的遍历相似，分为深度优先遍历和广度优先遍历两种。

### 广度优先遍历模版

```Go
// graph [][]int, 图的临接表存储

size := len(graph)

isVisited := make([]int, size)
// 需要用到for循环，因为图可能并不是一个连通图
for i := 0; i < size; i++ {
    if isVisited[i] == false {
        queue := make([]int, 0)
        queue = append(queue, i)

        for len(queue) > 0 {
            node := queue[0]
            queue = queue[1:]
            isVisited[node] = true
            // 对当前的结点做一些处理

            for _, n := range graph[node] {
                if isVisited[n] == false {
                    queue = append(queue, n)
                }
            }
        } // for
    } // if
} // for

```
