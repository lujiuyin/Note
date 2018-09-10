//
//  NoteDayModel.m
//  HQNote
//
//  Created by 陆久银 on 2018/8/14.
//  Copyright © 2018年 lujiuyin. All rights reserved.
//

#import "NoteDayModel.h"
#import "NSDate+extension.h"

@implementation NoteDayModel

+ (NSArray<NSString *> *)ignoredProperties {
    return @[@"dateFormat",@"sortDayModels"];
}

- (NSString *)dateFormat {
    return [self.createDate date2Formatter];
}
@end
