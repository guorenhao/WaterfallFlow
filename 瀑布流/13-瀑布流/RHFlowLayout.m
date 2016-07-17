//
//  RHFlowLayout.m
//  13-瀑布流
//
//  Created by 郭人豪 on 16/6/14.
//  Copyright © 2016年 Abner_G. All rights reserved.
//

#import "RHFlowLayout.h"

@interface RHFlowLayout ()

//自定义的布局配置数组
@property (nonatomic, strong) NSMutableArray * attributeArr;

@end

@implementation RHFlowLayout

//重写该方法 在此方法中做一些数组的相关设置
//布局前的准备会调用该方法
- (void)prepareLayout {
    [super prepareLayout];
    
    _attributeArr = [[NSMutableArray alloc] init];
    
    //设置静态的2列
    //计算每个item的宽度
    float itemWidth = ([UIScreen mainScreen].bounds.size.width - self.sectionInset.left - self.sectionInset.right - self.minimumLineSpacing)/2.0;
    
    //定义一个数组  保存每一列的高度
    //这个数组的作用主要是保存每一列的总高度, 这么在布局时, 我们可以始终将下一个item放在最短的列下面
    CGFloat heightArr[2] = {self.sectionInset.top, self.sectionInset.bottom};
    
    //itemCount是外界传入的个数, 遍历设置每一个item的布局
    for (int i = 0; i < _itemCount; i++) {
        
        //设置每个item的位置等相关属性
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        
        //创建一个布局属性类, 通过IndexPath创建
        UICollectionViewLayoutAttributes * attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        
        //随机一个高度  50 ~ 200之间
        CGFloat height = arc4random()%150 + 50;
        
        //哪一列高度小, 就放到哪一列下面
        //标记最短的那一列
        int width = 0;
        
        if (heightArr[0] < heightArr[1]) {
            
            //将新的item的高度加入到段的一列
            heightArr[0] = heightArr[0] + height + self.minimumLineSpacing;
            
            width = 0;
        }else {
            
            heightArr[1] = heightArr[1] + height + self.minimumLineSpacing;
            
            width = 1;
        }
        
        //设置item的位置
        attributes.frame = CGRectMake((self.sectionInset.left + itemWidth) * width + self.minimumInteritemSpacing, heightArr[width] - height - self.minimumLineSpacing, itemWidth, height);
        
        [_attributeArr addObject:attributes];
        
        
    }
    
    //设置itemSize来确保滑动范围正确, 这里是通过将所有的item高度平均化, 计算出来的 (以最高的的列为标准)
    if (heightArr[0] > heightArr[1]) {
        
        self.itemSize = CGSizeMake(itemWidth, (heightArr[0] - self.sectionInset.top)*2.0/_itemCount - self.minimumLineSpacing);
    }else {
        
        self.itemSize = CGSizeMake(itemWidth, (heightArr[1] - self.sectionInset.top)*2.0/_itemCount - self.minimumLineSpacing);
    }
    
}

//最后 在这个方法中返回布局的数组
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    return _attributeArr;
}






@end
