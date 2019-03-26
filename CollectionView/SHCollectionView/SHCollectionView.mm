//
//  SHCollectionView.m
//  CollectionView
//
//  Created by YLCHUN on 2018/2/27.
//  Copyright © 2018年 YLCHUN. All rights reserved.
//

#import "SHCollectionView.h"
#import "BlockConver.h"
#include <vector>
#include <map>

#ifdef __cplusplus
extern "C" {
#endif
    void _buildConverProxyManager(UICollectionView* collectionView, id original);
#ifdef __cplusplus
};
#endif

@interface HCollectionView ()
@property (nonatomic, assign) NSInteger section;
@end

#pragma mark -
#pragma mark - RegContent
@interface RegContent:NSObject
{
    @protected
    NSString* _identifier;
    id _regContent;
    BOOL _isClass;
}

@end
@implementation RegContent
+(RegContent*)contentWithIdentifier:(NSString*)identifier regContent:(id)regContent isClass:(BOOL)isClass
{
    RegContent *content = [RegContent new];
    content->_identifier = identifier;
    content->_regContent = regContent;
    content->_isClass = isClass;
    return content;
}

-(void)regToCollectionView:(UICollectionView*)collectionView
{
    if (_isClass) {
        [collectionView registerClass:_regContent forCellWithReuseIdentifier:_identifier];
    }else {
        [collectionView registerNib:_regContent forCellWithReuseIdentifier:_identifier];
    }
}
@end

#pragma mark -
#pragma mark - SHCollectionView
typedef std::map<NSInteger,BOOL> SHMap;
typedef std::map<NSInteger,CGPoint> SHOffsetMap;
typedef std::vector<RegContent*> RegContents;

@interface SHCollectionView ()
@property (nonatomic, strong)ConverProxyManager *converProxyManager;
@end

@implementation SHCollectionView
{
    SHMap _shMap;
    SHOffsetMap _shOffsetMap;
    RegContents _regContents;
}

-(id<SHCollectionViewDelegateFlowLayout>)delegate {
    return (id)[super delegate];
}
-(void)setDelegate:(id<SHCollectionViewDelegateFlowLayout>)delegate {
    [super setDelegate:delegate];
}
-(id<SHCollectionViewDataSource>)dataSource {
    return (id)[super dataSource];
}
-(void)setDataSource:(id<SHCollectionViewDataSource>)dataSource {
    [super setDataSource:dataSource];
}

-(void)setHorizontalContentOffset:(CGPoint)contentOffset section:(NSInteger)section
{
    SHOffsetMap::iterator iterator = _shOffsetMap.find(section);
    if (iterator == _shOffsetMap.end()) {
        _shOffsetMap.insert(std::make_pair(section, contentOffset));
    }else {
        iterator->second = contentOffset;
    }
}

-(CGPoint)horizontalContentOffset:(NSInteger)section
{
    SHOffsetMap::iterator iterator = _shOffsetMap.find(section);
    if (iterator == _shOffsetMap.end()) {
        return CGPointZero;
    }else {
        return iterator->second;
    }
}

-(BOOL)horizontalSecton:(NSInteger)section andUpdate:(BOOL)update
{
    SHMap::iterator iterator = _shMap.find(section);
    bool b = NO;
    if (iterator == _shMap.end())
    {
        b = [self.dataSource collectionView:self horizontalOfSection:section];
        _shMap.insert(std::make_pair(section, b));
    }
    else
    {
        b = iterator->second;
        if (update)
        {
            b = [self.dataSource collectionView:self horizontalOfSection:section];
            iterator->second = b;
        }
    }
    return b;
}

-(void)registerNib:(UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier
{
    [super registerNib:nib forCellWithReuseIdentifier:identifier];
    RegContent *content = [RegContent contentWithIdentifier:identifier regContent:nib isClass:NO];
    _regContents.push_back(content);
}
-(void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier
{
    [super registerClass:cellClass forCellWithReuseIdentifier:identifier];
    RegContent *content = [RegContent contentWithIdentifier:identifier regContent:cellClass isClass:YES];
    _regContents.push_back(content);
}

-(UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [super dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (identifier == HCollectionCellId)
    {
        HCollectionView* collectionView = ((HCollectionCell*)cell).collectionView;
        if (collectionView.section == -1)
        {
            [self regContentsToHCollectionView:collectionView];
            _buildConverProxyManager(collectionView, self.converProxyManager);
        }
        collectionView.section = indexPath.section;
        [collectionView setContentOffset:[self horizontalContentOffset:indexPath.section]];
    }
    return cell;
}

-(void)regContentsToHCollectionView:(UICollectionView*)collectionView
{
    for (auto iter = _regContents.cbegin(); iter != _regContents.cend(); iter++)
    {
        RegContent *content = *iter;
        [content regToCollectionView:collectionView];
    }
}

-(void)dealloc
{
    _shMap.clear();
    _regContents.clear();
}

@end

#pragma mark -
#pragma mark - HCollectionView
@interface HCollectionView ()
@property (nonatomic, strong)ConverProxyManager *converProxyManager;
@end
@implementation HCollectionView
-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.section = -1;
    }
    return self;
}
-(NSUInteger)hash
{
    return HCollectionViewHash;
}

-(UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath
{
    return [super dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:[self oIndexpath:indexPath]];
}

-(UICollectionReusableView *)dequeueReusableSupplementaryViewOfKind:(NSString *)elementKind withReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath
{
    return [super dequeueReusableSupplementaryViewOfKind:elementKind withReuseIdentifier:identifier forIndexPath:[self oIndexpath:indexPath]];
}

-(UICollectionViewCell *)cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [super cellForItemAtIndexPath:[self oIndexpath:indexPath]];
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section
{
    return [super numberOfItemsInSection:0];
}

-(NSIndexPath *) oIndexpath:(NSIndexPath*)indexpath
{
    if (self.section > 0)
    {
        indexpath = [NSIndexPath indexPathForItem:indexpath.item inSection:0];
    }
    return indexpath;
}
@end

#pragma mark -
#pragma mark - HCollectionCell
static NSString * const kContentOffset = @"contentOffset";
@implementation HCollectionCell
-(HCollectionView *)collectionView
{
    return _collectionView;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self buildCollectionView];
    }
    return self;
}

-(void)buildCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[HCollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsHorizontalScrollIndicator = NO;
    
    [self.contentView addSubview:_collectionView];
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
    
    [_collectionView addObserver:self forKeyPath:kContentOffset options:NSKeyValueObservingOptionNew context:nil];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    CGPoint contentOffset = [change[NSKeyValueChangeNewKey] CGPointValue];
    [((SHCollectionView*)self.superview) setHorizontalContentOffset:contentOffset section:_collectionView.section];
}

-(void)dealloc
{
    [_collectionView removeObserver:self forKeyPath:kContentOffset];
    _collectionView = nil;
}
@end


