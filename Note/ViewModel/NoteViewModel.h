//
//  NoteViewModel.h
//  HQNote
//
//  Created by 陆久银 on 2018/8/14.
//  Copyright © 2018年 lujiuyin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoteDayModel.h"

#define kViewModel  [NoteViewModel sharedViewModel]

@interface NoteViewModel : NSObject

@property (nonatomic, strong) NSMutableArray<NoteDayModel *> *models;

+ (instancetype)sharedViewModel;

- (void)insertModel:(NoteModel *)model;
- (void)deleteModel:(NoteModel *)model;
- (void)updateModel:(NoteModel *)model;
@end
