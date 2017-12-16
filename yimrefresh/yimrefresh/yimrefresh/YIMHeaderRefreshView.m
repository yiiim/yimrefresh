//
//  YIMHeaderRefreshView.m
//  yimrefresh
//
//  Created by ybz on 2017/12/13.
//  Copyright © 2017年 ybz. All rights reserved.
//

#import "YIMHeaderRefreshView.h"

#define YIMHeaderBackWidth 46
#define YIMHeaderImageWidth 30

@interface YIMHeaderRefreshView(){
    CGFloat _startOffY;
}
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UIView *contentView;
@end

@implementation YIMHeaderRefreshView

+(instancetype)headerWithBlock:(void (^)(void))block{
    YIMHeaderRefreshView *header = [[YIMHeaderRefreshView alloc]init];
    header.refreshBlock = block;
    return header;
}


#pragma -mark 重写父类方法
-(void)layoutSubviews{
    [super layoutSubviews];
    CGRect frame = self.contentView.frame;
    //减掉5是因为阴影漏出来了
    frame.origin = CGPointMake(CGRectGetMidX(self.bounds) - CGRectGetWidth(frame)/2, CGRectGetHeight(self.bounds) - CGRectGetHeight(frame) - 5);
    self.contentView.frame = frame;
}
/**scroll contentOffset变更时*/
-(void)scrollViewContentOffsetDidChange:(CGPoint)offset{
    if (offset.y<0) {
        self.scrollView.contentOffset = CGPointMake(offset.x, 0);
    }
}
-(void)setTintColor:(UIColor *)tintColor{
    [super setTintColor:tintColor];
    self.imageView.image = [[self class]newImage:self.imageView.image tintColor:self.tintColor];
}
/**初始化*/
-(void)setup{
    [super setup];
    
    UIView *backView = [[UIView alloc]init];
    backView.layer.cornerRadius = YIMHeaderBackWidth/2.0;
    backView.backgroundColor = [UIColor whiteColor];
    backView.frame = CGRectMake(0, 0, YIMHeaderBackWidth, YIMHeaderBackWidth);
    backView.layer.shadowOpacity = 0.5;
    backView.layer.shadowColor = [UIColor grayColor].CGColor;
    backView.layer.shadowRadius = 3;
    backView.layer.shadowOffset  = CGSizeMake(1, 1);
    [self addSubview:backView];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[[self class]newImage:[UIImage imageNamed:@"yimrefresh.bundle/refresh.png"]tintColor:self.tintColor]];
    imageView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    imageView.frame = CGRectMake((YIMHeaderBackWidth-YIMHeaderImageWidth)/2.0, (YIMHeaderBackWidth-YIMHeaderImageWidth)/2.0, YIMHeaderImageWidth, YIMHeaderImageWidth);
    [backView addSubview:imageView];
    
    
    self.imageView = imageView;
    self.contentView = backView;
}
-(void)didAddToScrollView{
    [super didAddToScrollView];
    [self.pan addTarget:self action:@selector(pan:)];
}
/**结束刷新*/
-(void)endRefresh{
    CGRect frame = self.frame;
    frame.origin.y = -CGRectGetHeight(self.bounds);
    [self.imageView.layer removeAllAnimations];
    [UIView animateWithDuration:.3f animations:^{
        self.frame = frame;
        self.contentView.alpha = 0.1;
        self.imageView.transform = CGAffineTransformIdentity;
    }completion:^(BOOL finished) {
        self.state = YIMRefreshStateNormal;
        self.contentView.alpha = 1;
        self.imageView.image = [[self class]newImage:[UIImage imageNamed:@"yimrefresh.bundle/refresh.png"] tintColor:self.tintColor];
    }];
}


#pragma -mark 私有方法
/**scrollView拖拽手势*/
-(void)pan:(UIPanGestureRecognizer*)p{
    if(self.state == YIMRefreshStateRefreshing)
        return;
    if (self.hidden)
        return;
    CGPoint point = [p translationInView:self.scrollView];
    if (p.state == UIGestureRecognizerStateBegan) {
        if (self.scrollView.contentOffset.y > 0){
            _startOffY = self.scrollView.contentOffset.y;
        }else{
            _startOffY = 0;
        }
    }
    point.y = point.y - _startOffY;
    [self.superview bringSubviewToFront:self];
    //拖拽到刷新的Y坐标
    CGFloat pullingOffsetY = 150;
    
    
    CGFloat distance = point.y;
    CGFloat b = 80;
    CGFloat sl = 1;
    CGFloat yPoint = 0;
    while (distance > 0) {
        if (distance > b) {
            distance -= b;
            yPoint += b*sl;
        }else{
            yPoint += distance*sl;
            break;
        }
        sl = sl*0.85;
    }
    //更新self的frame
    CGRect frame = self.frame;
    frame.origin.y = yPoint - CGRectGetHeight(self.frame);
    self.frame = frame;
    
    //如果正在拖拽
    if (p.state == UIGestureRecognizerStateChanged) {
        //到达刚好要拖拽的Y坐标，将状态置为松开即刷新，否则状态置为普通
        if (point.y >= pullingOffsetY) {
            self.state = YIMRefreshStatePulling;
            self.imageView.transform = CGAffineTransformIdentity;
        }else{
            self.state = YIMRefreshStateNormal;
            //旋转
            CGFloat per = MIN(1,point.y/pullingOffsetY);
            CGFloat angle = per * 360;
            CGAffineTransform rotation = CGAffineTransformMakeRotation(M_PI/180.0f*(NSInteger)angle);
            CGAffineTransform scale = CGAffineTransformScale(rotation, per, per);
            self.imageView.alpha = per;
            self.imageView.transform = scale;
        }
    }
    if (p.state == UIGestureRecognizerStateEnded) {
        if (self.state == YIMRefreshStatePulling) {
            self.state = YIMRefreshStateRefreshing;
            
            frame.origin.y = 0;
            [UIView animateWithDuration:.3f animations:^{
                self.frame = frame;
                self.imageView.transform = CGAffineTransformIdentity;
            }completion:^(BOOL finished) {
                self.imageView.image = [[self class]newImage:[UIImage imageNamed:@"yimrefresh.bundle/refresh1.png"]tintColor:self.tintColor];
                CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
                animation.repeatCount = HUGE_VALF;
                animation.toValue = [NSNumber numberWithFloat:M_PI * 2];
                animation.duration = 1.0f;
                [self.imageView.layer addAnimation:animation forKey:@"transform_animation"];
                NSLog(@"refresh");
                if (self.refreshBlock) {
                    self.refreshBlock();
                }
            }];
            
        }
        if (self.state == YIMRefreshStateNormal) {
            frame.origin.y = -CGRectGetHeight(self.bounds);
            [UIView animateWithDuration:.3f animations:^{
                self.frame = frame;
                self.imageView.transform = CGAffineTransformIdentity;
            }];
        }
    }
}




@end
