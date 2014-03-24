//
//  LevelIcon.m
//  MatchX
//
//  Created by Renan Benevides Cargnin on 3/23/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "LevelIcon.h"
#import "GameScene.h"

@implementation LevelIcon

@synthesize levelNumber;

- (LevelIcon *)initLockedWithNumber:(int)n
{
    self = [super init];
    if (self)
    {
        levelNumber = n;
        box = [CCSprite spriteWithImageNamed:@"levelBox.png"];
        
        CCLabelTTF *levelNumberLabel;
        
        levelNumberLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", n] fontName:@"NewAthleticM54" fontSize:35];
        [levelNumberLabel setOutlineWidth:3];
        [levelNumberLabel setOutlineColor:[CCColor blackColor]];
        [levelNumberLabel setPosition:ccp(box.contentSize.width * 0.5, box.contentSize.height * 0.65)];
        [levelNumberLabel setOpacity:0.5];
        
        [box addChild:levelNumberLabel];
        
        lock = [CCSprite spriteWithImageNamed:@"lock.png"];
        [lock setPosition:ccp(box.contentSize.width * 0.5, box.contentSize.height * 0.2)];
        
        [box addChild:lock];
        
        [self addChild:box];
    }
    return self;
}

- (LevelIcon *)initUnlockedWithNumber:(int)n andStars:(int)s
{
    self = [super init];
    if (self)
    {
        levelNumber = n;
        
        box = [CCSprite spriteWithImageNamed:@"levelBox.png"];
        
        CCLabelTTF *levelNumberLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", n] fontName:@"NewAthleticM54" fontSize:35];
        [levelNumberLabel setOutlineWidth:3];
        [levelNumberLabel setOutlineColor:[CCColor blackColor]];
        [levelNumberLabel setPosition:ccp(box.contentSize.width * 0.5, box.contentSize.height * 0.65)];
        
        [box addChild:levelNumberLabel];
        
        if (s >= 1)
        {
            star1 = [CCSprite spriteWithImageNamed:@"star.png"];
            [star1 setPosition:ccp(box.contentSize.width * 0.15, box.contentSize.height * 0.15)];
            [star1 setRotation:345];
            [box addChild:star1];
        }
        if (s >= 2)
        {
            star2 = [CCSprite spriteWithImageNamed:@"star.png"];
            [star2 setPosition:ccp(box.contentSize.width * 0.50, box.contentSize.height * 0.2)];
            [box addChild:star2];
        }
        if (s >= 3)
        {
            star3 = [CCSprite spriteWithImageNamed:@"star.png"];
            [star3 setPosition:ccp(box.contentSize.width * 0.85, box.contentSize.height * 0.15)];
            [star3 setRotation:15];
            [box addChild:star3];
        }
        
        [self addChild:box];
    }
    return self;
}

- (float)width
{
    return box.contentSize.width;
}

- (float)height
{
    return box.contentSize.height;
}

- (BOOL)locked
{
    return lock != nil;
}

@end
