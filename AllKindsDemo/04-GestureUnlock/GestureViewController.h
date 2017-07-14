//
//  GestureViewController.h
//  MasonyDemo
//
//  Created by kangjia on 16/9/3.
//  Copyright © 2016年 jim_kj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    
    GestureViewControllerTypeSetting = 1,
    
    GestureViewControllerTypeLogin
    
}GestureViewControllerType;

typedef enum {

    buttonReset = 10,
    buttonForget,
    buttonManager
    
}buttonTag;

@interface GestureViewController : UIViewController
@property(nonatomic,assign) GestureViewControllerType type;
@end
