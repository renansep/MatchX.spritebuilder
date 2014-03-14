//
//  NumberLayer.m
//  MatchX
//
//  Created by Renan Cargnin on 3/14/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "NumberLayer.h"
#import "GameNumber.h"

@implementation NumberLayer

- (NumberLayer *)initWithLines:(int)lines andWithColumns:(int)columns
{
    GameNumber *n = [GameNumber new];
    self = [super initWithColor:[CCColor whiteColor] width:lines*n.contentSize.height height:columns*n.contentSize.width];
    if (self)
    {
        self.userInteractionEnabled = YES;
        
        trace = [[NSMutableArray alloc] init];
        
        numbers = [[NSMutableArray alloc] init];
        
        for (int i=0; i<lines; i++)
        {
            [numbers addObject:[[NSMutableArray alloc] init]];
            for (int j=0; j<columns; j++)
            {
                GameNumber *number = [GameNumber new];
                [[numbers objectAtIndex:i] addObject:number];
                [number setPosition:CGPointMake(j * number.contentSize.width + number.contentSize.width / 2, i * number.contentSize.height + number.contentSize.height / 2)];
                [self addChild:number];
            }
            
            numbersSelected = 0;
            lastNumberSelected = nil;
        }
    }
    return self;
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    NSLog(@"Moved");
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
                if (numbersSelected == 0)
                {
                    [n setSelected:YES];
                    numbersSelected++;
                    lastNumberSelected = n;
                    [trace addObject:n];
                }
                else
                {
                    GameNumber *above;
                    GameNumber *under;
                    GameNumber *right;
                    GameNumber *left;
                    
                    if (i > 0)
                        under = numbers[i-1][j];
                    if (i < line.count-1)
                        above = numbers[i+1][j];
                    if (j > 0)
                        left = numbers[i][j-1];
                    if (j < numbers.count-1)
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
    for (GameNumber *n in trace)
    {
        NSLog(@"%d", [n intValue]);
    }
    trace = [[NSMutableArray alloc] init];
    numbersSelected = 0;
}

@end
