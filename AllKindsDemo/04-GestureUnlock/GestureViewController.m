//
//  GestureViewController.m
//  MasonyDemo
//
//  Created by kangjia on 16/9/3.
//  Copyright © 2016年 jim_kj. All rights reserved.
//

#import "GestureViewController.h"
#import "PCCircleView.h"
#import "PCLockLabel.h"
#import "PCCircleInfoView.h"
#import "PCCircle.h"
#import "UIView+Boom.h"

@interface GestureViewController ()<CircleViewDelegate>
/**
 *  重设按钮
 */

@property (nonatomic,strong) UIButton *resetBtn;
/**
 *  提示Label
 */
@property (nonatomic, strong) PCLockLabel *msgLabel;

/**
 *  解锁界面
 */
@property (nonatomic, strong) PCCircleView *lockView;

/**
 *  infoView
 */
@property (nonatomic, strong) PCCircleInfoView *infoView;
@end

@implementation GestureViewController
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.type == GestureViewControllerTypeLogin) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
    [PCCircleViewConst saveGesture:nil Key:gestureOneSaveKey];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = CircleViewBackgroundColor;
    
    //设置共有的界面
    [self setSameUI];
    //根据type 初始化不同界面
    [self setDiffertenceUI];
    
}
#pragma mark - 创建右上角按钮
-(UIBarButtonItem *)itemTitle:(NSString *)name target:(id)target action:(SEL)action tag:(NSInteger) tag{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn setTitle:name forState:UIControlStateNormal];
    
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    btn.frame = (CGRect){CGPointZero,{100,20}};
    
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    btn.tag = tag;
    [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [btn setHidden:YES];
    self.resetBtn = btn;
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}
#pragma mark - 共有界面
-(void)setSameUI{
    self.navigationController.navigationItem.rightBarButtonItem = [self itemTitle:@"重设" target:self action:@selector(didClickBtn:) tag:buttonReset];
    
    //解锁界面
    PCCircleView *lockView = [[PCCircleView alloc] init];
    lockView.delegate = self;
    self.lockView = lockView;
    [self.view addSubview:lockView];

    //提示Label
    PCLockLabel *lock_lb = [[PCLockLabel alloc] initWithFrame:CGRectMake(0, 0, screen_wid, 14)];
    lock_lb.center = CGPointMake(screen_wid/2, CGRectGetMinY(lockView.frame) - 30);
    self.msgLabel = lock_lb;
    [self.view addSubview:lock_lb];
}
#pragma mark button 点击
- (void)didClickBtn:(UIButton *)sender{
    
    switch (sender.tag) {
        case buttonReset:
        {
            NSLog(@"点击了重设按钮");
            // 1.隐藏按钮
            [self.resetBtn setHidden:YES];
            
            // 2.infoView取消选中
            [self infoViewDeselectedSubviews];
            
            // 3.msgLabel提示文字复位
            [self.msgLabel showNormalMsg:gestureTextBeforeSet];
            
            // 4.清除之前存储的密码
            [PCCircleViewConst saveGesture:nil Key:gestureOneSaveKey];
        }
            break;
        case buttonManager:
        {
            NSLog(@"点击了管理手势密码按钮");
        }
            break;
        case buttonForget:
        {
            NSLog(@"点击了登录其他账户按钮");
            [PCCircleViewConst saveGesture:nil Key:gestureOneSaveKey];
            [self.navigationController popViewControllerAnimated:YES];

        }
            break;

        default:
            break;
    }
    
}
#pragma mark 创建UIButton
- (void)creatButton:(UIButton *)btn frame:(CGRect)frame title:(NSString *)title alignment:(UIControlContentHorizontalAlignment)alignment tag:(NSInteger)tag
{
    btn.frame = frame;
    btn.tag = tag;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setContentHorizontalAlignment:alignment];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [btn addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

#pragma mark - 不同界面
-(void)setDiffertenceUI{
    if (self.type == GestureViewControllerTypeLogin) {
        [self setupLoginVC];
    }else{
        [self setupSettingVC];
    }
}
-(void)setupSettingVC{
    
    self.title = @"设置密码";
    
    [self.lockView setType:CircleViewTypeSetting];
    
    [self.msgLabel showNormalMsg:gestureTextBeforeSet];
    
    PCCircleInfoView *pcinfoView = [[PCCircleInfoView alloc] init];
    [self.view addSubview:pcinfoView];
    self.infoView = pcinfoView;
    pcinfoView.frame = CGRectMake(0, 0, CircleRadius * 2 * 0.6, CircleRadius * 2 *0.6);
    pcinfoView.center = CGPointMake(screen_wid/2, CGRectGetMinY(self.msgLabel.frame) - CGRectGetHeight(pcinfoView.frame)/2 - 10);
    /**
     CGRectGetHeight返回view本身的高度
     CGRectGetMinY返回view顶部的坐标
     CGRectGetMaxY 返回view底部的坐标
     CGRectGetMinX 返回view左边缘的坐标
     CGRectGetMaxX 返回view右边缘的坐标
     CGRectGetMidX表示得到一个frame中心点的X坐标
     CGRectGetMidY表示得到一个frame中心点的Y坐标
     */
}
-(void)setupLoginVC{
    
    [self.lockView setType:CircleViewTypeLogin];
    
    //头像
    UIImageView  *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 0, 65, 65);
    imageView.center = CGPointMake(kScreenW/2, kScreenH/5);
    [imageView setImage:[UIImage imageNamed:@"ic_menu_greenpig2"]];
    [self.view addSubview:imageView];
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)]];
    
    
    // 管理手势密码
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self creatButton:leftBtn frame:CGRectMake(CircleViewEdgeMargin + 20, kScreenH - 60, kScreenW/2, 20) title:@"管理手势密码" alignment:UIControlContentHorizontalAlignmentLeft tag:buttonManager];
    
    // 登录其他账户
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self creatButton:rightBtn frame:CGRectMake(kScreenW/2 - CircleViewEdgeMargin - 20, kScreenH - 60, kScreenW/2, 20) title:@"登陆其他账户" alignment:UIControlContentHorizontalAlignmentRight tag:buttonForget];

    
    
}

-(void)tapClick:(UITapGestureRecognizer *)tap{
    [tap.view boom];
}
#pragma mark - circleDelegate
/**
 *  连接少于4个点
 *
 */
-(void)circleView:(PCCircleView *)view type:(CircleViewType)type connectCirclesLessThanNeedWithGesture:(NSString *)gesture{
    
    NSString *one_gestures = [PCCircleViewConst getGestureWithKey:gestureOneSaveKey];
    
    if ([one_gestures length]) {
        self.resetBtn.hidden = NO;
        [self.msgLabel showWarnMsg:gestureTextDrawAgainError];
    }else{
        NSLog(@"长度不够%@",one_gestures);
        [self.msgLabel showWarnMsg:gestureTextConnectLess];
    }
    
    
}
/**
 *  第一个点绘制完成
 *
 */
-(void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteSetFirstGesture:(NSString *)gesture{
    
    NSLog(@"获得第一个手势密码%@", gesture);
    [self.msgLabel showWarnMsg:gestureTextDrawAgain];
    
    // infoView展示对应选中的圆

    [self infoViewSelectedSubviewsSameAsCircleView:view];
}
/**
 *  第二个点绘制完成
 *
 */
-(void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteSetSecondGesture:(NSString *)gesture result:(BOOL)equal{
    
    NSLog(@"获得第二个手势密码%@",gesture);
  
    
    if (equal) {
        NSLog(@"两次手势匹配！可以进行本地化保存了");

        [self.msgLabel showWarnMsg:gestureTextSetSuccess];
        [PCCircleViewConst saveGesture:gesture Key:gestureFinalSaveKey];
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        NSLog(@"两次手势不匹配！");
        [self.msgLabel showWarnMsgAndShake:gestureTextDrawAgainError];
        self.resetBtn.hidden = NO;
    }
    
    
}
/**
 *  验证,登录
 *
 */
-(void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteLoginGesture:(NSString *)gesture result:(BOOL)equal{
    
    
    // 此时的type有两种情况 Login or verify
    if (type == CircleViewTypeLogin) {
        
        if (equal) {
            
            [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@1
                       afterDelay:1];
            SHOWALERT(@"登录成功",self);
            
        
        } else {
            NSLog(@"密码错误！");
            [self.msgLabel showWarnMsgAndShake:gestureTextGestureVerifyError];
        }
    } else if (type == CircleViewTypeVerify) {
        
        if (equal) {
            NSLog(@"验证成功，跳转到设置手势界面");
            
        } else {
            NSLog(@"原手势密码输入错误！");
            
        }
    }

    
    
    
}
#pragma mark -
- (void)infoViewSelectedSubviewsSameAsCircleView:(PCCircleView *)circleView
{
    
    for (PCCircle *circle in circleView.subviews) {
        
        if ((circle.state == CircleStateSelected)||(circle.state == CircleStateLastOneSelected)) {
            
            for (PCCircle *circle_info in self.infoView.subviews) {
                if (circle.tag == circle_info.tag) {
                    [circle_info setState:CircleStateSelected];
                }
            }
            
        }
        
        
    }
    
    
}
- (void)infoViewDeselectedSubviews{
    [self.infoView.subviews enumerateObjectsUsingBlock:^(__kindof PCCircle * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [obj setState:CircleStateNormal];
        
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
