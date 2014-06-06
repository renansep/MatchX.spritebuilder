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
#import "Game.h"

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
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"useiCloud"] boolValue] == NO)
        {
            savedData = [Game getArrayFromPlistFileInDocumentsFolderWithFileName:@"LevelsSavedData"];
        }
        else
        {
            savedData = [[NSUbiquitousKeyValueStore defaultStore] objectForKey:@"LevelsSavedData"];
        }
        
        NSArray *levels = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Levels" ofType:@"plist"]];
        
        //Loads the scroll view
        scroll = [CCScrollView new];
        [scroll setHorizontalScrollEnabled:NO];
        [scroll setBounces:NO];
        
        levelIcons = [NSMutableArray new];
        
        for (int i=0; i<levels.count; i++)
        {
            LevelIcon *icon;
            if (i < savedData.count)
            {
                NSDictionary *level = [savedData objectAtIndex:i];
                int stars = [[level objectForKey:@"stars"] intValue];
                icon = [[LevelIcon alloc] initUnlockedWithNumber:i+1 andStars:stars];
            }
            else
            {
                icon = [[LevelIcon alloc] initLockedWithNumber:i+1];
            }
            
            if (i == 0)
            {
                int extraline;
                if (levels.count % 3 == 0)
                {
                    extraline = 1;
                }
                else
                {
                    extraline = 2;
                }
                levelIconsNode = [CCNodeColor nodeWithColor:[CCColor clearColor] width:viewSize.width height:(levels.count / 3 + extraline) * [icon height] * 1.5];
                [levelIconsNode setAnchorPoint:ccp(0,1)];
                [levelIconsNode setPosition:ccp(0, viewSize.height * 0.9)];
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
            
            [icon setPosition:ccp(positionX, levelIconsNode.contentSize.height - [icon height] * 1.5 - (line * [icon height]) * 1.5 - ([icon height] / 2))];
            
            [levelIcons addObject:icon];
            [levelIconsNode addChild:icon];
        }
        [scroll setContentNode:levelIconsNode];
        [scroll setScrollPosition:ccp(0, [[[NSUserDefaults standardUserDefaults] objectForKey:@"scrollLastPosition"] floatValue])];
        [self addChild:scroll];
        
        //Title label
        NSString *title;
        if ([[Game language] isEqualToString:@"pt"])
        {
            title = @"Escolha uma fase";
        }
        else
        {
            title = @"Select a level";
        }
        
        CCLabelTTF *titleLabel = [CCLabelTTF labelWithString:title fontName:@"NewAthleticM54" fontSize:32];
        [titleLabel setOutlineColor:[CCColor blackColor]];
        [titleLabel setOutlineWidth:3];
        [titleLabel setPosition:ccp(viewSize.width * 0.5, viewSize.height - titleLabel.contentSize.height)];
        
        CCSprite *backgroundOverlay = [CCSprite spriteWithImageNamed:@"background.png"];
        [backgroundOverlay setScaleX:viewSize.width / backgroundOverlay.contentSize.width];
        [backgroundOverlay setAnchorPoint:ccp(0.5,0)];
        [backgroundOverlay flipX];
        [backgroundOverlay flipY];
        [backgroundOverlay setPosition:ccp(viewSize.width * 0.5, titleLabel.position.y - titleLabel.contentSize.height)];
        [self addChild:backgroundOverlay];
        
        [self addChild:titleLabel];
        
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
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
                self.userInteractionEnabled = NO;
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:scroll.scrollPosition.y] forKey:@"scrollLastPosition"];
                [GameScene setCurrentLevel:[i levelNumber] - 1];
                CCScene *gameScene = [CCBReader loadAsScene:@"GameScene"];
                [[CCDirector sharedDirector] replaceScene:gameScene withTransition:[CCTransition transitionRevealWithDirection:CCTransitionDirectionDown duration:0.5f]];
            }
        }
    }
}

@end
