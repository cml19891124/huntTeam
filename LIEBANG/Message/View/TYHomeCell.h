//
//  MessageTabPagerBarCell.h
//  LIEBANG
//
//  Created by  YIQI on 2018/12/7.
//  Copyright © 2018年  YIQI. All rights reserved.
//

@protocol TYTabPagerBarCellProtocol <NSObject>

/**
 font ,textColor will use TYTabPagerBarLayout's textFont,textColor
 */
@property (nonatomic, strong, readonly) UILabel *titleLabel;

@end

@interface TYHomeCell : UICollectionViewCell

@property (nonatomic, weak,readonly) UILabel *titleLabel;

@property (nonatomic, weak,readonly) UIView *redView;

+ (NSString *)cellIdentifier;

@end
