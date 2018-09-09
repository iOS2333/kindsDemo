//
//  CyclicCardVC.m
//  AllKindsDemo
//
//  Created by kangjia on 2017/7/5.
//  Copyright © 2017年 jim_kj. All rights reserved.
//

#import "CyclicCardVC.h"
#import "CyclicCardFlowLayout.h"
#import "CyclicCardCell.h"
#import "CyclicCardView.h"
#define cellID @"cellid"
@interface CyclicCardVC ()

{

    CyclicCardView *cview;
}



@end

@implementation CyclicCardVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self makeUI];
}
-(void)makeUI{
    self.automaticallyAdjustsScrollViewInsets = YES;
    cview = [[CyclicCardView alloc] initWithFrame:CGRectMake(0, 0, screen_wid, screen_height*(324.00/667.00)) withImages:@[@"num_1",@"num_2",@"num_3",@"num_4",@"num_5"] withSacle:@{}];
    cview.animationDuration = 4;
    cview.Autoscrol = YES;
    [cview setTapActionBlock:^(NSInteger(pageIndex)) {
        NSLog(@"点击%zd",pageIndex);
    }];
    self.view.backgroundColor = [UIColor redColor];
    [self.view addSubview:cview];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
