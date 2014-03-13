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
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    NSLog(@"%d", [self intValue]);
    [self setColor:[CCColor colorWithRed:0.0f green:0.0f blue:0.0f]];
}

@end
