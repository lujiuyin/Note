//
//  RealmManager.m
//  HQNote
//
//  Created by 陆久银 on 2018/8/15.
//  Copyright © 2018年 lujiuyin. All rights reserved.
//

#import "RealmManager.h"
#import <Realm/Realm.h>

@interface RealmManager()
@property (nonatomic, strong) NSString *ss;

@property (nonatomic, assign) NSInteger ID;

@end

@implementation RealmManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static RealmManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[RealmManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadLastId];
    }
    return self;
}

- (void)insertModel:(NoteModel *)model {
    [RealmManager sharedManager].ID += 1;
    model.ID = [NSString stringWithFormat:@"%ld",[RealmManager sharedManager].ID];
    [self revertModel:model];
}

- (void)revertModel:(NoteModel *)model {
    RLMRealm *realm = [RLMRealm defaultRealm];
    NSMutableArray<NoteDayModel *> * dayModels = [self fetchAllDayModels];
    [realm transactionWithBlock:^{
        BOOL isExist = NO;
        for (NoteDayModel *dayModel in dayModels) {
            if ([dayModel.dateFormat isEqualToString:model.dateFormat]) {
                [dayModel.dayModels addObject:model];
                isExist = YES;
                break;
            }
        }
        if (!isExist) {
            NoteDayModel *dayModel = [self createNewDayModel:model];
            [realm addObject:dayModel];
        }
    }];
}

- (void)deleteModel:(NoteModel *)model {    
    RLMRealm *realm = [RLMRealm defaultRealm];
    NoteModel *m = [[NoteModel objectsWhere:@"ID == %@",model.ID] firstObject];
    [realm transactionWithBlock:^{
        [realm deleteObject:m];
    }];
    
    RLMResults<NoteDayModel *> *dayModels = [[NoteDayModel allObjects] sortedResultsUsingKeyPath:@"createDate" ascending:NO];
    for (int i = 0 ; i < dayModels.count; i++) {
        NoteDayModel *dayModel = dayModels[i];
        if (dayModel.dayModels.count == 0) {
            [realm transactionWithBlock:^{
                [realm deleteObject:dayModel];
            }];
        }
    }
}

- (NSMutableArray<NoteDayModel *> *)fetchAllDayModels {
    RLMResults<NoteDayModel *> *dayModels = [[NoteDayModel allObjects] sortedResultsUsingKeyPath:@"createDate" ascending:NO];
    
    NSMutableArray<NoteDayModel *> *dayModelArray = [NSMutableArray array];
    for (int i = 0 ; i < dayModels.count; i++) {
        NoteDayModel *dayModel = dayModels[i];
        RLMResults *results = [dayModel.dayModels sortedResultsUsingKeyPath:@"ID" ascending:NO];
        NSMutableArray *modelArray = [NSMutableArray array];
        for (int j = 0; j < results.count; j++) {
            [modelArray addObject:results[j]];
        }
        dayModel.sortDayModels = modelArray;
        [dayModelArray addObject:dayModel];
    }
    return dayModelArray;
}

- (void)updateModel:(NoteModel *)model {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        NoteModel *m = [[NoteModel objectsWhere:@"ID == %@",model.ID] firstObject];
        m = model;
    }];
}

#pragma mark - I/F
- (NoteDayModel *)createNewDayModel:(NoteModel *)model {
    NoteDayModel *dayModel = [[NoteDayModel alloc] init];
    dayModel.createDate = model.createDate;
    [dayModel.dayModels addObject:model];
    return dayModel;
}

- (void)loadLastId {
    RLMResults<NoteModel *> *models = [[NoteModel allObjects] sortedResultsUsingKeyPath:@"ID" ascending:NO];
    self.ID = [models.firstObject.ID integerValue];
}
@end
