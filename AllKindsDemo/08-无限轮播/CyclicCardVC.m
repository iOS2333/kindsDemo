//
//  CyclicCardVC.m
//  AllKindsDemo
//
//  Created by kangjia on 2017/7/5.
//  Copyright © 2017年 jim_kj. All rights reserved.
//

#import "CyclicCardVC.h"
#import "CyclicCardFlowLayout.h"
#import "CyclicCardCell.h"
#define cellID @"cellid"
@interface CyclicCardVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UIView *bkview;
    UICollectionView *collectionview;
    UILabel *showLabel;
    UILabel *currentLabel;
    CGFloat groupCount;
    NSMutableArray *imageArr;
    NSMutableArray *indexArr;
}
@end

@implementation CyclicCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    groupCount = 10;
    imageArr = [NSMutableArray arrayWithArray:@[@"num_1",@"num_2",@"num_3",@"num_4",@"num_5"]];
    indexArr = [NSMutableArray array];
    
    for (NSInteger i = 0; i<groupCount; i++) {
        for (NSInteger j = 0; j<imageArr.count; j++) {
            [indexArr addObject:[NSNumber numberWithInteger:j]];
        }
    }
    
    [self makeUI];
      [collectionview scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:groupCount/2*imageArr.count inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:false];
    // Do any additional setup after loading the view.
}
-(void)makeUI{
    self.automaticallyAdjustsScrollViewInsets = YES;
    bkview = [[UIView alloc] initWithFrame:CGRectMake(0, 64, screen_wid, 240)];
    bkview.backgroundColor = [UIColor colorWithRed:74/255.0 green:163/255.0 blue:243/255.0 alpha:1.0];//red: 74/255.0, green: 163/255.0, blue: 243/255.0, alpha: 1.0
    [self.view addSubview:bkview];
    showLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64+240, screen_wid, 40)];
    showLabel.textAlignment = NSTextAlignmentCenter;
//    showLabel.text = @"滚动到1张";
    [self.view addSubview:showLabel];
    currentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64+240+40, screen_wid, 40)];
    currentLabel.textAlignment = NSTextAlignmentCenter;
//    currentLabel.text = @"点击第1张图片";
    [self.view addSubview:currentLabel];
    [self setCollection];
}
-(void)setCollection{
    
    CGFloat padding = 10;
    
    CyclicCardFlowLayout *cyc = [[CyclicCardFlowLayout alloc] init];
    
    cyc.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    cyc.minimumLineSpacing = padding;
    
    cyc.minimumInteritemSpacing = padding;
    
    cyc.sectionInset = UIEdgeInsetsMake(padding, 0, padding, 0);
    
    CGFloat itemW = (screen_wid - padding * 2) *0.5;
    
    cyc.itemSize = CGSizeMake(itemW, bkview.frame.size.height - padding*2);
    
    collectionview = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, screen_wid, bkview.frame.size.height) collectionViewLayout:cyc];
    
    collectionview.showsHorizontalScrollIndicator = false;
    collectionview.delegate = self;
    collectionview.dataSource = self;
    [collectionview registerClass:[CyclicCardCell class] forCellWithReuseIdentifier:cellID];
    [bkview addSubview:collectionview];
    
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return indexArr.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CyclicCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    cell.index = [indexArr[indexPath.row] integerValue];
    cell.cardimage.image = [UIImage imageNamed:imageArr[cell.index]];
    cell.cardtitle.text = @"滚动吧";
    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CyclicCardCell *cell = (CyclicCardCell *)[collectionview cellForItemAtIndexPath:indexPath];
    currentLabel.text = [NSString stringWithFormat:@"点击第%zd张图片",cell.index+1];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGPoint pointInView = [self.view convertPoint:collectionview.center toView:collectionview];
    NSIndexPath *indexPathNow = [collectionview indexPathForItemAtPoint:pointInView];
    NSInteger index = indexPathNow.row%imageArr.count;
    showLabel.text = [NSString stringWithFormat:@"滚动到第%zd张",index+1];
    [collectionview scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:groupCount/2*imageArr.count +index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:false];
    
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
