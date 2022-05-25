# C/C++随机数生成器

```C++
// 一个C++标准库中随机数发生器使用示例

vector<unsigned> randVec() {
    // 对于一个随机数引擎，在定义并且运行起来之后就会根据种子生成
    // 一系列的值，每生成一个新的值之后引擎会自动指向下一个值

    // 利用time()作为种子本质上是利用它返回的整数来初始化随机数引擎，让
    // 随机数引擎从一个新的位置开始生成随机数。
    default_random_engine e(time(nullptr));
    uniform_int_distribution<unsigned> u(0,9);

    vector<unsigned> ret;

    for(int i = 0; i < 20; i++) {
        ret.push_back(u(e));
    }

    return ret;
} 
```
