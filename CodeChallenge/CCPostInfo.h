//
//  CCPostInfo.h
//  CodeChallenge
//
//  Created by Gonzalo Moreno F. on 19/06/13.
//  Copyright (c) 2013 Gonzalo Moreno F. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCPostInfo : NSObject

@property (nonatomic, strong) NSString* text;
@property (nonatomic, strong) NSString* authorName;
@property (nonatomic, strong) NSString* createdAt;
@property (nonatomic, strong) NSString* avatarImageUrl;

@end
