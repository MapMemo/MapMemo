//
//  PhotoAnnotation.h
//  photowall
//
//  Created by Spirit on 4/29/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import <MapKit/MapKit.h>

@class MapPoint;

@interface PhotoAnnotation : NSObject<MKAnnotation>

//who post the point
@property (nonatomic) NSString* poster;

//mapPoints
@property (weak, nonatomic) MapPoint* photo;

@end
