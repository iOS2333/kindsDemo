//
//  SphereTagVC.m
//  AllKindsDemo
//
//  Created by kangjia on 2017/3/1.
//  Copyright © 2017年 jim_kj. All rights reserved.
//

#import "SphereTagVC.h"
#import "SphereTagView.h"
@interface SphereTagVC ()
{
    SphereTagView *sphereView;
}
@end

@implementation SphereTagVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *arr = @[@"阿潮",@"考研必胜",@"复试成功",@"阿潮",@"考研必胜",@"阿潮"];
    NSMutableArray *marr = [NSMutableArray array];
    for (NSInteger i = 0;i<50 ; i++) {
        
        [marr addObject:arr[arc4random()%arr.count]];
    }
    
    sphereView = [[SphereTagView alloc] initWithFrame:CGRectMake(0, screen_height/2 - screen_wid/2, screen_wid, screen_wid)];
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSInteger i = 0; i < marr.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn setTitle:[NSString stringWithFormat:@"%@",marr[i]] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14.];
        btn.frame = CGRectMake(0, 0, 100, 20);
        [btn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [array addObject:btn];
        [sphereView addSubview:btn];
    }
    [sphereView setCloudTags:array];
    sphereView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:sphereView];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)buttonPressed:(UIButton *)btn
{
    [sphereView timerStop];
    
    [UIView animateWithDuration:0.3 animations:^{
        btn.transform = CGAffineTransformMakeScale(2., 2.);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            btn.transform = CGAffineTransformMakeScale(1., 1.);
        } completion:^(BOOL finished) {
            [sphereView timerStart];
        }];
    }];
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
