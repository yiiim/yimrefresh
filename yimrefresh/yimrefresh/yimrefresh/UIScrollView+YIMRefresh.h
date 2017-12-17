//
//  UIScrollView+YIMRefresh.h
//  yimrefresh
//
//  Created by ybz on 2017/12/13.
//  Copyright © 2017年 ybz. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YIMHeaderRefreshView.h"

@interface UIScrollView (YIMRefresh)

@property(nonatomic,strong)YIMHeaderRefreshView *yim_header;

/**
 移除刷新控件
 */
-(void)removeYIMHeaderRefresh;

/**
 添加刷新控件

 @param refreshBlock 执行刷新block
 */
-(void)addYIMHeaderRefresh:(void(^)(void))refreshBlock;

/** 结束刷新 */
-(void)endRefresh;

@end
