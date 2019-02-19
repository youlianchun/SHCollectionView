//
//  SHCollectionView.h
//  CollectionView
//
//  Created by YLCHUN on 2018/2/27.
//  Copyright © 2018年 YLCHUN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SHCollectionViewDataSource <UICollectionViewDataSource>
-(BOOL)collectionView:(UICollectionView *)collectionView horizontalOfSection:(NSInteger)section;
@end

@protocol SHCollectionViewDelegateFlowLayout <UICollectionViewDelegateFlowLayout>
-(CGFloat)collectionView:(UICollectionView *)collectionView heightOfHorizontalSection:(NSInteger)section;
@end


@class ConverProxyManager;
@interface SHCollectionView: UICollectionView
@property (nonatomic, weak) id <SHCollectionViewDelegateFlowLayout> delegate;
@property (nonatomic, weak) id <SHCollectionViewDataSource> dataSource;
-(BOOL)horizontalSecton:(NSInteger)section andUpdate:(BOOL)update;
@end


@interface HCollectionView : UICollectionView
@property (nonatomic, readonly) NSInteger section;
@end


static NSInteger const HCollectionViewHash = -1;
static NSString * const HCollectionCellId = @"HCollectionCell";
@interface HCollectionCell : UICollectionViewCell
{
    @protected
    HCollectionView *_collectionView;
}
-(HCollectionView *)collectionView;
@end
