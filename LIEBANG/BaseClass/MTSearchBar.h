//
//  MTSearchBar.h
//  TreasureApp
//
//  Created by caominglei on 2019/9/15.
//  Copyright © 2019 caominglei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTSearchBar : UITextField
{
    UIButton *searchButton;
}
@property(nonatomic,copy)void(^searchTfButtonBlock)(NSString *keyWord);

+ (instancetype)searchBar;
@end

NS_ASSUME_NONNULL_END
