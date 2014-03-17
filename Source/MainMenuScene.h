//
//  MainMenuScene.h
//  MatchX
//
//  Created by Renan Cargnin on 3/6/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"
@class GameLayer;

@interface MainMenuScene : CCNode
{
    CCLabelTTF *highscoreLabel;
}

- (void)startGame:(id)sender;

@end
