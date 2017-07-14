
//
//  BaseTableViewController.m
//  BigShow1949
//
//  Created by zhht01 on 16/1/13.
//  Copyright © 2016年 BigShowCompany. All rights reserved.
//

#import "BaseTableViewController.h"

//#import "RZTransitionsNavigationController.h"  // 自定义push动画
//#import "RZSimpleViewController.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"mainCellIdentifier"];


//    [self.tableView animateTableView:AnimationDirection_top withDuration:0.0 withCompletion:^{
//        [self.tableView animateTableViewCell:AnimationDirection_left withDuration:1 withCompletion:^{
//            
//        }];
//    }];
//    UITableViewCellSeparatorStyleNone,
//    UITableViewCellSeparatorStyleSingleLine,
//    UITableViewCellSeparatorStyleSingleLineEtched
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *mainCellIdentifier = @"mainCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mainCellIdentifier forIndexPath:indexPath];

    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    NSString *labelText;
    if (indexPath.row < 9) {
        labelText = [NSString stringWithFormat:@"0%zd - %@", indexPath.row + 1, self.titles[indexPath.row]];
    }else {
        labelText = [NSString stringWithFormat:@"%zd - %@", indexPath.row + 1, self.titles[indexPath.row]];
    }
    cell.textLabel.text = labelText;
    cell.detailTextLabel.text = self.classNames[indexPath.row];
    
    NSTimeInterval delay = 1.00/[[NSNumber numberWithInteger:self.classNames.count] doubleValue]*[[NSNumber numberWithInteger:indexPath.row] doubleValue];
    CGAffineTransform cellTransform = CGAffineTransformMakeTranslation([self xPositionwith:AnimationDirection_left with:cell], 0.0);
    [cell.layer setAffineTransform:cellTransform];
    
    [UIView animateWithDuration:1.00 delay:delay usingSpringWithDamping:0.55 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [cell.layer setAffineTransform:CGAffineTransformIdentity];
    } completion:^(BOOL finished) {
    }];

    return cell;
    
}
-(CGFloat )xPositionwith:(AnimationDirection )direction
                    with:(UITableViewCell *)cell{
    if (direction == AnimationDirection_left) {
        return -cell.frame.size.width;
    }else if(direction == AnimationDirection_right){
        return cell.frame.size.width;
    }else
        return 0;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *className = self.classNames[indexPath.row];
    
    // 注意: 如果是sb来搭建, 必须以 _UIStoryboard 结尾
    NSUInteger classNameLength = className.length;
    NSUInteger storyBoardLength = @"_UIStoryboard".length;
    NSUInteger xibLength = @"_xib".length;
    
    NSString *suffixClassName;
    if (classNameLength > storyBoardLength) {
        suffixClassName = [className substringFromIndex:classNameLength - storyBoardLength];
    }
//    else {
//        suffixClassName = className;
//    }
    
    if ([suffixClassName isEqualToString:@"_UIStoryboard"]) {
        
        className = [className substringToIndex:classNameLength - storyBoardLength];
        
//        if ([className isEqualToString:@"RZSimpleViewController"]) {  // 自定义push动画
//            RZSimpleViewController *rootViewController = [[RZSimpleViewController alloc] init];
//            RZTransitionsNavigationController* rootNavController = [[RZTransitionsNavigationController alloc] initWithRootViewController:rootViewController];
//            [self presentViewController:rootNavController animated:YES completion:nil];
//        }else
        {
        
            // 注意: 这个storyboard的名字必须是控制器的名字
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:className bundle:nil];
            UIViewController *cardVC = [storyBoard instantiateInitialViewController];
            if (!cardVC) {
                cardVC = [storyBoard instantiateViewControllerWithIdentifier:className];
            }
            cardVC.title = self.titles[indexPath.row];
            [self.navigationController pushViewController:cardVC animated:YES ];
        }
        
    }else if ([[className substringFromIndex:classNameLength - xibLength] isEqualToString:@"_xib"]) {
    
        className = [className substringToIndex:classNameLength - xibLength];

        UIViewController *vc = [[NSClassFromString(className) alloc]initWithNibName:className bundle:nil];
        vc.title = self.titles[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else {
        UIViewController *vc = [[NSClassFromString(className) alloc] init];
        vc.title = self.titles[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end
