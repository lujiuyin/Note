//
//  NoteModel.m
//  HQNote
//
//  Created by 陆久银 on 2018/8/14.
//  Copyright © 2018年 lujiuyin. All rights reserved.
//

#import "NoteModel.h"
#import "NoteDayModel.h"
#import "NSDate+extension.h"

@implementation NoteModel

+ (NSString *)primaryKey {
    return @"ID";
}

+ (NSArray<NSString *> *)ignoredProperties {
    return @[@"dateFormat"];
}

- (NSString *)dateFormat {
    return [self.createDate date2Formatter];
}

+ (NSDictionary<NSString *,RLMPropertyDescriptor *> *)linkingObjectsProperties {
    return @{@"containerModel":[RLMPropertyDescriptor descriptorWithClass:NoteDayModel.class propertyName:@"dayModels"]};
}
@end
