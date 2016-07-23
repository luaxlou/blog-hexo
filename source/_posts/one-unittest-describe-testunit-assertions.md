---
title: 一个单元测试描述Test::Unit::Assertions语法
date: 2016-07-23 00:19:47
tags:
    - ruby
    - tdd
    - testunit
---

``` ruby
p 'Hello Hexo!!!!!!!!!'
```


最进使用Ruby测试框架,选择使用 Test::Unit作为测试方法,下面的代码整理了常用的断言语法(其他的可能基本不太可能用上).当然对应的断言语法大多数都有not的反义判断.比如assert_true 和assert_not_true.

整体来说,感觉不太够用,毕竟这个库比较老.接下去可能会研究下minitest的源码.最后不行的话,可能会自己动手写测试框架.rspec还是算了


``` ruby
require 'test/unit'
class TestUnitAssertionsTest < Test::Unit::TestCase

  def setup

  end

  def test_assertions

    assert_block "block返回值不正确" do
      true
    end
    assert_equal('Yes', 'Yes')
    assert 1, '对象不能为false和nil'
    assert_true true
    assert_raise '需要抛出一个异常' do
      raise Exception
    end
    assert_nothing_raised '不能抛出异常' do
      # raise Exception
    end
    assert_raise_message "exception" do
      raise "exception"
    end

    assert_instance_of String, '', '预期的类型和实际类型不符'
    assert_nil nil
    assert_respond_to 'a string', :reverse, '对象预期的方法不存在'
    assert_match(/\d+/, 'five, 6, seven')
    o = Object.new
    assert_same o, o
    assert_empty("")
    assert_empty([])
    assert_empty({})
    assert_path_exist("/tmp")

    flunk '强制断言失败.看到这条失败断言,表示上面所有的断言通过.'
  end


  def teardown

  end

end

```


``` bash
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