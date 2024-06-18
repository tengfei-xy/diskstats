# 硬盘状态统计脚本

[english](./README_EN.MD)

## 说明

由于/proc/diskstats的输出太乱了，有时想快速收集或展示部分信息，直接执行查看结果比较累，也不利于监控具体值，因此通过脚本来执行

特色：无需安装包，开箱即输出

## 安装

```bash
wget -N -P /usr/bin/ds https://raw.githubusercontent.com/tengfei-xy/diskstats/main/diskstats.sh  && sudo chmod +x /usr/bin/ds
```

## 使用方法

输出中文

```bash
$ ds -z

设备名: dm-2
读完成次数: 84
合并读次数: 0
读扇区数: 10411
读花费时间(ms): 218
写完成次数: 58
合并写次数: 0
写扇区数: 4374
写花费时间(ms): 71
I/Os当前进行次数: 0
花费时间进行I/Os(ms): 201
加权花费时间进行I/Os(ms): 289
平均读扇区(ms): 0.02093
平均写扇区(ms): 0.01623
...
```

输出英文

```bash
$ ds -e

device name: dm-2
reads completed successfully: 84
reads merged: 0
sectors read: 10411
time spent reading(ms): 218
writes completed: 58
writes merged: 0
sectors written: 4374
time spent writing(ms): 71
I/Os currently in progress: 0
time spent doing I/Os(ms): 201
weighted time spent doing I/Os(ms): 289
average read sector(ms): 0.02093
average write sector(ms): 0.01623
```

输出具体设备

```bash
$ ds -d sda3

major number: 8
minor number: 3
device name: sda3
reads completed successfully: 3661640
reads merged: 41
sectors read: 467886931
time spent reading(ms): 903851
writes completed: 47884
writes merged: 3822
sectors written: 1154142
time spent writing(ms): 753079
I/Os currently in progress: 0
time spent doing I/Os(ms): 1027815
weighted time spent doing I/Os(ms): 1635018
average read sector(ms): 0.00193
average write sector(ms): 0.65250
```

仅输出具体设备的数值

```bash
$ ds -d  sda3 -v

8
3
sda3
3661640
41
467886931
903851
47898
3822
1154361
753129
0
1027831
1635066
0.00193
0.65242
```

仅仅输出time spent reading(ms)

```
$ ds -d sda3 --tsr

time spent reading(ms): 903851
```

仅仅输出time spent writing(ms)的值

```
$ ds -d sda3 --tsw -v

753513
```

仅仅输出I/Os currently in progress

```bash
$ ds -d sda3  --ioc

I/Os currently in progress: 0
```

仅仅输出I/Os currently in progress

```bash
$ ds -d sda3  --iot

time spent doing I/Os(ms): 1028099
```

输出weighted time spent doing I/Os

```basbashh
$ ds -d sda3  --iowt

weighted time spent doing I/Os(ms): 1635607
```

输出平均读取扇区时间

```bash
$ ds -d sda3  --ars

average read sector(ms): 0.00193
```

输出平均写入扇区时间的值

```bash
$ ds -d sda3  --aws

0.65106
```

