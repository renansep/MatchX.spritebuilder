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

@synthesize operation, result;

- (NumberLayer *)initWithLevel:(NSDictionary *)level
{
    NSArray *map = [level objectForKey:@"map"];
    int lines = map.count;
    int columns = [(NSString *) [map objectAtIndex:0] length];
    
    GameNumber *n = [GameNumber new];
    self = [super initWithColor:[CCColor clearColor] width:columns*n.contentSize.height height:lines*n.contentSize.width];
    n = nil;
    
    if (self)
    {
        self.userInteractionEnabled = YES;
        trace = [[NSMutableArray alloc] init];
        numbers = [[NSMutableArray alloc] init];
        
        for (int i=0; i<map.count; i++)
        {
            [numbers addObject:[[NSMutableArray alloc] init]];
            NSString *line = map[i];
            for (int j=0; j<[line length]; j++)
            {
                if ([line characterAtIndex:j] == '1')
                {
                    GameNumber *number = [GameNumber new];
                    [[numbers objectAtIndex:i] addObject:number];
                    [number setPosition:ccp(j * number.contentSize.width + number.contentSize.width / 2, i * number.contentSize.height + number.contentSize.height / 2)];
                    [self addChild:number];
                    /*
                    CCSprite *border = [CCSprite spriteWithImageNamed:@"numberBorder.png"];
                    [border setPosition:number.position];
                    [self addChild:border];
                     */
                }
                else if ([line characterAtIndex:j] == '0')
                {
                    [[numbers objectAtIndex:i] addObject:[[GameNumber alloc] initEmpty]];
                }
            }
        }
        numbersSelected = 0;
        lastNumberSelected = nil;
        
        [self generateOperation];
        [self generateResult];
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
            if (![n selected] &&
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
            if (![n selected] &&
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
                }
                else
                {
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
    
    int pontos = 0;
    
    for (GameNumber *n in trace)
    {
        if (n == [trace firstObject])
        {
            traceResult = [n intValue];
            pontos = [n intValue];
        }
        else
        {
            traceResult = [self calculateWithFirstNumber:traceResult andSecondNumber:[n intValue] andOperation:operation];
            pontos = pontos * 10 + [n intValue];
        }
        [n setSelected:NO];
    }
    
    if (traceResult == result)
    {
        [self tradeNumbers:trace];
        [self generateOperation];
        [self generateResult];
        GameScene *scene = (GameScene *) self.parent;
        [scene updateResult:result];
        [scene updateOperation:operation];
    }
    
    trace = [[NSMutableArray alloc] init];
    
    numbersSelected = 0;
    
    NSLog(@"Pontos: %d", pontos);
    NSLog(@"Trace result: %d", traceResult);
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
    
    //defines the max numbers of operands thart the calculation will have
    int operandsCount = /*arc4random() % 3 + */2;
    
    NSMutableArray *operands = [[NSMutableArray alloc] init];
    
    [operands addObject:randomNumber];
    GameNumber *lastOperand = [operands objectAtIndex:0];
    
    int newResult = [lastOperand intValue];
    
    for (int i=1; i<operandsCount; i++)
    {
        GameNumber *neighborOfLastOperand = [self getRandomNeighborOf:lastOperand Without:operands];
        if (neighborOfLastOperand == nil)
        {
            result = newResult;
            return result;
        }
        else
        {
            lastOperand = neighborOfLastOperand;
            [operands addObject:lastOperand];
            newResult = [self calculateWithFirstNumber:newResult andSecondNumber:[lastOperand intValue] andOperation:operation];
        }
    }
    result = newResult;
    return result;
}

- (int)calculateWithFirstNumber:(int)n1 andSecondNumber:(int)n2 andOperation:(NSString *)op
{
    if ([op isEqualToString:@"add"])
    {
        return n1 + n2;
    }
    else if ([op isEqualToString:@"sub"])
    {
        return n1 - n2;
    }
    else if ([op isEqualToString:@"mult"])
    {
        return n1 * n2;
    }
    else if ([op isEqualToString:@"div"])
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

- (void)generateOperation
{
    NSArray *operations = [NSArray arrayWithObjects:@"add", @"sub", @"mult", nil];
    operation = [operations objectAtIndex:arc4random() % [operations count]];
}

- (void)tradeNumbers:(NSArray *)tradeList
{
    for (GameNumber *n in tradeList)
    {
        [n runDestroyAnimation];
    }
}


@end
