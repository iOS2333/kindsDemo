//
//  OCAndJS.m
//  AllKindsDemo
//
//  Created by kangjia on 2017/6/13.
//  Copyright © 2017年 jim_kj. All rights reserved.
//

#import "OCAndJS.h"

@interface OCAndJS ()<UIWebViewDelegate>
@property(nonatomic,strong) UIWebView *webview;
@end

@implementation OCAndJS

-(UIWebView *)webview{
    if (_webview == nil) {
        
        _webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, screen_wid, (screen_height-64)/2)];
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
        NSURL *baseURL = [[NSBundle mainBundle] bundleURL];
        [_webview loadHTMLString:[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil] baseURL:baseURL];
        [self.view addSubview:_webview];
        
    }
    return _webview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.webview.delegate = self;
    self.view.backgroundColor = [UIColor lightGrayColor];
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, self.webview.frame.origin.y + self.webview.frame.size.height+40, screen_wid, 40)];
    lb.textAlignment = NSTextAlignmentCenter;
    lb.text = @"小红手机号: 180 0000 1111";
    [self.view addSubview:lb];
    NSArray *arr = @[@"小黄手机号",@"打电话给小黄",@"发短信给小黄"];
    CGFloat mary = lb.frame.origin.y + lb.frame.size.height;
    for (NSInteger i = 0; i < 3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(60, mary, screen_wid - 120, 60);
        mary += CGRectGetHeight(btn.frame);
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [self.view addSubview:btn];
        btn.tag = 100+i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    
    
}
#pragma mark - btnClick
-(void)btnClick:(UIButton *)sender{
    
    if (sender.tag == 100) {
        NSString *title = [self.webview stringByEvaluatingJavaScriptFromString:@"title"];
        NSLog(@"title:%@",title);
        [self.webview stringByEvaluatingJavaScriptFromString:@"alertMobile()"];
    }else  if (sender.tag == 101) {
        [self.webview stringByEvaluatingJavaScriptFromString:@"alertName('小红')"];
    }else {
        [self.webview stringByEvaluatingJavaScriptFromString:@"alertSendMsg('180 0000 1111','周末爬山真是件愉快的事情')"];
    }
    
}
#pragma mark - JS调用OC方法列表
- (void)showMobile {
    [self showMsg:@"我是下面的小红 手机号是:180 0000 1111"];
}

- (void)showName:(NSString *)name {
    NSString *info = [NSString stringWithFormat:@"你好 %@, 很高兴见到你",name];
    
    [self showMsg:info];
}

- (void)showSendNumber:(NSString *)num msg:(NSString *)msg {
    NSString *info = [NSString stringWithFormat:@"这是我的手机号: %@, %@ !!",num,msg];
    
    [self showMsg:info];
}
- (void)showMsg:(NSString *)msg {
    [[[UIAlertView alloc] initWithTitle:@"信息" message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
}
#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"%@",NSStringFromSelector(_cmd));
    
    //OC调用JS是基于协议拦截实现的 下面是相关操作
    NSString *absolutePath = request.URL.absoluteString;
    
    NSString *scheme = @"rrcc://";
    
    if ([absolutePath hasPrefix:scheme]) {
        NSString *subPath = [absolutePath substringFromIndex:scheme.length];
        
        if ([subPath containsString:@"?"]) {//1个或多个参数
            
            if ([subPath containsString:@"&"]) {//多个参数
                NSArray *components = [subPath componentsSeparatedByString:@"?"];
                
                NSString *methodName = [components firstObject];
                
                methodName = [methodName stringByReplacingOccurrencesOfString:@"_" withString:@":"];
                SEL sel = NSSelectorFromString(methodName);
                
                NSString *parameter = [components lastObject];
                NSArray *params = [parameter componentsSeparatedByString:@"&"];
                
                if (params.count == 2) {
                    if ([self respondsToSelector:sel]) {
                        [self performSelector:sel withObject:[params firstObject] withObject:[params lastObject]];
                    }
                }
                
                
            } else {//1个参数
                NSArray *components = [subPath componentsSeparatedByString:@"?"];
                
                NSString *methodName = [components firstObject];
                methodName = [methodName stringByReplacingOccurrencesOfString:@"_" withString:@":"];
                SEL sel = NSSelectorFromString(methodName);
                
                NSString *parameter = [components lastObject];
                
                if ([self respondsToSelector:sel]) {
                    [self performSelector:sel withObject:parameter];
                }
                
            }
            
        } else {//没有参数
            NSString *methodName = [subPath stringByReplacingOccurrencesOfString:@"_" withString:@":"];
            SEL sel = NSSelectorFromString(methodName);
            
            if ([self respondsToSelector:sel]) {
                [self performSelector:sel];
            }
        }
    }
    
    return YES;
}


- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"%@",NSStringFromSelector(_cmd));
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"%@",NSStringFromSelector(_cmd));
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
