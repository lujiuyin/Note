//
//  ViewController.h
//  Note
//
//  Created by 陆久银 on 2018/8/17.
//  Copyright © 2018年 lujiuyin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic,strong) NSIndexPath *selectedIndex;
@property (nonatomic,assign) CGRect contentViewRect;
@property (nonatomic,assign) CGRect bgViewRect;
@property (nonatomic,assign) CGRect titleLabRect;
@property (nonatomic,assign) CGRect contentLabRect;

@property (strong, nonatomic) UITableView *tableView;

@end

