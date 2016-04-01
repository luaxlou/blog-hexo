---
title: React Native Develop Tips
date: 2016-03-31 11:24:37
tags:
	- React Natvie
---

Lastest: React Native v0.22,Xcode 7.2.1



## IOS

### 环境配置

- ctrl + commond +z 和QQ冲突,关闭
- ctrl + commond +z 开启 Live Reload
- 更改NPM源
```
$ npm config set registry https://registry.npm.taobao.org
$ npm config set disturl https://npm.taobao.org/dist
```
* 快捷方式
	$ vi .bashrc
	alias rn="react-native"
###


### 发布

- 离线模式打包
```
$ rn bundle --platform=ios --entry-file=index.ios.js --bundle-output ios/main.jsbundle
```
- 模拟器下无法使用bundle打包运行
## Android
等待


## 资料
- [React Native 中文文档](http://reactnative.cn/)