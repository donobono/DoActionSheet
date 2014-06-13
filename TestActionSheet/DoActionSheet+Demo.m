//
//  DoActionSheet+Demo.m
//  TestActionSheet
//
//  Created by Jack Shi on 13/06/2014.
//  Copyright (c) 2014 Dono Air. All rights reserved.
//

#import "DoActionSheet+Demo.h"

@implementation DoActionSheet (Demo)

- (id)init
{
    self = [super init];
    if (self)
    {
        // set default style
        [self setDefaultStyle];
    }
    return self;
}

- (void)setDefaultStyle
{
    [self setStyle1];
}

- (void)setStyle1
{
    self.doBackColor = DO_RGB(232, 229, 222);
    self.doButtonColor = DO_RGB(52, 152, 219);
    self.doCancelColor = DO_RGB(231, 76, 60);
    self.doDestructiveColor = DO_RGB(46, 204, 113);
    
    self.doTitleTextColor = DO_RGB(95, 74, 50);
    self.doButtonTextColor = DO_RGB(255, 255, 255);
    self.doCancelTextColor = DO_RGB(255, 255, 255);
    self.doDestructiveTextColor = DO_RGB(255, 255, 255);
    
    self.doDimmedColor = DO_RGBA(0, 0, 0, 0.7);
    
    self.doTitleFont = [UIFont fontWithName:@"Avenir-Heavy" size:14];
    self.doButtonFont = [UIFont fontWithName:@"Avenir-Medium" size:14];
    self.doCancelFont = [UIFont fontWithName:@"Avenir-Medium" size:14];
    
    self.doTitleInset = UIEdgeInsetsMake(10, 20, 10, 20);
    self.doButtonInset = UIEdgeInsetsMake(5, 20, 5, 20);
    
    self.doButtonHeight = 40.0f;
}

- (void)setStyle2
{
    self.doBackColor = DO_RGBA(255, 255, 255, 0);
    self.doButtonColor = DO_RGB(113, 208, 243);
    self.doCancelColor = DO_RGB(73, 168, 203);
    self.doDestructiveColor = DO_RGB(235, 15, 93);
    
    self.doTitleTextColor = DO_RGB(209, 247, 247);
    self.doButtonTextColor = DO_RGB(255, 255, 255);
    self.doCancelTextColor = DO_RGB(255, 255, 255);
    self.doDestructiveTextColor = DO_RGB(255, 255, 255);
}

- (void)setStyle3
{
    self.doBackColor = [UIColor clearColor];
    self.doButtonColor = [UIColor whiteColor];
    self.doCancelColor = [UIColor whiteColor];
    self.doDestructiveColor = [UIColor redColor];
    
    self.doTitleTextColor = [UIColor grayColor];
    self.doButtonTextColor = [UIColor purpleColor];
    self.doCancelTextColor = [UIColor orangeColor];
    self.doDestructiveTextColor = [UIColor whiteColor];
    
    self.doTitleFont = [UIFont systemFontOfSize:18];
    self.doButtonFont = [UIFont systemFontOfSize:18];
    self.doCancelFont = [UIFont systemFontOfSize:18];
    self.doButtonHeight = 44.0f;
}

@end
