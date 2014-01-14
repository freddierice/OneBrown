//
//  ResizedTextField.m
//  OneBrown
//
//  Created by Benjamin Murphy on 1/11/14.
//  Copyright (c) 2014 Benjamin Murphy. All rights reserved.
//

#import "ResizedTextField.h"

@implementation ResizedTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(CGRect)textRectForBounds:(CGRect)bounds {
    
    CGRect maximumBounds = [super textRectForBounds:bounds];
    
    return CGRectMake(maximumBounds.origin.x, maximumBounds.origin.y, maximumBounds.size.width - 95, maximumBounds.size.height);
    
}

-(CGRect)editingRectForBounds:(CGRect)bounds {
    CGRect maximumBounds = [super editingRectForBounds:bounds];
    
    return CGRectMake(maximumBounds.origin.x, maximumBounds.origin.y, maximumBounds.size.width - 95, maximumBounds.size.height);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
