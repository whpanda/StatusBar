//  这个控件是在StatusBar上面显示提示消息的控件，字数多了可滚动显示全
//  WHPStatusBar.h
//  
//
//  Created by wanghepan on 16/5/16.
//  Copyright © 2016年 wanghepan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WHPStatusBar : UIView


//设置滚动时的动画效果
@property (nonatomic,assign) UIViewAnimationOptions animationOption;

+ (void)showWithStatus:(NSString*)status;
+ (void)showErrorWithStatus:(NSString*)status;
+ (void)showSuccessWithStatus:(NSString*)status;
+ (void)dismiss;

@end
