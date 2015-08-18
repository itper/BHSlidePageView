//
//  SlideControllerViewController.m
//  test
//
//  Created by chendi on 15/7/3.
//  Copyright (c) 2015年 ganji. All rights reserved.
//

#import "BHSlidePageView.h"
@interface BHSlidePageView ()<UIScrollViewDelegate,BHTitleBarOnClickListener>

@property (nonatomic,retain)UIScrollView *scrollView;
@property (nonatomic,retain)NSMutableArray *contentViewArray;
@property (nonatomic,assign)NSInteger previousIndex;
@property (nonatomic,retain)UIView *singleView;
@property (nonatomic,retain)NSMutableArray *statusArray;
@property (nonatomic,assign)BOOL titleFirstChange;//titilebar触发页面改变
@property (nonatomic,assign)CGFloat lastPosition;

@end

@implementation BHSlidePageView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [self initWithFrame:frame titleBarHeight:30 slideEnable:YES];
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame titleBarHeight:(CGFloat)height slideEnable:(BOOL)slideEnable{
    self = [super initWithFrame:frame];
    if(self){
        self.contentViewArray = [NSMutableArray array];
        _slideEnable = slideEnable;
        _selectedIndex = -1;
        _previousIndex = -1;
        _titleFirstChange = NO;
        [self createView:height];
    }
    return self;
}

-(void)createView:(CGFloat)titleHeight{
    self.backgroundColor = [UIColor whiteColor];
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
    self.scrollView.bounces = YES;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.delegate = self;
    [self addSubview:self.scrollView];
    
    self.titleBar = [[BHTitleBar alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, titleHeight)];
    [self addSubview:self.titleBar];
    [self.titleBar addOnClickListener:self];
}
-(void)enumerateAllPage:(void (^)(UIView *))enu{
    [self.contentViewArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        enu(obj);
    }];
}
-(UIView*)currentSelectedPage{
    if(!_slideEnable)return self.singleView;
    NSInteger pageCount = [self.delegate countOfPage];
    if(pageCount<=3){
        return self.contentViewArray[_selectedIndex];
    }
    return self.contentViewArray[1];
}
-(UIView *)leftPage{
    if(!_slideEnable)return nil;
    NSInteger pageCount = [self.delegate countOfPage];
    if(_selectedIndex-1<0)return nil;
    if(pageCount<=3){
        return self.contentViewArray[_selectedIndex-1];
    }
    return self.contentViewArray[0];
}
-(UIView*)rightPage{
    if(!_slideEnable)return nil;
    NSInteger pageCount = [self.delegate countOfPage];
    if(_selectedIndex+1>=pageCount)return nil;
    if(pageCount<=3){
        return self.contentViewArray[_selectedIndex+1];
    }
    return self.contentViewArray[2];
}
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    CGRect titleBarFrame = self.titleBar.frame;
    titleBarFrame.size.width = self.frame.size.width;
    self.titleBar.frame = titleBarFrame;
    
    self.scrollView.frame = CGRectMake(0,
                                       self.titleBar.frame.size.height+self.titleBar.frame.origin.y,
                                       self.frame.size.width,
                                       self.frame.size.height-self.titleBar.frame.size.height-self.titleBar.frame.origin.y);
    if(self.slideEnable && self.delegate){
        for (UIView *view in self.contentViewArray) {
            CGRect contentViewFrame = view.frame;
            contentViewFrame.size = contentViewFrame.size;
            contentViewFrame.origin.x = ((NSInteger)contentViewFrame.origin.x/frame.size.width)*(frame.size.width-contentViewFrame.size.width);
            view.frame = contentViewFrame;
        }
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width*[self.delegate countOfPage],
                                                 self.scrollView.frame.size.height);
    }else{
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width,
                                                 self.scrollView.frame.size.height);
    }
}
-(void)loadData{
    
    self.scrollView.frame = CGRectMake(0,
                                       self.titleBar.frame.size.height+self.titleBar.frame.origin.y,
                                       self.frame.size.width,
                                       self.frame.size.height-self.titleBar.frame.size.height-self.titleBar.frame.origin.y);
    UIImage *image = [self.delegate respondsToSelector:@selector(placeHolderImage)]?[self.delegate placeHolderImage]:nil;
    self.statusArray = [NSMutableArray array];
    
    if(!_slideEnable){
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        for (NSInteger i = 0; i<[self.delegate countOfPage]; i++) {
            [self.statusArray addObject:[NSNull null]];
        }
        UIView *view = [self.delegate slidePage:0 contentView:nil status:[NSNull null]];
        UIImageView *loadingView = [[UIImageView alloc] initWithFrame:CGRectMake(_scrollView.frame.size.width/2-image.size.width/2, self.scrollView.frame.size.height/2-image.size.height/2, image.size.width, image.size.height)];
        [self addSubview:loadingView];
        view.frame = CGRectMake(0, 0, self.scrollView.frame.size.width, _scrollView.frame.size.height);
        self.singleView = view;
        [self.scrollView insertSubview:view atIndex:0];
        return;
    }
    
    for (int i = 0; i<[self.delegate countOfPage]; i++) {
        [self.statusArray addObject:[NSNull null]];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.scrollView.frame.size.width/2-image.size.width/2+_scrollView.frame.size.width*i, _scrollView.frame.size.height/2-image.size.height/2, image.size.width, image.size.height)];
        imageView.image = image;
        [self.scrollView addSubview:imageView];
    }
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width*[self.delegate countOfPage], self.scrollView.frame.size.height);
    
    CGRect frame = self.scrollView.frame;
    frame.origin.y = 0;
    for (NSInteger i=0; i<3; i++) {
        if([self.delegate countOfPage]-1<i)break;
        UIView *view = [self.delegate slidePage:i contentView:nil status:[NSNull null]];
        frame.origin.x = self.scrollView.frame.size.width * i;
        view.frame = frame;
        [self.scrollView addSubview:view];
        [self.contentViewArray addObject:view];
    }
    NSObject *obj = self.contentViewArray.lastObject;
    [self.contentViewArray removeObject:obj];
    [self.contentViewArray insertObject:obj atIndex:0];
}

-(void)setSelectedIndex:(NSInteger)selectedIndex{
    self.previousIndex = _selectedIndex;
    _selectedIndex = selectedIndex;
    if(!_titleFirstChange){
        self.titleBar.selectedIndex = _selectedIndex;
    }
    if([self.delegate respondsToSelector:@selector(pageDidSelected:index:previous:)]){
        [self.delegate pageDidSelected:self.currentSelectedPage index:selectedIndex previous:_previousIndex];
    }
}
-(void)setDelegate:(id<BHSlidePageDelegate>)delegate{
    _delegate = delegate;
    [self loadData];
    [self setSelectedIndex:0];
}
-(void)setTitleBarDelegate:(id<BHTitleBarDelegate>)titleBarDelegate{
    self.titleBar.delegate = titleBarDelegate;
}
-(void)onClick:(NSInteger)index{
    _titleFirstChange = YES;
    if(!_slideEnable){
        if([self.delegate respondsToSelector:@selector(saveStatus:index:)])
            self.statusArray[_selectedIndex] = [self.delegate saveStatus:_singleView index:_selectedIndex];
        if([self.delegate respondsToSelector:@selector(prepareForReuse:)])
            [self.delegate prepareForReuse:self.singleView];
        [self.delegate slidePage:self.titleBar.selectedIndex contentView:self.singleView status:self.statusArray[self.titleBar.selectedIndex]];
        [self setSelectedIndex:self.titleBar.selectedIndex];
        return;
    }
    [self saveStatus];
    [self.scrollView setContentOffset:CGPointMake(self.titleBar.selectedIndex*self.scrollView.frame.size.width, 0) animated:NO];
    [self scrollViewDidEndDecelerating:self.scrollView];
    self.lastPosition = self.scrollView.contentOffset.x;
    _titleFirstChange = NO;
    
}

-(void)saveStatus{
    if(![self.delegate respondsToSelector:@selector(saveStatus:index:)])return;
    if(_selectedIndex!=0)
        self.statusArray[_selectedIndex-1] = [self.delegate saveStatus:self.contentViewArray[0] index:_selectedIndex-1];
    self.statusArray[_selectedIndex] = [self.delegate saveStatus:self.contentViewArray[1] index:_selectedIndex];
    if(_selectedIndex!=[self.delegate countOfPage]-1)
        self.statusArray[_selectedIndex+1] = [self.delegate saveStatus:self.contentViewArray[2] index:_selectedIndex+1];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if([self.delegate countOfPage]<=3)return;
    NSInteger index = scrollView.contentOffset.x/self.scrollView.frame.size.width;
    self.selectedIndex = index;
    if(self.previousIndex==self.selectedIndex)return;
    
    BOOL toRight =self.selectedIndex>self.previousIndex;
    if(labs(self.previousIndex-self.selectedIndex)==1){
        UIView *v = toRight?self.contentViewArray.firstObject:self.contentViewArray.lastObject;
        [self.contentViewArray removeObject:v];
        [self.contentViewArray insertObject:v atIndex:toRight?2:0];
        
        if(!(toRight && self.selectedIndex==([self.delegate countOfPage]-1)) && !(!toRight && self.selectedIndex==0)){
            if([self.delegate respondsToSelector:@selector(prepareForReuse:)])
                [self.delegate prepareForReuse:v];
            CGRect frame = v.frame;
            frame.origin.y = 0;
            frame.origin.x = (index+(toRight?1:-1))*self.scrollView.frame.size.width;
            v.frame = frame;
            NSInteger loadIndex = (index+(toRight?1:-1));
            [self.delegate slidePage:loadIndex contentView:v status:self.statusArray[loadIndex]];
        }
        
    }else{
        [self.contentViewArray enumerateObjectsUsingBlock:^(id   obj, NSUInteger idx, BOOL *  stop) {
            if((self.selectedIndex+idx)<(2+([self.delegate countOfPage]-1)) && self.selectedIndex+idx > 0){
                CGRect frame = self.scrollView.frame;
                UIView *view = (UIView*)obj;
                frame.origin.y = 0;
                frame.origin.x = (index-1+idx)*_scrollView.frame.size.width;
                view.frame = frame;
                NSUInteger loadIndex = (index-1+idx);
                [self.delegate slidePage:loadIndex contentView:view status:self.statusArray[loadIndex]];
            }
        }];
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(!_titleFirstChange){
        [self.titleBar updateCursorPositionForSlidePage:scrollView.frame.size.width currentPosition:scrollView.contentOffset.x lastPosition:self.lastPosition];
        self.lastPosition = scrollView.contentOffset.x;
    }
}
-(void)removeFromSuperview{
    for (UIView *view in self.contentViewArray) {
        if([self.delegate respondsToSelector:@selector(destroyPage:index:)]){
            [self.delegate destroyPage:view index:[self.contentViewArray indexOfObject:view]];
        }
    }
    [super removeFromSuperview];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if(!scrollView.decelerating)[self saveStatus];
}
@end
