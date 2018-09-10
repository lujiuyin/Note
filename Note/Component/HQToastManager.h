//
//  HQToastManager.h
//  NipponColors
//
//  Created by 陆久银 on 2018/8/13.
//  Copyright © 2018年 lujiuyin. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HQToast [HQToastManager sharedManager]
@interface HQToastManager : NSObject

+ (instancetype)sharedManager;

- (void)showToast:(NSString *)title;
@end
