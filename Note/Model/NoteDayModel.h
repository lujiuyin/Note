//
//  NoteDayModel.h
//  HQNote
//
//  Created by 陆久银 on 2018/8/14.
//  Copyright © 2018年 lujiuyin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
#import "NoteModel.h"

@class NoteDayModel;

RLM_ARRAY_TYPE(NoteModel);

@interface NoteDayModel : RLMObject

@property NSDate *createDate;

@property RLMArray<NoteModel> *dayModels;

@property (nonatomic, strong) NSString *dateFormat;

@property (nonatomic, strong) NSMutableArray *sortDayModels;

@end

