//
//  ZSHCustomWaterFlowLayout.m
//  ZSHApp
//
//  Created by zhaoweiwei on 2017/10/12.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ZSHCustomWaterFlowLayout.h"

static NSInteger const DefaultColumCount = 2;
static CGFloat   const DefalutSpacing = 13;
static UIEdgeInsets const DefaultEdgeInsets = {10,10,10,10};
@interface  ZSHCustomWaterFlowLayout()

/**所有cell的布局属性*/
@property (nonatomic, strong)NSMutableArray *attributesArr;
/**所有列的当前高度*/
@property (nonatomic, strong)NSMutableArray *maxyArr;

@end

@implementation ZSHCustomWaterFlowLayout

-(NSInteger)columCount{
    if([self.delegate respondsToSelector:@selector(numberOfColums:)]){
        return [self.delegate numberOfColums:self];
    }
    return DefaultColumCount;
}

- (CGFloat)spacing{
    if ([self.delegate respondsToSelector:@selector(lineSpacingOfItems:)]) {
        return [self.delegate lineSpacingOfItems:self];
    }
    return DefalutSpacing;
}

- (UIEdgeInsets)edgeInsets{
    if ([self.delegate respondsToSelector:@selector(edgeinsetOfItems:)]) {
        return [self.delegate edgeinsetOfItems:self];
    }
    return DefaultEdgeInsets;
}

- (NSMutableArray *)maxyArr{
    if (!_maxyArr) {
        _maxyArr = [NSMutableArray array];
    }
    return _maxyArr;
}

- (NSMutableArray *)attributesArr{
    if (!_attributesArr) {
        _attributesArr = [NSMutableArray array];
    }
    return _attributesArr;
}

//初始化布局
-(void)prepareLayout{
    [super prepareLayout];
    
    /**清除之前跟布局相关的所有属性，重新设置新的布局*/
    //清除之前计算的所有列的高度
    [self.maxyArr removeAllObjects];
    for (int i = 0; i <self.columCount; i++) {
         //设置所有列的初始高度
        [self.maxyArr addObject:@(self.edgeInsets.top)];
    }
    
     //清除之前所有的布局属性
    [self.attributesArr removeAllObjects];
     /**开始创建每一个cell对应的布局属性*/
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i < itemCount; i++) {
        //获取indexPath位置cell对应的布局属性
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        //将indexPath位置的cell的布局属性添加到所有cell的布局属性数组中
        [self.attributesArr addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
}

//返回包含所有cell的布局属性的数组
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    return self.attributesArr;
}

//设置每一个cell的布局属性
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //获取indexPath位置的布局属性
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    /**设置cell布局属性的frame*/
    
    /***确定cell的尺寸***/
    //获取collectionView的宽度
    UIEdgeInsets edgeInsets = self.edgeInsets;
    CGFloat width = (CGRectGetWidth(self.collectionView.frame)-edgeInsets.left - edgeInsets.right - self.spacing * (self.columCount -1))/self.columCount;
    
    //cell高度
    CGFloat height = [self.delegate heightForItem:self heightForItemAtIndex:indexPath.item itemWith:width];
//    CGFloat height = 100 + arc4random()%150;
    
    
     /***设置cell的位置***/
    NSInteger __block columNum = 0;
    CGFloat __block minHeight = [self.maxyArr[columNum]floatValue];
    [self.maxyArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat itemHeight = [(NSNumber *)obj floatValue];
        
        if (minHeight > itemHeight) {
            minHeight = itemHeight;
            columNum = idx;
        }
    }];
    
    CGFloat x = edgeInsets.left + columNum * (width + self.spacing);
    CGFloat y = minHeight;
    if (y != edgeInsets.top) {//如果不是第一行，需要加上行间距
        y+=self.spacing;
    }
    
    /**给cell的布局属性的frame赋值*/
    [attributes setFrame:CGRectMake(x,y,width,height)];
//    RLog(@"columNum==%ld,minHeight = %f,要取的y是==%f",columNum,minHeight,CGRectGetMaxY(attributes.frame));
    
    //更新最短那列的高度
    self.maxyArr[columNum] = @(CGRectGetMaxY(attributes.frame));
    return attributes;
}

-(CGSize)collectionViewContentSize{
    //获取最高的那一列的高度
    CGFloat __block maxHeight = 0;
    [self.maxyArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat itemHeight = [(NSNumber *)obj floatValue];
        if (maxHeight < itemHeight) {
            maxHeight = itemHeight;
        }
    }];
    
    //返回collectionView的contentSize，高度为最高的高度加上一个行间距
    return CGSizeMake(0, maxHeight+self.edgeInsets.bottom);
}


@end
