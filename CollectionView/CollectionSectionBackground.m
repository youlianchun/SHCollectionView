//
//  CollectionSectionBackground.m
//  CollectionView
//
//  Created by YLCHUN on 2018/2/27.
//  Copyright © 2018年 YLCHUN. All rights reserved.
//

#import "CollectionSectionBackground.h"
#import <UIKit/UIKit.h>


@interface ImageViewCell:UITableViewCell
@property (nonatomic, readonly) UIImageView *imageView;
@end
@implementation ImageViewCell
@synthesize imageView = _imageView;

-(UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:_imageView];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    }
    return _imageView;
}

@end
@interface _CollectionBGTableView:UITableView
@end
@implementation _CollectionBGTableView
-(void)setContentOffset:(CGPoint)contentOffset {
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        if (!CGPointEqualToPoint(contentOffset, scrollView.contentOffset)) return;
    }
    [super setContentOffset:contentOffset];
}
@end

static NSString * const kContentOffset = @"contentOffset";
static NSString * const kBounds = @"contentSize";

@interface CollectionSectionBackground ()<UITableViewDataSource, UITableViewDelegate>
@end
@implementation CollectionSectionBackground
{
    _CollectionBGTableView *_tableView;
    UICollectionView *_collectionView;
}
-(instancetype)init
{
    self = [super init];
    if (self)
    {
        _tableView = [[_CollectionBGTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.userInteractionEnabled = NO;
        _tableView.scrollEnabled = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return self;
}
-(void) setCollectionView:(UICollectionView*)collectionView
{
    _collectionView = collectionView;
    collectionView.backgroundView = _tableView;
    [_tableView reloadData];
    [collectionView addObserver:self forKeyPath:kContentOffset options:NSKeyValueObservingOptionNew context:nil];
    [collectionView addObserver:self forKeyPath:kBounds options:NSKeyValueObservingOptionNew context:nil];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:kBounds]) {
        [_tableView reloadData];
    }
    if ([keyPath isEqualToString:kContentOffset]) {
        CGPoint contentOffset = [change[NSKeyValueChangeNewKey] CGPointValue];
        [_tableView setContentOffset:contentOffset animated:NO];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _collectionView.numberOfSections;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributesMin = [_collectionView.collectionViewLayout layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]];
    
    NSInteger numberOfItems = [_collectionView.dataSource collectionView:_collectionView numberOfItemsInSection:indexPath.section];

    UICollectionViewLayoutAttributes *attributesMax = [_collectionView.collectionViewLayout layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:MAX(numberOfItems-1, 0) inSection:indexPath.section]];
    
    UIEdgeInsets insets = [(id<UICollectionViewDelegateFlowLayout>)_collectionView.delegate collectionView:_collectionView layout:_collectionView.collectionViewLayout insetForSectionAtIndex:indexPath.section];
    return CGRectGetMaxY(attributesMax.frame) - CGRectGetMinY(attributesMin.frame) + insets.top + insets.bottom;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * const identifier = @"contentOffset";
    ImageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ImageViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
//    if (indexPath.section %2 == 0) {
//        cell.backgroundColor = [UIColor colorWithRed:1 green:1 blue:0 alpha:0.2];
//    }else {
//        cell.backgroundColor = [UIColor colorWithRed:1 green:0 blue:1 alpha:0.2];
//    }
    [_delegate background:self imageView:cell.imageView atSection:indexPath.section];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [(id<UICollectionViewDelegateFlowLayout>)_collectionView.delegate collectionView:_collectionView layout:_collectionView.collectionViewLayout referenceSizeForHeaderInSection:section].height;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return [(id<UICollectionViewDelegateFlowLayout>)_collectionView.delegate collectionView:_collectionView layout:_collectionView.collectionViewLayout referenceSizeForFooterInSection:section].height;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

@end

