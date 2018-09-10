//
//  EditViewController.m
//  Note
//
//  Created by 陆久银 on 2018/8/17.
//  Copyright © 2018年 lujiuyin. All rights reserved.
//

#import "EditViewController.h"
#import "NoteViewModel.h"
#import <Masonry/Masonry.h>
#import "UIColor+hex2color.h"

#import "MagicMoveInverseTransition.h"
#import "ViewController.h"
#define ScreenW [UIScreen mainScreen].bounds.size.width
@interface EditViewController ()<UINavigationControllerDelegate>
//@property (nonatomic, strong) UIView *bgView;
//@property (nonatomic, strong) UIImageView *bgImageView;
//@property (nonatomic, strong) UITextField *titleInput;
//@property (nonatomic, strong) UITextView *contentInput;
//@property (nonatomic, strong) UIButton *saveBtn;
//@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *percentDrivenTransition;

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.delegate = self;
    
    UIPanGestureRecognizer *ges = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePanGesture:)];
    [self.view addGestureRecognizer:ges];
    
    [self setupUI];
    [self configureUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - I/F
- (void)setupUI {
    self.contentView = [[UIView alloc] init];
    self.contentView.clipsToBounds = YES;
    self.contentView.backgroundColor = [UIColor greenColor];
    
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    self.bgView = [[UIView alloc] init];
    [self.contentView addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(ScreenW * 1.5);
    }];
    self.bgView.backgroundColor = [UIColor redColor];

    self.bgImageView = [[UIImageView alloc] init];
    [self.bgView addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.bgView);
    }];
    
    self.titleInput = [[UITextField alloc] init];
    self.titleInput.font = [UIFont boldSystemFontOfSize:18];
    [self.contentView addSubview:self.titleInput];
    [self.titleInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(self.contentView).mas_offset(20);
        make.right.mas_equalTo(self.contentView).mas_offset(-20);
        make.height.mas_equalTo(50);
    }];
    
    self.contentInput = [[UITextView alloc] init];
    self.titleInput.font = [UIFont systemFontOfSize:15];
    self.contentInput.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.contentInput];
    [self.contentInput mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleInput.mas_bottom).mas_offset(20);
        make.left.mas_equalTo(self.contentView).mas_offset(20);
        make.right.mas_equalTo(self.contentView).mas_offset(-20);
        make.bottom.mas_equalTo(self.bgView.mas_bottom);
    }];
    
    self.saveBtn = [[UIButton alloc] init];
    [self.contentView addSubview:self.saveBtn];
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).mas_offset(20);
        make.right.mas_equalTo(self.contentView).mas_offset(-20);
        make.bottom.mas_equalTo(self.contentView).mas_offset(-20);
        make.height.mas_equalTo(50);
    }];
    [self.saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [self.saveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.saveBtn addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.closeBtn = [[UIButton alloc] init];
    [self.contentView addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).mas_offset(20);
        make.right.mas_equalTo(self.contentView).mas_offset(-20);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(50);
    }];
    [self.closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [self.closeBtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)configureUI {
    self.titleInput.text = _noteModel.title;
    self.contentInput.text = _noteModel.content;
    if (_noteModel.backgroundColorName && ![_noteModel.backgroundColorName isEqualToString:@""]) {
        self.bgView.backgroundColor = [UIColor colorWithHex:_noteModel.backgroundColorName];
    }
    if (_noteModel.backgroundImageName && ![_noteModel.backgroundImageName isEqualToString:@""]) {
        self.bgImageView.image = [UIImage imageNamed:_noteModel.backgroundImageName];
    }
}
#pragma mark - Action
- (void)saveAction:(UIButton *)sender {
    NoteModel *model = [[NoteModel alloc] init];
    model.title = self.titleInput.text;
    model.content = self.contentInput.text;
    //    model.backgroundColorName = @"backgroundColorName_01";
    //    model.backgroundImageName = @"backgroundImageName_01";
    model.createDate = [NSDate date];
    
    [kViewModel insertModel:model];
}

- (void)closeAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Getter & Setter

- (void)edgePanGesture:(UIScreenEdgePanGestureRecognizer *)recognizer {
    CGFloat progress = [recognizer translationInView:self.view].y / self.view.bounds.size.height;
    progress = MIN(1.0, MAX(0.0, progress));
    if(recognizer.state == UIGestureRecognizerStateBegan){
        self.percentDrivenTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        [self.navigationController popViewControllerAnimated:YES];
    }else if (recognizer.state == UIGestureRecognizerStateChanged){
        [self.percentDrivenTransition updateInteractiveTransition:progress];
    }else if (recognizer.state == UIGestureRecognizerStateCancelled || recognizer.state == UIGestureRecognizerStateEnded){
        if(progress > 0.4){
            [self.percentDrivenTransition finishInteractiveTransition];
        }else {
            [self.percentDrivenTransition cancelInteractiveTransition];
        }
    }
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    if([animationController isKindOfClass:[MagicMoveInverseTransition class]]){
        return self.percentDrivenTransition;
    }else {
        return nil;
    }
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if([toVC isKindOfClass:[ViewController class]]){
        MagicMoveInverseTransition *inverseTransition = [[MagicMoveInverseTransition alloc] init];
        return inverseTransition;
    }else {
        return nil;
    }
}
@end
