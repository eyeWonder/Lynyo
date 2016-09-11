//
//  CreateLanePointCell.h
//  Lynyo
//
//  Created by sergey on 10.09.16.
//  Copyright © 2016 Ivango. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDLanePoint.h"

@protocol LPDelegate <NSObject>
@required
-(void)removed:(CDLanePoint*)lp;
@end


@interface CreateLanePointCell : UITableViewCell<UITextFieldDelegate>
@property (nonatomic) CDLanePoint* lp;
@property (weak, nonatomic) id <LPDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *removeBtn;
@property (weak, nonatomic) IBOutlet UITextField *addressTF;

@end
