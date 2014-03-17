//
//  GameScene.m
//  MatchX
//
//  Created by Renan Cargnin on 3/13/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameScene.h"
#import "NumberLayer.h"

@implementation GameScene

- (void)didLoadFromCCB
{
    NSLog(@"Main Menu loaded.");
    
    int random = arc4random() % 4 + 3;
    
    numbersLayer = [[NumberLayer alloc] initWithLines:random andWithColumns:random];
    [numbersLayer setAnchorPoint:CGPointMake(0.5, 0.5)];
    [numbersLayer setPosition:CGPointMake([[CCDirector sharedDirector] viewSize].width / 2, [[CCDirector sharedDirector] viewSize].height / 2)];
    [numbersLayer setScale:[[CCDirector sharedDirector] viewSize].width / numbersLayer.contentSize.width];
    
    [self addChild:numbersLayer];
    
    [resultLabel setString:[NSString stringWithFormat:@"%d", [numbersLayer result]]];
    [operationLabel setString:[numbersLayer operation]];
    
    self.userInteractionEnabled = YES;
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}

- (void)back:(id)sender
{
    CCScene *mainMenuScene = [CCBReader loadAsScene:@"MainMenuScene"];
    [[CCDirector sharedDirector] replaceScene:mainMenuScene withTransition:[CCTransition transitionRevealWithDirection:CCTransitionDirectionDown duration:0.5f]];
}

- (void)updateResult:(int)newResult
{
    [resultLabel setString:[NSString stringWithFormat:@"%d", newResult]];
}

- (void)updateOperation:(NSString *)newOperation
{
    [operationLabel setString:newOperation];
}

@end
