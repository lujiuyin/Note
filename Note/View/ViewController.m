//
//  ViewController.m
//  Note
//
//  Created by 陆久银 on 2018/8/17.
//  Copyright © 2018年 lujiuyin. All rights reserved.
//

#import "ViewController.h"
#import "EditViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "HQToastManager.h"
#import "NoteCell.h"
#import "NoteViewModel.h"
#import <Masonry.h>
#import "UIColor+hex2color.h"

#import "MagicMoveTransition.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

static NSString * const reuseIdentifier = @"NoteCell";

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource,UINavigationControllerDelegate>

@property (strong, nonatomic) NSIndexPath* editingIndexPath;  //当前左滑cell的index，在代理方法中设置


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    kViewModel.models.count > 0 ? [self author] :
    [self setupView];
    
    [kViewModel addObserver:self forKeyPath:@"models" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (self.editingIndexPath)
    {
        [self configSwipeButtons];
    }
}

- (void)configSwipeButtons
{
    // 获取选项按钮的reference
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11.0"))
    {
        // iOS 11层级 (Xcode 9编译): UITableView -> UISwipeActionPullView
        for (UIView *subview in self.tableView.subviews)
        {
            if ([subview isKindOfClass:NSClassFromString(@"UISwipeActionPullView")])
            {
                // 和iOS 10的按钮顺序相反
                UIButton *deleteButton = subview.subviews[0];
                [subview setBackgroundColor:[UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0]];
                
                [self configDeleteButton:deleteButton];
            }
        }
    }
    else
    {
        // iOS 8-10层级: UITableView -> UITableViewCell -> UITableViewCellDeleteConfirmationView
        NoteCell *tableCell = [self.tableView cellForRowAtIndexPath:self.editingIndexPath];
        for (UIView *subview in tableCell.subviews)
        {
            if ([subview isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")])
            {
                UIButton *deleteButton = subview.subviews[0];
                
                [self configDeleteButton:deleteButton];
                [subview setBackgroundColor:[UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0]];
            }
        }
    }
    
}

- (void)configDeleteButton:(UIButton*)deleteButton
{
    if (deleteButton)
    {
        [deleteButton setBackgroundColor:[UIColor whiteColor]];
        [deleteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        CGRect rect = deleteButton.frame;
        CGFloat width = 50;
        deleteButton.layer.cornerRadius = width/2;
        deleteButton.layer.masksToBounds = YES;
        if (deleteButton.frame.size.width != width) {
            deleteButton.frame = CGRectMake(30, rect.size.height/2-width/2, width, width);
        }
        NSLog(@"deleteButton.y==  %f",rect.size.height/2-width/2);
        UIImageView *dele = [[UIImageView alloc] initWithFrame:CGRectInset(deleteButton.bounds, 10, 10)];
        dele.image = [UIImage imageNamed:@"delete"];
        [deleteButton addSubview:dele];
    }
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}
#pragma mark - I/F
- (void)setupView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).mas_offset(20);
//        make.edges.mas_equalTo(self.view);
    }];
    [self.tableView registerNib:[UINib nibWithNibName:reuseIdentifier bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    
    UIButton *editBtn = [[UIButton alloc] init];
    [self.view addSubview:editBtn];
    [editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-20);
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.centerX.mas_equalTo(self.view);
    }];
    editBtn.layer.cornerRadius = 25;
    editBtn.layer.masksToBounds = YES;
    [editBtn setBackgroundColor:[UIColor blackColor]];
    [editBtn setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)author {
    LAContext *context = [[LAContext alloc] init];
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:nil]) {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:@"请验证已有的指纹,完成认证" reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                [HQToast showToast:@"认证成功"];
                [self performSelectorOnMainThread:@selector(setupView) withObject:nil waitUntilDone:YES];
            }
        }];
    }
}

- (void)editAction:(UIButton *)sender {
    EditViewController *edit = [[EditViewController alloc] init];
    [self.navigationController pushViewController:edit animated:YES];
}
#pragma mark - Getter & Setter


#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return kViewModel.models.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return kViewModel.models[section].sortDayModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NoteCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NoteDayModel *dayModel = [kViewModel.models objectAtIndex:indexPath.section];
    [cell config:[dayModel.sortDayModels objectAtIndex:indexPath.row] isHeader:indexPath.row == 0];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 470;
    }
    return 400;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NoteDayModel *dayModel = [kViewModel.models objectAtIndex:indexPath.section];
    EditViewController *edit = [[EditViewController alloc] init];
    edit.noteModel = [dayModel.sortDayModels objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:edit animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //remove
        NoteDayModel *dayModel = [kViewModel.models objectAtIndex:indexPath.section];
        
        [kViewModel deleteModel:[dayModel.sortDayModels objectAtIndex:indexPath.row]];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"";
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.editingIndexPath = indexPath;
    [self.view setNeedsLayout];   // 触发-(void)viewDidLayoutSubviews
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.editingIndexPath = nil;
}

#pragma mark - UINavigationControllerDelegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if([toVC isKindOfClass:[EditViewController class]]){
        MagicMoveTransition *transition = [[MagicMoveTransition alloc] init];
        return transition;
    }else {
        return nil;
    }
}
@end
