//
//  BlockDataSource.m
//  CollectionView
//
//  Created by YLCHUN on 2018/2/11.
//  Copyright © 2018年 YLCHUN. All rights reserved.
//

#import "BlockConver.h"

#pragma mark -
#pragma mark - BlockDataSource
@interface BlockDataSource () <UICollectionViewDataSource>
@end
@implementation BlockDataSource

-(id<SHCollectionViewDataSource>)original {
    return _original;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (collectionView.hash == HCollectionViewHash) {
        return 1;
    }else {
        return [self.original numberOfSectionsInCollectionView:collectionView];
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView.hash == HCollectionViewHash) {
        return [self.original collectionView:collectionView numberOfItemsInSection:((HCollectionView*)collectionView).section];
    }
    else
    {
        if ([(SHCollectionView*)collectionView horizontalSecton:section andUpdate:YES]) {
            return 1;
        }else {
            return [self.original collectionView:collectionView numberOfItemsInSection:section];
        }
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.hash == HCollectionViewHash)
    {
        NSUInteger section = ((HCollectionView*)collectionView).section;
        indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:section];
        return [self.original collectionView:collectionView cellForItemAtIndexPath:indexPath];
    }
    else
    {
        if ([(SHCollectionView*)collectionView horizontalSecton:indexPath.section andUpdate:NO])
        {
            return [collectionView dequeueReusableCellWithReuseIdentifier:HCollectionCellId forIndexPath:indexPath];
        }
        else
        {
            return [self.original collectionView:collectionView cellForItemAtIndexPath:indexPath];
        }
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.hash == HCollectionViewHash) {
        return nil;
    }else {
        return [self.original collectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
    }
}

@end

#pragma mark -
#pragma mark - BlockDelegate
@interface BlockDelegate () <UICollectionViewDelegateFlowLayout>
{
    BOOL _resp_insetForSection;
}
@end
@implementation BlockDelegate
-(void)didSetOriginal
{
    _resp_insetForSection = [self.original respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)];
}

-(id<SHCollectionViewDelegateFlowLayout>)original {
    return _original;
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.hash == HCollectionViewHash)
    {
        indexPath = [NSIndexPath indexPathForItem:indexPath.item inSection:((HCollectionView*)collectionView).section];
        [self.original collectionView:collectionView willDisplayCell:cell forItemAtIndexPath:indexPath];
    }
    else
    {
        if ([(SHCollectionView*)collectionView horizontalSecton:indexPath.section andUpdate:NO]) {
            
        }else {
            [self.original collectionView:collectionView willDisplayCell:cell forItemAtIndexPath:indexPath];
        }
    }
}

-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.hash == HCollectionViewHash)
    {
        indexPath = [NSIndexPath indexPathForItem:indexPath.item inSection:((HCollectionView*)collectionView).section];
        [self.original collectionView:collectionView didEndDisplayingCell:cell forItemAtIndexPath:indexPath];
    }
    else
    {
        if ([(SHCollectionView*)collectionView horizontalSecton:indexPath.section andUpdate:NO]) {
        }else {
            [self.original collectionView:collectionView didEndDisplayingCell:cell forItemAtIndexPath:indexPath];
        }
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.hash == HCollectionViewHash)
    {
        indexPath = [NSIndexPath indexPathForItem:indexPath.item inSection:((HCollectionView*)collectionView).section];
        return [self.original collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    }
    else
    {
        if ([(SHCollectionView*)collectionView horizontalSecton:indexPath.section andUpdate:NO]) {
        }else {
            return [self.original collectionView:collectionView didSelectItemAtIndexPath:indexPath];
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.hash == HCollectionViewHash)
    {
        indexPath = [NSIndexPath indexPathForItem:indexPath.item inSection:((HCollectionView*)collectionView).section];
        return [self.original collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
    }
    else
    {
        if ([(SHCollectionView*)collectionView horizontalSecton:indexPath.section andUpdate:NO])
        {
            CGFloat width = CGRectGetWidth(collectionView.bounds);
            CGFloat height = [self.original collectionView:collectionView heightOfHorizontalSection:indexPath.section];
            {
                UIEdgeInsets insets =  UIEdgeInsetsZero;
                if (_resp_insetForSection) {
                    insets = [self.original collectionView:collectionView layout:collectionViewLayout insetForSectionAtIndex:indexPath.section];
                }
                width -= insets.left;
                width -= insets.right;
            }
            
            return CGSizeMake(width, height);
        }else {
            return [self.original collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
        }
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (collectionView.hash == HCollectionViewHash) {
        return UIEdgeInsetsZero;
    }
    return [self.original collectionView:collectionView layout:collectionViewLayout insetForSectionAtIndex:section];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (collectionView.hash == HCollectionViewHash) {
        section = ((HCollectionView*)collectionView).section;
    }
    return [self.original collectionView:collectionView layout:collectionViewLayout minimumLineSpacingForSectionAtIndex:section];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (collectionView.hash == HCollectionViewHash) {
        section = ((HCollectionView*)collectionView).section;
    }
    return [self.original collectionView:collectionView layout:collectionViewLayout minimumInteritemSpacingForSectionAtIndex:section];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (collectionView.hash == HCollectionViewHash) {
        return CGSizeZero;
    }
    return [self.original collectionView:collectionView layout:collectionViewLayout referenceSizeForHeaderInSection:section];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (collectionView.hash == HCollectionViewHash) {
        return CGSizeZero;
    }
    return [self.original collectionView:collectionView layout:collectionViewLayout referenceSizeForFooterInSection:section];
}
@end
