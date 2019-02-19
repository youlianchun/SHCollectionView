//
//  CollectionViews.m
//  CollectionView
//
//  Created by YLCHUN on 2018/2/27.
//  Copyright © 2018年 YLCHUN. All rights reserved.
//

#import "CollectionViews.h"

@implementation CellA

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end


@implementation CellB

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor orangeColor];
    return self;
}

@end


@implementation HeaderView
@end

@implementation FooterView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor redColor];
    return self;
}
@end
