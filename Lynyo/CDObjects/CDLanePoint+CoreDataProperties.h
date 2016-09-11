//
//  CDLanePoint+CoreDataProperties.h
//  
//
//  Created by sergey on 25.05.16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CDLanePoint.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDLanePoint (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *address;
@property (nullable, nonatomic, retain) NSNumber *latitude;
@property (nullable, nonatomic, retain) NSNumber *longitude;

@end

NS_ASSUME_NONNULL_END
