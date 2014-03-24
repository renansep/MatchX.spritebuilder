//
//  LevelSelectScene.m
//  MatchX
//
//  Created by Renan Benevides Cargnin on 3/23/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "LevelSelectScene.h"
#import "LevelIcon.h"
#import "GameScene.h"

@implementation LevelSelectScene

- (LevelSelectScene *)init
{
    self  = [super init];
    if (self)
    {
        CGSize viewSize = [[CCDirector sharedDirector] viewSize];
        
        background = [CCSprite spriteWithImageNamed:@"background.png"];
        [background setPosition:ccp(viewSize.width * 0.5, viewSize.height * 0.5)];
        [background setScaleX:viewSize.width / background.contentSize.width];
        [background setScaleY:viewSize.height / background.contentSize.height];
        [self addChild:background];

        savedData = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SavedData" ofType:@"plist"]];
        NSArray *levels = [savedData objectForKey:@"Levels"];
        
        levelIcons = [NSMutableArray new];
        
        for (int i=0; i<levels.count; i++)
        {
            NSDictionary *level = [levels objectAtIndex:i];
            BOOL locked = [[level objectForKey:@"locked"] boolValue];
            int stars = [[level objectForKey:@"stars"] intValue];
            LevelIcon *icon;
            
            if (locked)
            {
                icon = [[LevelIcon alloc] initLockedWithNumber:i+1];
            }
            else
            {
                icon = [[LevelIcon alloc] initUnlockedWithNumber:i+1 andStars:stars];
            }
            
            int column = i % 3;
            int line = i / 3;
            
            float positionX;
            switch (column)
            {
                case 0:
                    positionX = viewSize.width * 0.2;
                    break;
                case 1:
                    positionX = viewSize.width * 0.5;
                    break;
                case 2:
                    positionX = viewSize.width * 0.8;
                    break;
            }
            
            [icon setPosition:ccp(positionX, viewSize.height * 0.85 - line * ([icon height] + viewSize.height * 0.05))];
            [levelIcons addObject:icon];
            [self addChild:icon];
        }
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint location = [touch locationInNode:self];
    for (LevelIcon *i in levelIcons)
    {
        if (location.x > i.position.x - [i width] / 2 &&
            location.x < i.position.x + [i width] / 2 &&
            location.y > i.position.y - [i height] / 2 &&
            location.y < i.position.y + [i height] / 2)
        {
            if (![i locked])
            {
                [GameScene setLevelSelected:[i levelNumber] - 1];
                CCScene *gameScene = [CCBReader loadAsScene:@"GameScene"];
                [[CCDirector sharedDirector] replaceScene:gameScene withTransition:[CCTransition transitionRevealWithDirection:CCTransitionDirectionDown duration:0.5f]];
            }
        }
    }
}

@end
