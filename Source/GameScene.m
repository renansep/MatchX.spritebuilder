//
//  GameScene.m
//  MatchX
//
//  Created by Renan Cargnin on 3/13/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameScene.h"
#import "NumberLayer.h"
#import "LevelSelectScene.h"

@implementation GameScene

static int currentLevel;

- (void)didLoadFromCCB
{
    [background setScaleX:([[CCDirector sharedDirector] viewSize].width / background.contentSize.width)];
    [background setScaleY:([[CCDirector sharedDirector] viewSize].height / background.contentSize.height)];
    
    self.userInteractionEnabled = YES;
    
    NSArray *levelsArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Levels" ofType:@"plist"]];
    NSDictionary *level = [levelsArray objectAtIndex:currentLevel];
    
    calculationTime = [(NSNumber *) [level objectForKeyedSubscript:@"calculationTime"] intValue];
    calculationNumber = [[level objectForKey:@"calculationNumber"] intValue];
    maxOperands = [[level objectForKey:@"maxOperands"] intValue];
    calculationsCompleted = 0;
    remainingTime = calculationTime;
    [clockLabel setString:[NSString stringWithFormat:@"%d", remainingTime]];
    [calculationLabel setString:@""];
    calculationLabelOriginalFontSize = calculationLabel.fontSize;
    score = 0;
    [self updateScore];
    
    numbersLayer = [[NumberLayer alloc] initWithLevel:level];
    [numbersLayer setAnchorPoint:CGPointMake(0.5, 0.5)];
    [numbersLayer setPosition:ccp(paper.contentSize.width / 2, paper.contentSize.height / 2)];
    if (numbersLayer.contentSize.width > numbersLayer.contentSize.height)
    {
        [numbersLayer setScale:paper.contentSize.width * 0.85 / numbersLayer.contentSize.width];
    }
    else
    {
        [numbersLayer setScale:paper.contentSize.width * 0.85 / numbersLayer.contentSize.height];
    }
    [numbersLayer setScene:self];
    [paper addChild:numbersLayer];
    
    [self updateResult:[numbersLayer result]];
    [self updateOperation:[numbersLayer operations]];
    
    [self schedule:@selector(decreaseRemainingTime) interval:1];
}

- (void)update:(CCTime)delta
{
}

- (void)back:(id)sender
{
    LevelSelectScene *levelSelectScene = [LevelSelectScene new];
    [[CCDirector sharedDirector] replaceScene:levelSelectScene withTransition:[CCTransition transitionRevealWithDirection:CCTransitionDirectionDown duration:0.5f]];
}

- (void)updateResult:(int)newResult
{
    [resultLabel setString:[NSString stringWithFormat:@"X = %d", newResult]];
}

- (void)updateOperation:(NSArray *)operations
{
    for (NSString *op in operations)
    {
        
        if (op == [operations firstObject])
        {
            [operationLabel setString:op];
        }
        else
        {
            [operationLabel setString:[NSString stringWithFormat:@"%@ %@", operationLabel.string, op]];
        }
    }
}

- (void)increaseScoreWithMultiplier:(NSUInteger)multiplier
{
    score += remainingTime * multiplier;
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
        [self back:nil];
    }
}

- (void)increaseRemainingTime
{
    remainingTime = calculationTime;
    [clockLabel setString:[NSString stringWithFormat:@"%d", remainingTime]];
}

- (void)increaseCalculationsCompleted
{
    calculationsCompleted++;
    [self checkLevelCleared];
}

- (void)checkLevelCleared
{
    if (calculationsCompleted == calculationNumber)
    {
        [self saveScore];
        [self unschedule:@selector(decreaseRemainingTime)];
        [numbersLayer removeFromParent];
        [self showScore];
        [self performSelector:@selector(back:) withObject:nil afterDelay:3];
    }
}

- (void)saveScore
{
    {
        // get paths from root direcory
        NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
        // get documents path
        NSString *documentsPath = [paths objectAtIndex:0];
        // get the path to our Data/plist file
        NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"SavedData.plist"];
        
        NSMutableDictionary *savedData = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
        NSMutableArray *levelsSavedData = [savedData objectForKey:@"Levels"];
        
        NSMutableDictionary *savedDataOfThisLevel = [levelsSavedData objectAtIndex:currentLevel];
        
        if (score > [[savedDataOfThisLevel objectForKey:@"score"] intValue])
        {
            int stars = [self calculateStars];
            
            [savedDataOfThisLevel setObject:[NSNumber numberWithInt:score] forKey:@"score"];
            [savedDataOfThisLevel setObject:[NSNumber numberWithInt:stars] forKey:@"stars"];
        }
        
        if (savedDataOfThisLevel == [levelsSavedData lastObject])
        {
            NSDictionary *newLevelUnlocked = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0], @"stars",   [NSNumber numberWithInt:0], @"score", nil];
            [levelsSavedData addObject:newLevelUnlocked];
        }
        
        NSString *error = nil;
        NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:savedData format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
        
        
        // check is plistData exists
        if(plistData)
        {
            // write plistData to our Data.plist file
            [plistData writeToFile:plistPath atomically:YES];
        }
    }
}

- (void)updateCalculationLabel:(NSString *)text
{
    if ([calculationLabel string] == nil)
    {
        calculationLabel.fontSize = calculationLabelOriginalFontSize;
        [calculationLabel setString:text];
    }
    else
    {
        [calculationLabel setString:[NSString stringWithFormat:@"%@%@", calculationLabel.string, text]];
    }
    while (calculationLabel.contentSize.width > board.contentSize.width * 0.9 * board.scaleX)
    {
        calculationLabel.fontSize -= 0.1;
    }
}

- (void)clearCalculationLabel
{
    [calculationLabel setString:@""];
}

- (void)showScore
{
    CCLabelTTF *finalScore = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Pontos: %d", score] fontName:@"Helvetica" fontSize:32];
    finalScore.fontColor = [CCColor blackColor];
    [finalScore setPosition:ccp(paper.contentSize.width * 0.5, paper.contentSize.height * 0.75)];
    [paper addChild:finalScore];
    
    int stars = [self calculateStars];
    
    for (int i=0; i<stars; i++)
    {
        CCSprite *star = [CCSprite spriteWithImageNamed:@"star.png"];
        [star setPosition:ccp(paper.contentSize.width * (0.25*(i+1)), paper.contentSize.height * 0.5)];
        [paper addChild:star];
    }
}

- (int)calculateStars
{
    int maxScore = calculationTime * calculationNumber * maxOperands;
    if (score > maxScore * 0.75)
        return 3;
    else if (score > maxScore * 0.5)
        return 2;
    else
        return 1;
}

+ (void)setCurrentLevel:(int)l
{
    currentLevel = l;
}

+ (int)currentLevel
{
    return currentLevel;
}

@end
