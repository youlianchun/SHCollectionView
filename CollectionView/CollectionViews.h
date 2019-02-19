//
//  CollectionViews.h
//  CollectionView
//
//  Created by YLCHUN on 2018/2/27.
//  Copyright © 2018年 YLCHUN. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const CellAId = @"CellA";
static NSString * const CellBId = @"CellB";
static NSString * const HeaderViewId = @"HeaderView";
static NSString * const FooterViewId = @"FooterView";

@interface CellA : UICollectionViewCell
@end

@interface CellB : UICollectionViewCell
@end

@interface HeaderView : UICollectionReusableView
@end

@interface FooterView : UICollectionReusableView
@end
