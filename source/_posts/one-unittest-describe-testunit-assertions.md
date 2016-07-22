---
title: 一个单元测试描述Test::Unit::Assertions语法
date: 2016-07-23 00:19:47
tags:
    - ruby
    - tdd
    - testunit
---


最进使用Ruby测试框架,选择使用 Test::Unit作为测试方法,下面的代码整理了常用的断言语法(其他的可能基本不太可能用上).当然对应的断言语法大多数都有not的反义判断.比如assert_true 和assert_not_true.

整体来说,感觉不太够用,毕竟这个库比较老.接下去可能会研究下minitest的源码.最后不行的话,可能会自己动手写测试框架.rspec还是算了

{% gist 0becbc05912d7bb5275d703d68e5fff2 test_unit_assertions_test.rb %}


```bash
$ ruby assertions_test.rb -v --use-color=true 
...
Started
F
===============================================================================
Failure: 强制断言失败.看到这条失败断言,表示上面所有的断言通过.
test_assertions(AssertionsTest)
assertions_test.rb:41:in test_assertions
     38:     assert_empty({})
     39:     assert_path_exist("/tmp")
     40: 
  => 41:     flunk '强制断言失败.看到这条失败断言,表示上面所有的断言通过.'
     42:   end
     43: 
     44: 
===============================================================================


Finished in 0.001588 seconds.

1 tests, 17 assertions, 1 failures, 0 errors, 0 pendings, 0 omissions, 0 notifications
0% passed

629.72 tests/s, 10705.29 assertions/s

Process finished with exit code 1
```