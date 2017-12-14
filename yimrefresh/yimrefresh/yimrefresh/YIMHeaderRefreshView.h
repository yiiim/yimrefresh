//
//  YIMHeaderRefreshView.h
//  yimrefresh
//
//  Created by ybz on 2017/12/13.
//  Copyright © 2017年 ybz. All rights reserved.
//

#import "YIMRefreshView.h"

@interface YIMHeaderRefreshView : YIMRefreshView

@property(nonatomic,copy)void(^refreshBlock)(void);

+(instancetype)headerWithBlock:(void(^)(void))block;

@end
