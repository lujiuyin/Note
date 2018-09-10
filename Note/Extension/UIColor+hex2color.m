//
//  UIColor+hex2color.m
//  NipponColors
//
//  Created by 陆久银 on 2018/8/10.
//  Copyright © 2018年 lujiuyin. All rights reserved.
//

#import "UIColor+hex2color.h"

@implementation UIColor (hex2color)

+ (UIColor *)colorWithHex:(NSString *)hex {
    if ([hex hasPrefix:@"#"]) {
        hex = [hex substringFromIndex:1];
    }
    if (hex.length != 6) {
        return nil;
    }
    NSString *rStr = [hex substringWithRange:NSMakeRange(0, 2)];
    NSInteger r = [self numberWithHexString:rStr];
    
    NSString *gStr = [hex substringWithRange:NSMakeRange(2, 2)];
    NSInteger g = [self numberWithHexString:gStr];
    
    NSString *bStr = [hex substringWithRange:NSMakeRange(4, 2)];
    NSInteger b = [self numberWithHexString:bStr];
    
    UIColor *color = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
    return color;
}


+ (UIColor *)colorWithR:(NSInteger)r g:(NSInteger)g b:(NSInteger)b {
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
}


+ (UIColor *)convertColorWithR:(NSInteger)r g:(NSInteger)g b:(NSInteger)b {
    return [UIColor colorWithR:255-r g:255-g b:255-b];
}

+ (NSInteger)numberWithHexString:(NSString *)hexString{
    
    const char *hexChar = [hexString cStringUsingEncoding:NSUTF8StringEncoding];
    
    int hexNumber;
    
    sscanf(hexChar, "%x", &hexNumber);
    
    return (NSInteger)hexNumber;
}
@end
