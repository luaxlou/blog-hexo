---
title: Sublime Text 3 Develop Tips
date: 2016-03-31 12:07:33
tags:
	- Sublime Text 3
---

- [Install Package ](https://packagecontrol.io/installation)
Preferences > Setting > User
``` json
{
    "ignored_packages":
    [
        "Vintage",
        "Package Control"  //干掉这一行
    ]
}
```
command + Q,重启sublime
- command + shift + p ,RTX热键冲突,关闭
- command + shift + p, Install Package
    + MarkdownEditing
    + JsFormat
- 打开VI模式
Preferences > Setting > User
``` json
{
    "ignored_packages":
    [
        "Vintage" //干掉这一行
    ]
}
```
