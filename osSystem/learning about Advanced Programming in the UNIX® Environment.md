课本随附的源代码在http://www.apuebook.com/apue3e.html可以下载.

环境配置:
cd apue.3e
make
......

sudo cp ./include/apue.h /usr/local/include/
sudo cp ./lib/libapue.a /usr/local/lib/

代码编译要加上-lapue选项。（自己应该怎么在gcc里面添加自定义选项？ macOS的这两个目录有什么特别的？为什么编辑器和gcc会自动在这两个文件搜索头文件）。
