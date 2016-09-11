/*
 * Copyright © 2011-2016 HERE Global B.V. and its affiliate(s).
 * All rights reserved.
 * The use of this software is conditional upon having a separate agreement
 * with a HERE company for the use or utilization of this software. In the
 * absence of such agreement, the use of the software is not allowed.
 */

#import "NMALink.h"

@class NMADiscoveryRequest;

/**
 * \addtogroup NMA_Search NMA Search Group
 * @{
 */


/**
 * \class NMADiscoveryLink NMADiscoveryLink.h "NMADiscoveryLink.h"
 *
 * \brief Represents a discovery search results link that can be used to perform another discovery search.
 */
@interface NMADiscoveryLink : NMALink

/**
 * Creates an NMADiscoveryRequest object to perform another NMADiscoveryPage request.
 *
 * \note Attempts to read this property could return nil.
 *
 * \return The NMADiscoveryRequest
 */
- (NMADiscoveryRequest *)request;

#pragma mark - DEPRECATED

/**
 * Gets the %NSString representation of the link URL.
 * </p>
 * <p>
 * This URL may be used to perform an HTTP GET request to the HERE Places REST service
 * to retrieve the full metadata of the linked resources for online.
 *
 * Use the request methods in dervied classes for offline. See also
 * NMAPlaceLink#detailsRequest and NMADiscoveryLink#request.
 * </p>
 * <p>
 * The request may return a HTML or JSON response. If url contains "places.hybrid.api.here.com",
 * it will return a JSON response as specified at http://developer.here.com/places
 * If URL contains other domains, it will most likely return a HTML response.
 *
 * \deprecated: This property is deprecated since release 3.2. Please use NMAPlaceLink#detailsRequest
 * and NMADiscoveryLink#request.
 */
@property (nonatomic, strong, readonly) NSString *url DEPRECATED_ATTRIBUTE;

@end

/** @} */
