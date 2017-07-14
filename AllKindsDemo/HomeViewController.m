//
//  HomeViewController.m
//  AllKindsDemo
//
//  Created by kangjia on 2017/3/1.
//  Copyright © 2017年 jim_kj. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"收集的demo";
    self.titles = @[@"Label",
                    @"粒子效果",
                    @"2048",
                    @"手势",
                    @"OCR识别",
                    @"自定义collection",
                    @"OC-JS交互",
                    @"无限轮播"];
    
    
    self.classNames = @[@"LabelViewController",
                        @"ParticleSetVCViewController",
                        @"YFLittleProjectVC03",
                        @"GestureSelectViewController",
                        @"OCRViewController",
                        @"CollectionVC",
                        @"OCAndJS",
                        @"CyclicCardVC"];
    
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
