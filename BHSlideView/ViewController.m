//
//  ViewController.m
//  BHSlideView
//
//  Created by chendi on 15/8/11.
//  Copyright (c) 2015年 liupeng. All rights reserved.
//

#import "ViewController.h"
#import "BHSlidePageView.h"

@interface ViewController ()<BHSlidePageDelegate,BHTitleBarDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,retain)NSMutableArray *data;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.data = [NSMutableArray array];
    for (NSInteger i = 0; i<10; ) {
        [self.data addObject:[NSString stringWithFormat:@"title%@",@(i)]];
        i++;
    }
    self.title = @"Page";
    BHSlidePageView *pageView = [[BHSlidePageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) titleBarHeight:45 slideEnable:YES];
    [self.view addSubview:pageView];
    [pageView setTitleBarDelegate:self];
    pageView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

-(NSObject*)saveStatus:(UIView*)view index:(NSInteger)index{
    return NSStringFromCGPoint(((UITableView*)view).contentOffset);
}
-(NSInteger)countOfPage{
    return self.data.count;
}
-(UIImage *)placeHolderImage{
    return [UIImage imageNamed:@"logo"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (tableView.tag-1000) {
        case 0:
        return 10;
        case 1:
        return 20;
    }
    return 30;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"aaa"];
    
    cell.detailTextLabel.text=[NSString stringWithFormat:@"tableViewIndex:%@,cellIndex:%@",@(tableView.tag-1000),@(indexPath.row)];
    
    return cell;
}

-(NSInteger)itemCount:(BHTitleBar*)bar{
    return self.data.count;
}
-(CGFloat)itemWith:(BHTitleBar*)bar index:(NSInteger)index{
    return [self.data[index] sizeWithFont:[self itemFont:bar]].width*2.2;
}
-(NSString*)itemText:(BHTitleBar*)bar index:(NSInteger)index{
    return self.data[index];
}
-(UIFont*)itemFont:(BHTitleBar*)bar{
    return [UIFont systemFontOfSize:18];
}
-(UIFont*)selectedItemFont:(BHTitleBar*)bar{
    return [UIFont systemFontOfSize:18];
}

-(UIColor*)cursorColor:(BHTitleBar*)bar index:(NSInteger)index{return [UIColor colorWithRed:85/255.0f green:187/255.0f blue:34/255.0f alpha:1];}
-(UIColor*)itemColor:(BHTitleBar*)bar index:(NSInteger)index{return [UIColor colorWithRed:64/255.0f green:64/255.0f blue:64/255.0f alpha:1];}
-(UIColor*)selectedItemColor:(BHTitleBar*)bar index:(NSInteger)index{return [UIColor colorWithRed:85/255.0f green:187/255.0f blue:34/255.0f alpha:1];}
-(CGFloat)cursorWidth:(BHTitleBar*)bar index:(NSInteger)index{
    return [self itemWith:bar index:index];
}
-(CGFloat)cursorHeight:(BHTitleBar*)bar index:(NSInteger)index{
    [UIColor yellowColor];
    return 3;
}
-(BOOL)cursorAnimation:(BHTitleBar*)bar{
    return YES;
}
-(BOOL)transformColor{
    return YES;
}
-(BOOL)transformZoom{
    return YES;
}
-(CGFloat)scalingForSelected{
    return 1.2;
}
-(CGFloat)scaling{
    return 1;
}
@end
