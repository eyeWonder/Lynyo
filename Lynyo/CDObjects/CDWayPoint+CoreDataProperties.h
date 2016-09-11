//
//  CDWayPoint+CoreDataProperties.h
//  Lynyo
//
//  Created by sergey on 10.09.16.
//  Copyright © 2016 Ivango. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDWayPoint.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDWayPoint (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *stopType;
@property (nullable, nonatomic, retain) NSDate *arrivalTime;
@property (nullable, nonatomic, retain) NSNumber *toDistance;
@property (nullable, nonatomic, retain) NSNumber *toFuleAmount;
@property (nullable, nonatomic, retain) NSNumber *toFuelPrice;
@property (nullable, nonatomic, retain) NSNumber *toTime;
@property (nullable, nonatomic, retain) NSNumber *stayTime;
@property (nullable, nonatomic, retain) CDDrive *drive;
@property (nullable, nonatomic, retain) CDLanePoint *lanePoint;

@end

NS_ASSUME_NONNULL_END
