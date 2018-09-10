//
//  NoteCell.m
//  Note
//
//  Created by 陆久银 on 2018/8/17.
//  Copyright © 2018年 lujiuyin. All rights reserved.
//

#import "NoteCell.h"
#import "UIColor+hex2color.h"
#import "NSDate+extension.h"

@interface NoteCell()



@end

@implementation NoteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bgView.layer.cornerRadius = 10;
    self.bgView.backgroundColor = [UIColor redColor];
    //设置阴影颜色
    self.bgView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    //设置阴影的透明度
    self.bgView.layer.shadowOpacity = 0.5f;
    //设置阴影的偏移
    self.bgView.layer.shadowOffset = CGSizeMake(0,15);
    //设置阴影半径
    self.bgView.layer.shadowRadius = 15.0f;
    
    self.titleLab.font = [UIFont boldSystemFontOfSize:18];
    self.titleLab.font = [UIFont systemFontOfSize:15];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];

    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.transform = highlighted ? CGAffineTransformMakeScale(0.95, 0.95) : CGAffineTransformIdentity;
    }];
}

- (void)config:(NoteModel *)model isHeader:(BOOL)isHeader {
    self.headerViewHeight.constant = isHeader ? 70 : 0;
    self.titleLab.text = model.title;
    self.contentLab.text = model.content;
    if (model.backgroundImageName && ![model.backgroundImageName isEqualToString:@""]) {
        self.bgImageView.image = [UIImage imageNamed:model.backgroundImageName];
    }
    
    if (model.backgroundColorName && ![model.backgroundColorName isEqualToString:@""]) {
        self.bgView.backgroundColor = [UIColor colorWithHex:model.backgroundColorName];
    }
    if (!isHeader) {
        return;
    }
    if ([[[NSDate date] date2Formatter] isEqualToString:model.dateFormat]) {
        self.headerMainTitle.text = @"Today";
        self.headerSubTitle.text = [model.createDate date2FormatterAndWeek];
    } else {
        self.headerMainTitle.text = [model.createDate date2Week];
        self.headerSubTitle.text = [model.createDate date2ShortFormatter];
    }
}
@end
