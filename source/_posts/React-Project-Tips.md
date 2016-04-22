---
title: React Project Tips
date: 2016-03-29 15:27:02
tags:
    - node.js
    - webpack
    - babel
    - react
    - es6
---

此文为[Node Resource Search项目](https://github.com/luaxlou/NodeSearch.git)的开发历程

开发思路,这个跟作者的性格有关,作者不喜欢做一些重复的工作,所有能不依赖人工的就不依赖人工.

他会订阅一些开放的优质资源,可能会使用以下的方式:
- RSS订阅
- 内容抓取


<!--more-->


记录开发过程中,所经历的技术选型,以及一些关键点的考虑.

##项目中要解决的问题:
- build管理
- Livereload
- 使用ES6语法
- 移动端使用场景
- 管理内容订阅,标签管理等



## install packages
``` bash
$ npm i webpack -g
$ npm i css-loader style-loader -D
$ npm i browser-sync-webpack-plugin -D
$ npm i react -D
$ npm i babel-core babel-loader -D
$ npm i babel-preset-es2015 babel-preset-react -D

$ npm i mongoose -D
$ npm i commander -D
```

<!--more-->

### lastest:

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

### run with live reload

``` bash
$ webpack -w
```


to be continued
