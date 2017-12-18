//
//  YIMRefreshView.m
//  yimrefresh
//
//  Created by ybz on 2017/12/13.
//  Copyright © 2017年 ybz. All rights reserved.
//

#import "YIMRefreshView.h"

#define YIMRefreshControlHeight 100

@interface YIMRefreshView()
@property(nonatomic,strong,readwrite)UIPanGestureRecognizer *pan;
@end

@implementation YIMRefreshView

-(instancetype)init{
    return [self initWithFrame:CGRectZero];
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}


-(void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    [self removeObservers];
    if (newSuperview && [newSuperview isKindOfClass:[UIScrollView class]]) {
        self.frame = CGRectMake(0, -YIMRefreshControlHeight, CGRectGetWidth(newSuperview.frame), YIMRefreshControlHeight);
        _scrollView = (UIScrollView*)newSuperview;
        _scrollView.alwaysBounceVertical = true;
        self.pan = _scrollView.panGestureRecognizer;
        [self addObservers];
        [self didAddToScrollView];
    }
}


-(void)addObservers{
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [_scrollView addObserver:self forKeyPath:@"contentOffset" options:options context:NULL];
    [_scrollView addObserver:self forKeyPath:@"contentSize" options:options context:NULL];
    [self.pan addObserver:self forKeyPath:@"state" options:options context:NULL];
}
- (void)removeObservers{
    [self.superview removeObserver:self forKeyPath:@"contentOffset"];
    [self.superview removeObserver:self forKeyPath:@"contentSize"];
    [self.pan removeObserver:self forKeyPath:@"state"];
    self.pan = nil;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (!self.userInteractionEnabled) return;
    if ([keyPath isEqualToString:@"contentSize"]) {
        [self scrollViewContentSizeDidChange:[change[NSKeyValueChangeNewKey]CGSizeValue]];
    }
    if (self.hidden) return;
    if ([keyPath isEqualToString:@"contentOffset"]) {
        [self scrollViewContentOffsetDidChange:[change[NSKeyValueChangeNewKey]CGPointValue]];
    } else if ([keyPath isEqualToString:@"state"]) {
        [self scrollViewPanStateDidChange:[change[NSKeyValueChangeNewKey]integerValue]];
    }
}

-(void)setup{
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
}
-(void)didAddToScrollView{
    
}
-(void)scrollViewContentOffsetDidChange:(CGPoint)offset{}
-(void)scrollViewContentSizeDidChange:(CGSize)size{}
-(void)scrollViewPanStateDidChange:(UIGestureRecognizerState)status{}
-(void)endRefresh{}




+(UIImage*)newImage:(UIImage *)image tintColor:(UIColor *)color{
    if (!color) {
        return image;
    }
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextClipToMask(context, rect, image.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
-(void)dealloc{
    [self removeObservers];
}

@end
