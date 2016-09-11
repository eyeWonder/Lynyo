//
//  HereHelper.h
//  Lynyo
//
//  Created by sergey on 10.09.16.
//  Copyright © 2016 Ivango. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDWayPoint.h"
#import "CDLanePoint.h"
#import <NMAKit/NMAKit.h>

@interface HereHelper : NSObject<NMARouteManagerDelegate>
+(NMAGeoCoordinates*)geocodeAddress:(CDLanePoint*)lanePoint;
+(NSArray<CDWayPoint*>*)calculateWayPoints:(NSArray<CDLanePoint*>*)lanePoints hours:(int)hours;


+ (void) startSearch:(NMAGeoCoordinates*)coords categories:(NSArray*)categories;

@end
