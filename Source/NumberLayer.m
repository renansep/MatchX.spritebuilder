//
//  NumberLayer.m
//  MatchX
//
//  Created by Renan Cargnin on 3/14/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameScene.h"
#import "NumberLayer.h"
#import "GameNumber.h"

@implementation NumberLayer

@synthesize result, operations;

- (NumberLayer *)initWithLevel:(NSDictionary *)level
{
    NSArray *map = [level objectForKey:@"map"];
    NSUInteger lines = map.count;
    NSUInteger columns = [(NSString *) [map objectAtIndex:0] length];
    
    CCSprite *border = [CCSprite spriteWithImageNamed:@"numberBorder.png"];
    self = [super initWithColor:[CCColor clearColor] width:columns*border.contentSize.height height:lines*border.contentSize.width];
    [GameNumber setSize:border.contentSize];
    border = nil;
    
    if (self)
    {
        [self setAnchorPoint:CGPointMake(0.5, 0.5)];
        [GameNumber setMinNumber:[[level objectForKey:@"minNumber"] intValue]];
        [GameNumber setMaxNumber:[[level objectForKey:@"maxNumber"] intValue]];
        maxOperands = [[level objectForKey:@"maxOperands"] intValue];
        operations = [level objectForKey:@"operations"];
        
        trace = [[NSMutableArray alloc] init];
        numbers = [[NSMutableArray alloc] init];
        
        for (int i=0; i<map.count; i++)
        {
            [numbers addObject:[[NSMutableArray alloc] init]];
            NSString *line = map[i];
            for (int j=0; j<[line length]; j++)
            {
                CCSprite *border = [CCSprite spriteWithImageNamed:@"numberBorder.png"];
                [border setPosition:ccp(j * border.contentSize.width + border.contentSize.width / 2, i * border.contentSize.height + border.contentSize.height / 2)];
                [self addChild:border];
                
                GameNumber *number;
                
                if ([line characterAtIndex:j] == '1')
                {
                    number = [GameNumber new];
                }
                else if ([line characterAtIndex:j] == '0')
                {
                    number = [[GameNumber alloc] initEmpty];
                }
                [number setPosition:border.position];
                [[numbers objectAtIndex:i] addObject:number];
                [self addChild:number];
            }
        }
        numbersSelected = 0;
        lastNumberSelected = nil;
        
        [self generateResult];
        if ([[level objectForKey:@"tutorial"] boolValue])
        {
            self.userInteractionEnabled = NO;
            touchIcon = [CCSprite spriteWithImageNamed:@"touchIcon.png"];
            [touchIcon setPosition:ccp(self.contentSize.width * 0.5, self.contentSize.height * 0.9)];
            [self addChild:touchIcon];
            [self startPlaying];
        }
        else
        {
            self.userInteractionEnabled = YES;
        }
    }
    return self;
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint location = [touch locationInNode:self];
    for (int i=0; i<numbers.count; i++)
    {
        NSMutableArray *line = [numbers objectAtIndex:i];
        for (int j=0; j<line.count; j++)
        {
            GameNumber *n = numbers[i][j];
            if (![n selected] && [n numberOfRunningActions] == 0 &&
                location.x > n.position.x - n.contentSize.width / 2 * n.scale &&
                location.x < n.position.x + n.contentSize.width / 2 * n.scale &&
                location.y > n.position.y - n.contentSize.height / 2 * n.scale &&
                location.y < n.position.y + n.contentSize.height / 2 * n.scale)
            {
                if (numbersSelected == 0)
                {
                    [n setSelected:YES];
                    numbersSelected++;
                    lastNumberSelected = n;
                    [trace addObject:n];
                    [gameScene unschedule:@selector(clearCalculationLabel)];
                    [gameScene clearCalculationLabel];
                    if ([n intValue] >= 0)
                        [gameScene updateCalculationLabel:[NSString stringWithFormat:@"%d", [n intValue]]];
                    else
                        [gameScene updateCalculationLabel:[NSString stringWithFormat:@"(%d)", [n intValue]]];
                    operation = [operations objectAtIndex:0];
                }
            }
        }
    }
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint location = [touch locationInNode:self];
    for (int i=0; i<numbers.count; i++)
    {
        NSMutableArray *line = [numbers objectAtIndex:i];
        for (int j=0; j<line.count; j++)
        {
            GameNumber *n = numbers[i][j];
            if (![n selected] && [n numberOfRunningActions] == 0 &&
                location.x > n.position.x - n.contentSize.width / 3 * n.scale &&
                location.x < n.position.x + n.contentSize.width / 3 * n.scale &&
                location.y > n.position.y - n.contentSize.height / 3 * n.scale &&
                location.y < n.position.y + n.contentSize.height / 3 * n.scale)
            {
                GameNumber *above;
                GameNumber *under;
                GameNumber *right;
                GameNumber *left;
                
                if (i > 0)
                    under = numbers[i-1][j];
                if (i < numbers.count-1)
                    above = numbers[i+1][j];
                if (j > 0)
                    left = numbers[i][j-1];
                if (j < line.count-1)
                    right = numbers[i][j+1];
                
                if (lastNumberSelected == under || lastNumberSelected == above || lastNumberSelected == right || lastNumberSelected == left)
                {
                    lastNumberSelected = n;
                    [n setSelected:YES];
                    numbersSelected++;
                    [trace addObject:n];
                    if ([n intValue] >= 0)
                        [gameScene updateCalculationLabel:[NSString stringWithFormat:@"%@%d", operation, [n intValue]]];
                    else
                        [gameScene updateCalculationLabel:[NSString stringWithFormat:@"%@(%d)", operation, [n intValue]]];
                    operation = [self nextOperation];
                }
                else
                {
                    if (trace.count > 0)
                        [self finishedTrace];
                }
                return;
            }
        }
    }
}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    if ([trace count] > 0)
    {
        [self finishedTrace];
    }
}

- (void)finishedTrace
{
    int traceResult;
    
    for (GameNumber *n in trace)
    {
        if (n == [trace firstObject])
        {
            traceResult = [n intValue];
            operation = [operations objectAtIndex:0];
        }
        else
        {
            traceResult = [self calculateWithFirstNumber:traceResult andSecondNumber:[n intValue] andOperation:operation];
            operation = [self nextOperation];
        }
        [n setSelected:NO];
    }
    
    if (traceResult == result)
    {
        [[OALSimpleAudio sharedInstance] playEffect:@"Sounds/score.caf"];
        
        [self tradeNumbers:trace];
        [self generateResult];
    
        [gameScene updateResult:result];
        [gameScene increaseScoreWithMultiplier:trace.count];
        [gameScene updateScore];
        [gameScene increaseRemainingTime];
        [gameScene increaseCalculationsCompleted];
    }
    else
    {
        [[OALSimpleAudio sharedInstance] playEffect:@"Sounds/miss.caf"];
    }
    
    [gameScene updateCalculationLabel:[NSString stringWithFormat:@"=%d", traceResult]];
    [gameScene scheduleOnce:@selector(clearCalculationLabel) delay:1];
    
    trace = [[NSMutableArray alloc] init];
    
    numbersSelected = 0;
}

- (int)generateResult
{
    GameNumber *randomNumber;
    NSMutableArray *line;
    do
    {
        //selects a random line in the number`s grid
        int randomLine = arc4random() % numbers.count;
        line = numbers[randomLine];
    
        //selects a random column within the line
        int randomColumn = arc4random() % line.count;
        
        randomNumber = line[randomColumn];
    } while ([randomNumber isEmpty]);
    
    NSMutableArray *operands = [[NSMutableArray alloc] init];
    
    [operands addObject:randomNumber];
    GameNumber *lastOperand = [operands objectAtIndex:0];
    operation = [operations objectAtIndex:0];
    
    int newResult = [lastOperand intValue];
    
    for (int i=1; i<maxOperands; i++)
    {
        GameNumber *neighborOfLastOperand = [self getRandomNeighborOf:lastOperand Without:operands];
        if (neighborOfLastOperand == nil)
        {
            result = newResult;
            resultTrace = operands;
            return result;
        }
        else
        {
            lastOperand = neighborOfLastOperand;
            [operands addObject:lastOperand];
            newResult = [self calculateWithFirstNumber:newResult andSecondNumber:[lastOperand intValue] andOperation:operation];
        }
        operation = [self nextOperation];
    }
    result = newResult;
    resultTrace = operands;
    return result;
}

- (int)calculateWithFirstNumber:(int)n1 andSecondNumber:(int)n2 andOperation:(NSString *)op
{
    if ([op isEqualToString:@"+"])
    {
        return n1 + n2;
    }
    else if ([op isEqualToString:@"-"])
    {
        return n1 - n2;
    }
    else if ([op isEqualToString:@"x"])
    {
        return n1 * n2;
    }
    else if ([op isEqualToString:@"/"])
    {
        return n1 / n2;
    }
    else
    {
        return 0;
    }
}

- (GameNumber *)getRandomNeighborOf:(GameNumber *)number Without:(NSArray *)excludeNumbers
{
    for (int i=0; i<numbers.count; i++)
    {
        NSMutableArray *line = numbers[i];
        if ([line containsObject:number])
        {
            NSInteger column = [line indexOfObject:number];
            
            NSMutableArray *neighbors = [[NSMutableArray alloc] init];
            
            GameNumber *n;
            
            if (i > 0)
            {
                NSMutableArray *lineBelow = numbers[i-1];
                n = lineBelow[column];
                if (![excludeNumbers containsObject:n] && ![n isEmpty])
                {
                    [neighbors addObject:n];
                }
            }
            if (i < numbers.count - 1)
            {
                NSMutableArray *lineAbove = numbers[i+1];
                n = lineAbove[column];
                if (![excludeNumbers containsObject:n] && ![n isEmpty])
                {
                    [neighbors addObject:n];
                }
            }
            if (column > 0)
            {
                n = line[column-1];
                if (![excludeNumbers containsObject:n] && ![n isEmpty])
                {
                    [neighbors addObject:n];
                }
            }
            if (column < line.count-1)
            {
                n = line[column+1];
                if (![excludeNumbers containsObject:n] && ![n isEmpty])
                {
                    [neighbors addObject:n];
                }
            }
            
            if (neighbors.count == 0)
                return nil;
            
            return [neighbors objectAtIndex:arc4random() % neighbors.count];
        }
    }
    return nil;
}

- (void)tradeNumbers:(NSArray *)tradeList
{
    for (GameNumber *n in tradeList)
    {
        [n runDestroyAnimation];
    }
}

- (void)setScene:(GameScene *)scene
{
    gameScene = scene;
}

- (NSString *)nextOperation
{
    if (operations.count - 1 != [operations indexOfObject:operation])
    {
        return [operations objectAtIndex:[operations indexOfObject:operation] + 1];
    }
    else
    {
        return [operations objectAtIndex:0];
    }
}

- (void)startPlaying
{
    NSMutableArray *actions = [NSMutableArray new];
    for (GameNumber *g in resultTrace)
    {
        CCActionMoveTo *moveToNumber = [CCActionMoveTo actionWithDuration:1 position:ccp(g.position.x, g.position.y - g.contentSize.height / 2)];
        CCActionCallBlock *selectNumber = [CCActionCallBlock actionWithBlock:^{
            [g setSelected:YES];
        }];
        CCActionSequence *moveToAndSelectNumber = [CCActionSequence actions:moveToNumber, selectNumber, nil];
        [actions addObject:moveToAndSelectNumber];
    }
    
    [actions addObject:[CCActionCallBlock actionWithBlock:^{
        for (GameNumber *g in resultTrace)
        {
            [g setSelected:NO];
        }
        [self tradeNumbers:resultTrace];
    }]];
    
    [actions addObject:[CCActionCallFunc actionWithTarget:self selector:@selector(generateResult)]];
    [actions addObject:[CCActionCallFunc actionWithTarget:self selector:@selector(startPlaying)]];
    
    CCActionSequence *allActions = [CCActionSequence actionWithArray:actions];
    [touchIcon runAction:allActions];
}

@end
