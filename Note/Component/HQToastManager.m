//
//  HQToastManager.m
//  NipponColors
//
//  Created by 陆久银 on 2018/8/13.
//  Copyright © 2018年 lujiuyin. All rights reserved.
//

#import "HQToastManager.h"
#import <UIKit/UIKit.h>

@interface HQToastManager()
@property (atomic, strong) NSMutableArray<NSString *> *queue;

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) NSString *currentTitle;

@end

@implementation HQToastManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static HQToastManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[HQToastManager alloc] init];
    });
    return manager;
}

- (void)showToast:(NSString *)title {
    [self.queue addObject:title];
    [self performSelectorOnMainThread:@selector(showNext) withObject:nil waitUntilDone:YES];
}

#pragma mark - Private
- (instancetype)init {
    self = [super init];
    if (self) {
        self.queue = [NSMutableArray array];
        [self performSelectorOnMainThread:@selector(setup) withObject:nil waitUntilDone:YES];
    }
    return self;
}

- (void)setup {
    self.label = [[UILabel alloc] init];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.backgroundColor = [UIColor blackColor];
    self.label.textColor = [UIColor whiteColor];
    self.label.font = [UIFont systemFontOfSize:14.0];
    self.label.layer.cornerRadius = 15;
    self.label.layer.masksToBounds = YES;
}

- (void)showNext {
    if (self.currentTitle || self.queue.count == 0) {
        return;
    }
    self.currentTitle = self.queue.firstObject;
    [self.queue removeObjectAtIndex:0];
    
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.label.text = self.currentTitle;

    
    CGSize size = [self.currentTitle boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 50) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]} context:nil].size;
    
    CGFloat label_height = 30;
    CGFloat label_width = size.width + label_height;

    CGFloat label_x = ([UIScreen mainScreen].bounds.size.width-label_width)/2;
    CGFloat label_originY = 40;
    CGFloat label_destY = 84;


    self.label.frame = CGRectMake(label_x, label_originY, label_width, label_height);
    self.label.alpha = 0;
    [window addSubview:self.label];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.label.frame = CGRectMake(label_x, label_destY, label_width, label_height);
        self.label.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 delay:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.label.frame = CGRectMake(label_x, label_originY, label_width, label_height);
            self.label.alpha = 0;
        } completion:^(BOOL finished) {
            [self.label removeFromSuperview];
            self.currentTitle = nil;

            [self showNext];
        }];
    }];
}
@end
