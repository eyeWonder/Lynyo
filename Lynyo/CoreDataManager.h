//
//  CoreDataManager.h
//  Shipper
//
//  Created by sergey on 13.01.16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataManager : NSObject

+(void)setStoreName:(NSString*)name;
+ (CoreDataManager *)sharedManager;
- (NSManagedObjectContext*)getManagedObjectContext;

- (void)saveDataInManagedContextUsingBlock:(void (^)(BOOL saved, NSError *error))savedBlock;

- (NSManagedObject*)fetchEntity:(NSManagedObjectID *)objectID;
- (NSFetchedResultsController *)fetchEntitiesWithClassName:(Class)type
                                           sortDescriptors:(NSArray *)sortDescriptors
                                        sectionNameKeyPath:(NSString *)sectionNameKeypath
                                                 predicate:(NSPredicate *)predicate;

- (id)createEntityWithClassName:(Class)type
           attributesDictionary:(NSDictionary *)attributesDictionary;
- (void)deleteEntity:(NSManagedObject *)entity;
- (BOOL)uniqueAttributeForClassName:(NSString *)className
                      attributeName:(NSString *)attributeName
                     attributeValue:(id)attributeValue;



-(void)deleteAllInstancesOfEntity:(Class)type;
-(void)deleteFetched:(NSFetchedResultsController*)fetchResults;
@end