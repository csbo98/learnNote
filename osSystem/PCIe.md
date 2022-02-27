# PCIe的一些简单知识

1. PCIe是一种高带宽扩展总线，通常用来连接显卡、SSD以及像采集卡和网卡等外设。 
2. 所有的PCIe标准都是向后兼容的，更新的PCIe标准意味着与GPU、SSD和其他外围设备的更高带宽的连接。每一代PCIe带宽都是它前一代带宽的两倍。
3. 在主板上，PCIe通道通常有x1、x2、x4、x8和x16几种，lanes越多，带宽越高，slot也越长。GPU通常装在x16插槽上面，因为它不仅有最大的带宽，而且传统上直接与CPU连接；现代PCIe m.2 SSD使用x4 lanes。
4. [英特尔官网关于PCIe的文档](https://www.intel.com/content/www/us/en/gaming/resources/what-is-pcie-4-and-why-does-it-matter.html)