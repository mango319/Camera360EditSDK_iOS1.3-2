//
//  UICButton.m
//  UICEditSDK
//
//  Created by Cc on 15/2/12.
//  Copyright (c) 2015年 PinguoSDK. All rights reserved.
//

#import "UICButton.h"

@implementation UICButton

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor clearColor];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.frame.size.width, 0, 0)];
    [self setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    
    [self setTitleColor:[UIColor colorWithRed:255/255.
                                        green:255/255.
                                         blue:255/255. alpha:1]
               forState:UIControlStateNormal];
    
    [self setTitleColor:[UIColor colorWithRed:138/255.
                                        green:138/255.
                                         blue:138/255. alpha:1]
               forState:UIControlStateHighlighted];
    
    [self setTitleColor:[UIColor colorWithRed:138/255.
                                        green:138/255.
                                         blue:138/255. alpha:1]
               forState:UIControlStateDisabled];
}


- (void)pSetupTitle:(NSString*)text
{
    [self setTitle:text forState:UIControlStateNormal];
    [self setTitle:text forState:UIControlStateDisabled];
    [self setTitle:text forState:UIControlStateHighlighted];
}

@end
