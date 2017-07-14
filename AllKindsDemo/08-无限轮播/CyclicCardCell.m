//
//  CyclicCardCell.m
//  AllKindsDemo
//
//  Created by kangjia on 2017/7/3.
//  Copyright © 2017年 jim_kj. All rights reserved.
//

#import "CyclicCardCell.h"

@implementation CyclicCardCell
-(UIImageView *)cardimage{
    if (_cardimage == nil) {
        _cardimage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
        
    }
    return _cardimage;
}
-(UILabel *)cardtitle{
    if (_cardtitle == nil) {
        _cardtitle = [[UILabel alloc] init];
    }
    return _cardtitle;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];//(red: 102.0/255.0, green: 102.0/255.0, blue: 102.0/255.0, alpha: 1.0
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.cornerRadius = 5.0;
        [self.contentView addSubview:self.cardimage];
        [self.contentView addSubview:self.cardtitle];
        self.cardtitle.frame = CGRectMake(0, self.cardimage.frame.origin.y +self.cardimage.frame.size.height, self.cardimage.frame.size.width, self.bounds.size.height - self.cardimage.frame.origin.y - self.cardimage.frame.size.height);
        self.cardtitle.textAlignment = NSTextAlignmentCenter;
        self.cardtitle.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];//red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0
        self.cardtitle.font = [UIFont systemFontOfSize:15];
        
    }
    return self;
}
@end
