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
        
        //Title label
        CCLabelTTF *titleLabel = [CCLabelTTF labelWithString:@"Escolha uma Fase" fontName:@"NewAthleticM54" fontSize:32];
        [titleLabel setOutlineColor:[CCColor blackColor]];
        [titleLabel setOutlineWidth:3];
        [titleLabel setPosition:ccp(viewSize.width * 0.5, viewSize.height - titleLabel.contentSize.height)];
        [self addChild:titleLabel];

        //Load user saved data, too check witch levels are locked
        savedData = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SavedData" ofType:@"plist"]];
        NSArray *levels = [savedData objectForKey:@"Levels"];
        
        levelIconsNode = [CCNode new];
        [levelIconsNode setAnchorPoint:ccp(0, 1)];
        
        scrollView = [CCScrollView new];
        
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
            
            //[icon setPosition:ccp(positionX, titleLabel.position.y * 0.85 - line * ([icon height] + viewSize.height * 0.05))];
            
            [icon setPosition:ccp(positionX, -(line * [icon height]) * 1.5 - ([icon height] / 2))];
            
            [levelIcons addObject:icon];
            [levelIconsNode addChild:icon];
        }
        [levelIconsNode setPosition:ccp(0, titleLabel.position.y - titleLabel.contentSize.height)];
        [self addChild:levelIconsNode];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint location = [touch locationInNode:levelIconsNode];
    for (LevelIcon *i in levelIcons)
    {
        if (location.x > i.position.x - [i width] / 2 &&
            location.x < i.position.x + [i width] / 2 &&
            location.y > i.position.y - [i height] / 2 &&
            location.y < i.position.y + [i height] / 2)
        {
            if (![i locked])
            {
                [GameScene setCurrentLevel:[i levelNumber] - 1];
                CCScene *gameScene = [CCBReader loadAsScene:@"GameScene"];
                [[CCDirector sharedDirector] replaceScene:gameScene withTransition:[CCTransition transitionRevealWithDirection:CCTransitionDirectionDown duration:0.5f]];
            }
        }
    }
}

@end
