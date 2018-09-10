//
//  NoteViewModel.m
//  HQNote
//
//  Created by 陆久银 on 2018/8/14.
//  Copyright © 2018年 lujiuyin. All rights reserved.
//

#import "NoteViewModel.h"
#import "RealmManager.h"
#import "CloudManager.h"

@implementation NoteViewModel

+ (instancetype)sharedViewModel {
    static dispatch_once_t onceToken;
    static NoteViewModel *viewModel = nil;
    dispatch_once(&onceToken, ^{
        viewModel = [[NoteViewModel alloc] init];
    });
    return viewModel;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self loadNote];
    }
    return self;
}

- (void)loadNote {
    self.models = [Manager fetchAllDayModels];
    if (!self.models || self.models.count == 0) {
        [[CloudManager sharedManager] fetchAllModels:^(NSMutableArray<NoteModel *> *models) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                for (NoteModel *model in models) {
                    [Manager revertModel:model];
                }
                [self reloadNote];
            });
        }];
    }
}

- (void)reloadNote {
    self.models = [Manager fetchAllDayModels];
}
- (void)insertModel:(NoteModel *)model {
    [Manager insertModel:model];
    [[CloudManager sharedManager] insertModel:model];
    [self reloadNote];
}
- (void)deleteModel:(NoteModel *)model {
    [[CloudManager sharedManager] deleteModel:model];
    [Manager deleteModel:model];
    [self reloadNote];
}
- (void)updateModel:(NoteModel *)model {
    [[CloudManager sharedManager] updateModel:model];
    [Manager updateModel:model];
    [self reloadNote];
}
@end
