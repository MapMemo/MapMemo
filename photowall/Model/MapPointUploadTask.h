//
//  MapPointUploadTask.h
//  photowall
//
//  Created by Spirit on 4/9/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "MapPointManager.h"

@interface MapPointUploadTask : NSObject<CLLocationManagerDelegate>

- (instancetype)initWithData:(MapPoint*)data;

- (void)uploadWithClient:(RestClient*)client andHandler:(PhotoHandler)handler;

@end
