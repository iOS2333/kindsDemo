//
//  CyclicCardCell.h
//  AllKindsDemo
//
//  Created by kangjia on 2017/7/3.
//  Copyright © 2017年 jim_kj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CyclicCardCell : UICollectionViewCell
@property (nonatomic,assign) NSInteger index;
@property (nonatomic,retain) UIImageView *cardimage;
@property (nonatomic,retain) UILabel *cardtitle;
@end
