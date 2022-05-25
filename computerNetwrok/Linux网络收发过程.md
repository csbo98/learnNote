# Linux网络收发过程

ring buffer里面的元素是描述符或者指针，这些描述符或者指针指向存储packet data的socket kernel buffer
[对ring buffer结构的一个比较详细的描述](https://stackoverflow.com/questions/36625892/descriptor-concept-in-nic)

目前明确了收数据包的时候NIC通过DMA先把数据写到预先分配好的rx ring buffer指向的内存buffer中；发送数据包也是内核先把数据写到Tx ring buffer，然后NIC通过DMA把数据拷贝走。所谓的网卡多队列也是指内存中有多个Rx ring buffer或者是多个Tx ring buffer， 这些队列都是在系统启动时由网卡驱动在内存中分配并且把地址信息写入到网卡的寄存器当中。
