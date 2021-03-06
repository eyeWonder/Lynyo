/*
 * Copyright © 2011-2016 HERE Global B.V. and its affiliate(s).
 * All rights reserved.
 * The use of this software is conditional upon having a separate agreement
 * with a HERE company for the use or utilization of this software. In the
 * absence of such agreement, the use of the software is not allowed.
 */

#import <Foundation/Foundation.h>


/**
 * \addtogroup NMA_Common  NMA Common Group
 * @{
 */

/**
 * \class NMAGeoMesh NMAGeoMesh.h "NMAGeoMesh.h"
 *
 * Represents a 3D model.
 *
 * The NMAGeoMesh class encapsulates all the geometric information
 * needed to render a 3D model. This information includes the vertices,
 * texture coordinates, and triangles of the model.
 */
@interface NMAGeoMesh : NSObject

/**
 * Sets the vertices(geo-coordinates) of the mesh as an array of NMAGeoCoordinates.
 *
 * \note The mesh is limited to 65536 NMAGeoCoordinates.
 *
 * \param vertices An array of NMAGeoCoordinates representing the mesh vertices.
 */
- (void)setVertices:(NSArray *)vertices;

/**
 * \brief Sets the vertices(geo-coordinates) of the mesh.
 *
 * Each mesh vertex is represented by three float values representing its
 * longitude, latitude, altitude positions. Three values are always required for
 * each vertex, so the length of the vertices array should always be a multiple of 3.
 *
 * \note The mesh is limited to 65536 vertices.
 *
 * \param vertices A pointer to an array of floats representing the mesh vertices.
 * \param count The number of vertices in the array. The length of the vertices array
 * should be 3 * count.
 */
- (void)setVertices:(const double *)vertices withCount:(NSUInteger)count;

/**
 * \brief Sets the texture coordinates of the mesh.
 *
 * Every mesh vertex must also have a texture coordinate defined, which identifies the
 * location on the mesh texture corresponding to that vertex. Texture coordinates are
 * defined by two float values in the range [0, 1], with a value of (0, 0) corresponding
 * to the upper left corner of the texture and (1, 1) the lower right corner.
 *
 * \param textureCoordinates A pointer to an array of floats representing the texture
 * coordinates.
 * \param count The number of texture coordinates in the array. The length of the
 * textureCoordinates array should be 3 * count.
 */
- (void)setTextureCoordinates:(const float *)textureCoordinates withCount:(NSUInteger)count;

/**
 * \brief Sets the triangles of the mesh.
 *
 * A mesh is rendered as a collection of triangles. Each triangle is defined by specifying
 * the indices of the three vertices which make up its corners. The indices may be specified
 * in any order.
 *
 * \param triangles A pointer to an array of shorts representing the triangles of the mesh.
 * \param count The number of triangles in the array. The length of the triangles array should be
 * 3 * count.
 */
- (void)setTriangles:(const short *)triangles withCount:(NSUInteger)count;

/**
 * \brief Checks if the current mesh data is valid.
 *
 * A mesh is considered valid if it has equal numbers of vertices and texture coordinates
 * and the indices of the triangle array are all less than the number of vertices.
 */
- (BOOL)isValid;

@end
/** @} */
