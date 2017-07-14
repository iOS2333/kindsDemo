//
//  CollectionVC.m
//  AllKindsDemo
//
//  Created by kangjia on 2017/5/19.
//  Copyright © 2017年 jim_kj. All rights reserved.
//

#import "CollectionVC.h"

#import "EqualSpaceFlowLayout.h"
#import "ItemData.h"
#import "CustomCollectionViewCell.h"

@interface CollectionVC ()<UICollectionViewDataSource,UICollectionViewDelegate,EqualSpaceFlowLayoutDelegate>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation CollectionVC
- (void)addContentView
{
    EqualSpaceFlowLayout *flowLayout = [[EqualSpaceFlowLayout alloc] init];
    flowLayout.delegate = self;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, screen_wid, screen_height-64) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor lightGrayColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[CustomCollectionViewCell class] forCellWithReuseIdentifier:@"CellIdentifier"];
}

- (void)loadData
{
    self.dataArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 23; i++) {
        ItemData *itemData = [[ItemData alloc] init];
        itemData.content = [NSString stringWithFormat:@"%d",i];
        if (i==0) {
            itemData.size = CGSizeMake((screen_wid-1)/2,33);
        }else{
            itemData.size = CGSizeMake((screen_wid-1)/2,33);
        }
        
        [self.dataArray addObject:itemData];
    }
}

#pragma mark - lifeCycle methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self loadData];
    [self addContentView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *moreCellIdentifier = @"CellIdentifier";
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:moreCellIdentifier forIndexPath:indexPath];
    
    ItemData *itemData = [self.dataArray objectAtIndex:[indexPath row]];
    cell.num = [NSNumber numberWithInteger:indexPath.row];
    cell.content = itemData.content;
    NSLog(@"%@,%@",NSStringFromCGRect(cell.frame),cell.num);
    [cell setNeedsLayout];
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CustomCollectionViewCell *cell = (CustomCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    //    if (self.dataArray.count > 0) {
    //        [self.dataArray removeAllObjects];
    //    }
    for (int i = 0; i < self.dataArray.count; i++) {
        ItemData *itemData = [self.dataArray objectAtIndex:i];
        itemData.content = [NSString stringWithFormat:@"%d",i];
        if (i == indexPath.row && [cell.num integerValue] == indexPath.row) {
            if (cell.frame.size.height == 67) {
                itemData.size = CGSizeMake((screen_wid-1)/2,33);
            }else{
                itemData.size = CGSizeMake((screen_wid-1)/2,67);
                
            }
        }else{
            itemData.size = CGSizeMake((screen_wid-1)/2,33);
        }
    }
    [collectionView reloadData];
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ItemData *itemData = [self.dataArray objectAtIndex:[indexPath row]];
    return itemData.size;
}

@end
