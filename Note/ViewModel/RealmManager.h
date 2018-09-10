//
//  RealmManager.h
//  HQNote
//
//  Created by 陆久银 on 2018/8/15.
//  Copyright © 2018年 lujiuyin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoteModel.h"
#import "NoteDayModel.h"

#define Manager [RealmManager sharedManager]
@interface RealmManager : NSObject

+ (instancetype)sharedManager;

- (void)insertModel:(NoteModel *)model;
- (void)revertModel:(NoteModel *)model;
- (void)deleteModel:(NoteModel *)model;
- (NSMutableArray<NoteDayModel *> *)fetchAllDayModels;
- (void)updateModel:(NoteModel *)model;

@end
