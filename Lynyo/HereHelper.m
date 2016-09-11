//
//  HereHelper.m
//  Lynyo
//
//  Created by sergey on 10.09.16.
//  Copyright © 2016 Ivango. All rights reserved.
//

#import "HereHelper.h"
#import "MessageBox.h"

@implementation HereHelper
+(NSArray*)calculateWayPoints:(NSArray*)lanePoints hours:(int)hours
{
    NSArray<CDWayPoint*>* wpList = [NSArray new];
    
    
    //NMACoreRouter *router = [[NMACoreRouter alloc] init];
    NMARouteManager* router = [[NMARouteManager alloc] init];
    router.delegate = self;
    
    NMARoutingMode *routingMode = [[NMARoutingMode alloc] initWithRoutingType:NMARoutingTypeFastest transportMode:NMATransportModeCar routingOptions:0];

    NMADynamicPenalty *penalty = [[NMADynamicPenalty alloc] init];
    penalty.trafficPenaltyMode = NMATrafficPenaltyModeOptimal;
    router.dynamicPenalty = penalty;
    
    for(int i=0; i< [lanePoints count]-1; i++)
    {
        CDLanePoint* lp1 = lanePoints[i];
        CDLanePoint* lp2 = lanePoints[i+1];
        
        
        NMAGeoCoordinates* geoCoord1 = [[NMAGeoCoordinates alloc] initWithLatitude:[lp1.latitude doubleValue]
                                                                         longitude:[lp1.longitude doubleValue]];
        NMAGeoCoordinates* geoCoord2 = [[NMAGeoCoordinates alloc] initWithLatitude:[lp2.latitude doubleValue]
                                                                         longitude:[lp2.longitude doubleValue]];
        
        NMAWaypoint* waypoint1 = [[NMAWaypoint alloc] initWithGeoCoordinates:geoCoord1];
        NMAWaypoint* waypoint2 = [[NMAWaypoint alloc] initWithGeoCoordinates:geoCoord2];
        NSMutableArray* stops = [NSMutableArray new];
        [stops addObject:waypoint1];
        [stops addObject:waypoint2];
        
        [router calculateRouteWithStops:stops routingMode:routingMode];
    }
    
    return wpList;
}

+ (void)routeManager:(NMARouteManager *)routeManager didCalculateRoutes:(NSArray *)routes
           withError:(NMARouteManagerError)error violatedOptions:(NSArray *)violatedOptions DEPRECATED_ATTRIBUTE
{
    if (!error && routes.count >= 1)
    {
        NMARoute *route = routes[0];
        
        double secs = route.duration;
        int length = route.length;
        //route.arrival.scheduledTime
        //route.tta.duration
        
        float hrs = secs / 60 / 60;
        
        bool isLonger = true;
        
        if(hrs > 8)
        {
            //get point on direction line
            //make calculation
            //find point that is ok for time
            //find truckstop near
            //check that it is ok for time
            //save way point
        }
        else
        {
            //get hours (will be used for next calculation)
            //save way point
            //calculate next distance
        }
        
        
        
        //NMAMapRoute *mapRoute = [NMAMapRoute mapRouteWithRoute:route];
    }
    else if (error)
    {
        NSLog(@"Routing error: %lu", (unsigned long)error);
    }
}








+ (void) startSearch:(NMAGeoCoordinates*)coords categories:(NSArray*)categories
{
    NMACategoryFilter *categoryFilter = [NMACategoryFilter new];
    for(int i = 0; i< [categories count]; i++)
    {
        NSNumber* num = categories[i];
        NMACategoryFilterType cat = [num intValue];
        [categoryFilter addCategoryFilterFromType:cat];
    }

    // Create a request to search for restaurants in Vancouver
    NMAGeoCoordinates *boundingTopLeftCoords = [[NMAGeoCoordinates alloc] initWithLatitude:coords.latitude + 2.0 longitude:coords.longitude - 2.0];
    NMAGeoCoordinates *boundingBottomRightCoords = [[NMAGeoCoordinates alloc] initWithLatitude:coords.latitude - 2.0 longitude:coords.longitude + 2.0];

    NMAGeoBoundingBox *bounding = [[NMAGeoBoundingBox alloc] initWithTopLeft:boundingTopLeftCoords bottomRight:boundingBottomRightCoords];

    
 //   NMACategoryFilter* filter = [[NMACategoryFilter alloc] init];
 //   [filter addCategoryFilterFromType:NMAMapPoiCategoryRestaurant];
    
    NMADiscoveryRequest* request = [[NMAPlaces sharedPlaces] createSearchRequestWithLocation:coords query:@"restaurants"];
    request.viewport = bounding;
    // limit number of items in each result page to 10
    request.collectionSize = 100000;
//    NSError* error = [request startWithListener:self];
    
    
    [request startWithBlock:^(NMARequest *request,id data, NSError *error){
        
        NMADiscoveryPage *discoveryPage = (NMADiscoveryPage *)data;
        if((error.code == NMARequestErrorNone) && (discoveryPage != nil)){
            const NSInteger discoveryResultCount = [discoveryPage.discoveryResults count];
            NSLog(@"Search Results: Found %ld POIs", (long)discoveryResultCount);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                for(NMAPlaceLink *pl in discoveryPage.discoveryResults)
                {
                    if(nil != pl && [pl isKindOfClass:[NMAPlaceLink class]])
                    {
                        /*
                        // Info icon - Create UIImage containing search results text
                        NSInteger distance = [[self currentLocation]distanceTo:pl.position];
                        NSString *text = [NSString stringWithFormat:@"%@\n%d meters", pl.name, (int)distance];
                        UIImage *infoImage = [self createImageWithSize:CGSizeMake(150,poiARIcon.size.height) color:[UIColor blackColor] text:text];
                        
                        // Add an AR object representing the POI to the composite view
                        // IMPORTANT: poiARIcon size must match the size set in setFrontPlaneIconSize:
                        NMAARIconObject *iconObject = [NMAARIconObject iconObjectWithIcon:[NMAImage imageWithUIImage:poiARIcon]
                                                                                infoImage:[NMAImage imageWithUIImage:infoImage]
                                                                              coordinates:pl.position];
                        
                        [self.compositeView.arController addObject:iconObject];
                        [self.arObjects addObject:iconObject];
                        
                        // Add a Map Marker representing the POI to the map
                        NMAMapMarker *mapMarker = [NMAMapMarker mapMarkerWithGeoCoordinates:iconObject.coordinates
                                                                                      image:poiMapIcon];
                        [self.mapView addMapObject:mapMarker];
                        [self.mapObjects setObject:mapMarker forKey:[NSNumber numberWithUnsignedInteger:iconObject.uniqueId]];
                         */
                    }
                }
            });
        }
    }];
}
@end
