---
title: React Native Develop Tips
date: 2016-03-31 11:24:37
tags:
	- React Native
---

Lastest: React Native v0.22,Xcode 7.2.1

## 资料
- [React Native 中文文档](http://reactnative.cn/)
- [React Native学习指南](https://github.com/ele828/react-native-guide)
- [React/React Native 的ES5 ES6写法对照表](http://bbs.reactnative.cn/topic/15/react-react-native-%E7%9A%84es5-es6%E5%86%99%E6%B3%95%E5%AF%B9%E7%85%A7%E8%A1%A8)
- [构建 Facebook F8 2016 App / React Native 开发指南](http://f8-app.liaohuqiu.net/)
- [Redux 英文文档](http://redux.js.org/)
- [Redux 中文文档](http://camsong.github.io/redux-in-chinese/)


<!--more-->

## IDE
### Atom+Nuclide 环境安装
- Github上选择最新的发布版本,不要选择官网的下载链接
(https://github.com/atom/atom/releases)
- 安装Nuclide插件,使用APM安装,cross wall
apm install nuclide --verbose
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

### 发布

- 离线模式打包
```
$ rn bundle --platform=ios --entry-file=index.ios.js --bundle-output ios/main.jsbundle
```
- 模拟器下无法使用bundle打包运行
## Android
等待
