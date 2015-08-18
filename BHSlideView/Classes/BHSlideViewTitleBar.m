//
//  TopNavView.m
//  test
//
//  Created by chendi on 15/7/3.
//  Copyright (c) 2015年 ganji. All rights reserved.
//

#import "BHSlideViewTitleBar.h"

#define BH_TITLE_BAR_BASE_TAG 10100
#define BH_TITLE_BAR_PADDING_BOTTOM 1
#define RGB(R, G, B, A) \
[UIColor colorWithRed:R/255.f green:G/255.f blue:B/255.f alpha:A]

@interface ListenerWrap:NSObject
@property (nonatomic,weak)id<BHTitleBarOnClickListener>listener;
-(instancetype)initWithWeakObj:(id<BHTitleBarOnClickListener>)obj;
@end
@implementation ListenerWrap

-(instancetype)initWithWeakObj:(id<BHTitleBarOnClickListener>)obj{
    self = [super init];
    self.listener = obj;
    return self;
}

@end
@interface BHTitleBar ()
@property (nonatomic,retain)UIView *cursorView;
@property (nonatomic,assign)NSInteger previousIndex;
@property (nonatomic,readonly,retain)UIButton *previousButton,*selectedButton;
@property (nonatomic,retain)NSMutableArray *widthArray;
@property (nonatomic,retain)NSMutableArray *positionArray;
@property (nonatomic,retain)NSMutableArray *listeners;
@property (nonatomic,retain)UIScrollView *scrollView;
@end
@implementation BHTitleBar
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _selectedIndex = 0;
        _previousIndex = 0;
        self.widthArray = [NSMutableArray array];
        self.positionArray = [NSMutableArray array];
        self.listeners = [NSMutableArray array];
        [self createView];
    }
    return self;
}
-(void)reload{
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView *view = (UIView *)obj;
        if(view.tag>=BH_TITLE_BAR_BASE_TAG)[view removeFromSuperview];
    }];
    [self loadViews];
    self.selectedIndex = 0;
    
}
-(void)setDelegate:(id<BHTitleBarDelegate>)delegate{
    _delegate = delegate;
    [self reload];
}
//可注册多个侦听
-(void)addOnClickListener:(id<BHTitleBarOnClickListener>)listener{
    if(!listener)return;
    if([self.listeners containsObject:listener])[self.listeners removeObject:listener];
    [self.listeners addObject:[[ListenerWrap alloc] initWithWeakObj:listener]];
}
-(void)setSelectedIndex:(NSInteger)selectedIndex{
    self.previousIndex = self.selectedIndex;
    _selectedIndex = selectedIndex;
    [self setCursorPosition:selectedIndex];
}
//设置当前位置
-(void)setCursorPosition:(NSInteger)index{
    CGFloat _cursorHeight = [self.delegate cursorHeight:self index:index];
    CGRect frame=self.selectedButton.frame;
    CGFloat x = frame.origin.x-(self.scrollView.frame.size.width/2-[self.delegate itemWith:self index:index]/2);
    if(x<0)x = 0;
    if(x>self.scrollView.contentSize.width-self.scrollView.frame.size.width)x = self.scrollView.contentSize.width-self.scrollView.frame.size.width;
    [self performSelector:@selector(scrollTo:) withObject:[NSValue valueWithCGPoint:CGPointMake(x, 0)] afterDelay:0.2];
    BOOL animated = [self.delegate respondsToSelector:@selector(cursorAnimation:)]?[self.delegate cursorAnimation:self]:YES;
    [UIView animateWithDuration:animated?0.2:0 animations:^{
        
        self.cursorView.frame = CGRectMake(frame.origin.x+(frame.size.width/2-[self.delegate cursorWidth:self index:index]/2), self.scrollView.frame.size.height-_cursorHeight, [self.delegate cursorWidth:self index:index], _cursorHeight);
        
        CGFloat scaleTo = 1;
        if(self.selectedButton==self.previousButton)return;
        if([self.delegate respondsToSelector:@selector(scaling)])scaleTo = [self.delegate scaling];
        self.previousButton.transform = CGAffineTransformMakeScale(scaleTo,scaleTo);
        if([self.delegate respondsToSelector:@selector(scalingForSelected)])scaleTo = [self.delegate scalingForSelected];
        self.selectedButton.transform = CGAffineTransformMakeScale(scaleTo,scaleTo);
        
    }];
    self.cursorView.backgroundColor = [self.delegate cursorColor:self index:index];
    [self.previousButton setTitleColor:[self.delegate itemColor:self index:index] forState:UIControlStateNormal];
    [self.selectedButton setTitleColor:[self.delegate selectedItemColor:self index:index] forState:UIControlStateNormal];
    [self.previousButton.titleLabel setFont:[self.delegate itemFont:self]];
    [self.selectedButton.titleLabel setFont:[self.delegate selectedItemFont:self]];
}
-(void)scrollTo:(NSValue*)value{
    [self.scrollView setContentOffset:[value CGPointValue] animated:YES];
}
-(void)createView{
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-BH_TITLE_BAR_PADDING_BOTTOM)];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.backgroundColor = RGB(230, 230, 230, 1);
    [self addSubview:_scrollView];
    self.cursorView = [[UIView alloc] init];
    [self.scrollView addSubview:self.cursorView];
    self.cursorView.hidden = YES;
    
}
-(void)loadViews{
    
    CGFloat totalWidth = 0;
    for(NSInteger i=0;i<[self.delegate itemCount:self]; i++){
        
        CGFloat width = [self.delegate itemWith:self index:i];
        [self.widthArray addObject:@(width)];
        totalWidth+=width;
    }
    if(self.scrollView.frame.size.width>totalWidth){
        NSMutableArray *temp = [NSMutableArray array];
        [self.widthArray enumerateObjectsUsingBlock:^(id   obj, NSUInteger idx, BOOL *  stop) {
            NSNumber *value = (NSNumber*)obj;
            CGFloat dif = value.floatValue+(value.floatValue/totalWidth)*(self.scrollView.frame.size.width-totalWidth);
            [temp addObject:@(dif)];
        }];
        [self.widthArray removeAllObjects];
        [self.widthArray addObjectsFromArray:temp];
    }
    totalWidth = 0;
    for (NSInteger i = 0; i<[self.delegate itemCount:self]; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button.titleLabel setFont:[self.delegate itemFont:self]];
        
        NSString *title = [self.delegate itemText:self index:i];
        CGFloat width = ((NSNumber*)self.widthArray[i]).floatValue;
        
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateHighlighted];
        
        [button setTitleColor:[self.delegate itemColor:self index:i] forState:UIControlStateNormal];
        [button setTitleColor:[self.delegate itemColor:self index:i] forState:UIControlStateHighlighted];
        CGRect rect = CGRectMake(totalWidth, 0, width, self.scrollView.frame.size.height);
        [self.positionArray addObject:@(totalWidth)];
        button.frame = rect;
        button.tag = BH_TITLE_BAR_BASE_TAG+i;
        
        totalWidth+=width;
        [_scrollView addSubview:button];
        [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat scaleTo = 1;
        if([self.delegate respondsToSelector:@selector(scaling)])scaleTo = [self.delegate scaling];
        button.transform = CGAffineTransformMakeScale(scaleTo,scaleTo);
        
        if(![self.delegate respondsToSelector:@selector(viewForSeparator)])continue;
        if(i!=0){
            UIView *separator = [self.delegate viewForSeparator];
            CGFloat paddingBottom = [self.delegate respondsToSelector:@selector(paddingBottomForSeparator)]?[self.delegate paddingBottomForSeparator]:0;
            CGFloat paddingTop = [self.delegate respondsToSelector:@selector(paddingTopForSeparator)]?[self.delegate paddingTopForSeparator]:0;
            rect.size.height = rect.size.height-paddingTop-paddingBottom;
            CGFloat separatorWidth = [self.delegate respondsToSelector:@selector(separatorWidth)]?[self.delegate separatorWidth]:2;
            rect.origin.x = rect.origin.x - separatorWidth/2;
            rect.origin.y = paddingTop;
            rect.size.width = separatorWidth;
            separator.frame = rect;
            [_scrollView addSubview:separator];
        }
    }
    self.cursorView.frame = CGRectMake(0, self.scrollView.frame.size.height-[self.delegate cursorHeight:self index:0], [self.delegate cursorWidth:self index:0], [self.delegate cursorHeight:self index:0]);
    
    self.cursorView.hidden = totalWidth==0;
    _scrollView.contentSize = CGSizeMake(totalWidth, self.scrollView.frame.size.height);
}
-(void)click:(UIButton*)button{
    [self setSelectedIndex:button.tag-BH_TITLE_BAR_BASE_TAG];
    for (NSObject *obj in self.listeners) {
        [((ListenerWrap*)obj).listener onClick:button.tag-BH_TITLE_BAR_BASE_TAG];
    }
}
-(UIButton *)selectedButton{
    return (UIButton*)[self.scrollView viewWithTag:self.selectedIndex+BH_TITLE_BAR_BASE_TAG];
}
-(UIButton *)previousButton{
    return (UIButton*)[self.scrollView viewWithTag:self.previousIndex+BH_TITLE_BAR_BASE_TAG];
}
//为pageView类型视图准备的动画切换效果
-(void)updateCursorPositionForSlidePage:(CGFloat)pageWidth currentPosition:(CGFloat)x lastPosition:(CGFloat)lastPosition{
//    NSDate *date = [NSDate new];
    NSInteger currentPage = x/pageWidth;
    
    if(x<=0 || x>=(pageWidth*([self.delegate itemCount:self]-1)))return;
    CGFloat currentCursorWidth = ([self.delegate cursorWidth:self index:currentPage]);
    CGFloat currentTitleWidth = ((NSNumber*)self.widthArray[currentPage]).floatValue;
    
    CGFloat nextTitleWidth=(currentPage>[self.delegate itemCount:self]-2)?currentTitleWidth:((NSNumber*)self.widthArray[currentPage+1]).floatValue;
    CGFloat nextCursorWidth=(currentPage>[self.delegate itemCount:self]-2)?currentCursorWidth:([self.delegate cursorWidth:self index:currentPage+1]);
    
    CGRect frame = self.cursorView.frame;
    CGFloat xScale = (((currentTitleWidth)+(nextTitleWidth-nextCursorWidth)/2-(currentTitleWidth-currentCursorWidth)/2)/pageWidth);
    CGFloat wScale = ((currentCursorWidth-nextCursorWidth)/pageWidth);
    CGFloat scale = 1-(x-pageWidth*currentPage)/pageWidth;
    
    UIButton *targetButton = (UIButton*)[self.scrollView viewWithTag:currentPage+BH_TITLE_BAR_BASE_TAG+1];
    UIButton *currentButton = (UIButton*)[self.scrollView viewWithTag:currentPage+BH_TITLE_BAR_BASE_TAG];

    if([self.delegate respondsToSelector:@selector(transformColor)] && [self.delegate transformColor]){
        [self changeColor:scale button:currentButton];
        [self changeColor:1-scale button:targetButton];
    }
    
    if([self.delegate respondsToSelector:@selector(transformZoom)] && [self.delegate transformZoom]){
        [self changeSize:scale button:currentButton];
        [self changeSize:(1-scale) button:targetButton];
    }
    frame.origin.x += (x-lastPosition)* xScale;
    frame.size.width += -(x-lastPosition)* wScale;
    
    
    self.cursorView.frame = frame;
//    NSLog(@"%f,%f",([[NSDate new] timeIntervalSince1970] -[date timeIntervalSince1970])*1000.0f,1000.0f/60.0f);
}
-(void)changeColor:(CGFloat)precent button:(UIButton*)button{
    const CGFloat *targetRGBColor = CGColorGetComponents([self.delegate selectedItemColor:self index:_selectedIndex].CGColor);
    const CGFloat *originalRGBColor = CGColorGetComponents([self.delegate itemColor:self index:_selectedIndex].CGColor);
    [button setTitleColor:RGB(
                                     ((targetRGBColor[0]-originalRGBColor[0])*(precent) + originalRGBColor[0])*255.0f,
                                     ((targetRGBColor[1]-originalRGBColor[1])*(precent) + originalRGBColor[1])*255.0f,
                                     ((targetRGBColor[2]-originalRGBColor[2])*(precent)  + originalRGBColor[2])*255.0f, 1)
                        forState:UIControlStateNormal];
    
}
-(void)changeSize:(CGFloat)precent button:(UIButton*)button{
    CGFloat targetScale = [self.delegate scalingForSelected];
    CGFloat origScale = [self.delegate scaling];
    CGFloat dif = (precent)*(targetScale-origScale)+origScale;
    button.transform = CGAffineTransformMakeScale(dif,dif);
}
@end
