# Trie树

Trie树可以用来作为key-value存储使用，value存储在key中最后一个字符对应的结点上。

用Go语言实现的一个Trie树

```Go
// 使用链式结构
type Trie struct {
    child [26]*Trie
    isEnd bool
}


// Trie树在初始时刻应该有一个根结点，一方面是为了实现方便；另一方面根结点并不存储数据

/** Initialize your data structure here. */
func Constructor() Trie {
    // 初识时刻应该有一个根结点，在用数组实现时也是同样的道理

    return Trie{}
}


/** Inserts a word into the trie. */
func (this *Trie) Insert(word string)  {
    // this本质上是一个指向调用当前函数结构体的指针
    // 在这个地方不能直接使用this，不然会破坏树的结构
    t := this

    for _, ch := range word {
        ch -= 'a' // 这个地方把ch拿出来了所以会转变成rune对象么
        if t.child[ch] == nil {
            t.child[ch] = &Trie{}
        }

        t = t.child[ch]
    }
    t.isEnd = true
}

func (this *Trie) SearchPrefix(prefix string) *Trie {
    // 搜索Trie树中是不是有prefix这样一个字符串存在
    // 存在返回尾结点，不存在返回nil
    t := this

    for _, ch := range prefix {
        ch -= 'a'

        if t.child[ch] == nil {
            return nil
        }
        t = t.child[ch]
    }

    return t
}

/** Returns if the word is in the trie. */
func (this *Trie) Search(word string) bool {
    temp := this.SearchPrefix(word) 
    return temp != nil && temp.isEnd
}


/** Returns if there is any word in the trie that starts with the given prefix. */
func (this *Trie) StartsWith(prefix string) bool {
    // != 才说明存在
    return this.SearchPrefix(prefix) != nil
}

```

一个使用C++实现的Trie树

```C++

struct Trie {
    bool isEnd;
    vector<Trie*> child;

    Trie():isEnd(false), child(26, nullptr) {}   
};

Trie *root = new Trie(); // Trie树初始时刻需要有一个根结点，

void insert(string word) {
    auto pt = root;

    for(auto ch : word) {
        int index = ch - 'a';
        if(pt->child[index] == nullptr) {
            pt->child[index] = new Trie(); // 1
        }

        pt = pt->child[index];             // 2 1和2合在一起就像是链表的操作一样
    }

    pt->isEnd = true;
}


// C++版本的判断word是不是一个完整的单词
bool searchPrefix(string word) {
    auto pt = root;
    
    for(auto ch : word) {
        int index = ch - 'a';
        if(pt->child[index] == nullptr) {
            return false;
        }

        pt = pt->child[index];
    }

    return pt->isEnd == true;
}

// 删除操作可以使用栈来实现，先查找把待删除key的节点全部找出来，
// 然后从栈中不断的弹出节点直到符合要求
```