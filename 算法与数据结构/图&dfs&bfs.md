# 图算法

虽然图分为有向图和无向图，但是二者并无本质区别。无向图可以看作是有向图的一个特例，二者在存储上没有任何区别。任何适用于有向图的算法也同时适用于无向图。

与图有关的算法在分析时间复杂度时，通常从图中的结点数N和边的数量M着手做分析，深度优先搜索的时间复杂度是 O(V+E)，其中 V 是节点数，E 是边数，(这应该有个前提是每一个节点仅仅被便遍历一次)。它的空间复杂度主要由存储数据的内存空间和递归调用深度决定。

## 1. 遍历

对图的遍历和对树的遍历相似，分为深度优先遍历和广度优先遍历两种。

### 广度优先遍历模版

基础的bfs从一个初始点开始搜索。在此基础之上，还有一个进阶版的多源广度优先搜索，也即在初始时，向队列中加入多个初始点，其实这与单源bfs没有区别。但是可以从理论上加深理解（以力扣994为例）：观察到对于所有的腐烂橘子（多个初始点），其实它们在广度优先搜索上是等价于同一层的节点的。假设这些腐烂橘子刚开始是新鲜的，而有一个腐烂橘子(我们令其为超级源点)会在下一秒把这些橘子都变腐烂，而这个腐烂橘子刚开始在的时间是 −1 ，那么按照广度优先搜索的算法，下一分钟也就是第 0 分钟的时候，这个腐烂橘子会把它们都变成腐烂橘子，然后继续向外拓展，所以其实这些腐烂橘子是同一层的节点。那么在广度优先搜索的时候，我们将这些腐烂橘子都放进队列里进行广度优先搜索即可，**最后每个新鲜橘子被腐烂的最短时间 dis[x] [y] 其实是以这个超级源点的腐烂橘子为起点的广度优先搜索得到的结果。**

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


## 广度优先遍历加标记的位置
在对图做广度优先遍历的时候，需要用一个数组来标记那些顶点已经访问过，那些顶点还没有被访问过。
如果是在每一个顶点进入队列的时候标记该节点已经被访问过，这样表示访问每一个顶点一次且仅一次；
如果是在每一个顶点离开队列的时候标记该节点已经被访问过，这样表示访问每条边一次且仅一次。
```C++
class Solution {
public:
    vector<vector<pair<int, int>>> edge;
    int minScore(int n, vector<vector<int>>& roads) {
        
        edge = vector<vector<pair<int, int>>>(n+1, vector<pair<int, int>>());
        for(auto road : roads) {
            edge[road[0]].emplace_back(road[1], road[2]);
            edge[road[1]].emplace_back(road[0], road[2]); // emplace_back是直接在原地调用构造函数的，所以传递的enplace_back的参数要符合元素的某一个构造函数的要求，push_back不是模版函数，所以push_back可以
        }
        
        int min_edge = 10e5;
        queue<int> que;
        vector<bool> visited(n+1, false); 
        que.push(1);
        // visited[1] = true;  // 要遍历有向无环图的每一个顶点，在这个地方增加标记
        
        while(!que.empty()) {
            int v = que.front();
            que.pop();
            visited[v] = true;  // 要遍历有向无环图中的每一条边，在这个地方加已访问标记
            for(int i = 0; i < edge[v].size(); i++) {
                auto [v1, w] = edge[v][i];
                if(visited[v1] == false) {
                    // visited[v1] = true;
                    min_edge = min(min_edge, w);
                    // cout << w << endl;
                    que.push(v1);
                }
            }
        }
        
        return min_edge;
    }
};

```