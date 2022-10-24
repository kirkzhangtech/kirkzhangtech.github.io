---
title: Real_World_SQL_and_PLSQL
categories:
- oracle
---


# chapter 5 Edtion_Baseed Redefinition

升级数据库应用程序总是需要停机；根本不可能替换正在使用的PL/SQL对象。

## 5.1 Planned Downtime

unplaned downtime是很难预料的，可以通过使用备机来减少downtime，但是完全消除downtime是不可能的
硬件故障可以切换到物理或者逻辑备用数据库继续提供服务，一直以来，没有办法在运行时替换PL/SQL而不影响服务的运行。
某一PL/SQL object只能有一个版本。当你替换object时候，整个object是被锁住的。
planed downtime : 贵公司计划的downtime时间

With edition-based redefinition, you can create PL/SQL changes in the privacy of an edition. Then, when the custom application is updated, it can be released to the users. Newly connecting users will use the new application objects, while the users who were using the application during the upgrade can continue to work as if nothing happened. When the last of the users has disconnected from the pre-upgraded application, that application can be retired and only the post-upgraded application will be available for use.

## 5.2 Terminology Used（专业术语）

patch : 当程序没有实现需求所规定的内容时，需要应用补丁来纠正，实现程序和需求一致。补丁应该使程序符合需求所规定的。
upgrade : 当需求在程序创建后发生变化。（跟patch的区分不是太清晰，当文本中提到 "升级 "时，也可理解为一个补丁，反之亦然）。

## 5.3 The Concept

EBR解决的三个挑战
1. 首先，当有人在使用一个应用程序时，你怎么能对其进行修改？对一个应用程序进行修改通常涉及许多对象的修改，但你不能一个接一个地修改它们。这将使应用程序处于invalid的状态 ,有可能用升级前的数据库应用程序对数据库进行完整的复制，并进行必要的修改以达到升级后的状态，这就解决了第一个问题。另一个选择是复制数据库schema，并在这个schema中进行修改。
2. 随之而来的第二个问题，如何在两个应用程序（升级前的应用程序和升级后的应用程序）之间保持数据的同步？你可以想象，这不是一件容易做到的事情。原来的数据库对象仍然在使用，数据继续导入和改变。必须有一种机制，允许数据变化在升级前和升级后的应用程序之间传播。
3. 表结构的升级。

EBR三个优点  
Changes are made in the privacy of a new edition.
相同表的不同版本（pre,post）是通过使用编辑视图实现的.
在热更新期间，跨版本的触发器将使不同版本之间的数据变化保持同步.

high risk
```
Implementing edition-based redefinition is not as trivial as flipping a switch. 
The preparation phase of edition-based redefinition is very important and might 
require changing the existing database design and database source code
```

```txt
If, for whatever reason, the edition-based redefinition exercise fails 
and the edition must be removed, the edition can be dropped by a single 
statement.Keep in mind, though, that changes to the table are not reversed 
when an edition is dropped from the database. Also, changes to the data 
are not reversed and should be removed as well to return to the pre-upgraded version.
```

## 5.4 Preparation: Enable Editions

1. 启动EBR
   ```sql
    alter user scott enable editions
   ```
2. 不能disable这个操作
12.1之前是enable整个schema的object为editionable,12.1之后可以指定aditionable为non-editionable.

## 5.4.1 NE(non-editionable) on E(editionable) Prohibition
这句话怎么翻译比较贴切？--- It is not possible for noneditionable objects to depend on editionable objects. This is called the NE on E prohibition. 
user-defined type : 可能就是复合数据类型，由基础数据类型组成

在Oracle数据库12.1之前，当你想对一个schema启用编辑时，你必须解决NE on E的问题。例如，当你有一个user-defined type被用于表的定义时，你就违反了NE on E prohibition。一个用户定义的类型是可编辑的，而一个表永远不能被编辑。当你需要遵守12.1版本之前的zero downtime要求时，不可避免地需要改变你的模式设计。

从Oracle数据库12.1开始，可以通过明确地将某些对象设置为不可编辑来定义对象。这只能在edition-enable之前实现。一旦一个object被设置为不可编辑，并且edition enabled，其状态就会被固定，不能被改变。试图这样做将导致以下异常。
```sql
ORA-38825: The EDITIONABLB property of an editioned object cannot be altered.
```

演示对某一个用户(账号)启动EBR,分析NE on E prohibition具体例子，
创建一个新用户

```sql
create user neone identified by neone
/
grant connect,create table,create type to neone
/
alter user neone quota unlimited on users
/
```

接着用该账号创建user-defined type

```sql
create type phone_number_ot as object(
   type_name varchar2 (10)
,  phone_number varchar2(20)
)
/

```

基于上面的type object创建数据库的表

```sql
create type phone_numbers_tt as table of phone_number_ot
/
create table emps( 
   empno number
,  phone_numbers phone_numbers_tt
)
nested table phone_numbers store as phone_numbers_nt

```

这时候尝试启动EBR,就会碰到如下问题

```sql
alter user neone enable editions
/
ERRORat line l:
ORA-38819: user NEONE owns one or more objects whose type is editionableand that have noneditioned dependent objects

```
这是因为你的type类型是editionable的，table类型是non-aditionable的，EBR不允许有这样的依赖关系，这样是12.1版本之前必须要该schema的table和source code的设计，12.1之后我们可以实现将NE编程E从而解决这个问题。通过如下可以解决NE on E问题
```sql

alter type phone_numbers_tt noneditionable
/
alter type phone_number_ot noneditionable
/

```

另外，上面相同的例子，还有有第二种情况，如果是已经启动EBR，然后基于user-defined type创建表就会报错

```sql

create table emps*
ERROR at line 1:
ORA-38818: illegal reference to editioned object neone.PHONE_NUMBBR_OT

```
因为第二种情况下neone已经启动了EBR,这时候你也无法把将edtionable的type类型改变为non-aditionable

如果测试，生产环境中真碰到了这个问题，我们该如何的解决这个问题呢?  
需要我们重新创建type类型，这样才能保证我们成功创建基于type类型的table
```sql
drop type phone_numbers_tt
/
Type dropped.
drop type phone_number_ot
/
Type dropped.

create or replace noneditionable type phone_number_ot as object
( type_name varchar2 (10)
, phone_number varchar2 (20)
)
/
Type created

create or replace noneditionable type phone_numbers_tt as table of phone_number_ot
/
Type created.

create table emps(
   empno number
,  phone_numbers phone_numbers_tt
)
nested table phone_numbers store as phone_numbers_nt
/

Table created

```

现在总结如下:

1. 如果数据库中存在NE on E的情况，在12.1之前是启动不了EBR，需要改设计
2. 在12.1之前版本启动了EBR,那么在之后的表设计当中就要避开NE on E的问题
3. 如果真出了NE on E的问题，可以通过重新创建type,然后重新创建表来解决

遗留问题尚待解决:

1. 如果你的架构中使用ogg，data guard，RAC等等oracle系的组件，
   要如何保证他们不停机维护，也要把他们考虑进去

## 5.4.2 Create a new edition

因为用户SCOTT启用了edition，所以我们可以创建一个额外的edition。版本之间有一个层次关系，其中一个edition总是有一个父edition这里唯一的例外是ORA$BASE，或者当这个edition最终被删除时，是层次结构中的下一个版本——根edition。  
为了创建一个新版本，需要系统权限`create ANY edition`:
```sql
grant create any edition on scott
```

在创建版本之前，还需要将用作父版本的版本上的USE特权。一个版本总是作为另一个版本的子版本创建。创建版本时，会自动授予USE对象特权。USE权限也可以单独授予，如下面的代码示例所示:

```sql
grant use on edition <edition_name> to <user>
```

这里，`<edition_name>`和`<user>`需要用edition的名称和你想授予权限的用户来代替。
为了删除根edition或leaf edition，需要有`DROP ANY EDITION`系统权限。


```sql
grant drop any edition to scott
```

当你连接到一个数据库时，可以通过使用ALTER语句来改变版本，比如在下一个例子中，其中`<edition_name>`是指应该改成你想改成的版本。
```sql
alter session set edition =<edition_name>
```
请记住，如果application有未完成的事务，这时候是不用change你的edition,否则你将会碰到如下error。
```sql
alter session set edition =r2
error:
ora-38814:alter session set edition must be first statement of transaction

```

## 5.5 Complexity levels

使用EBR包括了多层复杂因素  
first level : PLSQL object结构change,有哪些在edition之间
second level : table struct change among edition
在同一时间不需要维护多个版本的edition因为在将来所有的user都会使用post-upgrade edition
third level : complex level is where you do have table structure changes and the users need to access multiple editions at the same time ,thus keeping data in sync between multiple editions.

### 5.5.1 replace PLSQL code

接下来阐述了在不同edition之间，不同的functionality可以有相同的名字
下面sql可以查看当前edition名字
```sql
select sys_context('userenv',
                   'current_edition_name') as "current_edition"from dual;
```
也可以通过`show edition`来查询当前edition.