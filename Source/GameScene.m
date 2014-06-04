//
//  GameScene.m
//  MatchX
//
//  Created by Renan Cargnin on 3/13/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Game.h"
#import "GameScene.h"
#import "NumberLayer.h"
#import "LevelSelectScene.h"
#import "GCHelper.h"

@implementation GameScene

static int currentLevel;

- (void)didLoadFromCCB
{    
    [background setScaleX:([[CCDirector sharedDirector] viewSize].width / background.contentSize.width)];
    [background setScaleY:([[CCDirector sharedDirector] viewSize].height / background.contentSize.height)];
    
    if ([[Game language] isEqualToString:@"pt"])
    {
        [scoreTitleLabel setString:@"Pontos"];
    }
    else
    {
        [scoreTitleLabel setString:@"Score"];
    }
    
    NSArray *levelsArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Levels" ofType:@"plist"]];
    NSDictionary *level = [levelsArray objectAtIndex:currentLevel];
    
    calculationTime = [(NSNumber *) [level objectForKey:@"calculationTime"] intValue];
    calculationNumber = [[level objectForKey:@"calculationNumber"] intValue];
    maxOperands = [[level objectForKey:@"maxOperands"] intValue];
    
    remainingTime = calculationTime;
    [clockLabel setString:[NSString stringWithFormat:@"%d", remainingTime]];
    
    [calculationLabel setString:@""];
    calculationsCompleted = 0;
    score = 0;
    [self updateScore];
    
    //Stores the board label original font size
    calculationLabelOriginalFontSize = calculationLabel.fontSize;
    
    numbersLayer = [[NumberLayer alloc] initWithLevel:level];
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
    
    self.userInteractionEnabled = YES;
}

- (void)back:(id)sender
{
    [self unscheduleAllSelectors];
    LevelSelectScene *levelSelectScene = [LevelSelectScene new];
    [[CCDirector sharedDirector] replaceScene:levelSelectScene withTransition:[CCTransition transitionRevealWithDirection:CCTransitionDirectionDown duration:0.5f]];
}

#pragma mark - updateMethods

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

- (void)updateScore
{
    [scoreLabel setString:[NSString stringWithFormat:@"%lld", score]];
}

- (void)increaseScoreWithMultiplier:(NSUInteger)multiplier
{
    score += remainingTime * multiplier;
    [self updateScore];
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

#pragma mark -gamePlay control

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

- (void)clearCalculationLabel
{
    [calculationLabel setString:@""];
}

#pragma mark - remainingTime
- (void)decreaseRemainingTime
{
    remainingTime--;
    [clockLabel setString:[NSString stringWithFormat:@"%d", remainingTime]];
    if (remainingTime == 0)
    {
        self.userInteractionEnabled = NO;
        [self unschedule:@selector(decreaseRemainingTime)];
        [self back:nil];
    }
}

- (void)increaseRemainingTime
{
    remainingTime = calculationTime;
    [clockLabel setString:[NSString stringWithFormat:@"%d", remainingTime]];
}

#pragma mark -scoreHandling

- (void)saveScore
{
    NSMutableArray *savedData;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"useiCloud"] boolValue] == NO)
    {
        savedData = [NSMutableArray arrayWithArray:[Game getArrayFromPlistFileInDocumentsFolderWithFileName:@"LevelsSavedData"]];
    }
    else
    {
        savedData = [NSMutableArray arrayWithArray:[[NSUbiquitousKeyValueStore defaultStore] objectForKey:@"LevelsSavedData"]];
    }
    
    NSMutableDictionary *savedDataOfThisLevel;
    
    savedDataOfThisLevel = [NSMutableDictionary dictionaryWithDictionary:[savedData objectAtIndex:currentLevel]];
    
    if (score > [[savedDataOfThisLevel objectForKey:@"score"] intValue])
    {
        int stars = [self calculateStars];
        [savedDataOfThisLevel setObject:[NSNumber numberWithInt:(int)score] forKey:@"score"];
        [savedDataOfThisLevel setObject:[NSNumber numberWithInt:stars] forKey:@"stars"];
        [savedData setObject:savedDataOfThisLevel atIndexedSubscript:currentLevel];
    }
    
    if ([savedData objectAtIndex:currentLevel] == [savedData lastObject])
    {
        NSDictionary *newLevelUnlocked = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0], @"stars", [NSNumber numberWithInt:0], @"score", nil];
        [savedData addObject:newLevelUnlocked];
    }
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"useiCloud"] boolValue] == NO)
    {
        [Game saveArray:savedData ToDocumentsFolderInPlistFile:@"LevelsSavedData"];
    }
    else
    {
        [[NSUbiquitousKeyValueStore defaultStore] setObject:savedData forKey:@"LevelsSavedData"];
    }
    
    int64_t totalStars = 0;
    for (NSDictionary *d in savedData)
    {
        totalStars += [[d objectForKey:@"stars"] intValue];
    }
    [[GCHelper sharedInstance] submitScore:totalStars forCategory:@"Stars"];
}

- (void)showScore
{
    CCLabelTTF *finalScore = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Pontos: %lld", score] fontName:@"Helvetica" fontSize:32];
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
    if (score > maxScore * 0.66)
        return 3;
    else if (score > maxScore * 0.33)
        return 2;
    else
        return 1;
}

#pragma mark -get/set

+ (void)setCurrentLevel:(int)l
{
    currentLevel = l;
}

+ (int)currentLevel
{
    return currentLevel;
}

@end
