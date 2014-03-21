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
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Levels" ofType:@"plist"]];
    NSDictionary *level = [dictionary objectForKey:@"Level1"];
    
    remainingTime = [(NSNumber *) [level objectForKeyedSubscript:@"calculationTime"] intValue];
    
    paper = [CCSprite spriteWithImageNamed:@"numberPaper.png"];
    [paper setPosition:ccp([[CCDirector sharedDirector] viewSize].width / 2, [[CCDirector sharedDirector] viewSize].height / 2)];
    [paper setScale:0.9];
    [self addChild:paper];
    
    numbersLayer = [[NumberLayer alloc] initWithLevel:level];
    [numbersLayer setAnchorPoint:CGPointMake(0.5, 0.5)];
    [numbersLayer setPosition:ccp(paper.contentSize.width / 2, paper.contentSize.height / 2 - paper.contentSize.height / 20)];
    if (numbersLayer.contentSize.width > numbersLayer.contentSize.height)
    {
        [numbersLayer setScale:paper.contentSize.width * 0.75 / numbersLayer.contentSize.width];
    }
    else
    {
        [numbersLayer setScale:paper.contentSize.width * 0.75 / numbersLayer.contentSize.height];
    }
    
    [paper addChild:numbersLayer];
    
    [self updateResult:[numbersLayer result]];
    [self updateOperation:[numbersLayer operation]];
    
    [background setScaleX:([[CCDirector sharedDirector] viewSize].width / background.contentSize.width)];
    [background setScaleY:([[CCDirector sharedDirector] viewSize].height / background.contentSize.height)];
    
    self.userInteractionEnabled = YES;
    
    [self schedule:@selector(decreaseRemainingTime) interval:1];
    
    score = 0;
}

- (void)update:(CCTime)delta
{
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
    [resultLabel setString:[NSString stringWithFormat:@"X = %d", newResult]];
}

- (void)updateOperation:(NSString *)newOperation
{
    [operationLabel setString:newOperation];
}

- (void)increaseScore:(int)ammount
{
    score += ammount;
    [self updateScore];
}

- (void)updateScore
{
    [scoreLabel setString:[NSString stringWithFormat:@"%d", score]];
}

- (void)decreaseRemainingTime
{
    remainingTime--;
    [clockLabel setString:[NSString stringWithFormat:@"%d", remainingTime]];
    if (remainingTime == 0)
    {
        [self unschedule:@selector(decreaseRemainingTime)];
    }
}

@end
