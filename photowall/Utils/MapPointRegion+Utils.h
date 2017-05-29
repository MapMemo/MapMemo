//
//  MapPointRegion+Utils.h
//  photowall
//
//  Created by Spirit on 4/29/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import "MapPointRegion.h"

#import <MapKit/MapKit.h>

@interface MapPointRegion (Utils)

+ (MapPointRegion*)fromMKCoordinateRegion:(MKCoordinateRegion)region;

- (MKCoordinateRegion)toMKCoordinateRegion;

@end
