//
//  CloudManager.m
//  Note
//
//  Created by 陆久银 on 2018/8/17.
//  Copyright © 2018年 lujiuyin. All rights reserved.
//

#import "CloudManager.h"
#import <CloudKit/CloudKit.h>
#import "HQToastManager.h"

#define RECORD_TYPE_NAME    @"NoteModel"
@implementation CloudManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static CloudManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[CloudManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        id cloudUrl = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
        if (cloudUrl == nil) {
            //cloud没有开启
            [HQToast showToast:@"cloud没有开启"];
        }else {
            //cloud已开启
        }
    }
    return self;
}

- (void)insertModel:(NoteModel *)model {
    CKContainer *container = [CKContainer defaultContainer];
    
    CKDatabase *dataBase = container.publicCloudDatabase;
    
    CKRecordID *noteId = [[CKRecordID alloc] initWithRecordName:[NSString stringWithFormat:@"%ld",model.ID]];
    CKRecord *noteRecord = [[CKRecord alloc] initWithRecordType:RECORD_TYPE_NAME recordID:noteId];

    [noteRecord setValue:model.ID forKey:@"ID"];
    [noteRecord setValue:model.title forKey:@"title"];
    [noteRecord setValue:model.content forKey:@"content"];
    [noteRecord setValue:model.createDate forKey:@"createDate"];
    [noteRecord setValue:model.backgroundImageName forKey:@"backgroundImageName"];
    [noteRecord setValue:model.backgroundColorName forKey:@"backgroundColorName"];

    [dataBase saveRecord:noteRecord completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
        if (!error) {
//            [HQToast showToast:@"iCloud同步成功"];
        }else {
//            [HQToast showToast:@"iCloud同步失败"];
        }
    }];
}
- (void)deleteModel:(NoteModel *)model {
    
    CKRecordID *noteId = [[CKRecordID alloc] initWithRecordName:[NSString stringWithFormat:@"%ld",model.ID]];
    CKContainer *container = [CKContainer defaultContainer];
    
    CKDatabase *database = container.publicCloudDatabase;
    
    [database deleteRecordWithID:noteId completionHandler:^(CKRecordID * _Nullable recordID, NSError * _Nullable error) {
        
        if(error)
            
        {
//            [HQToast showToast:@"删除失败"];
        }
        
        else
            
        {
//            [HQToast showToast:@"iCloud删除成功"];
        }
        
    }];
}

- (void)fetchAllModels:(void(^)(NSMutableArray<NoteModel *> * models))resultBlock {
    CKContainer *container = [CKContainer defaultContainer];
    
    CKDatabase *dataBase = container.publicCloudDatabase;
    
    NSPredicate *predicate = [NSPredicate predicateWithValue:YES];
    
    CKQuery *query = [[CKQuery alloc] initWithRecordType:RECORD_TYPE_NAME predicate:predicate];
    
    [dataBase performQuery:query inZoneWithID:nil completionHandler:^(NSArray<CKRecord *> * _Nullable results, NSError * _Nullable error) {
        NSLog(@"%@",results);
        if (!error) {
            [HQToast showToast:@"iCloud同步成功"];
        }else {
            [HQToast showToast:@"iCloud同步失败"];
        }
        NSMutableArray<NoteModel *> *models = [NSMutableArray array];
        for (CKRecord *record in results) {
            NoteModel *model = [[NoteModel alloc] init];
            model.ID = [record objectForKey:@"ID"];
            model.title = [record objectForKey:@"title"];
            model.content = [record objectForKey:@"content"];
            model.backgroundColorName = [record objectForKey:@"backgroundColorName"];
            model.backgroundImageName = [record objectForKey:@"backgroundImageName"];
            model.createDate = [record objectForKey:@"createDate"];

            [models addObject:model];
        }
        resultBlock(models);
    }];
}

- (void)updateModel:(NoteModel *)model {
    CKContainer *container = [CKContainer defaultContainer];
    CKDatabase *dataBase = container.publicCloudDatabase;
    
    CKRecordID *noteId = [[CKRecordID alloc] initWithRecordName:[NSString stringWithFormat:@"%ld",model.ID]];
    CKRecord *noteRecord = [[CKRecord alloc] initWithRecordType:RECORD_TYPE_NAME recordID:noteId];
    
    [noteRecord setValue:model.title forKey:@"title"];
    [noteRecord setValue:model.content forKey:@"content"];
    [noteRecord setValue:model.createDate forKey:@"createDate"];
    [noteRecord setValue:model.backgroundImageName forKey:@"backgroundImageName"];
    [noteRecord setValue:model.backgroundColorName forKey:@"backgroundColorName"];
    
    [dataBase saveRecord:noteRecord completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
        if (!error) {
//            [HQToast showToast:@"iCloud同步成功"];
        }else {
//            [HQToast showToast:@"iCloud同步失败"];
        }
    }];
}

@end
