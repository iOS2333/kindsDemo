//
//  GestureSelectViewController.m
//  MasonyDemo
//
//  Created by kangjia on 16/9/3.
//  Copyright © 2016年 jim_kj. All rights reserved.
//

#import "GestureSelectViewController.h"
#import "GestureViewController.h"
@interface GestureSelectViewController ()

@end

@implementation GestureSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"手势解锁";
    self.view.backgroundColor = [UIColor whiteColor];
    NSArray *nameArr = @[@"设置手势密码",@"登录手势密码",@"验证手势密码",@"修改手势密码"];
    CGFloat yy = screen_height/2 - 150
    ;
    for (NSInteger i = 0; i<nameArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:nameArr[i] forState:UIControlStateNormal];
        btn.frame = CGRectMake(0, yy, screen_wid, 30);
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:btn];
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        yy+= 60;
    }
    
    
    
}

- (void)btnClick:(UIButton *)sender{
    switch (sender.tag) {
        case 100:
        {
            GestureViewController *gestureVc = [[GestureViewController alloc] init];
            gestureVc.type = GestureViewControllerTypeSetting;
            [self.navigationController pushViewController:gestureVc animated:YES];

        }
            break;
        case 101:
        {
            if ([[PCCircleViewConst getGestureWithKey:gestureFinalSaveKey] length]) {
                GestureViewController *gestureVc = [[GestureViewController alloc] init];
                [gestureVc setType:GestureViewControllerTypeLogin];
                [self.navigationController pushViewController:gestureVc animated:YES];
            } else {
                UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"暂未设置手势密码，是否前往设置" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
                [alerView show];
            }

        }
            break;
        case 102:
        {
            
        }
            break;
        case 103:
        {
            
        }
            break;
            
        default:
            break;
    }
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
