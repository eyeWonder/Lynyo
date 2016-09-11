//
//  CreateLanePointCell.m
//  Lynyo
//
//  Created by sergey on 10.09.16.
//  Copyright © 2016 Ivango. All rights reserved.
//

#import "CreateLanePointCell.h"

@implementation CreateLanePointCell
@synthesize lp, delegate;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)removeBtn_Click:(id)sender {
    if(delegate != nil)
        [delegate removed:lp];
}

- (IBAction)addrTF_Changed:(id)sender {
    lp.address = _addressTF.text;
}
- (IBAction)addrTF_EditingEnd:(id)sender {
    [_addressTF resignFirstResponder];
}

@end
