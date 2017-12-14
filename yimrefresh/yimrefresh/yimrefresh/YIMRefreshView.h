//
//  YIMRefreshView.h
//  yimrefresh
//
//  Created by ybz on 2017/12/13.
//  Copyright © 2017年 ybz. All rights reserved.
//

#import <UIKit/UIKit.h>


/** 刷新控件的状态 */
typedef NS_ENUM(NSInteger, YIMRefreshState) {
    YIMRefreshStateNormal = 1,
    /** 松开就可以进行刷新的状态 */
    YIMRefreshStatePulling,
    /** 正在刷新中的状态 */
    YIMRefreshStateRefreshing
};

@interface YIMRefreshView : UIView

@property(nonatomic,strong)UIColor *tintColor;
@property(nonatomic,weak,readonly)UIScrollView *scrollView;
@property(nonatomic,weak,readonly)UIPanGestureRecognizer *pan;
@property(nonatomic,assign)YIMRefreshState state;


-(void)setup;
-(void)didAddToScrollView;

/** 当scrollView的contentOffset发生改变的时候调用 */
- (void)scrollViewContentOffsetDidChange:(CGPoint)offset;
/** 当scrollView的contentSize发生改变的时候调用 */
- (void)scrollViewContentSizeDidChange:(CGSize)size;
/** 当scrollView的拖拽状态发生改变的时候调用 */
- (void)scrollViewPanStateDidChange:(UIGestureRecognizerState)status;

-(void)endRefresh;



+(UIImage*)newImage:(UIImage*)image tintColor:(UIColor*)color;

@end
