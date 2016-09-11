//
//  CDDrive+CoreDataProperties.h
//  Lynyo
//
//  Created by sergey on 10.09.16.
//  Copyright © 2016 Ivango. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDDrive.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDDrive (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *isStarted;
@property (nullable, nonatomic, retain) NSNumber *truckType;
@property (nullable, nonatomic, retain) NSNumber *weight;
@property (nullable, nonatomic, retain) NSNumber *hoursLeft;
@property (nullable, nonatomic, retain) NSOrderedSet<CDLanePoint *> *lanePoints;

@end

@interface CDDrive (CoreDataGeneratedAccessors)

- (void)insertObject:(CDLanePoint *)value inLanePointsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromLanePointsAtIndex:(NSUInteger)idx;
- (void)insertLanePoints:(NSArray<CDLanePoint *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeLanePointsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInLanePointsAtIndex:(NSUInteger)idx withObject:(CDLanePoint *)value;
- (void)replaceLanePointsAtIndexes:(NSIndexSet *)indexes withLanePoints:(NSArray<CDLanePoint *> *)values;
- (void)addLanePointsObject:(CDLanePoint *)value;
- (void)removeLanePointsObject:(CDLanePoint *)value;
- (void)addLanePoints:(NSOrderedSet<CDLanePoint *> *)values;
- (void)removeLanePoints:(NSOrderedSet<CDLanePoint *> *)values;

@end

NS_ASSUME_NONNULL_END
