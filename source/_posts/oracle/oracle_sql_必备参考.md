---
title: Oracle Sql必备手册
categories: 
- oracle
thumbnailImagePosition: bottom
# thumbnailImage: http://d1u9biwaxjngwg.cloudfront.net/cover-image-showcase/city-750.jpg
coverImage: https://user-images.githubusercontent.com/46363359/198887021-f1b71975-a6e8-44ca-af02-decfaf7ca9e1.jpg
metaAlignment: center
coverMeta: out
---

摘要: 主要是讲oracle的sql基础
关系数据库系统的根源要追溯到1970年，那时E.F,.Codd博土发表了标题为"A Relational Model of Data for Large Shared Data Banks"的论文（注1),当年6月刊登在由美国让算机学会(the Association of Computer Machinery，ACM）主办的《Communciations of the ACM》期刊上。该论文永久地改变了计算世界。Codd建议的关系数据库管理系统模型(relational database management system,RDBMS)最后变成了关系数据库的定义标准．而关系数据库则成了当今使用的主流数据库。


<!-- more -->

<!-- toc -->


## 1. SQL元素

进行SQL开发是为了更容易地访问关系数据库,所以,sql能够执行下面几种操作：
- 从数据库中查询数据
- 向数据库中插入数据
- 从数据库中删除数据
- 创建和操纵数据库对象
- 控制对数据库的访问

严格地说，SQL根本不是种语言，而是对Oracle数据库传输指令的方式。它与传统的编程语言在以下几个主要方面有所不同:
- SQL提供自动定位数据的能力
- SQL在数据集合上操作，而不是对独立的数据元素操作
- SQL是声明的，而不是过程化的，并且不提供过程控制SQL设计在逻辑层完成;这不需要处理实现的细节
简单地说，当在SQL中设计时，你告诉Oracle自己想要干什么，而不是怎样做。但是这种方法利弊并存。考虑下面的SQL语句:

```sql
SELECTename,deptno,sal,cornn.FROM scott.ermp
WHEREhiredate > '01-JAN-Q0' ;
```

这个简单的SQL语句告诉数据库显示2000年1月1日以后雇佣的职工名字( ename )、部门号( deptno)、薪水（ sal）和佣金( comm)。在"老式的"过程化编程语言巾,这可能需要儿百行代码，但是，在SQL中只需要3行代码。Oracle在检索数据时并不总是如此灵巧。尽管Oracle内部的“查询优化器”有了稳步提高，但仍然有许多方法可以改进SQL的性能，第八章在讨论SQL语句的调试时将展示这一主题。

注意:有人将缺乏过程化控制视为SQL的缺点、因此，Oracle公司开发了PL/SQL ( Procedural
Language/SQL，即过程化编程语言/SQL),这一内容将在第七章讨论.

SQL语句也称为SQL命令，由以下儿部分组成:
- 关键字  带有特定Oralce操作意义的保留字。
- 变量    它是可以被动态文本或数宇变量替换的数据元素。SQL有许多对象名，如变量、表或视图。
- 文字    常量数据．包括文本字符串和数字。
- 操作符  操作一个或多个变量或文字的符号或单词。

**词汇习惯**
SQL语句由`命令`、`变量`和`操作符`组成，这些内容在本章和第二章将进行详细描述SQI.语句由以下元素构建:
- 字母A到Z(或者数据库符集中的等物成)
- 数字0到9
- 空格
- 下面的特殊字符串
- oracle不推荐使用$和#
- sql不区分大小写，除了字符串变量中的常量外
- 制表符,回车,多空格,注释都是空格符号

**SQL命名**

SQL小的大部分命名需求实际上是Oracie数据库的需求; Oracle数据库中川接受的架构对象 (schemma obiects，第3 节中定义)的命名都可在SQL中接受，反亦然。下列规则应用丁 Oracle 中的架构对象:
- 可以由 1-30个字母字符组成
- 必需用字母开始。
- 可以包下划线(_)。
- 虽然Oracle 不鼓励使用美($)或英镑 (#)字符，但也可以包括这些字符
- 不能是保留字
- 不能使用SQL命令名

### 1.1 架构对象

架构对象
架构对象是存储在数据库中由用户所有的数据或其他对象的逻辑集合。下面的对象类型可以被认为是架构对象:
- 簇
- 数塘库链接
- 数据库触发器
- 维度
- 扩展过程库
- 索引组织表
- 索引
- 索引类型
- 物化的视图/快照
- 嵌套的表类型
- 对象类型
- 操作符
- 包
- 序列
- 存储过程
- 同义词
- 表
- 可变数组类型
- 视图
- 数据库链接

**常用语法**
通常、大家在SQL语句中引用架构对象时使用下列语法:
```sql
schema.object_name.object_part@dblink
```
这些语法元素的意义如下:
- 架构(schema)
    拥有对象的架构名。在Oracle中，架构与用户名一…对应;如果在引用中省略架构对象，那么默认使用当前登录用户名。
- 对象名(object_name)
    被引用的对象名，如表
- 对象部分(object_part )
    对具有部分对象名的架构对象、就是部分对象名、如表的列。
- 数据库链接（ dblink )
    一个引用远程数据库的数据库连接的名称。

一个完整的sql查询是:
```sql
select ename ,empno,sal from scott.emp@test where sal>500;
```

**分区语法**
当引用一个已分区表中的特定分区或子分区时，使用下列语法:
```sql
schema.table_name {PARTITION(partition) |
Subpartition (subpartition)}
```
该语法元素具有以下意义;
- 架构（ schema )
    拥有对象的架构名。在Oracle中，架构对应于一对一的用户名，而且，如果在引用架构对象中省略架构，那么默认使用当前登录用户名。
- 表名( table_name )
    被引用的表的名家。
- 分区( partition )
    表的分区名。
- 子分区( subpartition )
    表的子分区名。
该结构被称为分区扩展表名( partition-extended table name)。分区扩展表名可以没有与之相关的数据库链接。因此，如果你想访问远端数据库上的该对象，就必须创建可以使用以前描述的常用架构对象语法访问的视图(不是太理解)

### 1.2 书类型
**字符数据**
`char[(length)]`
定长字符数据，最长可以到2000字节。length指定了被存储字符的最大长度。如果存储的数据没有达到指定长度，自动补足空格。指定长度时，默认长度的计量单位由NLS_LENGTH_SEMANTICS（默认为字节byte）参数决定，但是我们可以手动指定为char或者byte。oracle建议使用NLS_LENGTH_SEMANTICS来指定计量单位，这样可以提高效率。在plsql中，最大存储长度可以达到32767个字节。使用char时，可以不指定最大长度，此时最大长度为1.
`varchar2[(length)]`
可变长度的字符数据，最长可以到4000字节。length指定了被存储的字符的最大长度。使用数据库字符集存储数据，长度可变，如果存储数据没有达到指定长度，不自动补足空,8比特等于一个字节，2个字节等于一个中文字符(ASCII编码)，varchar2(4)最大存四个字节，那么最多存两个汉字
`NCHAR[(length)]`
固定长度的字符数据，由国际字符语言（National Character Language，NLS)字符集字符组成。因为一个字符可能需要不止一个字节，所以最长可以到2000字节(允许少于2000字节)。length指定了被存储字符的最大长度。
`NVARCHAR2[(length)]`
NLS字符集字符组成可变长度宇符数据。因为字符可能需要不止一个字节，所以最长可以到4000字节（允许少于4000字节)。length指定了被存储字符的最大长度。
`LONG`
可变长度的字符数据，最大长度可以为2GB。
`RAW`
原始的二进制数据,最大长度可以为2000字节。在不同字符集的系统之间移动数据时，不能用Oracle转换RAW数据。
`LONG RAW`
原始的二进制数据、最大长度可以为2GB。在不同字符集的系统之间移动数据时．不能用Oracle转换LONG RAW数据。

**算数类型**
数字数据是可以不进行数据转换而直接参与算术运算的数据。Oracle只有一种数字类型: `NUMBER`类型。
注意:NUMBER可以控制的值范围是10的负130次幂和9.99999.….x 10的125次幂，但数字精度只有38位。
数字数据元素可以用以下方式表示:
`NUMBER [ (precision[ , scale] ) ]`
- 精度(precision)
    数字中的数字位数，范围为1~38。
- 尾数(Scale )
    小数点石边的数宇位数，可以在-84~127之间变化。
如果省略尾数，则将数字当作整数，而且不存储小数点部分。如果既省略精度也省略尾数，则将数字当作为浮点数字。
警告:经常指定一个数字数据类型的精度是--个好想法。如果你不指定，则﹒些ODBC驱动将
认为其精度为0，与Oracle的默认精度为38相反。此时，ODBC兼容的客户工具将不能允许插入或更新列值不为0的行。
1. precision表示数字中的有效位;如果没有指定precision的话，Oracle将使用38作为精度。
2. 如果scale大于零，表示数字精确到小数点右边的位数；scale默认设置为0；如果scale小于零，Oracle将把该数字取舍到小数点左边的指定位数。
3. Precision的取值范围为【1---38】；Scale的取值范围为【-84---127】。
4. NUMBER整数部分允许的长度为（precision- scale），无论scale是正数还是负数。
5. 如果precision小于scale，表示存储的是没有整数的小数。
6. Precision表示有效位数，有效数位：从左边第一个不为0的数算起，小数点和负号不计入有效位数；scale表示精确到多少位，指精确到小数点左边或右边多少位(+-决定)  


summary:

|实际值|数据类型|存储值|
|---|---|---|
|1234567.89|Number|1234567.89
|1234567.89|Number(8)|1234567|
|1234567.89|Number(6)|出错|
|1234567.89|Number(9,1)|1234567.9|
|1234567.89|Number(9,3)|出错|
|1234567.89|Number(7,2)|出错|
|1234567.89|Number(5,-2)|1234600|
|1234511.89|Number(5,-2)|1234500|
|1234567.89|Number(5,-4)|1230000|
|1234567.89|Number(*,1)|1234567.9|
|0.012|Number(2,3)|0.012|
|0.23|Number(2,3)|出错|


**日期**
Oracle使用DATE数据类型存储日期和时间信息。Oracle DATE数据以包含下列信息的专有格式仔储:
- 世纪(century)
- 年( year)
- 月( month )
- 日( day )
- 小时(hour)
- 分钟( minute)
- 秒（ second )
要以DATE数据类型存储数据，则日期和/或时间信息必需转换为Oracle内部格式。如果字符代表的日期与默认格式（在初始化文件INIT.ORA的 NLS_DATE_FORMAT参数中指定）相匹配，那么Oracle就可以自动执行这种转换。例如，如果DD-MON-YY的默认NLS_DATE_FORMAT有效，那么下任的SQL语句将插入期2076年7月4日到表的T_DATE列中:
```sql
INSERT into sanple_table (t_date) VALUES ('07-JUL-76'):
```
如果日期和/或时间信息在另一种格式下可用，你就可以使用Oracle 内部的TO_DATE函数执行转换。例如,如果相间的日期以07/04/76提供,那么这里显示的SQL语句将使用Oracle的 TO_DATE函数插入下面行的数据;
```sql
INSERT INTO sanp1e_tab1e (t_date)
VALUES t TO__DATE(' 07-JUL-76'，"MEM/ DD/YY" ));
```

要了解有关TO_DATE和其他转换函数的更多信息、请参见第五章。

**空值**

null

**定位符**

- rawid
    ROWID返回代表行数据的物理位置的字符串，并包含了Oracle定位数据行需要的所有信息，包括:
    - 数据文件包含的行
    - 包含行的文件块
    - 数据块中的行位置
    - 对象的对象编号(只有Oracle8有)

除了表以簇的形式存储的情况之外，ROWID将惟--定义数据的单个行。
通常ROWID以18个字符串的形式返回且可用于数据操纵语言（DML)语句，就像Oracle的任何其他列一样。
注意:虽然ROWID可以存储在表列中，但你永远也不能依赖保留ROWID值的行。因为
ROWID代表了物理位置，所以、如果行以不同的形式存储，则该值将会发生变化。例如,导入以后再导出、则任何存储的ROWID都可能无效-

- UROWID
    囚为Oracle对象的一些类型可能没有Oracle固定的或产生的物理位置（如通过透明网关访问的对象)、所以Oracle已经开发了通用ROWID数据类型( UniversalROWID,UROWID)。在可用时，它可以包含物理的ROWID，否则，它包含逻辑RowID。Oracle强烈推荐你使用UROWID数据类型代替ROWID，所以可以使用任何类型的位置信息。

**伪列**
虽然不是实际的数据类型，Oracle支持许多特殊日的的数据元素。这些元素并不实际包含在表中，但可以用在SQL语句中，就像它们是表的一部分一样。
- ROWNUM
    对被SQL查询返回的每一行数据,ROWNUM将包含显示检索行顺序的数字。例如，检索的第一行ROWNUM为1，第2行ROWNUM为2等等。该方法可以用于限制被查询返回的行号。下面的SQL语句利用了ROWNUM伪列:
    ```sql
    SELECT*
    FROMemp
    WHEREROWNUM< 11;
    ```
    警告; ROWNUM返问的数字显示了从表中提取行的顺序,但这不是行一直显示的顺序。例如,如果SQL语句包括了ORDER BY从句，那么行将不会以ROWNUM的颖序显示，因为在排序操作之前已经分配了ROWNUM。
- CURRVAL
    在使用Oracle SEQUENCE值时（见第二章的“CREATE/ALTER/DROPSEQUENCE”)，伪列CURRVAL返回序列的当前值。要引用CURRVAL，就必须与序列相关。[schemna.]sequence_name.currval
    - schema
        序列的所有者。如果省略schema，Oracle就假设为当前连接到数据库的用户名。
    - sequence_name
        Oracle序列名。
    - CURRVAL
        序列的当前值。
**NEXTVAL**
在使用Oracle SEQUENCE值时，伪列NEXTVAL返回序列的下–个值、而且使序列增加1。你可以只在NEXTVAL与序列相关时才引用它:
[schema.]sequence_name.NEXTVAL
- schema
    序列的所有者。如果省略schema，Oracle就假设为当前连接到数据库的用户名。
- sequence _name
    Oracle序列名。
- NEXTVAL
    序列的下--个值。
注意:Oracle将只在给定的SQL语句中增加序列，所以，如果语句中包含NEXTVAL的多个
引用,那么第二个和后继的引用将返回相同的CURRVAL值。

**LEVEL**
    被分层查询(使用order bu从句)返回的每…行，LEVEL返回1表示根节点，2表示返回根节点的子节点等等。根节点是转换树中的最高节点、子节点是任何非根节点的节点，父节点是有子节点的节点，而叶节点是没有子节点的节点。
**USER**
    该伪列将一直包含你连接到数据库的Oracle用户名。
**SYSDATE**
    该伪列将包含当前H期和时间。该列是一个标准的Oracle期数据类型。
    在SYSDATE中包含的日期和时间来源于处理查询的服务器，而不是运行查询的客户端。所以，如果你从伦敦的客户工作站连接到东京的服务器.上，那么日期和时间将是东京服务器t的具体日期和时间（而且日期大概会提前Ⅰ天)。
警告:如果你通过数据库链接返回SYSDATE列（例如，SELECT SYSDATE FROM dual@london )，则会返回被连接的服务器的日期和时间，而不是数据库链接引用的远端服务器的日期和时间。
