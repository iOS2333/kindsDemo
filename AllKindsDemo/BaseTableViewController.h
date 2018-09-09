//
//  BaseTableViewController.h
//  BigShow1949
//
//  Created by zhht01 on 16/1/13.
//  Copyright © 2016年 BigShowCompany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Extension.h"
#import "UIViewController+Alpha.h"
#import "UINavigationController+Alpha.h"
@interface BaseTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *classNames;

@end
