//
//  UILabel+VerticalAlign.m
//  CodeChallenge
//
//  Created by Gonzalo Moreno F. on 19/06/13.
//  Copyright (c) 2013 Gonzalo Moreno F. All rights reserved.
//

#import "UILabel+VerticalAlign.h"

@implementation UILabel (VerticalAlign)

- (void) alignTop {
    
    CGSize fontSize = [self.text sizeWithFont:self.font];
    
    double finalHeight = fontSize.height * self.numberOfLines;
    double finalWidth = self.frame.size.width;    //expected width of label
    
    CGSize theStringSize = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(finalWidth, finalHeight) lineBreakMode:self.lineBreakMode];
    
    int newLinesToPad = theStringSize.height / fontSize.height;
    
    newLinesToPad = (self.numberOfLines > newLinesToPad)? newLinesToPad : self.numberOfLines;
    
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, (fontSize.height * newLinesToPad))];
    [self setNumberOfLines:newLinesToPad];
    
}

@end
