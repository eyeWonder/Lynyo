//
//  CreateTableViewController.h
//  Lynyo
//
//  Created by sergey on 10.09.16.
//  Copyright © 2016 Ivango. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataManager.h"
#import "CDDrive.h"
#import "CDLanePoint.h"
#import "CreateLanePointCell.h"
#import <NMAKit/NMAKit.h>
#import "HereHelper.h"

@interface CreateTableViewController : UITableViewController<LPDelegate, UIPickerViewDelegate, NMAResultListener>
@property (nonatomic) CoreDataManager* dm;
@property (nonatomic) CDDrive* drive;

@property(nonatomic, strong) NMACoreRouter *router;
@property(nonatomic, strong) NMAMapRoute *mapRoute;
@property(nonatomic, strong) NMARoute *route;

@property(nonatomic) int curGeocodeNum;


@end
