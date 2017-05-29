//
//  MapPointRegion+Utils.m
//  photowall
//
//  Created by Spirit on 4/29/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import "MapPointRegion+Utils.h"

@implementation MapPointRegion (Utils)

+ (MapPointRegion*)fromMKCoordinateRegion:(MKCoordinateRegion)region {
	double latitude = region.center.latitude;
	double longitude = region.center.longitude;
	CLLocation* loc1 = [[CLLocation alloc] initWithLatitude:(region.center.latitude - region.span.latitudeDelta * 0.5) longitude:region.center.longitude];
	CLLocation* loc2 = [[CLLocation alloc] initWithLatitude:(region.center.latitude + region.span.latitudeDelta * 0.5) longitude:region.center.longitude];
	double radius = [loc1 distanceFromLocation:loc2] / 1000;
	return [[MapPointRegion alloc] initWithLatitude:latitude longitude:longitude andRadius:radius];
}

- (MKCoordinateRegion)toMKCoordinateRegion {
	CLLocationCoordinate2D center = CLLocationCoordinate2DMake(self.latitude, self.longitude);
	double meters = self.radius * 1000;
	return MKCoordinateRegionMakeWithDistance(center, meters, meters);
}

@end
