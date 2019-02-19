//
//  BlockDataSource.h
//  CollectionView
//
//  Created by YLCHUN on 2018/2/11.
//  Copyright © 2018年 YLCHUN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHCollectionView.h"

@class BlockConver;
@interface ConverProxy : NSProxy
{
    @protected
    BlockConver *_conver;
}
@end


@interface ConverProxyManager : NSObject
@end
extern void buildConverProxyManager(SHCollectionView* collectionView, __kindof NSObject * original);


@interface BlockConver : NSObject
{
    @protected
    id _original;
}
@end

@interface BlockDataSource : BlockConver
@end

@interface BlockDelegate : BlockConver
@end

