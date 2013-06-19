//
//  CCTableViewCell.h
//  CodeChallenge
//
//  Created by Gonzalo Moreno F. on 19/06/13.
//  Copyright (c) 2013 Gonzalo Moreno F. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCPostInfo.h"

@interface CCTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView* photo;
@property (nonatomic, strong) UILabel* cellText;
@property (nonatomic, strong) UILabel* posterName;
@property (nonatomic, strong) CCPostInfo* postInfo;
@property (nonatomic) NSInteger sortingOrder;

@end
