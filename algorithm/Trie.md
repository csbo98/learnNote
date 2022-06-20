# Trie树

用Go语言实现的一个Trie树

```Go
// 使用链式结构
type Trie struct {
    child [26]*Trie
    isEnd bool
}


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
