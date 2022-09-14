---
highlight: monokai
theme: juejin
title: C++ Primer Plus
categories:
- CPP
---

- [1. 变量及基本类型](#1-变量及基本类型)
  - [1.1 基本内置类型](#11-基本内置类型)
    - [1.1.1 算术类型](#111-算术类型)
    - [1.1.2 类型转换](#112-类型转换)
    - [1.1.3 字面常量](#113-字面常量)
  - [1.2. 变量](#12-变量)
    - [1.2.1 变量定义](#121-变量定义)
    - [1.2.2 变量声明和定义的关系](#122-变量声明和定义的关系)
    - [1.2.3 名字的作用域](#123-名字的作用域)
  - [1.3. 复合类型](#13-复合类型)
  - [1.4. CPP修饰符和const限定符](#14-cpp修饰符和const限定符)
  - [1.5. 处理类型](#15-处理类型)
  - [1.6. 自定义数据结构](#16-自定义数据结构)
  - [1.7 CPP存储类[待重新拟题]](#17-cpp存储类待重新拟题)
- [2. 字符串，向量，数组](#2-字符串向量数组)
  - [2.1. using关键字](#21-using关键字)
  - [2.2. string 类型](#22-string-类型)
  - [2.3. vector类型](#23-vector类型)
  - [2.4. 迭代器的介绍](#24-迭代器的介绍)
  - [2.5 数组](#25-数组)
    - [2.5.1 定义和初始化内置数组](#251-定义和初始化内置数组)
    - [2.5.2 访问数组元素](#252-访问数组元素)
    - [2.5.3 指针和数组](#253-指针和数组)
    - [2.5.4 C风格字符串](#254-c风格字符串)
    - [2.5.5 与旧代码的接口,兼容C代码](#255-与旧代码的接口兼容c代码)
  - [2.6 多维数组](#26-多维数组)
    - [2.6.1 多维数组初始化](#261-多维数组初始化)
    - [2.6.2 多维数组的下标引用](#262-多维数组的下标引用)
    - [2.6.3 使用范围for语句处理多维数组](#263-使用范围for语句处理多维数组)
    - [2.6.4 指针和多维数组](#264-指针和多维数组)
    - [2.6.5 类型别名简化多维数组的指针](#265-类型别名简化多维数组的指针)
    - [2.6.6 术语表](#266-术语表)
- [3. CPP流程控制](#3-cpp流程控制)
- [4. 函数](#4-函数)
  - [4.1. struct构造初始化](#41-struct构造初始化)
- [5. 面向对象编程](#5-面向对象编程)
  - [5.1. 继承与多继承](#51-继承与多继承)
  - [5.3. 函数，运算符重载](#53-函数运算符重载)
  - [5.4. 多态](#54-多态)
  - [5.5. CPP接口](#55-cpp接口)

# 1. 变量及基本类型

 1. `g++ -o hello_world  -std=c++11  hello_world.cpp`  
    将源代码cpp文件编程成二进制程序,并支持C++11
 2. CPP保留字

    |1|2|3|4|
    | ------------ | --------- | ---------------- | -------- |
    |asm          | else      | new              | this / 自身地址     |
    | auto         | enum      | operator         | throw    |
    | bool         | explicit  | private          | true / 真 / 0     |
    | break        | export    | protected        | try      |
    | case         | extern    | public           | typedef / 别名定义  |
    | catch        | false     | register         | typeid   |
    | char         | float /单精度    | reinterpret_cast | typename |
    | class        | for       | return           | union    |
    | const        | friend    | short            | unsigned / 无符号 |
    | const_cast   | goto      | signed / 有符号          | using / 使用命名空间   |
    | continue     | if        | sizeof           | virtual  |
    | default      | inline    | static           | void / 空类型    |
    | delete       | int       | static_cast      | volatile |
    | do           | long      | struct           | wchar_t  |
    | double       | mutable   | switch /           | while / 循环   |
    | dynamic_cast | namespace | template||
 3. typedef声明

    ```cpp
    typedef short int s_int;
    typedef int feet;
    feet distance //合法声明
    ```

 4. 枚举类型
    所谓"枚举"是指将变量的值一一列举出来，变量赋值时候只能是特定的变量才能赋值

    <details><summary>枚举类型demo</summary>

    ```cpp

    enum 枚举名{ 
        标识符[=整型常数], 
        标识符[=整型常数], 
    ... 
        标识符[=整型常数]
    } 枚举变量;
    //举例子
    enum  color{ red , yellow ,blue} c
    c = blue 
    //默认情况下，是从0开始初始化

    ```

    </details>

 5. 三字符组

    以前为了表示键盘上没有的字符
    |字符串| 转义后的含义 |
    | ----------- | -------------- |
    | ??=         |  #             |
    | ??(         |\[              |
    | ??)         | ]              |
    | ??/         | \              |
    | ??<         | {              |
    | ??>         | }              |
    | ??'         | ^              |
    | ??!         | \|             |
    | ??-         | ～             |

## 1.1 基本内置类型

### 1.1.1 算术类型

`整形（布尔/字符）`和`浮点型`

|类型|含义|最小尺寸|
|---|---|---|
|bool|布尔类型|4bit|
|char|字符|8bit|
|wchar_t|宽字符|16bit|
|char16_t|Unicode16|16bit|
|char32_t|Unicode32|32bit|
|short|短整型|2个字节,16bit|
|int|整型|4个字节,32bit|
|long|长整型|32bit|
|long long|长整型|64bit,8字节|
|float|单精度|32bit,6位有效数字|
|double|双精度|64bit,10位有效数字|
|long double|扩展精度|128bit,10位有效数字|


1. 一个char应可以存机器基本字符集中任意字符对应的数字值,其他字符集可以用`wchar_t`-可以扩展字符集任意字符,`char16_t`,`char32_t`-他俩则是扩展Unicode字符标准
2. 8比特等于一个字节，四个字节等于一个字符
3. 内置类型的机器实现之address地址,就是一串数字,跟着其存储(8比特)内容
4. 带符号类型和无符号类型
`short`,`int`,`long` ,`long long` 都有`unsigned`类型。`char`,`signed char`和`unsigned char`,虽然表现是三种，但是只有两种，`char`具体表现为哪种，要看编译器

- 如何选择类型
    1. 数值不可能为负时，用无符号类型
    2. 超过了int范围，选用long long
    3. 因为类型char在一些机器上是有符号的，而在另一些机器上又是无符号的。所以如果你需要使用一个不大的整数，应指定是使用unsigned char 还是signed char
    4. float 和double在计算上没差别，但是long double提供的精度在一般情况下是没有必要的，况且它带来的运行时消耗也不容忽视

### 1.1.2 类型转换

```cpp
bool b = 42;
int i = b; // i的值为1
i= 3.14 ; //i的值为3
double pi = i ;//pi的值为3.0
unsigned char c =-1; //假设char占8比特,c的值在255,被转换
signed char c2 = 256; // 假设char占8比特，c2的值是未定义
```

1. int -> bool // 0是假，1是真  
2. bool -> int // false是0，真是1  
3. float -> int // 只保留整数位  
4. int -> float // 小数位填0  
5. signed -> unsigned //符号位当成数值位转换为十进制`1000 0001`，反码为`1111 1110`，补码为`1111 1111(signed char)`,然后转换为unsigned char  `1111 1111`,十进制是`255`，或者`-1 + 256 mod 256 = 255`,如第六行代码.
6. 当我们赋给`符号类型`一个超出它表示范围的值时，结果是未定义的（undefined）。此时，程序可能继续工作、可能崩溃，也可能生成垃圾数据
    > 建议：避免无法预知和依赖于实现环境的行为

- 含有无符号类型的表达式  

    例如，当一个算术表达式中既有无符号数又有int值时，那个int值就会转换成无符号数。把int转换成无符号数的过程和把int直接赋给无符号变量一样:

    ```cpp
    unsigned u = 10;
    int i  =-42;
    cout<< i + i << endl ; //-84
    cout << u + i << endl; // 输出结果4294967264
    ```

    ```cpp
    for (int i = 10 ; i >= 0 ; --i ){
        cout<<i << endl;
    }
    for (unsigned  i = 10 ; i >= 0 ; --i ){
        cout<<i << endl;
    }
    // 永远不会退出循环,其实是没设计好这个for statement,unsigned同样道理
    ```

    可以用下面语句带题

    ```cpp
    unsigned u =11;
    while (u>0){
        --u;
        std::cout<< u << std::endl;
    }
    ```

    > 提示:避免`signed`与`unsigned`混合运算，会将`signed`转换为`unsigned`类型

### 1.1.3 字面常量

例如`42`就是字面值常量,整型,浮点,字符,字符串字面值
    
  - 以0开头的整数代表八进制数  

  - 以0x或0X开头的代表十六进制数  

    |字面值|类型说明|
    |---|---|
    |20|  // decimal十进制|
    |024        |  //octal八进制|
    |0X14       |  // hexadecimal 十六进制|
    |128u ,128U |  // unsigned 十进制|
    |1024UL or 8LU  | // unsigned long|
    |1024ULL or 8LLU     |// unsigned long long|
    |1L         | // long 长整形|

  - 如果一个字面值连与之关联的最大的数据类型都放不下，将产生错误  

  - 3.14159,3.14159E0,0.,0e0,.001  

    |字面值|类型说明|
    |---|---|
    |3.14159F = 3.14159E0F  |// float ,科学计数|
    |.001f = 1E-3F | // float,科学计数|
    |12.345L = 1.2345E1L|// long double 扩展精度 ,科学计数|
    |0. = 0e0 |// double ,科学计数|

  - 'a','Hello World!', 字符字面值,字符串字面值

    |字面值|类型说明|
    |---|---|
    |'a'| // char 字符|
    |L'a' |// wchar_t 宽字符 |
    |u'a' |// char16_t 宽字符 |
    |U'a' |// char32_t 宽字符 |
    |u8"hi!"|//utf-8字符串类型,只支持字符串|
    |nullptr|//指针字面值|
    |'A'|//表示单个字符A |
    |"A"|//表示字符A和空字符两个字符的字符串|
  - 转义序列

    | 语义 | 实现 |
    | --- | --- |
    | \n | 换行 |
    |\v|纵向制表|
    |\\\|反斜线|
    |\r|回车符号|
    |\t|横向指标符号|
    |\b|退表符号|
    |\?|问号|
    |\a|报警符号|
    |\\"|双引号|
    |\\'|单引号|  

  - 泛化的转义序列  
    - (有需要再重点看)
    - 斜线\后面跟着的八进制数字超过3个，只有前3个数字与\构成转义序列。例如，"\1234"表示2个字符，即八进制数123对应的字符以及字符4
    - \x要用到后面跟着的所有数字，例如，"\x1234"表示一个16位的字符，该字符由这4个十六进制数所对应的比特唯一确定
  - 指定字面值的类型
    给字面值添加前后缀，可以改变其默认类型  
    |前缀|含义|类型|
    |---|---|---|
    |u|16字符|char16_t|
    |U|32字符|char32_t|
    |L|宽字符|wchar_t|
    |u8|UTF-8|char,仅适用于字符串|

    |后缀|最小匹配类型|
    |---|---|
    |u or U|unsigned|
    |l or L |long|
    |ll or LL|long long|
    |f or F|float|
    |l or L |long double|
  - 布尔字面值
        `bool test = false`

## 1.2. 变量

### 1.2.1 变量定义
`::` : 命名空间符号  


- 默认值,初始值,和列表初始化 :  

    ```cpp
    int units_sold = {0};//列表初始化
    int units_sold{0}; // 列表初始化
    int units_sold(0); //直接初始化 
    ```

- 全局变量默认值 : 在定义变量阶段如不指定会被指定默认值  
- 定义在函数体内部的`内置类型`变量将不被初始化（uninitialized）。一个未被初始化的内置类型变量的值是未定义的,如果试图拷贝或以其他形式访问此类值将引发错误.类自行决定初始化方式.绝大多数类都支持无须显式初始化而定义对象，这样的类提供了一个合适的默认值.如果一些类要求每个对象都显式初始化，此时如果创建了一个该类的对象而未对其做明确的初始化操作，将引发错误

### 1.2.2 变量声明和定义的关系

- CPP支持分离式编译，也就是定义和声明分开  
- extern语句如果包含初始值就不再是声明，而变成定义了  
- 变量的定义必须出现在且只能出现在一个文件中，而其他用到该变量的文件必须对其进行声明  

### 1.2.3 名字的作用域

1. 局部变量，顾名思义，生命周期作用范围只在函数内,局部变量不会对变量进行初始化，全局变量才会初始化  
2. 全局变量，存活于程序整个生命周期,extern允许你在任意地方的声明一个变量或者函数，然后允许再任何地方进行定义。
3. 嵌套的作用域
    <details>
    <summary>嵌套的作用域代码demo</summary>

    ```cpp
    #include <iostream>

    // Program for illustration purposes only: It is bad style for a function
    // to use a global variable and also define a local variable with the same name

    int reused = 42;  // reused has global scope

    int main()
    {
        int unique = 0; // unique has block scope

        // output #1: uses global reused; prints 42 0
        std::cout << reused << " " << unique << std::endl;   

        int reused = 0; // new, local object named reused hides global reused

        // output #2: uses local reused; prints 0 0
        std::cout << reused << " " <<  unique << std::endl;  

        // output #3: explicitly requests the global reused; prints 42 0
        std::cout << ::reused << " " <<  unique << std::endl;  

            return 0;
    }
    ```

    </details>  

    output #3则是访问全局`reused`变量  



## 1.3. 复合类型

 引用: 及别名

 1. `int &reference2` 报错，因为没有初始化，引用必须在定义时初始化.  
 2. `int &reference3 = reference`引用创建引用,reference是对象类型  
 3. 将引用赋值给变量就是把引用的对象作为初始值  

 指针  

 1. 块级作用域指针不被初始化也会拥有不确定值  
 2. `double *dp, *dp2`定义指针,访问无效指针后果无法预计
 3. `*dp = 0.0` 利用指针给对象赋值  
    建议
    初始化所有定义的指针，切莫将变量直接赋值给指针,而是通过取地址符号,但是0可以直接赋值
 4. `void *`指针,其他任意指针都可以指向空指针,我们无法直接操作空指针
 5. 同时定义多个变量`int i=1024 , *p=&i, &q = i` , `int* p`合法容易但是产生误导
 6. 指向指针的指针,`int ival=400,int *p=&ival, **pp=&p`,同时,访问对象值,也需要解两次引用  
 7. 指向指针的引用  

      <details>
      <summary>指向指针的引用demo</summary>

       ```cpp  
           int i = 42;  
           int *p;  
           int *&r=p;  
           r= &i //取i地址，让r指向i,同时p也指向了i  
           *r=0 //给指针引用赋值，p指向的值也变了  
       ```

       </details>

 8. 指针的类型必须与其所指对象的类型一致，但是有两个例外  
      - 第一种例外情况是允许令一个指向常量的指针指向一个非常量对象  
      <details>
      <summary>
      ```cpp
      const double pi = 3.14 ;
      double *ptr = &pi ; // 不可以，不能将变量指针绑定到常量指针

const double*cptr = &pi ; //合法
      *cptr = 42 ; // 错误，不能给指向常量的指针赋值
      double dval = 3.14 ; //
      cptr = &dval ; // 正确，指针常量不能绑定到普通变量
      ```
      </summary>
      </details>

## 1.4. CPP修饰符和const限定符  

- `signed`,`unsigned`, `long` 和 `short` 修饰整型和浮点型
    <details>
    <summary>修饰符demo</summary>

    ```cpp
     #include <iostream> 
     using namespace std; 
     /* * 这个程序演示了有符号整数和无符号整数之间的差别 */ 
     int main() { short int i; 
         // 有符号短整数 
         short unsigned int j;
         // 无符号短整数 
         j = 50000; i = j; 
         cout << i << " " << j; 
         return 0; 
     }
     ```

    </details>

- 类型限定符提供了变量的额外信息。

| 限定符      | 含义                                                                                                 |
| -------- | -------------------------------------------------------------------------------------------------- |
| const    | **const** 类型的对象在程序执行期间不能被修改改变。                                                                     |
| volatile | 修饰符 **volatile** 告诉编译器不需要优化volatile声明的变量，让程序可以直接从内存中读取变量。对于一般的变量编译器会对变量进行优化，将内存中的变量值放在寄存器中以加快读写效率。 |
| restrict | 由 **restrict** 修饰的指针是唯一一种访问它所指向的对象的方式。只有 C99 增加了新的类型限定符 restrict.  

 1. const对象创建之后就不能修改发，所有创建时必须初始化
 2. 默认情况下const对象尽在文件内有效，多文件间共享需要使用extern关键字

    ```cpp
    //file.cc
    extern const int bufsize = fn();
    //file.h
    extern const int bufsize;
    ```

 3. const的引用  
    常量引用可以绑定对象，但是不能修改被绑定对象的内容  
    也不能用变量绑定常量引用  
 4. 指向常量的指针

    ```cpp
    const double pi = 3.14;
    const double *cptr = &pi;  //指向常量的指针，指针的值不能变，但是指向的值却是可以变的
    ```

 5. 常量指针  
    指针本身是一个常量并不意味着不能通过指针修改其所指对象的值，能否这样做完全依赖于所指对象的类型，例如，pip是一个指向常量的常量指针，则不论是pip所指的对象值还是pip自己存储的那个地址都不能改变

    ```cpp
    int *const  curErr = &errNumb; //常量指针
    const double pi = 3.14;  
    const double *const pip = &pi;
    ```

 6. 顶层const和  
     当执行对象的拷贝操作时，常量是顶层const还是底层const区别明显。其中，顶层const不受什么影响
 7. constexpr和常量表达式  
     **TBC**

## 1.5. 处理类型

 1. typedef意为同义词，新标准中可以使用`using SI = Sales_items`  
 2. typedef的指针常量，指向常量的指针  

    ```cpp
    typedef  char *pstring;
    const pstring cstr = 0; //指向常量的指针常量
    const pstring *ps ; //指针常量
    ```

 3. `auto`自动判断类型类型

    ```cpp
     const int ci = i , &cr = ci;
     auto d = &i //整形指针
     auto e = &ci; // e是指向整型常量的指针
     const auto j = 0  //auto如果想推导出顶层const，需要明确写出  
     auto &h=42  //错误，因为非常量引用无法绑定字面值
     const auto &j=42  //错误，因为非常量引用无法绑定字面值
    ```

 4. decltype类型提示符  
     decltype只推断类型，但不使用其值
     - decltype和引用，和const

     ```cpp
     const int ci = 0,&cj = ci;
     decltype(ci) x = 0;
     decltype(cj) y = x ;
     decltype(cj) z ; //错误，z是一个引用类型，必须初始化
     int i =42,*p=&i,&r = i;
     decltype(*p) c; //错误。必须初始化
     decltype((i)) d; //错误，双层括号是引用类型，必须初始化
     decltype(i) e ; //正确，e是一个未初始化的int
     ```

## 1.6. 自定义数据结构  

   1. strcut 关键字

      ```cpp
            struct Sales_data {/* .....  */};就可以用来定义数据结构

      ```

   2. 预处理器概述  
       #define指令把一个名字设定为预处理变量  
       #ifdef当且仅当变量已定义时为真，#ifndef当且仅当变量未定义时为真  

       <details><summary>demo</summary>

        ```cpp
        #ifndef SALES_DATA_H
        #define SALES_DATA_H

        #include <string>

        struct Sales_data {
                std::string bookNo;
                unsigned units_sold = 0;
                double revenue = 0.0;
        };
        #endif
      ```

       </details>

## 1.7 CPP存储类[待重新拟题]

- auto
CPP17 弃用
- register
定义 'register'存储类用于定义存储在寄存器中而不是 RAM 中的局部变量。这意味着变量的最大尺寸等于寄存器的大小, 并不意味着变量将被存储在寄存器中，它意味着变量可能存储在寄存器中.
- static 存储类
`static` 存储类指示编译器在程序的生命周期内保持局部变量的存在，而不需要在每次它进入和离开作用域时进行创建和销毁。因此，使用 static 修饰局部变量可以在函数调用之间保持局部变量的值
- extern
扩展全局变量作用域
- nutable 存储类
- thread_local 存储类
变量在创建线程时创建，并在销毁线程时销毁。 每个线程都有其自己的变量副本

# 2. 字符串，向量，数组

## 2.1. using关键字

   1.切记不要在header文件中使用using namespace std  
   2. 每个名字都需要独立的using声明  

## 2.2. string 类型

   ```cpp
    string s1 = "hi ya"; //拷贝初始化
    string s2("hi ya"); // 直接初始化
    string s3(10,'C'); //拷贝十个C
    std::cin >> s3 >>std::endl;
    while (getline(cin,line)) //从输入控制设备读入整行
   ```

- `string` 对象操作  

   ```cpp
   
   os<<s //将s写道os中，并返回os 
   is>>s //从is中读取字符串赋值给s,字符串以空白分隔，返回is
   getline(is,s); //
   s.empty(); //s为空返回true，否则返回false
   s.size(); //返回s中字符个数,函数返回的是一个无符号整型数
   s[n] //返回数字索引储存的值
   s1+s2 //拼接字符串
   s1==s2;判断字符串是否相等
   s1 [<>=] s2 //按照asic码进行比较
   ```

   ```cpp
    #include <iostream>
    using std::cout; using std::endl;

    #include <string>
    using std::string;

    int main() 
    {

            string s1  = "hello, ", s2 = "world\n";
            string s3 = s1 + s2;   // s3 is hello, world\n
            cout << s1 << s2 << s3 << endl;

            s1 += s2;   // equivalent to s1 = s1 + s2
            cout << s1;

            string s4 = "hello", s5 = "world";  // no punctuation in s4 or s2
            string s6 = s4 + ", " + s5 + '\n';
            string s7 = "hello" + ", " + s5 + '\n';  //不合法
            string s8 = "ABC" + "EFG" + '\n'; // 不合法操作
            cout << s4 << s5 << "\n" << s6 << endl;

            return 0;
    }
   ```

- 处理`string`对象中的字符

   ```cpp
   //用for处理字符
   string str("ABCDEFG");
   for (auto c : str){
   //这里的c其实是str中字符的拷贝
       cout<< c << endl;
   }
   
   //改变str中的字符值
   for (auto &c : str){
       cout<< c << endl;
   }
   //下标运算符,返回字符串中的值
   if (!s.empty()){
       cout<< s[0] << endl;
   }
   ```

## 2.3. vector类型

  ```cpp
  vector<int> ivec; //保存int类型
  vector<Sales_item> Sales_vec; //保存Sales_item变量
  vector<vector<string>> file  ; //vector存vector类型
  // 初始化
  vector<T> v1
  vector<T> v2(v1);//v2中包含v1中所有副本
  vector<T> v2 = v1 //等价于 vector<T> v2(v1)
  vector<T> v3(n,val);//v3包含了n个val元素
  vector<T> v4(n)//包含了n个执行值初始化的对象
  vector<T> v5{a,b,c ...} //v5包含了初始值个数的元素，每个元素被赋予相应的初始值，这里还有一点要注意，就是可能会放不同类型的值，但
  vector<T> v5={a,b,c ...} //等价于vector<T> v5{a,b,c ...}
  // vector的CRUD
  v.empty();// 是否为空
  v.size(); //返回容量，类型std::size_type
  v.push_back(t); // 添加值
  v[n]; //访问下标存储的数据
  v2=v1 ;//v1拷贝到v2
  v1 ={a,b,c.....} //重新赋值
  v1 == v2 ;//时候绝对的相等，长度和内容
  <>= //顾名思义按照字典序进行比较
  v1!=v2;
  ```

- 无法访问索引外数据，编译期无法发现，但是运行期就会报错

## 2.4. 迭代器的介绍

除了vector之外，标准库还定义了其他容器，string也可以使用迭代器


v.begin()返回第一位元素的指针,v.end()返回最后一个元素，注意end()返回的是空引用

- 迭代器运算符包括  
    |符号类型            |说明                               |
    |------             |------                             |
    |  *iter            | `(*it).empty()`,返回迭代器所指元素的引用,解引用未定义迭代器都是未定义的行为，可以修改引用真实数据|
    |  item             |解引用iter并获取该元素的名为mem的成员变量，等价于(*iter).mem|
    |  ++iter / --iter /[+-] n  |进行加减运算                |
    |  iter==iter2      |判断两个迭代器                       |
    |  iter1 != iter2   | 判断两个迭代器不等                  |
    | <= ,>=            | 要求迭代器必须指向同一个容器          |

    <details><summary>将字符串小写符转化为大写示例</summary>

    ```cpp
    string s("some string");
    if (s.begin() != s.end()){
        auto it = s.begin();
        *it = toUpper(*it);
    }
    ```

    </details>

    1. 迭代器类型支持了以上操作
    2. 如果元素是常数则返回const_iterator,不是常数则返回iterator类型
    3. it->mem和(＊it).mem表达的意思相同
    4. 不能在范围for循环中向容器添加元素。**另外一个**限制是任何一种可能改变vector对象容量的操作，比如push_back，都会使该 vector对象的迭代器失效

- 将迭代器的移动
    <details><summary>迭代器移动示例</summary>

    ```cpp
    for (auto it = s.begin() ; it != it.end()&& !isUpper(*it); ++it){
        *it = toUpper(*it);
    }
    ```

- 泛型编程  
    泛型编程更像一种高度抽象数据结构的能力

- begin()和end()函数  
    如果元素是常数则返回const_iterator,不是常数则返回iterator类型


    </details>

## 2.5 数组
如果不清楚元素的确切个数,请使用vector,数组的大小确定不变,不能随意向数组中增加元素.因为数组的大小固定,因此对某些特殊的应用来说程序的运行时性能较好,但是相应地也损失了一些灵活性.

### 2.5.1 定义和初始化内置数组

1. 显示初始化数组
    <details>
    <summary>数组初始化示例</summary>
    ```cpp
    const unsigned sz=3; 定义常量
    int ia1 = {0,1，2};
    int a2[] = {0,1,2};
    int a3[5]= {0,1,2};
    string a4[] = {"hi","byte"};
    int a5[2] = {0,1,2}  //错误，超出容量
    ```

    </details>
2.  字符数组的特殊性

    <details>
    <summary>字符数组特殊性初始化示例</summary>

    ```cpp
    char a1[] = {'c','+','+'};
    char a2[] = {'c','+','+','\0'}; //显示胡世华空字符
    char a3[] = "C++"; //自动初始化空字符
    const a4[6]  = "Daneil"  //错误没有空间存放空字符

    ```

    </details>
3. 不允许拷贝赋值

    <details>
    <summary>不允许拷贝赋值示例</summary>

    ```cpp
    int a[] = {0,1,2} //含有三个元素的数组
    int a2[] = a1; // 错误: 不允许使用一个数组给另一个数组进行初始化
        a2 = a1 //错误: 不允许两个数组之间直接赋值计算
 
    ```

    </details>

4. 复杂数组声明
    <details>
    <summary>复杂数组声明示例</summary>

    ```cpp
    int *ptrs[10]  // 指向含有10个整型指针的数组
    int &refs[10] =/*?*/ //不存在引用的数组
    int (*Parrary)[10] = &arr; // 指向一个含有是个个整数的数组
    int (&arrRef)[10] = arr ; //arrRef 引用指向一个含有是个整数的数组
    int *(&arry)[10] = ptrs ; // 首先知道arry是一个引用，然后观察右边知道，arry引用的对象是一个大小为10的数组，最后观察左边知道，数组的元素类型是指向int的指针。这样，arry就是一个含有10个int型指针的数组的引用
    ```

    </details>

### 2.5.2 访问数组元素

1. 在使用数组下标的时候，通常将其定义为size_t类型
2. 检查下标的值, CPP要检查数组下标

### 2.5.3 指针和数组

1. 通过取地址符号获取地址

    ```cpp
    string nums = {"one","two","three"};
    string *p = &nums[0];  //  等价于    string *p2=nums;
    ```

    其中一层意思就是当使用数组作为`auto`变量初始值的时候，推断出的是指针而非数组，显然是`auto ia2(&ia[0])`;但是使用decltype(ia)返回的类型是由10个整数构成的数组

    ```cpp
    decltype(ia) ia3 = {0,1,2,3,4} ;
     ia3 =p ;//错误:不能把整型指针给数组赋值， 
     ia3[4] = i;//正确: 把整数i赋值给ia3的一个元素
    ```

2. 指针也是迭代器,可以进行整型运算
    获取数组的指针后就可以通过`加/减`计算指针的值,获取指针的最后一个元素地址 `&arr[n]` ,这个表示arr的长度。针超出了上述范围就将产生错误，而且这种错误编译器一般发现不了。两个指针相减的结果的类型是一种名为`ptrdiff_t`的标准库类型，和`size_t`一样，`ptrdiff_t`也是一种定义在cstddef头文件中的机器相关的类型。因为差值可能为负值，所以ptrdiff_t是一种带符号类型,两指针不指向头一个对象而进行`加/减`没有意义
3. 标准库函数begin()和end()

    ```cpp
    int arr[] ={0,1,2,3,4,5};
    int *head = begin(arr);
    int *tail = end(arr);

    ```

4. 指针解引用的运算

    ```cpp
    int arr[] = {0,1,2,3};
    int last =*(arr + 3);
    last = *last + 4; //是解引用last然后加4
    int k = p[-2] // 数组下标运算可以处理负值
    vector<T> //下标运算不能为负值，是无符号类型
    ```

### 2.5.4 C风格字符串  

- 支持C风格运算函数，比较字符串时候,比较第一个不相同字符的ASCII码值
- 如果是两个字符串字面量可以用`+`进行拼接，但是如果是两个指针就需要用函数进行拼接
    `strcpy(str,ca1)` //把ca1复制给str,一定要注意str的容量  
    `strcat(str,"")` //str是字符串数组  
    `strcat(str,ca2)` // 将ca2和str继续拼接v  

### 2.5.5 与旧代码的接口,兼容C代码

1. 混合string对象和C风格字符串
    `string s("hello world");`//也允许空字符串初始化string字符串，在string对象的加法运算中允许使用以空字符结束的`字符数组`作为其中一个运算对象（不能两个运算对象都是）；在string对象的复合赋值运算中允许使用以空字符结束的字符数组作为右侧的运算对象.
    无法用`string`对象初始化字符数组，除非使用`s.c_str()`函数`const char *str = s.c_str();`
2. 使用数组初始化vector对象

- 不允许使用一个`数组`给另一个`内置类型数组`初始化  
- `vector`允许给`数组`初始化  
- 但是`数组`却可以给vector 进行初始化,可以是相等元素数量进行赋值，也可以是部分元素数量给`vector`赋值

建议：尽量使用标准库类型而非数组,应该尽量使用string，避免使用C风格的基于数组的字符串

## 2.6 多维数组

```cpp
int ia[10][10] ; //多维数组
int ia[10][10] = {0} ;//将所有元素都初始化为0
// 从左往右理解，定义了一个十个元素的数组，每个元素里面又能容纳一个是元素的数组。
```

### 2.6.1 多维数组初始化

```cpp
/*----1-----*/
//二维数组分别初始化
int ia[3][4] = {
    {1,2,3,0},
    {4,5,6,0},
    {7,8,9,0}
};

/*----2----*/
int ia[3][4] = {0,1,2,3,4,5,6};//这种初始化方式是等价的，但是并不会把所有元素都初始化

/*----3----*/
//显示缺省
int ia[3][4] = {
    {1},
    {4},
    {7}
};
/*----4----*/
// 只是初始化第一行
int ia[3][4] = {
  0,1,2,3
};
```

### 2.6.2 多维数组的下标引用

说白了就是可以通过下标运算符进行取值，如果是三维数组，而用了两个下标运算符那么就会取出**数组**

### 2.6.3 使用范围for语句处理多维数组

看如下例子,因为程序要改变数组中的值，所以要使用`引用`进行赋值。
```cpp
size_t = 0;
for (auto &row : ia){  // row其实是数组的引用
    for(auto &col :row){ // col其实是整数的引用
                col = cnt;
            ++cnt;
    }
}
```

而如下例子代码是错的,编译器初始化row时会自动将这些数组形式的元素（和其他类型的数组一样）
,转换成指向该数组内首元素的指针。这样得到的row的类型就是int＊

```cpp
for (auto row : ia){ 
    for (auto col :row){

    }
}
```

### 2.6.4 指针和多维数组

定义数组的时候千万别忘了这是数组的数组,所以由多维数组名转换得来的指针实际上是指向第一个内层数组的指针,例如  

```cpp
int ia[3][4];
int (*p)[4] = ia; //p 是指向四个整数的数组
int *p[4] ;//整形指针数组
p = &ia[2] ;//p指向ia的尾元素

```

在C++11标准中使用`auto`和`decltype`就能避免在数组前面加一个指针类型，例子如下  
 
```cpp
    for (auto p = ia ;p!=ia+3; ++p){
        for (auto q = *p; q!= *p +4 ; ++q){
            cout << *q << '' ;
        }
        cout << endl;
    }

```

它首先令指针q指向p当前所在行的第一个元素,然后再一次`解引用`指向内层的数组的首元素，然后终止条件为`+4`,当然也可以使用标准函数`begin()`和`end()`实现相同的效果

```cpp
    for (auto p = begin(ia) ; p!=end(ia);++ia ){
        for (auto q = begin(*p); q!=end(*p);++q){
            cout<< *q << '' ;
        }
        cout<< endl; 
    }

```

### 2.6.5 类型别名简化多维数组的指针

使用`类型别名`可以简化工作  
```cpp
using int_array  = int[3]; //新标准下的写法
typedef int int[4] ;//等价的typedef声明
for (int_array *p = ia ; p!= ia +3 ; ++p){
    for( int *q = *p ; q!= *p +3 ; ++q){
        cout<< *q << '' ; 
    }
    cout << endl ; 
}

```
程序将类型“四个整数组成的数组”命名为int_array,用类型名int_array定义外层循环`控制变量`更加简洁

### 2.6.6 术语表

|术语|解释|
|---|---|
|begin |是string和vector的成员，返回指向第一个元素的迭代器。也是一个标准库函数，输入一个数组，返回指向该数组首元素的指针。|
|缓冲区溢出（buffer overflow）|一种严重的程序故障，主要的原因是试图通过一个越界的索引访问容器内容，容器类型包括string、vector和数组等|
|C风格字符串（C-style string）|以空字符结束的字符数组。字符串字面值是C风格字符串，C风格字符串容易出错|
|类模板（class template）|用于创建具体类类型的模板。要想使用类模板，必须提供关于类型的辅助信息。例如，要定义一个vector对象需要指定元素的类型：`vector<int>`包含int类型的元素。|
|编译器扩展（compiler extension）|某个特定的编译器为C++语言额外增加的特性。基于编译器扩展编写的程序不易移植到其他编译器上|
|容器（container） |是一种类型，其对象容纳了一组给定类型的对象。vector是一种容器类型。|
|容器（container） |是一种类型，其对象容纳了一组给定类型的对象。vector是一种容器类型。|
|difference_type | 由string和vector定义的一种带符号整数类型，表示两个迭代器之间的距离。|
|直接初始化（direct initialization）| 不使用赋值号（=）的初始化形式|
|empty() | 是string和vector的成员，返回一个布尔值。当对象的大小为0时返回真，否则返回假。|
|end() |是string和vector的成员，返回一个尾后迭代器。也是一个标准库函数，输入一个数组，返回指向该数组尾元素的下一位置的指针。|
|getline | 在string头文件中定义的一个函数，以一个istream对象和一个string对象为输入参数。该函数首先读取输入流的内容直到遇到换行符停止，然后将读入的数据存入string对象，最后返回istream对象。其中换行符读入但是不保留。|
|索引（index） | 是下标运算符使用的值。表示要在string对象、vector对象或者数组中访问的一个位置。|
|实例化（instantiation） | 编译器生成一个指定的模板类或函数的过程。|
|迭代器（iterator）| 是一种类型，用于访问容器中的元素或者在元素之间移动。|
|迭代器运算（iterator arithmetic） | 是string或vector的迭代器的运算：迭代器与整数相加或相减得到一个新的迭代器，与原来的迭代器相比，新迭代器向前或向后移动了若干个位置。两个迭代器相减得到它们之间的距离，此时它们必须指向同一个容器的元素或该容器尾元素的下一位置。|
|以空字符结束的字符串（null-terminated string）|  是一个字符串，它的最后一个字符后面还跟着一个空字符（'\0'）。|
|prtdiff_t |是cstddef头文件中定义的一种与机器实现有关的带符号整数类型，它的空间足够大，能够表示数组中任意两个指针之间的距离。|
|push_back |是vector的成员，向vector对象的末尾添加元素。|
| 范围for语句（range for）|  一种控制语句，可以在值的一个特定集合内迭代。|
|size | 是string和vector的成员，分别返回字符的数量或元素的数量。返回值的类型是size_type。| 
|size_t |是cstddef头文件中定义的一种与机器实现有关的无符号整数类型，它的空间足够大，能够表示任意数组的大小。|
|size_type |是string和vector定义的类型的名字，能存放下任意string对象或vector对象的大小。在标准库中，size_type被定义为无符号类型。|
|string |是一种标准库类型，表示字符的序列。|
|using声明（using declaration）| 令命名空间中的某个名字可被程序直接使用。using 命名空间 ：： 名字；上述语句的作用是令程序可以直接使用名字，而无须写它的前缀部分命名空间：：。|
|值初始化（value initialization） |是一种初始化过程。内置类型初始化为0，类类型由类的默认构造函数初始化。只有当类包含默认构造函数时，该类的对象才会被值初始化。对于容器的初始化来说，如果只说明了容器的大小而没有指定初始值的话，就会执行值初始化。此时编译器会生成一个值，而容器的元素被初始化为该值|
|vector |是一种标准库类型，容纳某指定类型的一组元素。|
|++运算符（++ operator）| 是迭代器和指针定义的递增运算符。执行“加1”操作使得迭代器指向下一个元素。|
|[ ]运算符（[ ] operator）|下标运算符。obj[j]得到容器对象obj中位置j的那个元素。索引从0开始，第一个元素的索引是0，尾元素的索引是obj.size（）-1。下标运算符的返回值是一个对象。如果p是指针、n是整数，则p[n]与＊（p+n）等价。|
|->运算符（->operator）| 箭头运算符，该运算符综合了解引用操作和点操作。a->b等价于（＊a）.b。|
<<运算符`（<<operator）`|标准库类型string定义的输出运算符，负责输出string对象中的字符。|
|>>运算符`（>>operator）`|标准库类型string定义的输入运算符，负责读入一组字符，遇到空白停止，读入的内容赋给运算符右侧的运算对象，该运算对象应该是一个string对象。|
|！运算符（！ operator）|逻辑非运算符，将它的运算对象的布尔值取反。如果运算对象是假，则结果为真，如果运算对象是真，则结果为假。|
|&&运算符（&&operator）| 逻辑与运算符，如果两个运算对象都是真，结果为真。只有当左侧运算对象为真时才会检查右侧运算对象。|
| ||运算符（|| operator）| 逻辑或运算符，任何一个运算对象是真，结果就为真。只有当左侧运算对象为假时才会检查右侧运算对象。|


# 3. CPP流程控制

- 如果标准输入输出作为`if`,`while`条件，读到文件结束符判断假，或者是无效输入

1. windows : Ctrl+Z (文件结束符)
2. linux : Ctrl+D (文件结束符)

# 4. 函数

- 函数的调用
  - 传值
  - 传引用

- 参数默认值
- Lambda表达式

```cpp
[](int x, int y) -> int { int z = x + y; return z + x; }
```

```
[]      // 沒有定义任何变量。使用未定义变量会引发错误。
[x, &y] // x以传值方式传入（默认），y以引用方式传入。
[&]     // 任何被使用到的外部变量都隐式地以引用方式加以引用。
[=]     // 任何被使用到的外部变量都隐式地以传值方式加以引用。
[&, x]  // x显式地以传值方式加以引用。其余变量以引用方式加以引用。
[=, &z] // z显式地以引用方式加以引用。其余变量以传值方式加以引用。
```

- 引用
实际上是已知变量的另一个名字。

```
int&  r = i;
```

- 标准IO
通过(std::)方式调用标准函数库，或者在函数头写`using namespace std`

```cpp
#include <iostream>
 
using namespace std;
 
int main( )
{
   char name[50];
 
   cout << "请输入您的名称： ";
   cin >> name;
   cout << "您的名称是： " << name << endl;
   cerr << "Error message : " << str << endl;
   clog << "Error message : " << str << endl;
}
```

## 4.1. struct构造初始化

- 利用自带默认构造函数
- 参数构造
- 自定义void init(.....){ ... this->  ...}
在建立结构体数组时,如果只写了带参数的构造函数将会出现数组无法初始化的错误！！！各位同学要牢记呀！！！

```cpp

struct node{
 int data;
 string str;
 char x;
 //自己写的初始化函数
 void init(int a, string b, char c){
  this->data = a;
  this->str = b;
  this->x = c;
 }
 node() :x(), str(), data(){}
 node(int a, string b, char c) :x(c), str(b), data(a){}
}N[10];
```

# 5. 面向对象编程

- #include指令使用（<>）导入标准库函数，非标准库用双引号（" "）。

<details>
<summary>类示例demo</summary>

```cpp
#include <iostream>
#include "Books"
using namespace std;
 
class Box
{
   private:
   
   protected:
   
   public:
      char  title[50];
      char  author[50];
      char  subject[100];
      int   book_id;
      double length;   // 长度
      double breadth;  // 宽度
      double height;   // 高度
      // 成员函数声明，但是没有实现
      double get(void);
      void set( double len, double bre, double hei );
      
};
// 成员函数定义
double Box::get(void)
{
    return length * breadth * height;
}
 
void Box::set( double len, double bre, double hei)
{
    length = len;
    breadth = bre;
    height = hei;
}
int main( )
{
   Box Box1;        // 声明 Box1，类型为 Box
   Box Box2;        // 声明 Box2，类型为 Box
   Box Box3;        // 声明 Box3，类型为 Box
   double volume = 0.0;     // 用于存储体积
 
   // box 1 详述
   Box1.height = 5.0; 
   Box1.length = 6.0; 
   Box1.breadth = 7.0;
 
   // box 2 详述
   Box2.height = 10.0;
   Box2.length = 12.0;
   Box2.breadth = 13.0;
 
   // box 1 的体积
   volume = Box1.height * Box1.length * Box1.breadth;
   cout << "Box1 的体积：" << volume <<endl;
 
   // box 2 的体积
   volume = Box2.height * Box2.length * Box2.breadth;
   cout << "Box2 的体积：" << volume <<endl;
 
 
   // box 3 详述
   Box3.set(16.0, 8.0, 12.0); 
   volume = Box3.get(); 
   cout << "Box3 的体积：" << volume <<endl;
   return 0;
}
```

</details>

- CPP支持文件重定向`$ addItems <infile >outfile` 可直接从文件读数据然后计算

<details>
  <summary>文件重定向Sales_item代码</summary>
 <blockcode>

 ```cpp
  /*
 * This file contains code from "C++ Primer, Fifth Edition", by Stanley B.
 * Lippman, Josee Lajoie, and Barbara E. Moo, and is covered under the
 * copyright and warranty notices given in that book:
 * 
 * "Copyright (c) 2013 by Objectwrite, Inc., Josee Lajoie, and Barbara E. Moo."
 * 
 * 
 * "The authors and publisher have taken care in the preparation of this book,
 * but make no expressed or implied warranty of any kind and assume no
 * responsibility for errors or omissions. No liability is assumed for
 * incidental or consequential damages in connection with or arising out of the
 * use of the information or programs contained herein."
 * 
 * Permission is granted for this code to be used for educational purposes in
 * association with the book, given proper citation if and when posted or
 * reproduced.Any commercial use of this code requires the explicit written
 * permission of the publisher, Addison-Wesley Professional, a division of
 * Pearson Education, Inc. Send your request for permission, stating clearly
 * what code you would like to use, and in what specific way, to the following
 * address: 
 * 
 *     Pearson Education, Inc.
 *     Rights and Permissions Department
 *     One Lake Street
 *     Upper Saddle River, NJ  07458
 *     Fax: (201) 236-3290
*/ 

/* This file defines the Sales_item class used in chapter 1.
 * The code used in this file will be explained in
 * Chapter 7 (Classes) and Chapter 14 (Overloaded Operators)
 * Readers shouldn't try to understand the code in this file
 * until they have read those chapters.
*/

#ifndef SALESITEM_H
// we're here only if SALESITEM_H has not yet been defined 
#define SALESITEM_H

// Definition of Sales_item class and related functions goes here
#include <iostream>
#include <string>

class Sales_item {
// these declarations are explained section 7.2.1, p. 270 
// and in chapter 14, pages 557, 558, 561
friend std::istream& operator>>(std::istream&, Sales_item&);
friend std::ostream& operator<<(std::ostream&, const Sales_item&);
friend bool operator<(const Sales_item&, const Sales_item&);
friend bool 
operator==(const Sales_item&, const Sales_item&);
public:
    // constructors are explained in section 7.1.4, pages 262 - 265
    // default constructor needed to initialize members of built-in type
    Sales_item() = default;
    Sales_item(const std::string &book): bookNo(book) { }
    Sales_item(std::istream &is) { is >> *this; }
public:
    // operations on Sales_item objects
    // member binary operator: left-hand operand bound to implicit this pointer
    Sales_item& operator+=(const Sales_item&);
    
    // operations on Sales_item objects
    std::string isbn() const { return bookNo; }
    double avg_price() const;
// private members as before
private:
    std::string bookNo;      // implicitly initialized to the empty string
    unsigned units_sold = 0; // explicitly initialized
    double revenue = 0.0;
};

// used in chapter 10
inline
bool compareIsbn(const Sales_item &lhs, const Sales_item &rhs) 
{ return lhs.isbn() == rhs.isbn(); }

// nonmember binary operator: must declare a parameter for each operand
Sales_item operator+(const Sales_item&, const Sales_item&);

inline bool 
operator==(const Sales_item &lhs, const Sales_item &rhs)
{
    // must be made a friend of Sales_item
    return lhs.units_sold == rhs.units_sold &&
           lhs.revenue == rhs.revenue &&
           lhs.isbn() == rhs.isbn();
}

inline bool 
operator!=(const Sales_item &lhs, const Sales_item &rhs)
{
    return !(lhs == rhs); // != defined in terms of operator==
}

// assumes that both objects refer to the same ISBN
Sales_item& Sales_item::operator+=(const Sales_item& rhs) 
{
    units_sold += rhs.units_sold; 
    revenue += rhs.revenue; 
    return *this;
}

// assumes that both objects refer to the same ISBN
Sales_item 
operator+(const Sales_item& lhs, const Sales_item& rhs) 
{
    Sales_item ret(lhs);  // copy (|lhs|) into a local object that we'll return
    ret += rhs;           // add in the contents of (|rhs|) 
    return ret;           // return (|ret|) by value
}

std::istream& 
operator>>(std::istream& in, Sales_item& s)
{
    double price;
    in >> s.bookNo >> s.units_sold >> price;
    // check that the inputs succeeded
    if (in)
        s.revenue = s.units_sold * price;
    else 
        s = Sales_item();  // input failed: reset object to default state
    return in;
}

std::ostream& 
operator<<(std::ostream& out, const Sales_item& s)
{
    out << s.isbn() << " " << s.units_sold << " "
        << s.revenue << " " << s.avg_price();
    return out;
}

double Sales_item::avg_price() const
{
    if (units_sold) 
        return revenue/units_sold; 
    else 
        return 0;
}
#endif
```

 </blockcode>
</details>

```cpp
#include <iostream>
#include "Sales_item.cc"

 
using namespace std;
int main() 
{
    Sales_item item1, item2;

    std::cin >> item1 >> item2;   //read a pair of transactions
    std::cout << item1 + item2 << std::endl; //print their sum

    return 0;
}
```

## 5.1. 继承与多继承

```cpp
#include <iostream>
 
using namespace std;
 
// 基类
class Shape 
{
   public:
      void setWidth(int w)
      {
         width = w;
      }
      void setHeight(int h)
      {
         height = h;
      }
   protected:
      int width;
      int height;
};
 
// 派生类, 多继承就是写成 class Rectangle: public Shape, public square { ... }
class Rectangle: public Shape
{
   public:
      int getArea()
      { 
         return (width * height); 
      }
};
 
int main(void)
{
   Rectangle Rect;
 
   Rect.setWidth(5);
   Rect.setHeight(7);
 
   // 输出对象的面积
   cout << "Total area: " << Rect.getArea() << endl;
 
   return 0;
}
```

访问   | public | protected | private |
| ---- | ------ | --------- | ------- |
| 同一个类 | yes    | yes   | yes |
| 派生类  | yes    | yes    | no  |
| 外部的类 | yes    | no    | no |

一个派生类继承了所有的基类方法，但下列情况除外：

- 基类的构造函数、析构函数和拷贝构造函数。
- 基类的重载运算符。
- 基类的友元函数。

我们几乎不使用 **protected** 或 **private** 继承，通常使用 **public** 继承。当使用不同类型的继承时，遵循以下几个规则：

- **公有继承（public）：** 当一个类派生自**公有**基类时，基类的**公有**成员也是派生类的**公有**成员，基类的**保护**成员也是派生类的**保护**成员，基类的**私有**成员不能直接被派生类访问，但是可以通过调用基类的**公有**和**保护**成员来访问。
- **保护继承（protected）：**  当一个类派生自**保护**基类时，基类的**公有**和**保护**成员将成为派生类的**保护**成员。
- **私有继承（private）：** 当一个类派生自**私有**基类时，基类的**公有**和**保护**成员将成为派生类的**私有**成员。

## 5.3. 函数，运算符重载

- 函数签名不同的叫函数重载
- 运算符重载

```cpp
类成员函数
Box operator+(const Box&);
```

```cpp
类的非成员函数
Box operator+(const Box&, const Box&);

```

## 5.4. 多态

如果对象具有继承关系，那么CPP会更具具体的对象类型调用具体的成员函数长度

## 5.5. CPP接口

```cpp
class Box
{
   public:
      // 纯虚函数
      virtual double getVolume() = 0;
   private:
      double length;      // 长度
      double breadth;     // 宽度
      double height;      // 高度
};
```

实现类必须要实现抽象安徽念书(虚函数)
