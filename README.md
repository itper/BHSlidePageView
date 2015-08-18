# BHSlidePageView
###演示效果
![Alt text](Untitled.gif)
title 有字体和颜色变换
可滑动情况下全局三个 View 实例,不可滑动是一个 View 实例.
在 delegate 中会放回 contentView 如果为空,手动初始化并放回. status可以用来保存每个 view 的状态.
该方法在 SlidePage 将要显示新的页面的时候会被调用.
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