//
//  Game.h
//  MatchX
//
//  Created by Renan Cargnin on 4/7/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Game : NSObject

+ (NSDictionary *)getDictionaryFromPlistFileInDocumentsFolderWithFileName:(NSString *)fileName;
+ (NSArray *)getArrayFromPlistFileInDocumentsFolderWithFileName:(NSString *)fileName;
+ (void)saveDictionary:(NSDictionary *)dictionary ToDocumentsFolderInPlistFile:(NSString *)fileName;
+ (void)saveArray:(NSArray *)array ToDocumentsFolderInPlistFile:(NSString *)fileName;
+ (NSString *)language;

@end
