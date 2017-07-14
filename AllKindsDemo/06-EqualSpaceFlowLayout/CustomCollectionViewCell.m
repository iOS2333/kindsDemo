//
//  CustomCollectionViewCell.m
//  UICollectionViewDemo
//
//  Created by CHC on 15/5/12.
//  Copyright (c) 2015年 CHC. All rights reserved.
//

#import "CustomCollectionViewCell.h"

@interface CustomCollectionViewCell()
@end

@implementation CustomCollectionViewCell
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.layer.borderColor = [UIColor colorWithRed:99/255.0 green:99/255.0 blue:99/255.0 alpha:1.0].CGColor;
        self.layer.borderWidth = 0.8;
        
        self.label = [[UILabel alloc] initWithFrame:self.bounds];
        self.label.font = [UIFont systemFontOfSize:13];
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.textColor = [UIColor colorWithRed:99/255.0 green:99/255.0 blue:99/255.0 alpha:1.0];
        [self.contentView addSubview:self.label];
    }
    
    return self;
}

- (void)setContent:(NSString *)aContent
{
    self.label.frame = self.bounds;
    self.label.text = aContent;
    NSLog(@"label%@,num%@,text%@,labeltag%zd,self.frame%@",NSStringFromCGRect(self.label.frame),self.num,self.label.text,self.label.tag,NSStringFromCGRect(self.frame));
}
@end
