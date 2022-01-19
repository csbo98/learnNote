一个字符串拷贝的函数，分析汇编代码，了解字符串拷贝的处理过程。内存与外设(硬盘、网卡等)的数据传输全部都由DMA来传输，除了开始和结束时需要CPU干预，其他时间并不需要CPU。内存到内存的数据拷贝是CPU拷贝，即需要把源内存地址的数据先传到CPU寄存器里面，然后再从寄存器里面传到目的内存地址里面。

cache、页表、虚拟地址、TLB都是应用程序和操作系统无感知的。
源代码：

```c
/*
 *  验证一下内存到内存的拷贝是CPU拷贝，即把数据拿到寄存器，然后再写到另一个内存地址去
 */

#include <stdio.h>
#include <stdlib.h>

void test(char *dst, char *src, int count) {
    while(count--) {
        *(dst++) = *(src++);  // 这个src++和dst++都是在吓一条语句中起作用，不是在本条语句中起作用，是以语句为单位
    }
    return;
}

int main() {
    // 指针里面存储的其实就是虚拟地址空间这个大数组上的一个索引
    char *src = "temptemptemp";
    char *dst = (char*)malloc(12);
    test(dst, src, 12);

    return 0;
}
```

汇编代码详细分析：

```c

// 这是一个32位的汇编程序，这应该是跟编译器有关系的
	.file	"memMove.c"
	.text
	.globl	_test
	.def	_test;	.scl	2;	.type	32;	.endef
_test:
	pushl	%ebp
	movl	%esp, %ebp
	jmp	L2
L3:
	movl	8(%ebp), %eax   // 按照下面得程序，8(%ebp)是dst的值
	leal	1(%eax), %edx   // edx里面存放着dst+1这个指针值
	movl	%edx, 8(%ebp)   // 把这个值更改回dst里面，就是dst已经指向第二个位置了

	movl	12(%ebp), %edx  // 12(%ebp)是src的值
	leal	1(%edx), %ecx   
	movl	%ecx, 12(%ebp)  // 同样这里是让src = src+1，指向源操作数中的下一个位置
	movzbl	(%edx), %edx    // 把原src指向的这个字节拷贝到edx寄存器里面
	movb	%dl, (%eax)     // 再把这个字节拷贝到原dst指针指向的地址里面

/*
	猜测栈顶存放的是4位的函数返回地址和ebp里面四位的值
	        然后是两个32位的段偏移地址， 一个是dst的偏移， 一个是src的偏移，，，这些都是编译器放上去的
 */	
L2:                          // count--的实现
	movl	16(%ebp), %eax   // 把栈中的count取出来放到eax中
	leal	-1(%eax), %edx   // 为了实现count--这里借用leal指令，把eax里面的count当作地址算偏移，而不是直接修改eax， 把减一后的count放入edx
	movl	%edx, 16(%ebp)   // 把减一之后的count放回到栈中的位置
	testl	%eax, %eax       // 测试count是不是0来决定跳转到那里
	jne	L3
	nop
	popl	%ebp
	ret
	.def	___main;	.scl	2;	.type	32;	.endef
	.section .rdata,"dr"
LC0:
	.ascii "temptemptemp\0"  // 编译器自动在这里放了一个\0
	.text                    // 常量字符串应该是在全局数据区存储,那是另外一个段
	.globl	_main
	.def	_main;	.scl	2;	.type	32;	.endef
_main:
	pushl	%ebp
	movl	%esp, %ebp
	andl	$-16, %esp
	subl	$32, %esp
	// src和dst的位置都由编译器分配好了
	call	___main
	movl	$LC0, 28(%esp)   // 常量字符串应该是在全局数据区存储，这里把它的地址放到变量src指针当中，28(%esp)这个位置是src的内存空间

	movl	$12, (%esp)      /* 把12压入栈顶，作为传给_malloc的参数， 传递参数的约定是把参数值放在栈顶 */
	call	_malloc          // 系统调用也是通过call指令
	movl	%eax, 24(%esp)   // eax是函数返回值存放的地方，eax里面存放着malloc返回的地址，把这个地址放在栈中24(%esp)这个位置
							 // 这个位置就是dst变量的内存空间

	// 把dst、src、count三个参数全部放到栈顶作为传递给test函数的参数， 尽管dst和src已经在栈的上面已经有了，
	// 这大概就是值传递， main里面的src和dst的值并没有改变，，，，改变的是test函数使用的两个栈顶的值
	movl	$12, 8(%esp)   
	movl	28(%esp), %eax
	movl	%eax, 4(%esp)
	movl	24(%esp), %eax
	movl	%eax, (%esp)

	call	_test
	movl	$0, %eax   // eax没用，直接把它清零
	leave
	ret
	.ident	"GCC: (tdm-1) 5.1.0"
	.def	_malloc;	.scl	2;	.type	32;	.endef

```












源代码：
```c
#include <stdio.h>

int add(int x, int y)
{
    return x + y;
}

int main()
{
    printf("hello world\n");
    int c = add(156, 678);
    printf("%d\n", c);
    return 0;
}
```

汇编代码：
```c
	.file	"test.c"
	.text
	.globl	_add
	.def	_add;	.scl	2;	.type	32;	.endef
_add:                       // 这里是C语言中定义的add函数
	pushl	%ebp            // 先把ebp原来的寄存器值压入栈中临时存储，函数结束之后再取回来，push与pop一般是成对使用的
	movl	%esp, %ebp      // 把esp的内容存到ebp中，为了从栈中取到两个值，esp的内容是当前栈顶元素的下一个位置地址，系统中栈都是从大地址往小地址发展的,esp一般是由push和pop指令修改的，程序员不应该去修改，所以才用ebp寄存器来访问对应的内存
	movl	8(%ebp), %edx   // 拿到栈顶起的第二个元素，这里为什么是加8呢？因为栈顶第一个元素是本函数内push的ebp，第二个就是本函数的返回地址。
	movl	12(%ebp), %eax  // 拿到栈顶起的第三个元素, 12(%ebp) == [ebp + 12]
	addl	%edx, %eax      // 将两个值相加，结果放在eax寄存器中
	popl	%ebp
	ret                     // 这条指令通过pop IP或者pop IP, pop CS来返回到原来的调用函数里面
	.def	___main;	.scl	2;	.type	32;	.endef
	.section .rdata,"dr"
LC0:
	.ascii "hello world\0"
LC1:
	.ascii "%d\12\0"
	.text
	.globl	_main
	.def	_main;	.scl	2;	.type	32;	.endef
_main:
	pushl	%ebp
	movl	%esp, %ebp
	andl	$-16, %esp
	subl	$32, %esp
	call	___main
	movl	$LC0, (%esp)
	call	_puts
	// 这一段就是调用add函数并把结果打印出来的汇编代码了
	movl	$678, 4(%esp)
	movl	$156, (%esp)
	call	_add
	movl	%eax, 28(%esp)  //main函数中的局部代码都在栈中存放着
	movl	28(%esp), %eax
	movl	%eax, 4(%esp)
	movl	$LC1, (%esp)
	call	_printf         // 这应该是C语言库里面的打印函数，_puts应该也是的，只是这两个看不到


	movl	$0, %eax
	leave
	ret
	.ident	"GCC: (tdm-1) 5.1.0"
	.def	_puts;	.scl	2;	.type	32;	.endef
	.def	_printf;	.scl	2;	.type	32;	.endef

```


[介绍ret指令和call指令的一个博客](https://www.huaweicloud.com/articles/c3e1bd7701185050ea2a7e148e31b7b2.html)
