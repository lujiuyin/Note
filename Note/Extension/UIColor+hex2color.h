//
//  UIColor+hex2color.h
//  NipponColors
//
//  Created by 陆久银 on 2018/8/10.
//  Copyright © 2018年 lujiuyin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (hex2color)

+ (UIColor *)colorWithHex:(NSString *)hex;

+ (UIColor *)colorWithR:(NSInteger)r g:(NSInteger)g b:(NSInteger)b;

+ (UIColor *)convertColorWithR:(NSInteger)r g:(NSInteger)g b:(NSInteger)b;

@end
