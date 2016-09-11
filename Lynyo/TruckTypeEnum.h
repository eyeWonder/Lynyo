//
//  BankAccountStatusEnum.h
//  Data
//
//  Created by sergey on 20.04.16.
//  Copyright © 2016 sergey. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef Lynyo_TruckTypeEnum
#define Lynyo_TruckTypeEnum

#define TruckTypeEnum_1_DryVan 1
#define TruckTypeEnum_2_FlatBed 2
#define TruckTypeEnum_3_Refeer 3

#endif

@interface TruckTypeEnum : NSObject

+(NSString*)getName:(short)status;

@end
