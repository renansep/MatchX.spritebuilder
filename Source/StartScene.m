//
//  StartScene.m
//  MatchX
//
//  Created by Renan Cargnin on 3/6/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "StartScene.h"
#import "LevelSelectScene.h"
#import "NumberLayer.h"
#import "Game.h"

@implementation StartScene

- (void)didLoadFromCCB
{
    CGSize viewSize = [[CCDirector sharedDirector] viewSize];
    
    [background setScaleX:viewSize.width / background.contentSize.width];
    [background setScaleY:viewSize.height / background.contentSize.height];
    
    if ([[Game language] isEqualToString:@"pt"])
    {
        [scoreTitleLabel setString:@"Pontos"];
        [tutorialLabel setString:@"Como jogar"];
        tutorialText = [NSArray arrayWithObjects:
                        @"Usando os operadores...",
                        @"Caminhe entre os números...",
                        @"Para calcular X!",
                        @"Fique de olho no tempo!",
                        @"Seja rápido para \nganhar mais pontos!",
                        @"Como jogar",
                        nil];
        [tapAnywhereLabel setString:@"Toque para jogar"];
    }
    else
    {
        [scoreTitleLabel setString:@"Score"];
        [tutorialLabel setString:@"How to play"];
        tutorialText = [NSArray arrayWithObjects:
                        @"Using the operators...",
                        @"Trace your path \nthrough the numbers...",
                        @"To Match X!",
                        @"Hurry! Time's running out!",
                        @"Be fast to increase your score!",
                        @"How to play",
                        nil];
        [tapAnywhereLabel setString:@"Tap to play"];
    }
    
    //Creates the tutorial level
    tutorialLevel = [NSMutableDictionary new];
    [tutorialLevel setObject:[NSArray arrayWithObjects:@"+", nil] forKey:@"operations"];
    [tutorialLevel setObject:[NSNumber numberWithInt:20] forKey:@"calculationTime"];
    [tutorialLevel setObject:[NSNumber numberWithInt:2] forKey:@"maxOperands"];
    [tutorialLevel setObject:[NSArray arrayWithObjects:@"111", @"111", @"111", nil] forKey:@"map"];
    [tutorialLevel setObject:[NSNumber numberWithInt:1] forKey:@"minNumber"];
    [tutorialLevel setObject:[NSNumber numberWithInt:10] forKey:@"maxNumber"];
    [tutorialLevel setObject:[NSNumber numberWithBool:YES] forKey:@"tutorial"];
    
    [tutorialLabel setZOrder:2];
    
    numberLayer = [[NumberLayer alloc] initWithLevel:tutorialLevel];
    [numberLayer setPosition:ccp(paper.contentSize.width / 2, paper.contentSize.height / 2)];
    if (numberLayer.contentSize.width > numberLayer.contentSize.height)
    {
        [numberLayer setScale:paper.contentSize.width * 0.85 / numberLayer.contentSize.width];
    }
    else
    {
        [numberLayer setScale:paper.contentSize.width * 0.85 / numberLayer.contentSize.height];
    }
    [paper addChild:numberLayer];
    
    result = [numberLayer result];
    [resultLabel setString:[NSString stringWithFormat:@"X = %d", result]];
    
    [operatorsLabel setString:[[numberLayer operations] firstObject]];
    
    [self schedule:@selector(blinkTapAnywhereLabel) interval:0.75];
    
    [self startTutorialAnimation];
    
    self.userInteractionEnabled = YES;
}

- (void)blinkTapAnywhereLabel
{
    [tapAnywhereLabel setVisible:![tapAnywhereLabel visible]];
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (levelSelectionScene == nil)
    {
        self.userInteractionEnabled = NO;
        [self unscheduleAllSelectors];
        levelSelectionScene = [LevelSelectScene new];
        [[CCDirector sharedDirector] replaceScene:levelSelectionScene withTransition:[CCTransition transitionRevealWithDirection:CCTransitionDirectionDown duration:0.5f]];
    }
}

- (void)update:(CCTime)delta
{
    if (result != [numberLayer result])
    {
        result = [numberLayer result];
        [resultLabel setString:[NSString stringWithFormat:@"X = %d", result]];
    }
}

- (void)updateTutorialLabel:(NSString *)newText
{
    [tutorialLabel setString:newText];
    if ([newText isEqualToString:[tutorialText lastObject]])
    {
        [self startTutorialAnimation];
    }
}

- (void)startTutorialAnimation
{
    [self performSelector:@selector(updateTutorialLabel:) withObject:[tutorialText objectAtIndex:0] afterDelay:2];
    [self performSelector:@selector(updateTutorialLabel:) withObject:[tutorialText objectAtIndex:1] afterDelay:5];
    [self performSelector:@selector(updateTutorialLabel:) withObject:[tutorialText objectAtIndex:2] afterDelay:8];
    [self performSelector:@selector(updateTutorialLabel:) withObject:[tutorialText objectAtIndex:3] afterDelay:11];
    [self performSelector:@selector(updateTutorialLabel:) withObject:[tutorialText objectAtIndex:4] afterDelay:14];
    [self performSelector:@selector(updateTutorialLabel:) withObject:[tutorialText objectAtIndex:5] afterDelay:17];
    
    [self runScaleAnimationWithNode:operatorsLabel andDelay:2 andScaleMax:3 andScaleMin:0.5];
    [self runScaleAnimationWithNode:resultLabel andDelay:8 andScaleMax:1.5 andScaleMin:0.5];
    [self runScaleAnimationWithNode:clockNode andDelay:11 andScaleMax:1.2 andScaleMin:0.8];
    [self runScaleAnimationWithNode:scoreNode andDelay:14 andScaleMax:1.2 andScaleMin:0.8];
}

- (void)runScaleAnimationWithNode:(CCNode *)node andDelay:(float)delay andScaleMax:(float)scaleMax andScaleMin:(float)scaleMin
{
    CCActionScaleTo *scaleToMax = [CCActionScaleTo actionWithDuration:0.5 scale:scaleMax];
    CCActionScaleTo *scaleToMin = [CCActionScaleTo actionWithDuration:0.5 scale:scaleMin];
    CCActionScaleTo *scaleToBack = [CCActionScaleTo actionWithDuration:0.5 scale:1];
    
    CCActionSequence *scaleAnimation = [CCActionSequence actions:scaleToMax, scaleToMin, scaleToMax, scaleToMin, scaleToMax, scaleToBack, nil];
    
    [node runAction:[CCActionSequence actions:[CCActionDelay actionWithDuration:delay], scaleAnimation, nil]];
}

@end
