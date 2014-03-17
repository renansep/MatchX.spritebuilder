//
//  GameNumber.m
//  MatchX
//
//  Created by Renan Cargnin on 3/13/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameNumber.h"

@implementation GameNumber

@synthesize intValue;

- (GameNumber *)init
{
    int random = arc4random() % 9 + 1;
    self = [super initWithImageNamed:[NSString stringWithFormat:@"number%d.png", random]];
    if (self)
    {
        intValue = random;
        
        background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5] width:self.contentSize.width height:self.contentSize.height];
        [background setAnchorPoint:CGPointMake(0.5, 0.5)];
        [background setPosition:CGPointMake(self.contentSize.width / 2, self.contentSize.height / 2)];
        [background setScale:0.95];
        [background setVisible:NO];
        [self addChild:background];
    }
    return self;
}

- (BOOL)selected
{
    return [background visible];
}

- (void)setSelected:(BOOL)s
{
    [background setVisible:s];
}

@end
