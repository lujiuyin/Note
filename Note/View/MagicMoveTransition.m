//
//  MagicMoveTransition.m
//  Note
//
//  Created by 陆久银 on 2018/8/17.
//  Copyright © 2018年 lujiuyin. All rights reserved.
//

#import "MagicMoveTransition.h"
#import "ViewController.h"
#import "EditViewController.h"
#import "NoteCell.h"

@implementation MagicMoveTransition

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    ViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    EditViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    NoteCell *cell = (NoteCell*)[fromVC.tableView cellForRowAtIndexPath:[fromVC.tableView indexPathForSelectedRow]];
    fromVC.selectedIndex = [fromVC.tableView indexPathForSelectedRow];
    
    UIView *contentView = [cell.contentView snapshotViewAfterScreenUpdates:NO];
    contentView.frame = fromVC.contentViewRect = [containerView convertRect:cell.contentView.frame fromView:cell.contentView.superview];
    cell.contentView.hidden = YES;
    
    UIView *bgView = [cell.bgView snapshotViewAfterScreenUpdates:NO];
    bgView.frame = fromVC.bgViewRect = [containerView convertRect:cell.bgView.frame fromView:cell.bgView.superview];
    
    UIView *titleInput = [cell.titleLab snapshotViewAfterScreenUpdates:NO];
    titleInput.frame = fromVC.titleLabRect = [containerView convertRect:cell.titleLab.frame fromView:cell.titleLab.superview];
    
    UIView *contentInput = [cell.contentLab snapshotViewAfterScreenUpdates:NO];
    contentInput.frame = fromVC.contentLabRect = [containerView convertRect:cell.contentLab.frame fromView:cell.contentLab.superview];
    
    [contentView addSubview:bgView];
    [bgView addSubview:titleInput];
    [bgView addSubview:contentInput];
    
    toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
    toVC.view.alpha = 0;
    toVC.contentView.hidden = YES;
    
    [containerView addSubview:toVC.view];
    [containerView addSubview:contentView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        [containerView layoutIfNeeded];
        toVC.view.alpha = 1;
        contentView.frame = [containerView convertRect:toVC.contentView.frame toView:toVC.contentView.superview];
        bgView.frame = [containerView convertRect:toVC.bgView.frame toView:toVC.bgView.superview];
        titleInput.frame = [containerView convertRect:toVC.titleInput.frame toView:toVC.titleInput.superview];
        contentInput.frame = [containerView convertRect:toVC.contentInput.frame toView:toVC.contentInput.superview];
    }completion:^(BOOL finished) {
        [contentView removeFromSuperview];
        toVC.contentView.hidden = NO;
        cell.contentView.hidden = NO;
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3f;
}
@end
