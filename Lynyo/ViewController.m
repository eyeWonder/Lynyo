//
//  ViewController.m
//  Lynyo
//
//  Created by sergey on 10.09.16.
//  Copyright © 2016 Ivango. All rights reserved.
//

#import "ViewController.h"
#import "HereHelper.h"
#import "MessageBox.h"
#import <MapKit/MapKit.h>
#import "XMLParser.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *addrContainerView;
@property (weak, nonatomic) IBOutlet UITextField *addressTF;
@property (weak, nonatomic) IBOutlet UIButton *getBtn;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UIButton *currentBtn;
@property (weak, nonatomic) IBOutlet UIView *resultView;
@property (weak, nonatomic) IBOutlet UILabel *totalLbl;

@property (weak, nonatomic) IBOutlet UIView *scoreView;
@property (weak, nonatomic) IBOutlet UIView *scoreBgView;
@end

@implementation ViewController
@synthesize getBtn, addressTF, addrContainerView, slider, scoreView, scoreBgView, currentBtn, mapView, businessCategories, vacationCategories, familyVacationCategories, livingCategories, resultArray, curIndex, currentCategories, resultView, totalLbl;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NMAGeoPosition* pos = [[NMAPositioningManager sharedPositioningManager] currentPosition];
    NMAGeoCoordinates *geoCoordCenter = nil;
    if (pos)
        geoCoordCenter = pos.coordinates;


    [NMAMapView class];
    
//    NMAGeoCoordinates *geoCoordCenter = [[NMAGeoCoordinates alloc] initWithLatitude:49.260327 longitude:-123.115025];
    [self.mapView setGeoCenter:geoCoordCenter withAnimation:NMAMapAnimationBow];
    self.mapView.copyrightLogoPosition = NMALayoutPositionBottomCenter;
    //set zoom level
    self.mapView.zoomLevel = 14;
    
    
    addrContainerView.layer.borderWidth = 0.3f;
    addrContainerView.layer.borderColor = [[UIColor lightGrayColor] CGColor];

    
    getBtn.layer.cornerRadius = 10;
    getBtn.layer.borderWidth = 0.3f;
    getBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    currentBtn.layer.cornerRadius = 4;
    currentBtn.layer.borderWidth = 0.3f;
    currentBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    addressTF.delegate = self;
    
    [self showScore:false];
    
    [self initCategories];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NMAPositioningManager sharedPositioningManager] startPositioning];
    
    
    if ([CLLocationManager locationServicesEnabled] )
    {
        if (self.locationManager == nil )
        {
            self.locationManager = [[CLLocationManager alloc] init];
            self.locationManager.delegate = self;
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            //self.locationManager.distanceFilter = kDistanceFilter; //kCLDistanceFilterNone// kDistanceFilter;
        }
        
        //[self.locationManager startUpdatingLocation];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [[NMAPositioningManager sharedPositioningManager] stopPositioning];
}


- (IBAction)sliderTouchUp:(UISlider *)sender
{
    [sender setValue:floorf([sender value] + 0.5) animated:YES];
}

- (IBAction)closeBtn_Click:(id)sender {
    [self showScore:false];
}
- (IBAction)currentBtn_click:(id)sender {
    NMAGeoPosition* pos = [[NMAPositioningManager sharedPositioningManager] currentPosition];
    NMAGeoCoordinates *geoCoordCenter = nil;
    if (pos)
        geoCoordCenter = pos.coordinates;
    
    [self.mapView setGeoCenter:geoCoordCenter withAnimation:NMAMapAnimationBow];
    self.mapView.zoomLevel = 14.0;
}

-(void)showScore:(BOOL)isShow
{
    scoreBgView.hidden = !isShow;
    scoreView.hidden = !isShow;
}






-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
        // here we get the current location
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    [self geocodeAddress];
    
    return NO;
}


// MARK: Categories
-(void)initCategories
{
    businessCategories = [[NSArray alloc] initWithObjects:Category_NoiseLevel, Category_Infrastructure, Category_Ecology, Category_Businesses, nil];
    
    vacationCategories = [[NSArray alloc] initWithObjects:Category_NoiseLevel, Category_Infrastructure, Category_Ecology, Category_Sightseeing, Category_NightLife, Category_Shopping, nil];

    familyVacationCategories = [[NSArray alloc] initWithObjects:Category_NoiseLevel, Category_Infrastructure, Category_Ecology, Category_Sightseeing, Category_Child, Category_Shopping, nil];

    livingCategories = [[NSArray alloc] initWithObjects:Category_NoiseLevel, Category_Infrastructure, Category_Ecology, Category_Medicine, nil];
}
-(NSString*)getFilterForCategory:(NSString*) category
{
    if([category isEqualToString:Category_NoiseLevel])
        return @"restaurants%7Croads";
    if([category isEqualToString:Category_Infrastructure])
        return @"restaurants%7Cshops";
    if([category isEqualToString:Category_Ecology])
        return @"park%7Cforest";
    if([category isEqualToString:Category_Sightseeing])
        return @"historical%7Csightseeing";
    if([category isEqualToString:Category_Businesses])
        return @"company";
    if([category isEqualToString:Category_Child])
        return @"child%7Cfamily";
    if([category isEqualToString:Category_NightLife])
        return @"bars%7Cclubs%7Crestaurants";
    if([category isEqualToString:Category_Shopping])
        return @"shops";
    if([category isEqualToString:Category_Medicine])
        return @"hospital";
    
    return nil;
}
// End: Categories

// MARK: Actions
-(void)geocodeAddress
{
    NMAGeoCoordinates *topLeft = [[NMAGeoCoordinates alloc] initWithLatitude:180.0 longitude:0.365641];
    NMAGeoCoordinates *bottomRight = [[NMAGeoCoordinates alloc] initWithLatitude:0.522428 longitude:180.0];
    NMAGeoBoundingBox *boundingBox =
    [NMAGeoBoundingBox
     geoBoundingBoxWithTopLeft:topLeft bottomRight:bottomRight];
    
    //start geocoding
    NMAGeocodeRequest* request = [[NMAGeocoder sharedGeocoder]
                                  createGeocodeRequestWithQuery: addressTF.text
                                  searchArea:boundingBox];
    // limit the number of results to 10
    request.collectionSize = 10;
    [request startWithListener:self];
}
- (IBAction)getBtn_Click:(id)sender {
    resultArray = [NSMutableArray new];
    curIndex = 0;
    
    
    switch ((int)slider.value) {
        case 0:
            currentCategories = businessCategories;
            break;
        case 1:
            currentCategories = vacationCategories;
            break;
        case 2:
            currentCategories = familyVacationCategories;
            break;
        case 3:
            currentCategories = livingCategories;
            break;
    }
    
    
    for(int i=0; i< [currentCategories count]; i++)
    {
        NSString* filter = [self getFilterForCategory: currentCategories[i]];

        int res = [self startSearch: mapView.geoCenter categories:filter];
        
        [resultArray addObject:[NSNumber numberWithInt:res]];
    }
    
    
    [[resultView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self showScore:true];
    
    
    int total=0;
    for(int i=0; i< [resultArray count]; i++)
    {
        UILabel* lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 10 + i*30, 150, 20)];
        [lbl setTextColor:[UIColor darkGrayColor]];
        
        int percent = (int)(([resultArray[i] floatValue] / 20.f)*100);
        int level =0;
        
        if([currentCategories[i] isEqualToString:Category_NoiseLevel])
        {
            if(percent >=0 && percent <= 33)
                level = 3;
            if(percent >33 && percent <= 66)
                level = 2;
            if(percent >66 )
                level = 1;
        }
        else
        {
            if(percent >=0 && percent <= 33)
                level = 1;
            if(percent >33 && percent <= 66)
                level = 2;
            if(percent >66 )
                level = 3;
        }
        
        NSString* levelStr = 0;
        switch (level) {
            case 1:
                levelStr = @"Bad";
                break;
            case 2:
                levelStr = @"Average";
                break;
            case 3:
                levelStr = @"Good";
                break;
        }
        
        total += level;
        
        lbl.text = [NSString stringWithFormat: @"%@: %@", currentCategories[i], levelStr];
        lbl.font = [UIFont systemFontOfSize: 14.0f];
        
        [resultView addSubview:lbl];
    }
    
    int level = total / [currentCategories count];
    
    NSString* levelStr = 0;
    switch (level) {
        case 1:
            levelStr = @"Bad";
            break;
        case 2:
            levelStr = @"Average";
            break;
        case 3:
            levelStr = @"Good";
            break;
    }
    
    totalLbl.text = [NSString stringWithFormat: @"%@: %@", @"Total", levelStr];
}
// End: Actions

// MARK: HERE
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
        
        [mapView setGeoCenter:res.location.position withAnimation:NMAMapAnimationRocket];
    }
    else {
    }
}
- (int) startSearch:(NMAGeoCoordinates*)coords categories:(NSString*)category
{
    NSString* reqStr = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/xml?location=%f,%f&radius=500&name=%@&sensor=false&key=AIzaSyAMZ21cDRD106wSK0Ua4NYv3MTrTgelwJc", coords.latitude, coords.longitude, category];
    
    NSURL *URL = [[NSURL alloc] initWithString:reqStr];
    NSString *xmlString = [[NSString alloc] initWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:NULL];
    NSLog(@"string: %@", xmlString);
    
    NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:xmlString];
    //NSLog(@"dictionary: %@", xmlDoc);
    
    NSArray *values = [xmlDoc allValues][2];

    
    return (int)[values count];
    
    /*
    NMACategoryFilter *categoryFilter = [NMACategoryFilter new];
    for(int i = 0; i< [categories count]; i++)
    {
        NSNumber* num = categories[i];
        NMACategoryFilterType cat = [num intValue];
        [categoryFilter addCategoryFilterFromType:cat];
    }
    CGFloat shift = 0.000001f;
    
    coords = [[NMAGeoCoordinates alloc] initWithLatitude:37.81264 longitude:-122.26855];
    
    // Create a request to search for restaurants in Vancouver
    NMAGeoCoordinates *boundingTopLeftCoords = [[NMAGeoCoordinates alloc] initWithLatitude:37.81315 longitude:-122.26913];
    NMAGeoCoordinates *boundingBottomRightCoords = [[NMAGeoCoordinates alloc] initWithLatitude:37.81200 longitude:-122.26783];
    
    NMAGeoBoundingBox *bounding = [[NMAGeoBoundingBox alloc] initWithTopLeft:boundingTopLeftCoords bottomRight:boundingBottomRightCoords];
    
    
    //   NMACategoryFilter* filter = [[NMACategoryFilter alloc] init];
    //   [filter addCategoryFilterFromType:NMAMapPoiCategoryRestaurant];
    
    NMADiscoveryRequest* request = [[NMAPlaces sharedPlaces] createHereRequestWithLocation:coords filters:categoryFilter];
    //request.viewport = bounding;
    // limit number of items in each result page to 10
    request.collectionSize = 100000;
    //    NSError* error = [request startWithListener:self];
    
    
    [request startWithBlock:^(NMARequest *request,id data, NSError *error){
        
        NMADiscoveryPage *discoveryPage = (NMADiscoveryPage *)data;
        if((error.code == NMARequestErrorNone) && (discoveryPage != nil)){
            const NSInteger discoveryResultCount = [discoveryPage.discoveryResults count];
            NSLog(@"Search Results: Found %ld POIs", (long)discoveryResultCount);
            
            [resultArray addObject:[NSNumber numberWithLong:(long)discoveryResultCount]];
            
            curIndex++;
            if(curIndex < [currentCategories count])
            {
                NSArray* filter = [self getFilterForCategory: currentCategories[curIndex]];
                
                [self startSearch: mapView.geoCenter categories:filter];
            }
            else
            {
                [[resultView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
                
                [self showScore:true];


                for(int i=0; i< [resultArray count]; i++)
                {
                    UILabel* lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 10 + i*30, 150, 20)];
                    [lbl setTextColor:[UIColor darkGrayColor]];
                    lbl.text = [NSString stringWithFormat: @"%@: %@", currentCategories[i], resultArray[i]];
                    lbl.font = [UIFont systemFontOfSize: 14.0f];
                
                    [resultView addSubview:lbl];
                 }
            }
        }
    }];*/
}
// End: HERE
@end
