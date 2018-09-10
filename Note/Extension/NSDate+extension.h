//
//  NSDate+extension.h
//  HQNote
//
//  Created by 陆久银 on 2018/8/15.
//  Copyright © 2018年 lujiuyin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (extension)

- (NSString *)date2Formatter;

- (NSString *)date2ShortFormatter;

- (NSString *)date2Week;

- (NSString *)date2FormatterAndWeek;
@end
