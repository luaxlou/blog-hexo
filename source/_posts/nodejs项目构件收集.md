---
title: Nodejs项目构件收集
date: 2016-03-29 15:27:02
tags:
    - nodejs
---

## 构建系统
``` shell
$ npm install webpack -g
$ npm install css-loader style-loader 
$ npm install --save-dev browser-sync-webpack-plugin
```
### webpack.config.js:
``` js
var BrowserSyncPlugin = require('browser-sync-webpack-plugin');

module.exports = {
  entry: './app/entry.js',
  output: {
    path: __dirname,
    filename: "./public/bundle.js"
  },
  module: {
    loaders: [{
      test: /\.css$/,
      loader: "style!css"
    }]
  },
  plugins: [
    new BrowserSyncPlugin({
      host: 'localhost',
      port: 3000,
      server: {
        baseDir: ['./public']
      }
    })
  ]
};
```

<!--more-->

## 开发框架
``` bash
$ npm install koa
$ npm install angular
```
## 测试库
``` bash
$ npm install mocha -g 
```
## 数据库
``` bash
$ npm install mongoose
```
## 生产环境
### 进程管理器

``` bash
$ npm install -g pm2
```
