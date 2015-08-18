//
//  SlidePageView.h
//  test
//
//  Created by chendi on 15/7/4.
//  Copyright © 2015年 ganji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BHSlideViewTitleBar.h"
@protocol BHSlidePageDelegate;
@interface BHSlidePageView : UIView

@property (nonatomic,weak)id<BHSlidePageDelegate> delegate;
@property (nonatomic,assign)NSInteger selectedIndex;
@property (nonatomic,strong)BHTitleBar *titleBar;
@property (nonatomic,readonly,strong)UIView *currentSelectedPage;
@property (nonatomic,readonly,strong)UIView *leftPage,*rightPage;
@property (nonatomic,readonly,assign)BOOL slideEnable;
-(void)setTitleBarDelegate:(id<BHTitleBarDelegate>)titleBarDelegate;
- (instancetype)initWithFrame:(CGRect)frame titleBarHeight:(CGFloat)height slideEnable:(BOOL)slideEnable;
-(void)enumerateAllPage:(void(^)(UIView* view))enu;
@end


@protocol BHSlidePageDelegate <NSObject>
@required
/**
 *  获取page的View
 *
 *  @param index       页数
 *  @param contentView 复用view，未初始化的时候为nil
 *  @param obj         当前位置View上次的状态，未保存为NSNull
 *
 *  @return return value description
 */
-(UIView*)slidePage:(NSInteger)index contentView:(UIView * )contentView  status:(NSObject*)obj;
/**
 *  页数
 *
 *  @return return value description
 */
-(NSInteger)countOfPage;
@optional
/**
 *  页面将要被复用的时候调用
 *
 *  @param view view description
 */
-(void)prepareForReuse:(UIView*)view;
/**
 *  快速滑动时，未加载view时的图
 *
 *  @return return value description
 */
-(UIImage*)placeHolderImage;
/**
 *  page可能要改变的存储状态
 *
 *  @param view  要存储状态的view
 *  @param index index description
 *
 *  @return return value description
 */
-(NSObject*)saveStatus:(UIView*)view index:(NSInteger)index;

-(void)destroyPage:(UIView*)view index:(NSInteger)index;

-(void)pageDidSelected:(UIView*)view index:(NSInteger)index previous:(NSInteger)previousIdx;

/**
-(UIView*)slidePage:(NSInteger)index contentView:(UIView * )contentView status:(NSObject*)obj;
-(NSInteger)countOfPage;
-(void)prepareForReuse:(UIView*)view;
-(UIImage*)placeHolderImage;
-(NSObject*)saveStatus:(UIView*)view index:(NSInteger)index;
 
 */
@end
