---
title: 从wordpress到jekyll迁移
tags:
  - jekyll
date: 2015-09-03 18:24:00
---

今天祖国大阅兵的好日子，抗日战士胜利70周年。

今天决定将wordpress换成[jekyll](http://jekyllrb.com/)。
为什么呢？

1.  访问够快，jekyll将所有页面生成为静态html，服务器不需要任何动态语言支持。
2.  写博客够快，只需要用markdown的语法编写一篇博客就可以，剩下的jekyll会将你的文章生成为html。

写博客就是为了写博客，不是吗 ^_^。

下面说说过程
过程分为3部分

*   如何安装jekyll
*   如何部署jekyll
*   如何完成wordpress的导入

## 在本地安装 jekyll

本地的jekyll 可以作为博客写作的地方。上传到服务器只需要用github的方式就行，待会介绍。

安装ruby环境（不再赘述，网上有好多ruby安装教程，推荐用RVM安装）

``` bash
$ gem install jekyll
```

## 用jekyll生成博客项目

输入jekyll项目创建指令:

``` bash
$ jekyll new blog
```
这样项目就创建完毕了

```
$ cd blog
```

这是项目的目录结构：
```  
    _config.yml #博客的配置文件，比如博客名等，打开看下便知
    _includes   #博客页面的包含文件，头部，尾部登，这个是用户对自己博客定制化的地方
    _layouts    #顾名思义，就是布局文件，如果要改变布局，可以在这编辑
    _posts     #在这个下面编写博客
    _sass
    _site       #所有的网站静态文件都在这下面，这就是网站的全部，服务器上只需要部署这个目录即可。
                #记得在 gitignore底下忽略这个目录
    about.md    #关于我们页面，自行编辑即可
    css
    favicon.ico #这个是我自己加的，其实在根目录下自己添加的文件，都会被拷贝到_site目录下
    feed.xml
    index.html  #首页，不用说了吧
```

## 在本地启动项目吧，很快就可以开始编写博客之旅了

命令行下输入

```
$ cd blog
$ jekyll s
```

打开浏览器，输入:[http://localhost:4000](http://localhost:4000)
5.打开 _config.yml
增加一行，不然写博客的时候会报错

```
excerpt_separator: ""
```

ok，到此为止，就可以在本地编写博客了~

***

## 将你的博客部署到服务器

关于jekyll的部署，官网有很多推荐的方式

其实个人认为，用Github会比较简单点

而且使用Github的方式有两个好处:

*   不依赖编写设备，可以随时随地编写
*   不需要写草稿，你只需要将写好的博客push 到Github即可

1.  首先，将你的项目加入到github版本库
2.  登陆你需要部署的服务器
     如果不想部到自己的服务器，也可以用 github.io,官网的文档有这种方式的介绍 [jekyll](http://jekyllrb.com/
3.  clone代码
4.  搭建和本地一样的ruby环境
     为什么不直接将_site提交到github？这个读者自己考虑吧
5.  jekyll s 跑起你的项目
6.  设定定时更新 github项目，这样一旦本地提交博客，就可以直接部署到服务器。
     当然你也可以使用钩子，只不过本人觉得有点麻烦。就用这种比较土的方法。
    设定10分钟一次,[crontab周期生成](http://tools.luaxlou.com/crontab)
```
*/10  * * * * cd /www/blog;git pull
```

    到此，你就可以专注于写博客这一件事情上了。

    那么，如果已有 wordpress怎么办呢？

* * *

1.  第一步将你的wordpress博客的数据导入到你的新博客
     官网上有教程 [http://import.jekyllrb.com/docs/wordpress/](http://import.jekyllrb.com/docs/wordpress/)
2.  当导入的时候，你会发现有很多html标签没过滤，图片也毁了。
     作者写了一个修正脚本，可以修复这些问题

``` ruby
#将所有的_posts下的文件读出，然后修复导入，并写回
#通过这段脚本，可以基本上修复大部分问题
#为什么不封装成工具，因为情况太复杂，用户如果有需要，可以随时修改

    Dir.entries("./blog/_posts/").each do
      |d|
      if(d[0]!='.')
        filename = "./blog/_posts/#{d}";
        f =  File.read filename
         f.gsub! '&#47;','/'
        f.gsub! '&nbsp;',' '

         f.gsub!(/<p.?>(.?)<\/p>/m){ |a|
            a.gsub('<p.?>',"\n\n").gsub('</p>','')
          }

        f.gsub!(/<div.?>(.?)<\/div>/m){ |a|
             a.gsub('<div.?>',"\n\n").gsub('</div>','')
           }

        f.gsub!(/<br \/>/,"\n\n")
        f.gsub!(/\n\n\n/m,"\n\n")
        f.gsub!(/<pre class="prettyprint lang-rb">.?<\/pre>/m){ |a|

             a.gsub("\n\n","\n").gsub('<pre class="prettyprint lang-rb">','
<div class="highlight"><pre><code class="language-ruby" data-lang="ruby"><span class="s1">&#39;).gsub(&#39;</span><span class="o">&lt;</span><span class="sr">/pre&gt;&#39;,&#39;</span></code></pre></div>
')
           }

         f.gsub!(/<pre class="prettyprint lang-php">.?<\/pre>/m){ |a|

             a.gsub("\n\n","\n").gsub('<pre class="prettyprint lang-php">','
<div class="highlight"><pre><code class="language-ruby" data-lang="ruby"><span class="s1">&#39;).gsub(&#39;</span><span class="o">&lt;</span><span class="sr">/pre&gt;&#39;,&#39;</span></code></pre></div>
')
         }

        f.gsub!("<\/p>",'')

        File.write filename, f
      end

    end
```

剩下的，就是，愉快地写作吧!!!

* * *

tips：博客迁移原来老博客收录的链接怎么办？
使用服务器的rewrite，访问404时将连接转发到老的博客站点

官方地址:[jekyll](http://jekyllrb.com/)