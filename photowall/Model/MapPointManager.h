//
//  MapPointManager.h
//  photowall
//
//  Created by Spirit on 4/9/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MapKit/MapKit.h>

#import "MapPoint.h"
#import "MapPointRegion.h"

@class RestClient;

typedef void(^PhotoHandler)(NSError* error, NSArray* photos);

@interface MapPointManager : NSObject<CLLocationManagerDelegate>

- (instancetype)initWithClient:(RestClient*)client;

- (void)uploadPhoto:(NSData*)photo withHandler:(PhotoHandler)handler;

- (void)loadPhotosAfter:(NSDate*)after before:(NSDate*)before ofUser:(NSString*)userId withHandler:(PhotoHandler)handler;

- (void)loadPhotosNear:(MapPointRegion*)region withHandler:(PhotoHandler)handler;

@end
