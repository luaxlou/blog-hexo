---
title: Nodejs项目构件收集
date: 2016-03-29 15:27:02
tags:
    - nodejs webpack babel react es6
---

## 构建系统
``` bash
$ npm i webpack -g
$ npm i css-loader style-loader -D
$ npm i browser-sync-webpack-plugin -D
$ npm i react -D
$ npm i babel-core babel-loader -D
$ npm i babel-preset-es2015 babel-preset-react -D
```

<!--more-->

lastest:

``` json
{
    "babel-core": "^6.7.4",
    "babel-loader": "^6.2.4",
    "babel-preset-es2015": "^6.6.0",
    "babel-preset-react": "^6.5.0",
    "browser-sync": "^2.11.2",
    "browser-sync-webpack-plugin": "^1.0.1",
    "react": "^0.14.8",
    "react-dom": "^0.14.8"
  }
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
    }, {
      test: /\.js$/,
      exclude: /node_modules/,
      loader: "babel",
      query: {
        presets: ['es2015', 'react']
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
$ npm i mocha -g 
```
## 数据库
``` bash
$ npm i mongoose
```
## 生产环境
### 进程管理器

``` bash
$ npm i -g pm2
```
