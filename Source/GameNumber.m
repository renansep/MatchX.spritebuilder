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

- (GameNumber *) init
{
    int random = arc4random() % 10;
    self = [super initWithImageNamed:[NSString stringWithFormat:@"number%d.png", random]];
    if (self)
    {
        intValue = random;
        selected = NO;
    }
    return self;
}

- (BOOL)selected
{
    return selected;
}

- (void)setSelected:(BOOL)s
{
    selected = s;
    if (selected)
        [self setColor:[CCColor blackColor]];
    else
        [self setColor:nil];
}

@end
