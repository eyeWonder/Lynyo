//
//  LocalSettingsStorage.h
//  LCash
//
//  Created by Сергей on 04.06.14.
//  Copyright (c) 2014 Sergey Zaturanov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalSettingsStorage : NSObject
+ (LocalSettingsStorage *) sharedInstance;

+(void)setSetting:(NSString*)name value:(NSString*)value;
+(NSString*)getSetting:(NSString*)name;
+(void)deleteSetting:(NSString*)name;
@end
