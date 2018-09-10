//
//  NSDate+extension.m
//  HQNote
//
//  Created by 陆久银 on 2018/8/15.
//  Copyright © 2018年 lujiuyin. All rights reserved.
//

#import "NSDate+extension.h"

@implementation NSDate (extension)

- (NSString *)date2Formatter {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-M-d"];
    return [formatter stringFromDate:self];
}

- (NSString *)date2ShortFormatter {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"M月d日"];
    return [formatter stringFromDate:self];
}

- (NSString *)date2Week {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:self];
    
    NSArray *weekDesc = @[@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",];
    return weekDesc[components.weekday-1];
}

- (NSString *)date2FormatterAndWeek {
    NSString *dateAndWeek = [NSString stringWithFormat:@"%@ %@",[self date2ShortFormatter],[self date2Week]];
    return dateAndWeek;
}

@end
