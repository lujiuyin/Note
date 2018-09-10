//
//  EditViewController.h
//  Note
//
//  Created by 陆久银 on 2018/8/17.
//  Copyright © 2018年 lujiuyin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteModel.h"

@interface EditViewController : UIViewController

//UI
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UITextField *titleInput;
@property (nonatomic, strong) UITextView *contentInput;
@property (nonatomic, strong) UIButton *saveBtn;
@property (nonatomic, strong) UIButton *closeBtn;


@property (nonatomic, strong) NoteModel *noteModel;

@end
