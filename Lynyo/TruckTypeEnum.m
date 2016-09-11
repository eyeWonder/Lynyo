//
//  BankAccountStatusEnum.m
//  Data
//
//  Created by sergey on 20.04.16.
//  Copyright © 2016 sergey. All rights reserved.
//

#import "TruckTypeEnum.h"

@implementation TruckTypeEnum
+(NSString*)getName:(short)status{
    switch (status) {
        case TruckTypeEnum_1_DryVan:
            return @"DryVan";
            break;
        case TruckTypeEnum_2_FlatBed:
            return @"FlatBed";
            break;
        case TruckTypeEnum_3_Refeer:
            return @"Reefer";
            break;
    }
    
    return @"- select equipment -";
}

@end
