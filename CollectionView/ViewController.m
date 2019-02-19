//
//  ViewController.m
//  CollectionView
//
//  Created by YLCHUN on 2018/2/11.
//  Copyright © 2018年 YLCHUN. All rights reserved.
//

#import "ViewController.h"
#import "BlockConver.h"
#import "CollectionViews.h"
#import "CollectionSectionBackground.h"

@interface ViewController ()<SHCollectionViewDelegateFlowLayout, SHCollectionViewDataSource>
@property (weak, nonatomic) IBOutlet SHCollectionView *collectionView;
@property (nonatomic, strong) CollectionSectionBackground *background;
@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.collectionView registerClass:[CellB class] forCellWithReuseIdentifier:CellBId];
    [self.collectionView registerNib:[UINib nibWithNibName:CellAId bundle:nil] forCellWithReuseIdentifier:CellAId];
    
    [self.collectionView registerNib:[UINib nibWithNibName:HeaderViewId bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderViewId];
    
    [self.collectionView registerClass:[FooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:FooterViewId];

    buildConverProxyManager(self.collectionView, self);
    [self.collectionView reloadData];
    
    self.background = [CollectionSectionBackground new];
    [self.background setCollectionView:self.collectionView];
    // Do any additional setup after loading the view, typically from a nib.
}

-(BOOL)collectionView:(UICollectionView *)collectionView horizontalOfSection:(NSInteger)section {
    return (section == 1 || section == 5 || section == 7);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView heightOfHorizontalSection:(NSInteger)section {
    return 100;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 8;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier;
    if (indexPath.row %2 == 0) {
        identifier = CellAId;
    }else {
        identifier = CellBId;
    }
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
//    NSLog(@"%s", __func__);
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"%s", __func__);
    return CGSizeMake(100, 100);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"%@", indexPath);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(0, 20);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(0, 20);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier;
    if (kind == UICollectionElementKindSectionHeader) {
        identifier = HeaderViewId;
    }else {
        identifier = FooterViewId;
    }
    return [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifier forIndexPath:indexPath];
}


@end
