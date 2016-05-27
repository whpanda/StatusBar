
//
//  WHPStatusBar.m
//
//  Created by wanghepan on 16/5/16.
//  Copyright © 2016年 wanghepan. All rights reserved.
//

#import "WHPStatusBar.h"

@interface WHPStatusBar ()

@property (nonatomic, strong, readonly) UIWindow *overlayWindow;
@property (nonatomic, assign) BOOL isshowing;
@property (nonatomic, strong, readonly) UIScrollView *topBar;
@property (nonatomic, strong) UILabel *label4Title;
@property (nonatomic,assign) NSTimer *timer;
//label根据行高设置滚动时间
@property (nonatomic,assign) float timeInterval4Label;
@end

@implementation WHPStatusBar

@synthesize topBar, overlayWindow,label4Title;

+ (WHPStatusBar*)sharedView {
    static dispatch_once_t once;
    static WHPStatusBar *sharedView;
    dispatch_once(&once, ^ { sharedView = [[WHPStatusBar alloc] initWithFrame:[[UIScreen mainScreen] bounds]]; });
    sharedView.layer.borderColor = [UIColor greenColor].CGColor;
    sharedView.layer.borderWidth = 5;

    return sharedView;
}

+ (void)showSuccessWithStatus:(NSString*)status
{
    [WHPStatusBar showWithStatus:status];
    //    [WHPStatusBar performSelector:@selector(dismiss) withObject:self afterDelay:5.0 ];
}

+ (void)showWithStatus:(NSString*)status {
    [[WHPStatusBar sharedView] showWithStatus:status barColor:[UIColor grayColor] textColor:[UIColor colorWithRed:191.0/255.0 green:191.0/255.0 blue:191.0/255.0 alpha:1.0]];
}

+ (void)showErrorWithStatus:(NSString*)status {
    [[WHPStatusBar sharedView] showWithStatus:status barColor:[UIColor colorWithRed:97.0/255.0 green:4.0/255.0 blue:4.0/255.0 alpha:1.0] textColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0]];
    [WHPStatusBar performSelector:@selector(dismiss) withObject:self afterDelay:2.0 ];
}
+ (void)dismiss {
    [[WHPStatusBar sharedView] dismiss];
}
- (id)initWithFrame:(CGRect)frame {
    
    if ((self = [super initWithFrame:frame])) {
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return self;
}

- (void)showWithStatus:(NSString *)status barColor:(UIColor*)barColor textColor:(UIColor*)textColor{
    if (_isshowing) {
        return;
    }
    _isshowing = YES;
    if(!self.superview)
        [self.overlayWindow addSubview:self];
    [self.overlayWindow setHidden:NO];
    [self.topBar setHidden:NO];
    self.topBar.backgroundColor = barColor;
    NSString *labelText = status;
    CGRect labelRect = CGRectZero;
    CGFloat stringWidth = 0;
    CGFloat stringHeight = 0;
    if(labelText) {
        CGSize size = [labelText boundingRectWithSize:CGSizeMake((self.topBar.frame.size.width-20), 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.label4Title.font} context:nil].size;
        stringWidth = size.width;
        stringHeight = size.height;
        _timeInterval4Label = stringHeight/10;
        labelRect = CGRectMake(10, 0, stringWidth, stringHeight);
    }
    self.label4Title.frame = labelRect;
    self.topBar.contentSize = CGSizeMake(self.topBar.frame.size.width, labelRect.size.height+20);
    self.label4Title.alpha = 0.0;
    self.label4Title.hidden = NO;
    self.label4Title.text = labelText;
    self.label4Title.textColor = textColor;
    [UIView animateWithDuration:0.4 animations:^{
        self.label4Title.alpha = 1.0;
    }];
    [UIView animateWithDuration:0.4 animations:^{
        self.label4Title.alpha = 1.0;
    } completion:^(BOOL finished) {
        [self beginScrollWithTimeOfTimer:_timeInterval4Label];
    }];
    [self setNeedsDisplay];
}

- (void) dismiss
{
    _isshowing = NO;
    [self.timer invalidate];
    self.timer = nil;
    
    [label4Title removeFromSuperview];
    label4Title = nil;
    [topBar removeFromSuperview];
    topBar = nil;
    [overlayWindow removeFromSuperview];
    overlayWindow = nil;
    
}

- (UIWindow *)overlayWindow {
    if(!overlayWindow) {
        overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        overlayWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        overlayWindow.backgroundColor = [UIColor clearColor];
        overlayWindow.userInteractionEnabled = NO;
        overlayWindow.windowLevel = UIWindowLevelStatusBar;
    }
    return overlayWindow;
}

- (UIView *)topBar {
    if(!topBar) {
        topBar = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, overlayWindow.frame.size.width, 20.0)];
        topBar.clipsToBounds = YES;
        
        //        [[UIView alloc] initWithFrame:CGRectMake(0, 0, overlayWindow.frame.size.width, 20.0)];
        [overlayWindow addSubview:topBar];
    }
    return topBar;
}

- (UILabel *)label4Title {
    if (label4Title == nil) {
        label4Title = [[UILabel alloc] initWithFrame:CGRectZero];
        label4Title.textColor = [UIColor colorWithRed:191.0/255.0 green:191.0/255.0 blue:191.0/255.0 alpha:1.0];
        label4Title.backgroundColor = [UIColor clearColor];
        //		label4Title.adjustsFontSizeToFitWidth = YES;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 60000
        label4Title.textAlignment = UITextAlignmentCenter;
#else
        label4Title.textAlignment = NSTextAlignmentCenter;
#endif
        label4Title.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        label4Title.font = [UIFont boldSystemFontOfSize:14.0];
        label4Title.shadowColor = [UIColor blackColor];
        label4Title.shadowOffset = CGSizeMake(0, -1);
        label4Title.numberOfLines = 0;
    }
    
    if(!label4Title.superview)
    {
        [self.topBar addSubview:label4Title];
    }
    
    return label4Title;
}
-(void)beginScrollWithTimeOfTimer:(NSUInteger)timeInterval
{
    if (timeInterval < 1) {
        timeInterval = 3.0f;
    }
    NSTimer *timer;
    
    timer = [NSTimer timerWithTimeInterval:timeInterval target:self selector:@selector(animationOfScroll) userInfo:nil repeats:YES];
    
    
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    [timer fire];
    self.timer = timer;
}

-(void)animationOfScroll
{
    CGPoint lb1Origin = self.label4Title.frame.origin;
    CGSize lb1Size = self.label4Title.frame.size;
    
    self.animationOption = UIViewAnimationOptionCurveEaseInOut;
    
    [UIView animateWithDuration:_timeInterval4Label delay:0 options:self.animationOption animations:^{
        [self.label4Title setFrame:CGRectMake(lb1Origin.x, lb1Origin.y-lb1Size.height+16.7, lb1Size.width, lb1Size.height)];
        
    } completion:^(BOOL finished) {
        [WHPStatusBar performSelector:@selector(dismiss) withObject:self afterDelay:0];
        
    }];
}
@end
