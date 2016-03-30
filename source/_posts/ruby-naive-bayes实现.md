---
title: ruby naive bayes实现
tags:
  - ruby
  - 算法
date: 2014-08-21 11:25:20
---

``` ruby
#encoding = utf-8
require 'nokogiri'
require 'open-uri'
require 'html_to_plain_text'
require 'sugar'
#初始化分词工具
trie = Sugar::Trie.new
#functions
#todo 分词算法有点问题，待优化
def parseHtmlWords(trie, html)
  words = []
  #先按空格分段
  sentences =HtmlToPlainText.plain_text(html).gsub("\t", '').split(' ')
  #进行中文分词
  sentences.each do |s|
    if (s =~ /\p{Han}/)
      trie.DAG(s).each do |a|
        w =''
        a.each do |d|
          w += s[d, 1]
        end
        words.push(w)
      end
    else
      words.push(s) if !s.empty?
    end
  end
  words= words.uniq()
  return words
end
#准备训练样本 www.luaxlou.com
#获得所有3级URL
#遍历所有page
allLinks = []
allContents = []
allClasses = []
1.upto(10) { |i|
  begin
    doc = Nokogiri::HTML(open("http://www.luaxlou.com/page/#{i}/"))
  rescue Exception => e
    break
  end
  doc.css('#content h2 a').each do |link|
    allLinks.push(link)
  end
}
#获得所有内容
allLinks.each { |link|
  doc = Nokogiri::HTML(open(link['href']))
  html = doc.css('#content').first().content.to_s
  words = parseHtmlWords(trie, html)
  classes = []
  #获得人工分类
  doc.css('#menus .current-post-parent a').each do |link|
    classes.push(link.content)
    allClasses.push(link.content)
  end
  content = {
      :classes => classes,
      :title => doc.css('#content .title').first().content,
      :has_code => (doc.css('#content .prettyprint').length>0),
      :words => words
  }
  allContents.push(content)
}
#regin=====================================================
#求在各分类下，各特征属性的条件概率，
#初始化结构
pClass2Prop = {}
allClasses.each do |c|
  pClass2Prop[c] = {:num => 0, :has_code => {:num => 0}, :words => {}}
end
#统计特征出现次数
allClasses.each do |c|
  allContents.each do |ct|
    if (ct[:classes].include? c)
      pClass2Prop[c][:num] +=1
      if (ct[:has_code])
        pClass2Prop[c][:has_code][:num] +=1
      end
      ct[:words].each do |w|
        if (pClass2Prop[c][:words][w].nil?)
          pClass2Prop[c][:words][w]={:num => 1}
        else
          pClass2Prop[c][:words][w][:num] +=1
        end
      end
    end
  end
end
#求条件概率
pClass2Prop.each do |c, cp|
  cp[:has_code][:p] = cp[:has_code][:num].to_f/cp[:num]
  cp[:words].each do |w, wt|
    wt[:p] =wt[:num].to_f/ cp[:num]
  end
end
#regin=====================================
#实现naive bayes,确定新文章的分类
#确定特征与分类概率
pProp2Class = {:has_code => {}, :words => {}}
pClass2Prop.each do |cs, cp|
  pProp2Class[:has_code][cs] = cp[:has_code][:p] if cp[:has_code][:p]>0
  cp[:words].each do |w, wt|
    pProp2Class[:words][w] = {} if pProp2Class[w].nil?
    pProp2Class[:words][w][cs] = wt[:p] if wt[:p]>0
  end
end
#抓取blog的个人简介，看应该会属于什么分类
doc = Nokogiri::HTML(open("http://www.luaxlou.com/%e5%85%b3%e4%ba%8eluax/"))
html = doc.css('#content').first().content.to_s
c_title =doc.css('#content .title').first().content
c_words = parseHtmlWords(trie, html)
c_has_code = doc.css('#content .prettyprint').length>0
ps = {}
#统计所有分类的概率
allClasses.each do |cs|
  if (c_has_code)
    if ps[cs].nil?
      ps[cs] = pProp2Class[:has_code][cs]
    else
      ps[cs] *= pProp2Class[:has_code][cs]
    end
  end
  c_words.each do |w|
    if !pProp2Class[:words][w].nil? &amp;&amp; !pProp2Class[:words][w][cs].nil?
      if ps[cs].nil?
        ps[cs] = pProp2Class[:words][w][cs]
      else
        ps[cs] *= pProp2Class[:words][w][cs]
      end
    end
  end
end
bestClass  =ps.keys.sort_by {|a| ps[a]}.last
p pProp2Class
p ps
p "文章[#{c_title}]最有可能的分类是：#{bestClass}"
```