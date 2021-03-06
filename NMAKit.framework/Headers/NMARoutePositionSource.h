/*
 * Copyright © 2011-2016 HERE Global B.V. and its affiliate(s).
 * All rights reserved.
 * The use of this software is conditional upon having a separate agreement
 * with a HERE company for the use or utilization of this software. In the
 * absence of such agreement, the use of the software is not allowed.
 */

#import <Foundation/Foundation.h>

#import "NMAPositionDataSource.h"

@class NMARoute;

/**
 * \addtogroup NMA_Common  NMA Common Group
 * @{
 */


/**
 * \class NMARoutePositionSource NMARoutePositionSource.h "NMARoutePositionSource.h"
 *
 * A position data source which generates updates by simulating traversal of
 * a route.
 *
 * \note This class uses UIApplication background tasks to allow it to generate position
 * updates whilst the app is backgrounded. The amount of time it can run in the background
 * is therefore decided by Apple and could only be a couple of minutes. To guarantee
 * background position updates beyond this you will need use other means to keep your app
 * running in the background.
 */
@interface NMARoutePositionSource : NSObject<NMAPositionDataSource>

/**
 * The route from which to generate position updates.
 *
 * \note The route can't be changed while position generation is active.
 */
@property (nonatomic) NMARoute *route;

/**
 * The time period between successive position updates, in seconds.
 *
 * \note The default value is 1.0s.
 */
@property (nonatomic) NSTimeInterval updateInterval;

/**
 * The simulated speed at which to traverse the route, in meters per second.
 *
 * \note The default value is 20m/s.
 */
@property (nonatomic) float movementSpeed;

/**
 * The accuracy used in generated position updates, in meters.
 *
 * \note The default value is 5.0m.
 */
@property (nonatomic) float accuracy;

/**
 * Indicates whether or not the simulated positions are moving along the route.
 *
 * If stationary is YES, the currentPosition will remain fixed at the last calculated
 * position, or the beginning of the route if no progress has been made.
 *
 * \note The default value is NO.
 */
@property (nonatomic) BOOL stationary;

/**
 * Indicates whether the position source returns valid positions.
 *
 * Setting positionLost to YES can be used to simulate position loss. Position updates
 * will still be generated by the position source, but the currentPosition property
 * will always return nil.
 *
 * \note Progress along the route will continue regardless of the value of this property.
 *
 * \note The default value is NO.
 */
@property (nonatomic) BOOL positionLost;

/**
 * Initializes an NMARoutePositionSource with a given route.
 */
- (id)initWithRoute:(NMARoute *)route;

/**
 * Erases all progress along the route.
 *
 * \note This method will not affect any properties, including the current route.
 */
- (void)reset;

@end
/** @} */
