//
//  AppDelegate.h
//  Lynyo
//
//  Created by sergey on 10.09.16.
//  Copyright © 2016 Ivango. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "CoreDataManager.h"
#import <NMAKit/NMAKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) CoreDataManager* dm;

@end

