//
//  CollectionSectionBackground.h
//  CollectionView
//
//  Created by YLCHUN on 2018/2/27.
//  Copyright © 2018年 YLCHUN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class CollectionSectionBackground;
@protocol CollectionSectionBackgroundDelegate <NSObject>
-(void)background:(CollectionSectionBackground *)background imageView:(UIImageView *)imageView atSection:(NSUInteger)section;
@end

//TODO: collection section 高度变化后cell高度适应
@class UICollectionView;
@interface CollectionSectionBackground : NSObject
@property (nonatomic, weak)id<CollectionSectionBackgroundDelegate> delegate;
-(void) setCollectionView:(UICollectionView*)collectionView;
@end
