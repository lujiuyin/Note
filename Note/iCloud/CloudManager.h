//
//  CloudManager.h
//  Note
//
//  Created by 陆久银 on 2018/8/17.
//  Copyright © 2018年 lujiuyin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoteModel.h"

@interface CloudManager : NSObject

+ (instancetype)sharedManager;

- (void)insertModel:(NoteModel *)model;
- (void)deleteModel:(NoteModel *)model;
- (void)fetchAllModels:(void(^)(NSMutableArray<NoteModel *> * models))resultBlock;

- (void)updateModel:(NoteModel *)model;

@end
