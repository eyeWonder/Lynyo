//
//  CoreDataManager.m
//  Shipper
//
//  Created by sergey on 13.01.16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import "CoreDataManager.h"

@interface CoreDataManager ()

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)setupManagedObjectContext;

@end

@implementation CoreDataManager

static CoreDataManager *coreDataManager;

+ (CoreDataManager *)sharedManager
{
    if (!coreDataManager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            coreDataManager = [[CoreDataManager alloc] init];
        });
        
    }
    
    return coreDataManager;
}

-(NSManagedObjectContext*)getManagedObjectContext
{
    return self.managedObjectContext;
}

static NSString* storeName;
+(void)setStoreName:(NSString*)name
{
    storeName = name;
}

#pragma mark - setup

- (id)init
{
    self = [super init];
    
    if (self) {
        [self setupManagedObjectContext];
    }
    
    return self;
}

- (void)setupManagedObjectContext
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSURL *documentDirectoryURL = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask][0];
    
    NSURL *storeURL = [documentDirectoryURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", @"lcash"]];
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Lynyo" withExtension:@"momd"];
    if(modelURL == nil)
    {
        NSLog(@"momd file is missing");
        return;
    }
    
    self.managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    self.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    
    NSError *error = nil;
    NSDictionary *options = @{ NSMigratePersistentStoresAutomaticallyOption : @(YES),
                               NSInferMappingModelAutomaticallyOption : @(YES) };
    
     NSPersistentStore *persistentStore = [self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                                                       configuration:nil
                                                                                                 URL:storeURL
                                                                                             options:options
                                                                                               error:&error];
    
    if (persistentStore) {
        self.managedObjectContext = [[NSManagedObjectContext alloc] init];
        self.managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    } else {
        NSLog(@"ERROR: %@", error.description);

        @try {
            error = nil;
            [[NSFileManager defaultManager] removeItemAtPath:storeURL.path error:&error];
            
            error = nil;
            persistentStore = [self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                                            configuration:nil
                                                                                      URL:storeURL
                                                                                  options:nil
                                                                                    error:&error];
            if (persistentStore) {
                self.managedObjectContext = [[NSManagedObjectContext alloc] init];
                self.managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
            } else {
                NSLog(@"ERROR: Cannot recreate %@", error.description);
            }
        }
        @catch (NSException *exception) {
        }
    }
}


- (void)saveDataInManagedContextUsingBlock:(void (^)(BOOL saved, NSError *error))savedBlock
{
    NSError *saveError = nil;
    savedBlock([self.managedObjectContext save:&saveError], saveError);
}

- (NSFetchedResultsController *)fetchEntitiesWithClassName:(Class)type
                                           sortDescriptors:(NSArray *)sortDescriptors
                                        sectionNameKeyPath:(NSString *)sectionNameKeypath
                                                 predicate:(NSPredicate *)predicate

{
    NSFetchedResultsController *fetchedResultsController;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass(type)
                                              inManagedObjectContext:self.managedObjectContext];
    fetchRequest.entity = entity;
    fetchRequest.sortDescriptors = sortDescriptors;
    fetchRequest.predicate = predicate;
    
    fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                   managedObjectContext:self.managedObjectContext
                                                                     sectionNameKeyPath:sectionNameKeypath
                                                                              cacheName:nil];
    
    NSError *error = nil;
    BOOL success = [fetchedResultsController performFetch:&error];
    
    if (!success) {
        NSLog(@"fetchManagedObjectsWithClassName ERROR: %@", error.description);
    }
    
    return fetchedResultsController;
}

- (NSManagedObject*)fetchEntity:(NSManagedObjectID *)objectID
{
    NSError *error = nil;

    NSManagedObject* obj = [self.managedObjectContext existingObjectWithID:objectID error:&error];

    if (error) {
        NSLog(@"fetchManagedObjectsWithClassName ERROR: %@", error.description);
    }
    
    return obj;
}


- (id)createEntityWithClassName:(Class)type
           attributesDictionary:(NSDictionary *)attributesDictionary
{
    NSManagedObject *entity = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(type)
                                                            inManagedObjectContext:self.managedObjectContext];
    [attributesDictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
        
        [entity setValue:obj forKey:key];
        
    }];
    
    return entity;
}

- (void)deleteEntity:(NSManagedObject *)entity
{
    [self.managedObjectContext deleteObject:entity];
}

- (BOOL)uniqueAttributeForClassName:(NSString *)className
                      attributeName:(NSString *)attributeName
                     attributeValue:(id)attributeValue
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K like %@", attributeName, attributeValue];
    NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:attributeName ascending:YES]];
    
    NSFetchedResultsController *fetchedResultsController = [self fetchEntitiesWithClassName:className
                                                                            sortDescriptors:sortDescriptors
                                                                         sectionNameKeyPath:nil
                                                                                  predicate:predicate];
    
    return fetchedResultsController.fetchedObjects.count == 0;
}


-(void)deleteAllInstancesOfEntity:(Class)type
{
    NSFetchRequest *allObjs = [[NSFetchRequest alloc] init];
    NSString* classNm = NSStringFromClass(type);
    [allObjs setEntity:[NSEntityDescription entityForName:classNm inManagedObjectContext:self.managedObjectContext]];
    [allObjs setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError *error = nil;
    NSArray *objs = [self.managedObjectContext executeFetchRequest:allObjs error:&error];
    //error handling goes here
    for (NSManagedObject *obj in objs) {
        [self.managedObjectContext deleteObject:obj];
    }
    NSError *saveError = nil;
    [self.managedObjectContext save:&saveError];
    //more error handling here
}

-(void)deleteFetched:(NSFetchedResultsController *)fetchResults
{
    NSArray* objList = [fetchResults fetchedObjects];
    for (NSManagedObject* obj in objList) {
        [self deleteEntity:obj];
    }
}
@end