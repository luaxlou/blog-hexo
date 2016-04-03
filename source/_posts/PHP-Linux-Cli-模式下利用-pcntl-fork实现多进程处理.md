---
title: PHP Linux Cli 模式下利用 pcntl_fork实现多进程处理
tags:
  - 多进程
  - pcntl_fork
  - php
date: 2013-12-08 11:09:23
---

以下这段例程用来解决PHP单进程执行大批量任务时间长的问题。
经测试可用。
<!--more-->

``` php
<?php
/**
 * PHP Linux Cli 模式下利用 pcntl_fork实现多进程处理
 *
 * @author Luax <luaxcn@gmail.com>
 */
//进程数
$processes = 5;
//所有任务就是是为了输出0到9999中的所有数字
//这些数字将被分成5个块，代表5个进程，
//当输出的时候我们就可以看到所有进程的执行顺序
$tasks= range(0,9999);
$blocks = array();
//将任务按进程分块
foreach ($tasks as $i) {
    $blocks[($i % $processes)][] = $i;
}
foreach ($blocks as $blockNum => $block) {
    //通过pcntl得到一个子进程的PID
    $pid= pcntl_fork();
    if ($pid == -1) {
        //错误处理：创建子进程失败时返回-1.
        die('could not fork');
    } else if ($pid) {
        //父进程逻辑
        //等待子进程中断，防止子进程成为僵尸进程。
        //WNOHANG为非阻塞进程，具体请查阅pcntl_wait PHP官方文档
        pcntl_wait($status, WNOHANG); 
    } else {
        //子进程逻辑
        foreach ($block as $i) {
            echo "I'm block {$blockNum},I'm  printing:{$i}\n";
            sleep(1);
        }
        //为避免僵尸进程，当子进程结束后，手动杀死进程
        if (function_exists("posix_kill")) {
            posix_kill(getmypid(), SIGTERM);
        } else {
            system('kill -9' . getmypid());
        }
        exit;
    }
}
```


## 执行结果 
```
$ php multi.php &gt;&gt; multi.log
$ vi multi.log

I’m block 0,I’m  printing:0

I’m block 4,I’m  printing:4

I’m block 3,I’m  printing:3

I’m block 1,I’m  printing:1

I’m block 2,I’m  printing:2

I’m block 0,I’m  printing:5

I’m block 4,I’m  printing:9

I’m block 3,I’m  printing:8

I’m block 1,I’m  printing:6

I’m block 2,I’m  printing:7

I’m block 0,I’m  printing:10

I’m block 4,I’m  printing:14

I’m block 3,I’m  printing:13

I’m block 1,I’m  printing:11

I’m block 2,I’m  printing:12

I’m block 0,I’m  printing:15

I’m block 4,I’m  printing:19

I’m block 3,I’m  printing:18

I’m block 1,I’m  printing:16

I’m block 2,I’m  printing:17

I’m block 0,I’m  printing:20

I’m block 4,I’m  printing:24

I’m block 3,I’m  printing:23

I’m block 1,I’m  printing:21

...
```

## 查看进程
```
$ ps aux |grep php 


root      2806  0.3  0.7 217520  7384 pts/1    S    19:03   0:00 php multi.php

root      2807  0.2  0.7 217520  7380 pts/1    S    19:03   0:00 php multi.php

root      2808  0.1  0.7 217520  7380 pts/1    S    19:03   0:00 php multi.php

root      2809  0.1  0.7 217520  7380 pts/1    S    19:03   0:00 php multi.php

root      2810  0.1  0.7 217520  7380 pts/1    R    19:03   0:00 php multi.php

root      2826  3.0  0.0 103180   848 pts/0    S+   19:05   0:00 grep php
```
出现了5个php进程
    