//
//  TYCertCell.h
//  LIEBANG
//
//  Created by  YIQI on 2019/3/6.
//  Copyright © 2019年  YIQI. All rights reserved.
//


NS_ASSUME_NONNULL_BEGIN
@protocol TYTabPagerBarCellProtocol <NSObject>

/**
 font ,textColor will use TYTabPagerBarLayout's textFont,textColor
 */
@property (nonatomic, strong, readonly) UILabel *titleLabel;

@end


@interface TYCertCell : UICollectionViewCell

@property (nonatomic, weak,readonly) UILabel *titleLabel;

@property (nonatomic, weak,readonly) UIImageView *redView;

+ (NSString *)cellIdentifier;

@end

NS_ASSUME_NONNULL_END
