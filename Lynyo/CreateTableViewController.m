//
//  CreateTableViewController.m
//  Lynyo
//
//  Created by sergey on 10.09.16.
//  Copyright © 2016 Ivango. All rights reserved.
//

#import "CreateTableViewController.h"
#import "LocalSettingsStorage.h"
#import "Constants.h"
#import "CDLanePoint.h"
#import "CreateLanePointCell.h"
#import "AddLanePointCell.h"
#import "TruckTypeEnum.h"
#import "MessageBox.h"
#import "CDWayPoint.h"

@interface CreateTableViewController ()
@property (weak, nonatomic) IBOutlet UIButton *eqSelectBtn;
@property (weak, nonatomic) IBOutlet UITextField *weightTF;
@property (weak, nonatomic) IBOutlet UITextField *hrsTF;
@property (weak, nonatomic) IBOutlet UITableView *lpTV;

@end

@implementation CreateTableViewController
@synthesize drive, eqSelectBtn, weightTF, hrsTF, lpTV, dm, curGeocodeNum;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    weightTF.text = @"43000";
    hrsTF.text = @"6";//test
    [eqSelectBtn setTitle:@"DryVan" forState: UIControlStateNormal];
    
    
    self.tableView.tag = 1;
    
    lpTV.tag = 100;
    lpTV.delegate = self;
    lpTV.dataSource = self;
    lpTV.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    
    dm = [CoreDataManager sharedManager];
    
    
    NSString* idStr = [LocalSettingsStorage getSetting:LOCALSETTING_ACTIVEDRIVEID];
    if(idStr == nil || [idStr isEqualToString:@""])
    {
        [dm deleteAllInstancesOfEntity:[CDDrive class]];
    }

    drive = [dm createEntityWithClassName:[CDDrive class] attributesDictionary:nil];
    
    CDLanePoint* lp1 = [dm createEntityWithClassName:[CDLanePoint class] attributesDictionary:nil];
    [drive addLanePointsObject:lp1];
    
    CDLanePoint* lp2 = [dm createEntityWithClassName:[CDLanePoint class] attributesDictionary:nil];
    [drive addLanePointsObject:lp2];
    
    drive.truckType = [NSNumber numberWithInt:1];//test
    drive.lanePoints[0].address = @"1 Dr Carlton B Goodlett Pl, San Francisco, CA 94102, USA";
    drive.lanePoints[1].address = @"445 Broad St, Newark, NJ 07102, USA";
    
    [dm saveDataInManagedContextUsingBlock:^(BOOL saved, NSError *error) {
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv {
    if(tv.tag == 100)
    {
        return 1;
    }
    return [super numberOfSectionsInTableView:tv];
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    if(tv.tag == 100)
    {
        if(drive == nil)
            return 0;
        
        return [drive.lanePoints count] + 1;
    }
    return [super tableView:tv numberOfRowsInSection:section];
}

-(CGFloat)tableView:(UITableView *)tv heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tv.tag == 1 && indexPath.row == 3)
    {
        if(drive == nil)
            return 0;
        return ([drive.lanePoints count] + 1) * 43;
    }
    if(tv.tag == 100)
        return 43;
    
    return [super tableView:tv heightForRowAtIndexPath:indexPath];
}


- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tv.tag == 100)
    {
        if(indexPath.row < [drive.lanePoints count])
        {
            CDLanePoint* lp = drive.lanePoints[indexPath.row];
            
            NSString* cellIdentifier = @"CreateLanePointCell";
            
            CreateLanePointCell *cell = [tv dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CreateLanePointCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            cell.delegate = self;
            cell.lp = lp;
            cell.addressTF.text = lp.address;
            
            if(indexPath.row == 0 || indexPath.row == 1)
                cell.removeBtn.hidden = true;
            
            return cell;
        }
        else
        {
            NSString* cellIdentifier = @"AddLanePointCell";
            
            AddLanePointCell *cell = [tv dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AddLanePointCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            return cell;
        }
   }
    
    return [super tableView:tv cellForRowAtIndexPath:indexPath];
}

- (nullable NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tv.tag == 100 && indexPath.row == [drive.lanePoints count])
    {
        CDLanePoint* lp1 = [dm createEntityWithClassName:[CDLanePoint class] attributesDictionary:nil];
        [drive addLanePointsObject:lp1];
        
        [dm saveDataInManagedContextUsingBlock:^(BOOL saved, NSError *error) {
            [tv reloadData];
            [self.tableView reloadData];
        }];
    }
    if(tv.tag == 1 && indexPath.row == 4)
    {
        [self createDrive];
    }
    return nil;
}


-(void)removed:(CDLanePoint *)lp
{
    NSIndexPath* ip = [NSIndexPath indexPathForRow:3 inSection:0];
    
    UITableViewCell* cell = [self tableView:self.tableView cellForRowAtIndexPath:ip];
    UITableView* tv = [cell.contentView viewWithTag:100];
    
    [drive removeLanePointsObject:lp];
    [dm saveDataInManagedContextUsingBlock:^(BOOL saved, NSError *error) {
        [tv reloadData];
        [self.tableView reloadData];
    }];
}


// MARK: Select equipment type
- (void)removeViews:(id)object {
    [[self.view viewWithTag:9] removeFromSuperview];
    [[self.view viewWithTag:10] removeFromSuperview];
    [[self.view viewWithTag:11] removeFromSuperview];
}
- (void)dismissDatePicker:(id)sender {
    CGRect toolbarTargetFrame = CGRectMake(0, self.view.bounds.size.height, 320, 44);
    CGRect datePickerTargetFrame = CGRectMake(0, self.view.bounds.size.height+44, 320, 216);
    [UIView beginAnimations:@"MoveOut" context:nil];
    [self.view viewWithTag:9].alpha = 0;
    [self.view viewWithTag:10].frame = datePickerTargetFrame;
    [self.view viewWithTag:11].frame = toolbarTargetFrame;
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(removeViews:)];
    [UIView commitAnimations];
    
    
    NSInteger index = [drive.truckType intValue];
    NSString *beneficialStr = [TruckTypeEnum getName:index];
    [eqSelectBtn setTitle:beneficialStr forState:UIControlStateNormal];
    if(index > 0)
        [eqSelectBtn.titleLabel setTextColor:[UIColor blackColor]];
}
- (IBAction)selectBeneficialOwnerTypeClick:(id)sender {
    if ([self.view viewWithTag:9]) {
        return;
    }
    [self.view endEditing:YES];
    
    CGRect toolbarTargetFrame = CGRectMake(0, self.view.bounds.size.height-216-44, self.view.bounds.size.width, 44);
    CGRect datePickerTargetFrame = CGRectMake(0, self.view.bounds.size.height-216, self.view.bounds.size.width, 216);
    
    UIView *darkView = [[UIView new] initWithFrame:self.view.bounds];
    darkView.backgroundColor = [UIColor blackColor];
    darkView.tag = 9;
    darkView.frame = self.view.bounds;
    darkView.alpha = 0.5f;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer new] initWithTarget:self action:@selector(dismissDatePicker:)];
    [darkView addGestureRecognizer:tapGesture];
    [self.view addSubview:darkView];
    
    UIPickerView *picker = [[UIPickerView new] initWithFrame:datePickerTargetFrame];
    picker.tag = 10;
    picker.backgroundColor = [UIColor whiteColor];
    picker.delegate = self;
    if([drive.truckType intValue] < 0)
        drive.truckType = [NSNumber numberWithInt:0];
    [picker selectRow:[drive.truckType intValue] inComponent:0 animated:YES];
    [self.view addSubview:picker];
    
    
    UIToolbar *toolBar = [[UIToolbar new] initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 44)];
    toolBar.tag = 11;
    toolBar.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem *spacer = [[UIBarButtonItem new] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem new] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissDatePicker:)];
    [toolBar setItems:[NSArray arrayWithObjects:spacer, doneButton, nil]];
    [self.view addSubview:toolBar];
    
    [UIView beginAnimations:@"MoveIn" context:nil];
    toolBar.frame = toolbarTargetFrame;
    picker.frame = datePickerTargetFrame;
    [UIView commitAnimations];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    drive.truckType = [NSNumber numberWithLong:row];
    
    [eqSelectBtn.titleLabel setTextColor:[UIColor blackColor]];
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 4;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [TruckTypeEnum getName:row];
}
// End: Select beneficiar owner


-(void)createDrive
{
    if([weightTF.text isEqualToString:@""])
    {
        [MessageBox show:@"Enter weight" message:nil];
        return;
    }
    if([hrsTF.text isEqualToString:@""])
    {
        [MessageBox show:@"Enter hours" message:nil];
        return;
    }
    if([drive.truckType intValue] == 0)
    {
        [MessageBox show:@"Select truck type" message:nil];
        return;
    }
    
    drive.weight = [NSNumber numberWithInt: [weightTF.text intValue]];
    drive.hoursLeft = [NSNumber numberWithInt: [hrsTF.text intValue]];
    
    
    curGeocodeNum = 0;
    [self geocodeLP:drive.lanePoints[curGeocodeNum]];
}

-(void)geocodeLP :(CDLanePoint*)lp
{
    NMAGeoCoordinates *topLeft = [[NMAGeoCoordinates alloc] initWithLatitude:100.537413 longitude:10.365641];
    NMAGeoCoordinates *bottomRight = [[NMAGeoCoordinates alloc] initWithLatitude:10.522428 longitude:100.39345];
    NMAGeoBoundingBox *boundingBox =
    [NMAGeoBoundingBox
     geoBoundingBoxWithTopLeft:topLeft bottomRight:bottomRight];
    
    //start geocoding
    NMAGeocodeRequest* request = [[NMAGeocoder sharedGeocoder]
                                  createGeocodeRequestWithQuery: lp.address
                                  searchArea:boundingBox];
    // limit the number of results to 10
    request.collectionSize = 10;
    [request startWithListener:self];
}
-(void)calculateWayPoints
{
    NSArray* wpList = [HereHelper calculateWayPoints:[drive.lanePoints array] hours:8];
}



//------------
// NMAResultListener protocol callback implementation
-(void)request:(NMARequest *)request didCompleteWithData:(id)data error:(NSError *)error
{
    if ( ( [request isKindOfClass:[NMAGeocodeRequest class]] ) && ( error.code == NMARequestErrorNone ) )
    {
        // Process result NSArray of NMAGeocodeResult objects
        //[self processResult:(NSMutableArray *)data];
        
        NSMutableArray* resList = (NSMutableArray*)data;
        
        if([resList count] == 0)
        {
            [MessageBox show:@"Could not geocode" message:nil];
            return;
        }
        
        NMAGeocodeResult* res = resList[0];
        
        CDLanePoint* lp = drive.lanePoints[curGeocodeNum];
        
        lp.latitude = [NSNumber numberWithFloat:res.location.position.latitude];
        lp.longitude = [NSNumber numberWithFloat:res.location.position.longitude];
        
        [dm saveDataInManagedContextUsingBlock:^(BOOL saved, NSError *error) {
            curGeocodeNum++;
            if(curGeocodeNum < [drive.lanePoints count])
                [self geocodeLP:drive.lanePoints[curGeocodeNum]];
            else
                [self calculateWayPoints];
        }];
    }
    else {
    }
}
@end
