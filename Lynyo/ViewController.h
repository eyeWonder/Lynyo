//
//  ViewController.h
//  Lynyo
//
//  Created by sergey on 10.09.16.
//  Copyright © 2016 Ivango. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NMAKit/NMAKit.h>
#import <CoreLocation/CoreLocation.h>



#ifndef Category
#define Lynyo_Category
#define Category_NoiseLevel @"Noise Level"
#define Category_Infrastructure @"Infrastructure"
#define Category_Ecology @"Ecology"
#define Category_Sightseeing @"Sightseeing"
#define Category_Businesses @"Businesses"
#define Category_Child @"Child convenience"
#define Category_NightLife @"Night life"
#define Category_Shopping @"Shopping"
#define Category_Medicine @"Medicine"
#endif


@interface ViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet NMAMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic) NSArray* businessCategories;
@property (nonatomic) NSArray* vacationCategories;
@property (nonatomic) NSArray* familyVacationCategories;
@property (nonatomic) NSArray* livingCategories;


@property (nonatomic) NSArray* currentCategories;
@property (nonatomic) NSMutableArray* resultArray;
@property (nonatomic) int curIndex;
@end

