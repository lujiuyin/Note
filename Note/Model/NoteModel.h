//
//  NoteModel.h
//  HQNote
//
//  Created by 陆久银 on 2018/8/14.
//  Copyright © 2018年 lujiuyin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
#import "NoteDayModel.h"

@interface NoteModel : RLMObject

@property  NSString *ID;
@property  NSDate *createDate;

@property  NSString *title;
@property  NSString *content;

@property  NSString *backgroundImageName;
@property  NSString *backgroundColorName;

@property (nonatomic, strong) NSString *dateFormat;

@property (readonly) RLMLinkingObjects *containerModel;

@end

