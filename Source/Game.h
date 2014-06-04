//
//  Game.h
//  MatchX
//
//  Created by Renan Cargnin on 4/7/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GADBannerView.h"

@interface Game : NSObject <GADBannerViewDelegate>

+ (NSDictionary *)getDictionaryFromPlistFileInDocumentsFolderWithFileName:(NSString *)fileName;
+ (NSArray *)getArrayFromPlistFileInDocumentsFolderWithFileName:(NSString *)fileName;
+ (void)saveDictionary:(NSDictionary *)dictionary ToDocumentsFolderInPlistFile:(NSString *)fileName;
+ (void)saveArray:(NSArray *)array ToDocumentsFolderInPlistFile:(NSString *)fileName;
+ (NSString *)language;
+ (void)showBanner;
+ (void)hideBanner;
+ (void)loadAds;
+ (GADBannerView *)bannerView;

@end
