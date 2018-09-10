//
//  MagicMoveInverseTransition.m
//  Note
//
//  Created by 陆久银 on 2018/8/17.
//  Copyright © 2018年 lujiuyin. All rights reserved.
//

#import "MagicMoveInverseTransition.h"
#import "EditViewController.h"
#import "ViewController.h"
#import "NoteCell.h"

@implementation MagicMoveInverseTransition

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    EditViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    ViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    UIView *contentView = [fromVC.contentView snapshotViewAfterScreenUpdates:NO];
    contentView.frame = [containerView convertRect:fromVC.contentView.frame fromView:fromVC.contentView.superview];
    fromVC.contentView.hidden = YES;

    UIView *bgView = [fromVC.bgView snapshotViewAfterScreenUpdates:NO];
    bgView.frame = [containerView convertRect:fromVC.bgView.frame fromView:fromVC.bgView.superview];

    UIView *titleInput = [fromVC.titleInput snapshotViewAfterScreenUpdates:NO];
    titleInput.frame = [containerView convertRect:fromVC.titleInput.frame fromView:fromVC.titleInput.superview];

    UIView *contentInput = [fromVC.contentInput snapshotViewAfterScreenUpdates:NO];
    contentInput.frame = [containerView convertRect:fromVC.contentInput.frame fromView:fromVC.contentInput.superview];
    [bgView addSubview:titleInput];
    [bgView addSubview:contentInput];
    [contentView addSubview:bgView];

    
    NoteCell *cell = (NoteCell*)[toVC.tableView cellForRowAtIndexPath:toVC.selectedIndex];
    cell.contentView.hidden = YES;
    
    toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
    [containerView insertSubview:toVC.view belowSubview:fromVC.view];
    [containerView addSubview:contentView];
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromVC.view.alpha = 0;
        contentView.frame = toVC.contentViewRect;
        bgView.frame = toVC.bgViewRect;
        titleInput.frame = toVC.titleLabRect;
        contentInput.frame = toVC.contentLabRect;
// NSLog(@"x=%f,y=%f,w=%f,h=%f",toVC.finalRect.origin.x,toVC.finalRect.origin.y,toVC.finalRect.size.width,toVC.finalRect.size.height);
    }completion:^(BOOL finished) {
        [contentView removeFromSuperview];
        fromVC.contentView.hidden = NO;
        cell.contentView.hidden = NO;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.6f;
}

@end
