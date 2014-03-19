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

- (GameNumber *)init
{
    int random = arc4random() % 9 + 1;
    self = [super initWithImageNamed:[NSString stringWithFormat:@"number%d.png", random]];
    if (self)
    {
        isEmpty = NO;
        
        intValue = random;
        
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
    self = [super init];
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
    int random = arc4random() % 9 + 1;
    
    [self setIntValue:random];
    
    CCActionRotateBy *rotateBy = [CCActionRotateBy actionWithDuration:0.5 angle:1440];
    CCActionScaleTo *scaleToZero = [CCActionScaleTo actionWithDuration:0.5 scale:0];
    CCActionScaleTo *scaleToOne = [CCActionScaleTo actionWithDuration:0.5 scale:1];
    
    CCActionSpawn *actionDestroy = [CCActionSpawn actionOne:rotateBy two:scaleToZero];
    CCActionCallFunc *changeTexture = [CCActionCallFunc actionWithTarget:self selector:@selector(changeNumberTexture)];
    CCActionSpawn *actionRegen = [CCActionSpawn actionOne:rotateBy two:scaleToOne];
    
    CCActionSequence *sequence = [CCActionSequence actions:actionDestroy, changeTexture, actionRegen, nil];
    
    [self runAction:sequence];
}
                                  
- (void)changeNumberTexture
{
    CCTexture *texture = [CCTexture textureWithFile:[NSString stringWithFormat:@"number%d.png", [self intValue]]];
    [self setTexture:texture];
}

@end
