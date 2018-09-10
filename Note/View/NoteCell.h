//
//  NoteCell.h
//  Note
//
//  Created by 陆久银 on 2018/8/17.
//  Copyright © 2018年 lujiuyin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteModel.h"

@interface NoteCell : UITableViewCell

//UI
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *headerSubTitle;
@property (weak, nonatomic) IBOutlet UILabel *headerMainTitle;


- (void)config:(NoteModel *)model isHeader:(BOOL)isHeader;

@end
