//
//  WordAniVC.m
//  AllKindsDemo
//
//  Created by kangjia on 2017/11/3.
//  Copyright © 2017年 jim_kj. All rights reserved.
//

#import "WordAniVC.h"
#import <CoreText/CoreText.h>
@interface WordAniVC ()<CAAnimationDelegate>
{
   
    CALayer *penLayer;
    CGRect tmprect;
}
@end

@implementation WordAniVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.view.backgroundColor = [UIColor blueColor];
    tmprect = CGRectMake(screen_wid/2 - 100, 50, 200,30);
    [self creatui];
  
}
-(void)creatui{
     UIBezierPath *path = [self getStringPath:@"效果如下图所示"];
    UIView *testview = [[UIView alloc] initWithFrame:tmprect];
    testview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:testview];
    //通过字体路径创建CAShapeLayer：
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.frame = testview.layer.bounds;
    pathLayer.bounds = CGPathGetBoundingBox(path.CGPath);
    pathLayer.backgroundColor = [[UIColor clearColor] CGColor];
    pathLayer.geometryFlipped = YES;
    pathLayer.path = path.CGPath;
    pathLayer.strokeColor = [UIColor colorWithRed:234.0/255 green:84.0/255 blue:87.0/255 alpha:1].CGColor;
    pathLayer.fillColor = [UIColor clearColor].CGColor;
    pathLayer.lineWidth = 1.0f;
    pathLayer.lineJoin = kCALineJoinMiter;
    [testview.layer addSublayer:pathLayer];
    
    
    
    //添加图片
    UIImage* penImage = [UIImage imageNamed:@"qianbitou.png"];
    penLayer = [CALayer layer];
    penLayer.contents = (id)penImage.CGImage;
    penLayer.anchorPoint = CGPointZero;
    penLayer.frame = CGRectMake(path.currentPoint.x, path.currentPoint.y, penImage.size.width*0.2, penImage.size.height*0.2);
    [pathLayer addSublayer:penLayer];
    
    //添加动画
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 20.0;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    [pathLayer addAnimation:pathAnimation forKey:@"strokeStart"];
    pathAnimation.speed = 1;
    pathAnimation.timeOffset = 0;
    
    
    CAKeyframeAnimation *penAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    penAnimation.duration = 20.0;
    penAnimation.path = pathLayer.path;
    penAnimation.calculationMode = kCAAnimationPaced;
    penAnimation.delegate = self;
    [penLayer addAnimation:penAnimation forKey:@"position"];
    [penAnimation setValue:penLayer forKey:@"pen"];
    
}
-(UIBezierPath *)getStringPath:(NSString *)pathstr{
    //创建可变的path
    CGMutablePathRef mutpath = CGPathCreateMutable();
    
    //设置字体
    CTFontRef font = CTFontCreateWithName(CFSTR("STHeiti K"), 25, NULL);
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)font,kCTFontAttributeName, nil];
    NSAttributedString *attristr = [[NSAttributedString alloc] initWithString:pathstr attributes:attrs];
    //根据字符串创建line
    CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)attristr);
    
    //获取每个字符作为数组
    CFArrayRef array = CTLineGetGlyphRuns(line);
    
    //遍历字符数组
    for (CFIndex i = 0; i<CFArrayGetCount(array); i++) {
        
        //获取每个字符的字体
        CTRunRef run = CFArrayGetValueAtIndex(array, i);
        CTFontRef runfont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);
        
        // for each GLYPH in run
        for (CFIndex runGlyphIndex = 0; runGlyphIndex < CTRunGetGlyphCount(run); runGlyphIndex++)
        {
            // get Glyph & Glyph-data
            CFRange thisGlyphRange = CFRangeMake(runGlyphIndex, 1);
            CGGlyph glyph;
            CGPoint position;
            CTRunGetGlyphs(run, thisGlyphRange, &glyph);
            CTRunGetPositions(run, thisGlyphRange, &position);
            // Get PATH of outline
            {
                
                CGPathRef letter = CTFontCreatePathForGlyph(runfont, glyph, NULL);
                CGAffineTransform t = CGAffineTransformMakeTranslation(position.x, position.y);
                CGPathAddPath(mutpath, &t, letter);
                CGPathRelease(letter);
            }
        }
       
    }
    CFRelease(line);
    UIBezierPath *paths = [UIBezierPath bezierPath];
    [paths moveToPoint:CGPointZero];
    [paths appendPath:[UIBezierPath bezierPathWithCGPath:mutpath]];
    CGPathRelease(mutpath);
    CFRelease(font);
    return paths;
    

}
//delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (flag) {
        [penLayer removeFromSuperlayer];
        CGFloat yy = tmprect.origin.y+tmprect.size.height;
        tmprect = CGRectMake(screen_wid/2 - 100, yy, 200,30);
        if (yy<screen_height/2) {
            [self creatui];
        }
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return 0;
//}
//
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
