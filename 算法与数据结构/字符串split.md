
```C++

// 一个C++版本的split函数

vector<string_view> split(string &str, char ch) {
    int pos = 0;
    int start = 0;
    string_view s(str);
    vector<string_view> ret;
    while (pos < s.size()) {
        while (pos < s.size() && s[pos] == ch) {
            pos++;
        }
        start = pos;
        while (pos < s.size() && s[pos] != ch) {
            pos++;
        }
        if (start < s.size()) {
            ret.emplace_back(s.substr(start, pos - start));
        }
    }
    return ret;
}
```