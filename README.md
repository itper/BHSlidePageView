# BHSlidePageView
###演示效果
![Alt text](Untitled.gif)
###title 有字体和颜色变换需要更多的效果,自己可以手动添加.

可滑动情况下全局三个 View 实例,不可滑动是一个 View 实例.

在 delegate 中会返回 contentView,也就是每一个 tab 的内容 如果为空,手动初始化并返回.达到 view 的 reuse status可以用来保存每个 view 的状态.

复用方式参考了 Android listView 的 ListViewAdapter 的方式.


#####该方法在 SlidePage 将要显示新的页面的时候会被调用.

#####如果非常快速的切换 tab 将会显示一个默认的  占位符,


```objective-c

-(UIView*)slidePage:(NSInteger)index contentView:(UIView * )contentView status:(NSObject*)obj{
    UITableView *tableView;
    if(contentView==nil){
        tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        tableView.tag = index+1000;
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"aaa"];
        tableView.dataSource = self;
        tableView.delegate = self;
    }else{
        
        tableView = (UITableView*)contentView;
        tableView.tag = index+1000;
        [tableView reloadData];
        [tableView setContentOffset:CGPointFromString([obj description])];
    }
    return tableView;
}

```

通过BHTitleBarDelegate来配置 title 的颜色字体缩放动画等一些属性,其中注意的是一些 optional 方法需要同时实现,配置动画颜色请指定 RGB 值,不要直接使用类似[UIColor yellowColor]这样的.
