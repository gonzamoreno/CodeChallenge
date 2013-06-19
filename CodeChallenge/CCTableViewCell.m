//
//  CCTableViewCell.m
//  CodeChallenge
//
//  Created by Gonzalo Moreno F. on 19/06/13.
//  Copyright (c) 2013 Gonzalo Moreno F. All rights reserved.
//

#import "CCTableViewCell.h"

@implementation CCTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    // overloaded to do nothing
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    // overloaded to do nothing
}

- (void) prepareForReuse {
    [self.photo removeFromSuperview];
    self.photo = nil;
    [self.cellText removeFromSuperview];
    self.cellText = nil;
    [self.posterName removeFromSuperview];
    self.posterName = nil;
}

- (void) layoutSubviews {
    //draw the cell content.
    [self prepareForReuse];
     if (self.sortingOrder%2 == 0) {
        [self setBackgroundColor:[UIColor lightGrayColor]];
    }
    self.photo = [[UIImageView alloc] initWithFrame:CGRectMake(((self.frame.size.width*0.25)-80)/2, 10, 75, 75)];
    [self.photo setImageWithURL:[NSURL URLWithString:self.postInfo.avatarImageUrl]];
    [self.photo.layer setCornerRadius:self.photo.frame.size.width/2];
    [self.photo.layer setMasksToBounds:YES];
    [self addSubview:self.photo];
    
    self.cellText = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width*0.25), 10, self.frame.size.width*0.75, self.frame.size.height-20)];
    [self.cellText setText:self.postInfo.text];
    [self.cellText setFont:[UIFont fontWithName:@"Helvetica Neue" size:28]];
    [self.cellText setBackgroundColor:[UIColor clearColor]];
    [self.cellText setTextColor:[UIColor blackColor]];
    [self.cellText setTextAlignment:NSTextAlignmentLeft];
    [self.cellText setLineBreakMode:NSLineBreakByWordWrapping];
    [self.cellText setNumberOfLines:15];
    [self.cellText alignTop];
    [self addSubview:self.cellText];
    
    self.posterName = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, self.frame.size.width*0.25, 30)];
    [self.posterName setText:self.postInfo.authorName];
    [self.posterName setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:13]];
    [self.posterName setBackgroundColor:[UIColor clearColor]];
    [self.posterName setTextColor:[UIColor blackColor]];
    [self.posterName setTextAlignment:NSTextAlignmentCenter];
    [self.posterName setLineBreakMode:NSLineBreakByWordWrapping];
    [self.posterName setNumberOfLines:2];
    [self.posterName alignTop];
    [self addSubview:self.posterName];
}


@end
