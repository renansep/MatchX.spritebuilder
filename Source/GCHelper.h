//
//  GCHelper.h
//  MatchX
//
//  Created by Renan Cargnin on 4/15/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCHelper : NSObject
{
    BOOL gameCenterAvailable;
    BOOL userAuthenticated;
}

@property BOOL gameCenterAvailable;

+ (GCHelper *)sharedInstance;
- (void)authenticateLocalUser;
- (void)submitScore:(int64_t)score forCategory:(NSString *)category;

@end
