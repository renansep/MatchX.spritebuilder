//
//  GameScene.m
//  MatchX
//
//  Created by Renan Cargnin on 3/13/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameScene.h"
#import "GameNumber.h"

@implementation GameScene

- (void)didLoadFromCCB
{
    NSLog(@"Main Menu loaded.");
    
    numbers = [[NSMutableArray alloc] init];
    
    GameNumber *number = [[GameNumber alloc] init];
    
    CCNodeColor *numbersLayer = [CCNodeColor nodeWithColor:[CCColor whiteColor] width:number.contentSize.width * 8 height:number.contentSize.height * 8];
    [numbersLayer setAnchorPoint:CGPointMake(0.5, 0.5)];
    [numbersLayer setPosition:CGPointMake([[CCDirector sharedDirector] viewSize].width / 2, [[CCDirector sharedDirector] viewSize].height / 2)];
    [self addChild:numbersLayer];
    
    
    for (int i=0; i<8; i++)
    {
        [numbers addObject:[[NSMutableArray alloc] init]];
        for (int j=0; j<8; j++)
        {
            GameNumber *number = [GameNumber new];
            [[numbers objectAtIndex:i] addObject:number];
            [number setPosition:CGPointMake(j * number.contentSize.width + number.contentSize.width / 2, i * number.contentSize.height + number.contentSize.height / 2)];
            [numbersLayer addChild:number];
        }
    }
    
    [numbersLayer setScale:[[CCDirector sharedDirector] viewSize].width / numbersLayer.contentSize.width];
}



@end
