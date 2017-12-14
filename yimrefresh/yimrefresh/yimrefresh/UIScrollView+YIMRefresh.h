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
-(void)removeYIMHeaderRefresh;
-(void)addYIMHeaderRefresh:(void(^)(void))refreshBlock;
-(void)endRefresh;

@end
