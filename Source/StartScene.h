//
//  StartScene.h
//  MatchX
//
//  Created by Renan Cargnin on 3/6/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"
@class NumberLayer;

@interface StartScene : CCNode
{
    CCSprite *background;
    CCSprite *paper;
    CCSprite *notePaper;
    
    CCLabelTTF *scoreTitleLabel;
    CCLabelTTF *scoreLabel;
    CCLabelTTF *clockLabel;
    CCNode *scoreNode;
    CCNode *clockNode;
    
    CCLabelTTF *operatorsLabel;
    CCLabelTTF *resultLabel;
    int result;

    CCLabelTTF *tapAnywhereLabel;
    CCLabelTTF *tutorialLabel;
    NSString *tutorialString;
    NSMutableDictionary *tutorialLevel;
    
    NumberLayer *numberLayer;
    
    CCScene *levelSelectionScene;
    
    NSArray *tutorialText;
}

@end
