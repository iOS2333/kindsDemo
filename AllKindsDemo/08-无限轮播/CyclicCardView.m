//
//  CyclicCardView.m
//  AllKindsDemo
//
//  Created by kangjia on 2018/3/29.
//  Copyright © 2018年 jim_kj. All rights reserved.
//

#import "CyclicCardView.h"
#import "CyclicCardFlowLayout.h"
#import "CyclicCardCell.h"
#import "NSTimer+ScrollTimer.h"

#define cellID @"cellid"

@interface CyclicCardView()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionView *collectionview;
    CGFloat groupCount;
    NSMutableArray *indexArr;
    UIPageControl *pageControl;
    
}
@property(nonatomic,strong) NSMutableArray *imageArr;//数据源
@property (nonatomic,strong) NSTimer *animationTimer;
@property(nonatomic,assign) CGFloat paddings;
@property(nonatomic,assign) CGFloat itemsW;
@property(nonatomic,assign) CGFloat itemsH;
@end

@implementation CyclicCardView

- (instancetype)
initWithFrame:(CGRect)frame
withImages:(NSArray *)imagearr
withSacle:(NSDictionary *)scale;

{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        if([scale objectForKey:@"padding"])
        {
            self.paddings = [[scale objectForKey:@"padding"] floatValue];
            
        }else{
            self.paddings = 14.00*(screen_wid/375.00);
        }
        
        if([scale objectForKey:@"itemsW"])
        {
            self.itemsW = [[scale objectForKey:@"itemsW"] floatValue];
            
        }else{
            self.itemsW = 323.00*(screen_wid/375.00);
        }
        if([scale objectForKey:@"itemsH"])
        {
            self.itemsH = self.itemsW*[[scale objectForKey:@"itemsH"] floatValue];
            
        }else{
            self.itemsH = self.itemsW*(228.00/323.00);
        }
       
        groupCount = 10;
        self.imageArr = [NSMutableArray arrayWithArray:imagearr];
        indexArr = [NSMutableArray array];
        for (NSInteger i = 0; i<groupCount; i++) {
            for (NSInteger j = 0; j<self.imageArr.count; j++) {
                [indexArr addObject:[NSNumber numberWithInteger:j]];
            }
        }
        self.autoresizesSubviews = YES;
        [self setCollection];
        
    }
    return self;
}
-(void)setImageviewscale:(CGFloat)imageviewscale{
    if (imageviewscale) {
        
    }
}
-(void)setPadding:(CGFloat)padding{
    
}
-(void)setAutoscrol:(BOOL)Autoscrol{
    if(Autoscrol){
        [self startAnimationTimer];
    }else{
        if (self.animationTimer) {
            [self.animationTimer pauseTimer];
        }
    }
}
-(void)setCollection{
    
    CGFloat padding = self.paddings;
    
    
    
    
    CyclicCardFlowLayout *cyc = [[CyclicCardFlowLayout alloc] init];
    
    cyc.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    cyc.minimumLineSpacing = padding;
    
    cyc.minimumInteritemSpacing = padding;
    
    cyc.sectionInset = UIEdgeInsetsMake(padding, 0, padding, 0);
    
    CGFloat itemW = self.itemsW;
    CGFloat itemH = self.itemsH;
    cyc.itemSize = CGSizeMake(itemW, itemH);
    
    collectionview = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width,self.bounds.size.height) collectionViewLayout:cyc];
    
    collectionview.backgroundColor = [UIColor clearColor];
    collectionview.showsHorizontalScrollIndicator = false;
    collectionview.delegate = self;
    collectionview.dataSource = self;
    [collectionview registerClass:[CyclicCardCell class] forCellWithReuseIdentifier:cellID];
    [self addSubview:collectionview];
    [collectionview scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:groupCount/2*self.imageArr.count inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:false];
    
    pageControl = [[UIPageControl alloc] init];
    pageControl.frame = CGRectMake(0, self.bounds.size.height - 10,self.bounds.size.width, 10);
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    pageControl.pageIndicatorTintColor = [UIColor lightTextColor];
    pageControl.backgroundColor = [UIColor clearColor];
    pageControl.numberOfPages = self.imageArr.count;
    [self addSubview:pageControl];
    
    
}
#pragma mark - collection delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return indexArr.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CyclicCardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    cell.index = [indexArr[indexPath.row] integerValue];
    cell.cardimage.image = [UIImage imageNamed:self.imageArr[cell.index]];
    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CyclicCardCell *cell = (CyclicCardCell *)[collectionview cellForItemAtIndexPath:indexPath];
    if (self.TapActionBlock) {
        self.TapActionBlock(cell.index+1);
    }
}
#pragma mark - scrollviewdelegete
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.animationTimer pauseTimer];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    CGPoint pointInView = [self convertPoint:collectionview.center toView:collectionview];
    NSLog(@"cc%f", collectionview.contentOffset.x);
    
    NSIndexPath *indexPathNow = [collectionview indexPathForItemAtPoint:pointInView];
    NSInteger index = indexPathNow.row%self.imageArr.count;
    //    showLabel.text = [NSString stringWithFormat:@"滚动到第%zd张",index+1];
    NSLog(@"index%zd,%f,%@",index,scrollView.contentOffset.x,NSStringFromCGPoint(pointInView));
    pageControl.currentPage = index;
    [collectionview scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:groupCount/2*self.imageArr.count +index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:false];
    [self.animationTimer resumeTimerAfterTimeInterval:self.animationDuration];

}

#pragma mark - 定时器

-(void)startAnimationTimer{
    
    NSTimeInterval animationDuration = 5;
    if (_animationDuration>0) {
        animationDuration = _animationDuration;
    }else{
        _animationDuration = animationDuration;
    }
    self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:(animationDuration)
                                                           target:self
                                                         selector:@selector(animationTimerDidFired:)
                                                         userInfo:nil
                                                          repeats:YES];
    
}

- (void)animationTimerDidFired:(NSTimer *)timer
{
   dispatch_async(dispatch_get_main_queue(), ^{
    [collectionview layoutIfNeeded];

    CGPoint newOffset = CGPointMake(collectionview.contentOffset.x + self.itemsW+self.paddings, collectionview.contentOffset.y);
    [collectionview setContentOffset:newOffset animated:YES];
    
    CGPoint pointInView = [self convertPoint:collectionview.center toView:collectionview];
    NSIndexPath *indexPathNow = [collectionview indexPathForItemAtPoint:pointInView];
    NSLog(@"%zd",indexPathNow.row);
    NSInteger index = indexPathNow.row%self.imageArr.count;
    if(indexPathNow.row>=(indexArr.count/2+self.imageArr.count)){
        [collectionview scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:groupCount/2*self.imageArr.count +index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:false];

    }else{
        if (index == 4) {
            pageControl.currentPage = 0;
        }else{
            pageControl.currentPage = index+1;
        }
    }
  });
   

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
