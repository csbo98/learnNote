# C++强制类型转换

1. static_cast< targetType>(expression)
    
2. const_cast< targetType>(expression)
   
    const_cast用于改变表达式的常量属性，**它只能改变运算对象的底层const**，所以targetType只能是reference、pointer-to-object、pointer-to-data-member；const_cast不能改变表达式的类型，同时使用其他形式的命名强制类型转换改变表达式的常量属性将引发编译器错误。

3. reinterpret_cast< targetType>(expression)

    将任何指针类型转换为任何其他指针类型；也可以将任何整数类型转换为任何指针类型以及反向转换。

4. dynamic_cast< targetType>(expression)

