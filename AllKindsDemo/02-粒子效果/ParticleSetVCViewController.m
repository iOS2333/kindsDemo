//
//  ParticleSetVCViewController.m
//  AllKindsDemo
//
//  Created by kangjia on 2017/5/10.
//  Copyright © 2017年 jim_kj. All rights reserved.
//

#import "ParticleSetVCViewController.h"
#import <QuartzCore/CoreAnimation.h>
#import <CoreMotion/CoreMotion.h>
#import "UIButton+Bubbling.h"
#import "UIView+Boom.h"
@interface ParticleSetVCViewController (){
    NSArray *name_arr;
    CAEmitterLayer *dazlayer;
    CAEmitterLayer *snowEmitter;
}
@property (assign,nonatomic) BOOL isDropping;
@property (strong,nonatomic) UIDynamicAnimator * animator;
@property (strong,nonatomic) UIGravityBehavior * gravityBehavior;
@property (strong,nonatomic) UICollisionBehavior *collisionBehavitor;
@property (strong,nonatomic) UIDynamicItemBehavior *itemBehavitor;
@property (strong,nonatomic) CMMotionManager *motionMManager;
@property (strong,nonatomic) NSMutableArray *dropsArray;
@property (strong,nonatomic) UIImageView *leftShoot;
@property (strong,nonatomic) UIImageView *rightShoot;
@property (nonatomic, strong) dispatch_source_t timer;



@property (strong,nonatomic) UIButton *bubbeBtn;

@property (strong,nonatomic) NSArray *images;


@end

@implementation ParticleSetVCViewController
-(void)viewWillAppear:(BOOL)animated{
    self.navAlpha = @"0.0";
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    name_arr = @[@"粒子掉落",@"烟花效果",@"礼物冒泡",@"雪花飘落"];
    NSInteger grain_h = 0;
    NSInteger grain_x = (screen_wid - name_arr.count *60)/(name_arr.count+1);
    NSInteger xx = grain_x;
    for (NSInteger i = 0; i<name_arr.count; i++) {
        
        UIButton *grain_btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        grain_btn.frame = CGRectMake(xx, 100, 60, 30);
        
        grain_btn.selected = NO;
        [self.view addSubview:grain_btn];
        grain_btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [grain_btn setBackgroundColor:[UIColor lightGrayColor]];
        [grain_btn setTitle:name_arr[i] forState:UIControlStateNormal];
        [grain_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [grain_btn addTarget:self action:@selector(grain_btn_click:) forControlEvents:UIControlEventTouchUpInside];
        grain_btn.tag = 100 + i;
        grain_h = grain_btn.frame.origin.y + grain_btn.frame.size.height;
        xx += (grain_btn.frame.size.width + grain_x);
    }

    
}
#pragma mark - 选择
-(void)grain_btn_click:(UIButton *)sender{
    switch (sender.tag) {
        case 100:
        {
            if (sender.selected) {
                sender.selected = NO;
                [sender setTitle:name_arr[sender.tag - 100] forState:UIControlStateNormal];
                [self dropremove];
            }else{
                [self drop];
                sender.selected = YES;
                [sender setTitle:@"清除" forState:UIControlStateNormal];
            }
        }
            break;
        case 101:
        {
            if (sender.selected) {
                sender.selected = NO;
                [sender setTitle:name_arr[sender.tag - 100] forState:UIControlStateNormal];
                [self dazremove];
            }else{
                [self daz];
                sender.selected = YES;
                [sender setTitle:@"清除" forState:UIControlStateNormal];
            }
        }
            break;
        case 102:
        {
            if (sender.selected) {
                sender.selected = NO;
                [sender setTitle:name_arr[sender.tag - 100] forState:UIControlStateNormal];
            [self bubbingremove];
            }else{
                sender.selected = YES;
                [sender setTitle:@"清除" forState:UIControlStateNormal];
                [self bubbingLove];
            }
            
        }
            break;
        case 103:
        {
            if (sender.selected) {
            sender.selected = NO;
                self.view.backgroundColor = [UIColor whiteColor];
            [sender setTitle:name_arr[sender.tag - 100] forState:UIControlStateNormal];
            [self snowremove];
        }else{
            self.view.backgroundColor = [UIColor redColor];
            
            sender.selected = YES;
            [sender setTitle:@"清除" forState:UIControlStateNormal];
            [self showSnowFlake];
        }
        }
            break;
        case 104:
        {
            
        }
            break;
        default:
            break;
    }
}
#pragma  mark - 雪花飘落
-(void)showSnowFlake{
    //粒子发射器
    snowEmitter = [CAEmitterLayer layer];
    //粒子发射的位置
    snowEmitter.emitterPosition = CGPointMake(screen_wid/2, 30);
    //发射源的大小
    snowEmitter.emitterSize        = CGSizeMake(self.view.bounds.size.width, 0.0);;
    //发射模式
    snowEmitter.emitterMode        = kCAEmitterLayerOutline;
    //发射源的形状
    snowEmitter.emitterShape    = kCAEmitterLayerRectangle;
    
    //创建雪花粒子
    CAEmitterCell *snowflake = [CAEmitterCell emitterCell];
    //粒子的名称
    snowflake.name = @"snow";
    //粒子参数的速度乘数因子。越大出现的越快
    snowflake.birthRate        = 1.0;
    //存活时间
    snowflake.lifetime        = 120.0;
    //粒子速度
    snowflake.velocity        = -10;                // falling down slowly
    //粒子速度范围
    snowflake.velocityRange = 20;
    //粒子y方向的加速度分量
    snowflake.yAcceleration = 2;
    //周围发射角度
    snowflake.emissionRange = 0.3 * M_PI;        // some variation in angle
    //子旋转角度范围
    snowflake.spinRange        = 0.5 * M_PI;        // slow spin
    //粒子图片
    snowflake.contents        = (id) [[UIImage imageNamed:@"DazFlake"] CGImage];
    //粒子颜色
    snowflake.color            = [[UIColor whiteColor] CGColor];
    
    //设置阴影
    snowEmitter.shadowOpacity = 1.0;
    snowEmitter.shadowRadius  = 0.0;
    snowEmitter.shadowOffset  = CGSizeMake(0.0, 1.0);
    snowEmitter.shadowColor   = [[UIColor whiteColor] CGColor];
    
    // 将粒子添加到粒子发射器上
    snowEmitter.emitterCells = [NSArray arrayWithObject:snowflake];
    [self.view.layer insertSublayer:snowEmitter atIndex:0];
}
#pragma mark - 礼物冒泡

-(void)bubbingLove{
    UIImage *bubbing_image = [UIImage imageNamed:@"ab-main-libao-white"];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(screen_wid/2 - bubbing_image.size.width*3/2, screen_height/2 - bubbing_image.size.height*3/2, bubbing_image.size.width*3, bubbing_image.size.height*3)];
    button.backgroundColor = [UIColor grayColor];
    
    [button setImage:bubbing_image forState:UIControlStateNormal];
    [button.layer shake];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(bubbing) forControlEvents:UIControlEventTouchUpInside];
    self.bubbeBtn = button;

    _images = @[@"ic_menu_bluepig",
                @"ic_menu_bluepig2",
                @"ic_menu_greenpig",
                @"ic_menu_greenpig2",
                @"ic_menu_pinkpig",
                @"ic_menu_pinkpig2",
                @"ic_menu_purplepig",
                @"ic_menu_purplepig2",
                @"ic_menu_yellowpig",
                @"ic_menu_yellowpig2"];
  
}
-(void)bubbing{
    [self.bubbeBtn bubbingImage:[UIImage imageNamed:@"love"]];
    [self.bubbeBtn bubbingImages:_images];
}
#pragma mark @"粒子掉落"
-(void)drop{
    [self startMotion];
    UIImage *love = [UIImage imageNamed:@"love"];
    UIImage *star = [UIImage imageNamed:@"star"];
    [self dropWithCount:100 images:@[love,star]];
    
    [self serialDrop];}
//串行
-(void)serialDrop{
    if (_isDropping) return;
    _isDropping = YES;
    dispatch_queue_t queue = dispatch_get_main_queue();
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));/**< 延迟一秒执行*/
    uint64_t interval = (uint64_t)(0.05 * NSEC_PER_SEC);
    dispatch_source_set_timer(self.timer, start, interval, 0);
    // 设置回调
    dispatch_source_set_event_handler(self.timer, ^{
        if (self.dropsArray.count == 0) return;
        NSMutableArray *currentDrops = self.dropsArray[0];
        
        if ([currentDrops count]) {
            if (currentDrops.count == 0) return;
            UIImageView * dropView = currentDrops[0];
            [currentDrops removeObjectAtIndex:0];
            [self.view addSubview:dropView];
            UIPushBehavior *pushBehavior = [[UIPushBehavior alloc] initWithItems:@[dropView] mode:UIPushBehaviorModeInstantaneous];
            [self.animator addBehavior:pushBehavior];
            //角度范围 ［0.6 1.0］
            float random = ((int)( (arc4random() % (2))))*0.1;
            
            NSLog(@"%f",random);
            
            pushBehavior.pushDirection = CGVectorMake(-random,-random);
            
            pushBehavior.magnitude = 0.3;
            [self.gravityBehavior addItem:dropView];
            [self.collisionBehavitor addItem:dropView];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                dropView.alpha = 0;
                [self.gravityBehavior removeItem:dropView];
                [self.collisionBehavitor removeItem:dropView];
                [pushBehavior removeItem:dropView];
                [self.animator removeBehavior:pushBehavior];
                [dropView removeFromSuperview];
            });
            
        }else{
            dispatch_source_cancel(self.timer);
            [self.dropsArray removeObject:currentDrops];
            _isDropping = NO;
            if (self.dropsArray.count) {
                [self serialDrop];
            }
        }
        
    });
    dispatch_source_set_cancel_handler(_timer, ^{
        
    });
    //启动
    dispatch_resume(self.timer);
    
}
#pragma mark 设置陀螺仪
- (void)startMotion
{
    
    if(_motionMManager.accelerometerAvailable)
    {
        if (!_motionMManager.accelerometerActive)
        {
            _motionMManager.accelerometerUpdateInterval = 1.0/3.0;
            __unsafe_unretained typeof(self) weakSelf = self;
            [_motionMManager
             startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc] init]
             withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
                 
                 if (error)
                 {
                     NSLog(@"CoreMotion Error : %@",error);
                     [_motionMManager stopAccelerometerUpdates];
                 }
                 CGFloat a = accelerometerData.acceleration.x;
                 CGFloat b = accelerometerData.acceleration.y;
                 CGVector gravityDirection = CGVectorMake(a,-b);
                 weakSelf.gravityBehavior.gravityDirection = gravityDirection;
             }];
        }
        
    }
    else
    {
        NSLog(@"The accelerometer is unavailable");
    }
}
- (NSMutableArray *)dropWithCount:(int)count images:(NSArray *)images
{
    NSMutableArray *viewArray = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < count; i++) {
        
        UIImage *image = [images objectAtIndex:rand()%[images count]];
        UIImageView * imageView =[[UIImageView alloc ]initWithImage:image];
        imageView.contentMode = UIViewContentModeCenter;
        imageView.center = CGPointMake(screen_wid/2, 160);
        imageView.tag = 11;
        [viewArray addObject:imageView];
    }
    [self.dropsArray addObject:viewArray];
    return _dropsArray;
    
}

- (UIDynamicAnimator *)animator{
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
        /** 重力效果*/
        self.gravityBehavior = [[UIGravityBehavior alloc] init];
        //        self.gravityBehavior.gravityDirection = CGVectorMake(0.5,1);
        /** 碰撞效果*/
        self.collisionBehavitor = [[UICollisionBehavior alloc] init];
        [self.collisionBehavitor setTranslatesReferenceBoundsIntoBoundary:YES];
        [_animator addBehavior:self.gravityBehavior];
        [_animator addBehavior:self.collisionBehavitor];
    }
    return _animator;
}

-(NSMutableArray *)dropsArray{
    if (nil == _dropsArray) {
        _dropsArray = [NSMutableArray array];
    }
    return _dropsArray;
}
#pragma mark @"烟花效果"
- (void)daz{
    CGRect viewBounds = self.view.layer.bounds;
    
    dazlayer = [CAEmitterLayer layer];//初始化
    
    dazlayer.emitterPosition = CGPointMake(viewBounds.size.width/2, viewBounds.size.height-10);//粒子发射的位置
    dazlayer.emitterSize = CGSizeMake(0, 0);//发射源尺寸大小
    /**
     * emitterMode' values.
     
     CA_EXTERN NSString * const kCAEmitterLayerPoints
     __OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);
     CA_EXTERN NSString * const kCAEmitterLayerOutline
     __OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);
     CA_EXTERN NSString * const kCAEmitterLayerSurface
     __OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);
     CA_EXTERN NSString * const kCAEmitterLayerVolume
     __OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);
     *
     *
     */
    dazlayer.emitterMode = kCAEmitterLayerVolume;//发射源模式
    /**
     *  emitterShape' values.
     
     CA_EXTERN NSString * const kCAEmitterLayerPoint
     __OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);
     CA_EXTERN NSString * const kCAEmitterLayerLine
     __OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);
     CA_EXTERN NSString * const kCAEmitterLayerRectangle
     __OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);
     CA_EXTERN NSString * const kCAEmitterLayerCuboid
     __OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);
     CA_EXTERN NSString * const kCAEmitterLayerCircle
     __OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);
     CA_EXTERN NSString * const kCAEmitterLayerSphere
     __OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);
     *
     *
     */
    dazlayer.emitterShape = kCAEmitterLayerLine;//发射源形状
    /**
     *  renderMode' values.
     
     CA_EXTERN NSString * const kCAEmitterLayerUnordered
     __OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);
     CA_EXTERN NSString * const kCAEmitterLayerOldestFirst
     __OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);
     CA_EXTERN NSString * const kCAEmitterLayerOldestLast
     __OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);
     CA_EXTERN NSString * const kCAEmitterLayerBackToFront
     __OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);
     CA_EXTERN NSString * const kCAEmitterLayerAdditive
     __OSX_AVAILABLE_STARTING (__MAC_10_6, __IPHONE_5_0);
     *
     *
     */
    dazlayer.renderMode = kCAEmitterLayerAdditive;//渲染模式
    
    dazlayer.velocity = 1;//发射方向
    
    dazlayer.seed = (arc4random()%100)+1;//用于初始化随机数产生的种子
    
    // Create the rocket
    CAEmitterCell *rocket = [CAEmitterCell emitterCell];
    
    rocket.birthRate		= 2.0;//粒子产生系数，默认1.0
    rocket.emissionRange	= M_PI/8.0;  // some variation in angle//周围发射角度
    rocket.velocity			= 400;//速度
    rocket.velocityRange	= 100;//速度范围
    rocket.yAcceleration	= 200;//粒子y方向的加速度分量
    rocket.lifetime			= 1.05;	// we cannot set the birthrate < 1.0 for the burst//生命周期
    
    rocket.contents			= (id) [[UIImage imageNamed:@"love"] CGImage];//是个CGImageRef的对象,既粒子要展现的图片
    rocket.scale			= 0.2;//缩放比例
    rocket.color			= [[UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0] CGColor];//[[UIColor redColor] CGColor];//粒子的颜色
    rocket.greenRange		= 1.0;		// different colors//一个粒子的颜色green 能改变的范围
    rocket.redRange			= 1.0;//一个粒子的颜色red 能改变的范围
    rocket.blueRange		= 1.0;//一个粒子的颜色blue 能改变的范围
    rocket.spinRange		= M_PI;		// slow spin//子旋转角度范围
    
    
    
    // 爆炸 the burst object cannot be seen, but will spawn the sparks
    // we change the color here, since the sparks inherit its value
    CAEmitterCell* burst = [CAEmitterCell emitterCell];
    
    burst.birthRate			= 1.0;		// at the end of travel//粒子产生系数，默认为1.0
    burst.velocity			= 0;    //速度
    burst.scale				= 2.0;  //缩放比例
    burst.redSpeed			=-1.5;		// shifting粒子red在生命周期内的改变速度
    burst.blueSpeed			=+0.5;		// shifting粒子blue在生命周期内的改变速度
    burst.greenSpeed		=+1.0;		// shifting粒子green在生命周期内的改变速度
    burst.lifetime			= 0.3; //生命周期
    
    // 火花 and finally, the sparks
    CAEmitterCell* spark = [CAEmitterCell emitterCell];
    
    spark.birthRate			= 2000;//粒子产生系数，默认为1.0
    spark.velocity			= 100;//速度
    spark.emissionRange		= 2* M_PI;	// 360 deg//周围发射角度
    spark.yAcceleration		= 75;		// gravity//y方向上的加速度分量
    spark.lifetime			= 3.0;    //粒子生命周期
    
    spark.contents			= (id) [[UIImage imageNamed:@"FFTspark"] CGImage];//是个CGImageRef的对象,既粒子要展现的图片
    spark.scaleSpeed		=-0.3;  //缩放比例速度
    spark.greenSpeed		=-0.1;  //粒子green在生命周期内的改变速度
    spark.redSpeed			= 0.4;  //粒子red在生命周期内的改变速度
    spark.blueSpeed			=-0.1;  //粒子blue在生命周期内的改变速度
    spark.alphaSpeed		=-0.6; //粒子透明度在生命周期内的改变速度
    spark.spin				= 2* M_PI;  //子旋转角度
    spark.spinRange			= 2* M_PI;  //子旋转角度范围
    
    // First traigles are emitted, which then spawn circles and star along their path
    dazlayer.emitterCells = [NSArray arrayWithObject:rocket];
    rocket.emitterCells = [NSArray arrayWithObjects:burst, nil];
    burst.emitterCells = [NSArray arrayWithObject:spark];
    //	circle.emitterCells = [NSArray arrayWithObject:star];	// this is SLOW!
    [self.view.layer addSublayer:dazlayer];
    
    
    
    
    
    
}
#pragma  mark - 清除
-(void)dropremove{
    // 停止陀螺仪
    [_motionMManager stopAccelerometerUpdates];
    _isDropping = NO;
    if (_timer) {
        dispatch_cancel(_timer);
        _timer = nil;
    }
    for (UIDynamicBehavior *behavior in _animator.behaviors)
    {
        if (behavior == self.gravityBehavior)
        {
            for (UIImageView *v in self.gravityBehavior.items)
            {
                [self.gravityBehavior removeItem:v];
                if (v.superview)[v removeFromSuperview];
            }
            continue;
        }
        else if (behavior == self.collisionBehavitor)
        {
            for (UIImageView *v in self.collisionBehavitor.items) {
                [self.collisionBehavitor removeItem:v];
                if (v.superview)[v removeFromSuperview];
            }
            continue;
        }
        else [_animator removeBehavior:behavior];;
    }
    self.animator = nil;
    [self.dropsArray removeAllObjects];
}

-(void)dazremove{
    [dazlayer removeFromSuperlayer];
}
-(void)bubbingremove{
    [self.bubbeBtn removeFromSuperview];
}
-(void)snowremove{
    [snowEmitter  removeFromSuperlayer];
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
