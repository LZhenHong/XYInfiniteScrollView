# XYInfiniteScrollView
#### 用 scrollView 实现的无限滚动
---

类
---

* XYInfiniteScrollItem
* XYInfiniteScrollViewButton
* XYInfiniteScrollView

---

用法
---	
    
    XYInfiniteScrollView *isv = [[XYInfiniteScrollView alloc] init];
    // items : XYInfiniteScrollItem 数组
  	isv.items = self.items;
  	isv.center = self.view.center;
  	isv.bounds = CGRectMake(0, 0, 300, 168);
  	[self.view addSubview:isv];

    
---- 
功能 
---
1> 实现无限滚动

2> 支持点击

3> 可以控制图片上文字的位置

4> 支持水平与垂直方向的滚动

5> 支持对 pageControl 进行操作

----

TODO
---

~~1> 支持垂直方向上的滚动~~

~~2> 添加 pageControl 的控制~~

3> 添加自动滚动

4> 图片上的文字支持更多的位置

5> 添加对网络图片的支持

----
#### 希望能给您带来帮助！
    
    
 
