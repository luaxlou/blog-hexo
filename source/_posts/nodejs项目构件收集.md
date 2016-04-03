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
$ npm install browser-sync-webpack-plugin --save-dev
$ npm install react --save-dev
$ npm install babel-core babel-loader --save-dev
$ npm install babel-preset-react --save-dev
```

<!--more-->


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
    }, {
      test: /\.js$/,
      exclude: /node_modules/,
      loader: "babel",
      query: {
        presets: ['react']
      }
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

``` bash
$ webpack --watch
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
