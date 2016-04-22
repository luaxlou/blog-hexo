---
title: React Native IDE Nuclide Tips
date: 2016-04-22 07:38:00
tags:
  - React Native
  - Nuclide
  - Atom

---

Lastest: React Native v0.23.1,Atom v1.7.2,Nuclide v0.131.0

- Github上选择最新的发布版本,不要选择官网的下载链接
(https://github.com/atom/atom/releases)
- 安装Nuclide插件,使用APM安装,cross wall
apm install nuclide --verbose

<!--more-->

- flow 无法启动
``` shell
$ brew upgrade flow
```
根目录下运行flow看看
``` shell
$ flow
.flowconfig:91 Wrong version of Flow. The config specifies version 0.22.0 but this is version 0.22.1
```
修改.flowconfig,矫正版本号
