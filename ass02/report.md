# Assignment_02_Report
> 新雅62/CDIE6 2016013327 项雨桐

> 19.10.04

## 0 version info
* MySQL Server: 8.0.17 MySQL Community Server - GPL
* MySQL Workbench: Version 8.0.17 build

## 1 Create a database named University in MySQL WorkBench
![1.png](https://i.loli.net/2019/10/04/Q9n3XLHYBwxShW4.png)

## 2 ER Model Transformation
### 2.1 转化
该ER图可转化为6张表(加[]为主键)：

#### 2.1.1 ``entity:department``

[name]| building | budget
--|--|--
 | | 
 
#### 2.1.2 ``entity:instructor``

[i_ID]| i_name | salary
--|--|--
 | | 

#### 2.1.3 ``entity:student``

[s_ID]| s_name | tot_cred
--|--|--
 | | 
 
#### 2.1.4 ``relation:work``

[i_ID]|dept_name
--|--
  |  |

#### 2.1.5 ``relation:belong``

[s_ID]|dept_name
--|--
  |  |

#### 2.1.6 ``relation:advise``

[i_ID]|[s_ID]
--|--
  |  |

### 2.2 合并
观察可知``entity:instructor``和``relation:work``主键相同，可以合并，同理可知``entity:student``和``relation:belong``也可合并。
因此合并后的4张表分别为：

#### 2.2.1 ``department``

[name]| building | budget
--|--|--
 | | 

#### 2.2.2 ``instructor``

[i_ID]| i_name | dept_name | salary
--|--|--|--
 | | |

#### 2.2.3 ``student``
[s_ID]| s_name | dept_name | tot_cred
--|--|--|--
 | | |

#### 2.2.4 ``advise``
[i_ID]|[s_ID]
--|--
  |  |

### 2.3 建表
建表时要适当加以外键限制，结果如下

![2.png](https://i.loli.net/2019/10/04/5Fx4AcaOUno9dzL.png)

## 3 Insert all the values in the file named Data-University.xlsx into the University database using SQL
### 3.1 ``department``
![3-1.png](https://i.loli.net/2019/10/04/JZ6WTVkoqzMIrHj.png)

### 3.2 ``instructor``
![3-2.png](https://i.loli.net/2019/10/04/2OINxk6ctRQpwSa.png)

### 3.3 ``student``
![3-3.png](https://i.loli.net/2019/10/04/TrVAGKDvg3jQPOu.png)

### 3.4 ``advise``
![3-4.png](https://i.loli.net/2019/10/04/mCeTDk2yF4XQloh.png)

## 4  Single-Table Queries:
### 4.1 Select those students whose total credit are higher than 100 (including 100)

![4-1.png](https://i.loli.net/2019/10/04/iJseBV7jF8ycu6o.png)

### 4.2 Select those instructors whose salary are lower than 70000.00 (including 70000.00)

![4-2.png](https://i.loli.net/2019/10/04/JRYEWgr3CxUufZn.png)\

### 4.3 Select those departments whose budget are higher than 80000.00 (including 80000.00) and then sort them by budget in a descended order

![4-3.png](https://i.loli.net/2019/10/04/TfadSGemcy5hpNX.png)

### 4.4 Calculate the average salary of those instructors whose salary are between 50000.00 and 100000.00 (including 50000.00 and 100000.00)

![4-4.png](https://i.loli.net/2019/10/04/glU2Dk3ruH4nAEF.png)

### 4.5 Calculate the student number and teacher number of those departments with more than 2 students (including 2)

![4-5.png](https://i.loli.net/2019/10/04/rKszLjSPlUmYxTB.png)

## 5 Multi-Table Queries

### 5.1 Join table student with table advise conditioning on student ID under the following join types


#### 5.1.1 ``natural join``
![5-1.png](https://i.loli.net/2019/10/04/x7uQnE6gqDbYWRc.png)

#### 5.1.2 ``inner join``
![5-2.png](https://i.loli.net/2019/10/04/CGqPhA5epVx12Mc.png)

#### 5.1.3 ``left outer join``
![5-3.png](https://i.loli.net/2019/10/04/LzBW3kTrjI2eYpQ.png)

#### 5.1.4 ``right outer join``
![5-4.png](https://i.loli.net/2019/10/04/N3n1mrH8IRLuPfw.png)

#### 5.1.5 ``full outer join``
![5-5.png](https://i.loli.net/2019/10/04/MubiaomSnXAfZY5.png)

### 5.2 List all instructors along with the number (including 0) of students they advise using a proper join type

![5-6.png](https://i.loli.net/2019/10/04/o1tFwAkRWycq9um.png)

## 6 Update: Double the salary of the instructors who advise more than 2 students (including 2)

![6.png](https://i.loli.net/2019/10/04/3ie6Q7RopKw8GNI.png)

## 7 Delete: Delete the departments whose budget are lower than 50000.00 (including 50000.00)

![7.png](https://i.loli.net/2019/10/04/qrhpQckAe7mEKvR.png)



















