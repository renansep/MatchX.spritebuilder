//
//  GameLayer.m
//  MatchX
//
//  Created by Renan Benevides Cargnin on 3/12/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameLayer.h"

@implementation GameLayer

- (void)didLoadFromCCB
{
    NSLog(@"Main Menu loaded.");
    
    numbers = [[NSMutableArray alloc] init];
    
    for (int i=0; i<8; i++)
    {
        CCSprite *sprite = [CCSprite spriteWithImageNamed:[NSString stringWithFormat:@"number%d.png", i]];
        [numbers addObject:sprite];
        [numbersLayer addChild:sprite];
        [sprite setPosition:CGPointMake(i * numbersLayer.contentSize.width / 8 + sprite.contentSize.width / 2, 0)];
    }
    
    CCSprite *sprite = [CCSprite spriteWithImageNamed:@"number9.png"];
    [sprite setPosition:CGPointMake(100, 100)];
    [self addChild:sprite];
    NSLog(@"Width: %f", sprite.contentSizeInPoints.width);
    NSLog(@"Height: %f", sprite.contentSizeInPoints.height);
}

@end
