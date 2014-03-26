//
//  GameNumber.m
//  MatchX
//
//  Created by Renan Cargnin on 3/13/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameNumber.h"

@implementation GameNumber

@synthesize intValue, isEmpty;

static CGSize size;
static int minNumber;
static int maxNumber;

- (GameNumber *)init
{
    self = [super initWithColor:[CCColor clearColor] width:size.width height:size.height];
    if (self)
    {
        [self setAnchorPoint:ccp(0.5, 0.5)];
        
        intValue = (arc4random() % (maxNumber - minNumber + 1)) + minNumber;
        numberLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", intValue] fontName:@"Helvetica" fontSize:18];
        [numberLabel setFontColor:[CCColor blackColor]];
        [numberLabel setPosition:ccp(size.width * 0.5, size.height * 0.5)];
        [self addChild:numberLabel];
    
        isEmpty = NO;
        
        background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5] width:self.contentSize.width height:self.contentSize.height];
        [background setAnchorPoint:CGPointMake(0.5, 0.5)];
        [background setPosition:CGPointMake(self.contentSize.width / 2, self.contentSize.height / 2)];
        [background setScale:0.95];
        [background setVisible:NO];
        [self addChild:background];
    }
    return self;
}

- (GameNumber *)initEmpty
{
    self = [super initWithColor:[CCColor clearColor] width:size.width height:size.height];
    if (self)
    {
        isEmpty = YES;
    }
    return self;
}

- (BOOL)selected
{
    if (isEmpty)
        return YES;
    return [background visible];
}

- (void)setSelected:(BOOL)s
{
    [background setVisible:s];
}

- (void)runDestroyAnimation
{
    intValue = (arc4random() % (maxNumber - minNumber + 1)) + minNumber;
    
    CCActionRotateBy *rotateBy = [CCActionRotateBy actionWithDuration:0.5 angle:1440];
    CCActionScaleTo *scaleToZero = [CCActionScaleTo actionWithDuration:0.5 scale:0];
    CCActionScaleTo *scaleToOne = [CCActionScaleTo actionWithDuration:0.5 scale:1];
    
    CCActionSpawn *actionDestroy = [CCActionSpawn actionOne:rotateBy two:scaleToZero];
    CCActionCallFunc *changeTexture = [CCActionCallFunc actionWithTarget:self selector:@selector(changeNumber)];
    CCActionSpawn *actionRegen = [CCActionSpawn actionOne:rotateBy two:scaleToOne];
    
    CCActionSequence *sequence = [CCActionSequence actions:actionDestroy, changeTexture, actionRegen, nil];
    
    [self runAction:sequence];
}
                                  
- (void)changeNumber
{
    [numberLabel setString:[NSString stringWithFormat:@"%d", intValue]];
}

+ (void)setSize:(CGSize)s
{
    size = s;
}

+ (CGSize)size
{
    return size;
}

+ (void)setMinNumber:(int)n
{
    minNumber = n;
}

+ (void)setMaxNumber:(int)n
{
    maxNumber = n;
}

@end
