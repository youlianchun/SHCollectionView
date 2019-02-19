//
//  ConverProxy.m
//  CollectionView
//
//  Created by YLCHUN on 2018/2/11.
//  Copyright © 2018年 YLCHUN. All rights reserved.
//

#import "BlockConver.h"

@interface UICollectionView ()
@property (nonatomic, strong)ConverProxyManager *converProxyManager;
@end

#pragma mark -
#pragma mark - BlockConver
@implementation BlockConver
+(instancetype) converWithOriginal:(id)original
{
    BlockConver *cover = [self new];
    cover->_original = original;
    [cover didSetOriginal];
    return cover;
}
-(id)original
{
    return _original;
}
-(void)didSetOriginal {}
@end

#pragma mark -
#pragma mark - ConverProxy
@implementation ConverProxy
+(instancetype)proxyWithCover:(BlockConver*)conver
{
    ConverProxy *proxy = [self alloc];
    proxy->_conver = conver;
    return proxy;
}

-(BlockConver*)conver
{
    return _conver;
}
- (void)forwardInvocation:(NSInvocation *)invocation
{
    if ([_conver respondsToSelector:invocation.selector]) {
        [invocation setTarget:_conver];
    }else {
        [invocation setTarget:_conver.original];
    }
    [invocation invoke];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    return [_conver.original methodSignatureForSelector:sel];
}

-(BOOL)respondsToSelector:(SEL)aSelector
{
    return [_conver.original respondsToSelector:aSelector];
}
@end

#pragma mark -
#pragma mark - ConverProxyManager
@implementation ConverProxyManager
{
    @public
    ConverProxy *dataSource;
    ConverProxy *delegate;
}
ConverProxy *buildConverProxy(Class ConverCls, id original)
{
    BlockConver *cover = [ConverCls converWithOriginal:original];
    ConverProxy *converProxy = [ConverProxy proxyWithCover:cover];
    return converProxy;
}

-(instancetype)initWithDataSource:(id)dataSource delegate:(id)delegate
{
    self = [super init];
    if (self)
    {
        if ([dataSource isKindOfClass:[ConverProxyManager class]]) {
            dataSource = ((ConverProxyManager*)dataSource)->dataSource.conver.original;
        }
        self->dataSource = buildConverProxy([BlockDataSource class], dataSource);
        
        if ([delegate isKindOfClass:[ConverProxyManager class]]) {
            delegate = ((ConverProxyManager*)delegate)->delegate.conver.original;
        }
        self->delegate = buildConverProxy([BlockDelegate class], delegate);
    }
    return self;
}

@end


void _buildConverProxyManager(UICollectionView* collectionView, id original)
{
    ConverProxyManager *proxyManager = [[ConverProxyManager alloc] initWithDataSource:original delegate:original];
    [collectionView setConverProxyManager:proxyManager];
    collectionView.dataSource = (id)proxyManager->dataSource;
    collectionView.delegate = (id)proxyManager->delegate;
}

void buildConverProxyManager(SHCollectionView* collectionView, id original)
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [collectionView setCollectionViewLayout:layout];
    [collectionView registerClass:[HCollectionCell class] forCellWithReuseIdentifier:HCollectionCellId];
    _buildConverProxyManager(collectionView, original);
}


