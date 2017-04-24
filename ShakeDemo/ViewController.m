//
//  ViewController.m
//  ShakeDemo
//
//  Created by 刘超 on 15/7/28.
//  Copyright (c) 2015年 Leo. All rights reserved.
//
//获取设备屏幕尺寸
#define ScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define ScreenHeight ([UIScreen mainScreen].bounds.size.height)//应用尺寸
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#import "ViewController.h"
#import "LZAudioTool.h"
@interface ViewController ()

@property (weak, nonatomic)  UIImageView *imageView;
@property (weak, nonatomic)  UILabel *textLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // 1.背景图
    self.navigationItem.title = @"摇一摇";
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    imageView.image = [UIImage imageNamed:@"YIY_4bg"];
    [self.view addSubview:imageView];
    
    // 2.动画图
    UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 77+64, ScreenWidth, ScreenWidth*605/750.0)];
    headImageView.image = [UIImage imageNamed:@"YIY_2"];
    [self.view addSubview:headImageView];
    self.imageView = headImageView;
    NSMutableArray *arrM = [NSMutableArray array];
    for (int i = 1; i <= 3; i++) {
        NSString *name = [NSString stringWithFormat:@"YIY_%d", i];
        [arrM addObject:[UIImage imageNamed:name]];
    }
    self.imageView.animationImages = arrM;
    self.imageView.animationDuration = 2;
    self.imageView.animationRepeatCount = NSIntegerMax;

    // 3.下面的文字
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-252)/2, 77+64+ScreenWidth*605/750.0, 252, 40)];
    textLabel.text = @"摇一摇可以获得意外惊喜哦~";
    textLabel.textColor = [UIColor whiteColor];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.layer.masksToBounds = YES;
    textLabel.layer.cornerRadius = 20;
    textLabel.backgroundColor = UIColorFromRGB(0xffbd5d);
    [self.view addSubview:textLabel];
    self.textLabel = textLabel;
}

- (BOOL)canBecomeFirstResponder {
    
    return YES;
}

#pragma mark - 摇动

/**
 *  摇动开始
 */
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    
    if (motion == UIEventSubtypeMotionShake) {
        
        NSLog(@"开始摇了");
        [self.imageView startAnimating];
        [LZAudioTool playMusic:@"摇一摇触发铃声.mp3"];
        self.textLabel.text = @"正在为您搜寻中...";
        self.textLabel.frame = CGRectMake((ScreenWidth-200)/2, 77+64+ScreenWidth*605/750.0, 200, 40);
    }
}

/**
 *  摇动结束
 */
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    
    NSLog(@"摇动结束");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.imageView stopAnimating];
        [LZAudioTool playMusic:@"摇一摇结果铃声.mp3"];
        
        
    });
    
}

/**
 *  摇动取消
 */
- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    
    NSLog(@"摇动取消");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.imageView stopAnimating];
        [LZAudioTool playMusic:@"摇一摇结果铃声.mp3"];
    });
}

@end
