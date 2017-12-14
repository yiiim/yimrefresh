//
//  UIScrollView+YIMRefresh.m
//  yimrefresh
//
//  Created by ybz on 2017/12/13.
//  Copyright © 2017年 ybz. All rights reserved.
//

#import "UIScrollView+YIMRefresh.h"
#import "YIMHeaderRefreshView.h"
#import <objc/runtime.h>

@implementation UIScrollView (YIMRefresh)

static const char *YIMRefreshHeaderKey = "YIMRefreshHeaderKey";

-(void)setYim_header:(YIMHeaderRefreshView *)yim_header{
    YIMHeaderRefreshView *o_header = self.yim_header;
    if(yim_header == o_header)return;
    if(!yim_header && o_header)[o_header removeFromSuperview];
    if(yim_header)[self addSubview:yim_header];
    objc_setAssociatedObject(self, &YIMRefreshHeaderKey, yim_header, OBJC_ASSOCIATION_ASSIGN);
}
-(YIMHeaderRefreshView*)yim_header{
    YIMHeaderRefreshView *header = objc_getAssociatedObject(self, &YIMRefreshHeaderKey);
    return header;
}
-(void)addYIMHeaderRefresh:(void (^)(void))refreshBlock{
    self.yim_header = [YIMHeaderRefreshView headerWithBlock:refreshBlock];
}
-(void)removeYIMHeaderRefresh{
    self.yim_header = nil;
}
-(void)endRefresh{
    YIMHeaderRefreshView *header = self.yim_header;
    if(header)
        [header endRefresh];
}


@end
