//
//  MapPointMKMapView.m
//  photowall
//
//  Created by andy840119 on 2017/06/11.
//  Copyright © 2017年 Picowork. All rights reserved.
//

#import "MapPointMKMapView.h"
#import "MapPoint.h"
#import "PhotoAnnotation.h"
#import "UserManager.h"


@implementation MapPointMKMapView{

    //all the points int the mapView
    NSMutableArray* _annotations;
    //All map points
    NSMutableArray* _nearByMapPoints;
}

- (id) init {
    self = [super init];
    if (self != nil)
    {
        // initializations go here.
        _nearByMapPoints = [NSMutableArray new];

    }
    return self;
}

//update all the map points
#pragma mark - Code Blocks
- (void)updateListMapPointToMapView:(NSArray *)mapPoints
{
    _nearByMapPoints = [NSMutableArray new];
     //remove all points
    [_nearByMapPoints removeAllObjects];
    [self removeAnnotations:_annotations];
    [_annotations removeAllObjects];

    [_nearByMapPoints addObjectsFromArray:mapPoints];

    //add the points that not in the map
    for (MapPoint* mapPoint in mapPoints)
    {
        PhotoAnnotation* annotation = [PhotoAnnotation new];
        annotation.photo = mapPoint;
        annotation.poster = [self.userManager getUser:mapPoint.posterId].nickname;
        [_annotations addObject:annotation];
    }
    [self addAnnotations:_annotations];
}

@end
