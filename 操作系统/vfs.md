# Linux virtual filesystem

vfs作为用户应用程序和底层文件系统的一个中间抽象，极大的方便了文件系统切换等功能。用户态只需要一套统一的接口就可以操作各种各样细节不同的文件系统
除此以外，vfs作为一套接口，也方便实现很多其他的系统级功能。比如各种各样的伪文件系统（例如，cgroups、tmpfs、socket等），这些功能只是实现了vfs提供的接口，让使用者可以通过文件系统的接口来与这些功能进行交互。这些功能的实现与真正的文件系统无关。