//
//  TopNavView.h
//  test
//
//  Created by chendi on 15/7/3.
//  Copyright (c) 2015年 ganji. All rights reserved.
//

#import <UIKit/UIKit.h>

// #define NOTIFICATION_IDENTIFIER_TITLEBAR_CLICK @"com.itper.titleBar_click"

@protocol BHTitleBarDelegate ;
@protocol BHTitleBarOnClickListener;
@interface BHTitleBar : UIView
@property (nonatomic,weak)id<BHTitleBarDelegate> delegate;
@property (nonatomic,assign)NSInteger selectedIndex;
/**
 *  reload
 */
-(void)reload;
/**
 *  为导航条添加侦听
 *
 *  @param listener listener description
 */
-(void)addOnClickListener:(id<BHTitleBarOnClickListener>)listener;
/**
 *  为slidepage准备的更新title的方法
 *
 *  @param pageWidth    页宽
 *  @param x            偏移量
 *  @param lastPosition 上次
 */
-(void)updateCursorPositionForSlidePage:(CGFloat)pageWidth currentPosition:(CGFloat)x lastPosition:(CGFloat)lastPosition;
@end
/**
 *  title点击
 */
@protocol BHTitleBarOnClickListener <NSObject>
@required
-(void)onClick:(NSInteger)index;
@end

@protocol BHTitleBarDelegate <NSObject>
@required
/**
 *  总数量
 *
 *  @param bar bar description
 *
 *  @return count
 */
-(NSInteger)itemCount:(BHTitleBar*)bar;
/**
 *  每个title的宽度
 *
 *  @param bar   bar description
 *  @param index 位置
 *
 *  @return return value description
 */
-(CGFloat)itemWith:(BHTitleBar*)bar index:(NSInteger)index;
/**
 *  内容
 *
 *  @param bar   bar description
 *  @param index 位置
 *
 *  @return return value description
 */
-(NSString*)itemText:(BHTitleBar*)bar index:(NSInteger)index;
/**
 *  字体
 *
 *  @param bar bar description
 *
 *  @return return value description
 */
-(UIFont*)itemFont:(BHTitleBar*)bar;
/**
 *  字体
 *
 *  @param bar bar description
 *
 *  @return return value description
 */
-(UIFont*)selectedItemFont:(BHTitleBar*)bar;

/**
 *  选中后的颜色
 *
 *  @param bar   bar description
 *  @param index index description
 *
 *  @return return value description
 */
-(UIColor*)selectedItemColor:(BHTitleBar*)bar index:(NSInteger)index;
/**
 *  title颜色
 *
 *  @param bar   bar description
 *  @param index index description
 *
 *  @return return value description
 */
-(UIColor*)itemColor:(BHTitleBar*)bar index:(NSInteger)index;
/**
 *  下划线游标的宽度
 *
 *  @param bar   bar description
 *  @param index index description
 *
 *  @return return value description
 */
-(CGFloat)cursorWidth:(BHTitleBar*)bar index:(NSInteger)index;
-(CGFloat)cursorHeight:(BHTitleBar*)bar index:(NSInteger)index;
-(UIColor*)cursorColor:(BHTitleBar*)bar index:(NSInteger)index;

@optional
/**
 *  切换title的时候是否显示动画
 *
 *  @param bar bar description
 *
 *  @return return value description
 */
-(BOOL)cursorAnimation:(BHTitleBar*)bar;
-(CGFloat)paddingBottomForSeparator;
-(CGFloat)paddingTopForSeparator;
-(UIView*)viewForSeparator;
-(CGFloat)separatorWidth;
/**
 *  变换颜色
 *
 *  @return return value description
 */
-(BOOL)transformColor;
-(BOOL)transformZoom;
/**
 *  被选中后标题缩放
 *
 *  @return return value description
 */
-(CGFloat)scalingForSelected;
/**
 *  原始缩放比例
 *
 *  @return return value description
 */
-(CGFloat)scaling;


/**copy
 
 -(CGFloat)scaling;
 -(CGFloat)scalingForSelected;
 -(BOOL)transformColor;
 -(BOOL)transformZoom;
 -(BOOL)cursorAnimation:(BHTitleBar*)bar;
 -(CGFloat)paddingBottomForSeparator;
 -(CGFloat)paddingTopForSeparator;
 -(UIView*)viewForSeparator;
 -(CGFloat)separatorWidth;
 
 
 
 -(CGFloat)cursorWidth:(BHTitleBar*)bar index:(NSInteger)index;
 -(CGFloat)cursorHeight:(BHTitleBar*)bar index:(NSInteger)index;
 -(UIColor*)cursorColor:(BHTitleBar*)bar index:(NSInteger)index;
 -(UIColor*)itemColor:(BHTitleBar*)bar index:(NSInteger)index;
 -(UIColor*)selectedItemColor:(BHTitleBar*)bar index:(NSInteger)index;
 -(UIFont*)itemFont:(BHTitleBar*)bar;
 -(NSString*)itemText:(BHTitleBar*)bar index:(NSInteger)index;
 -(CGFloat)itemWith:(BHTitleBar*)bar index:(NSInteger)index;
 -(NSInteger)itemCount:(BHTitleBar*)bar;
**/



























@end