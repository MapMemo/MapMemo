//
//  MapPointUploadTask.m
//  photowall
//
//  Created by Spirit on 4/9/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import "MapPointUploadTask.h"

#import "RestClient.h"

@implementation MapPointUploadTask
{
	//TODO : change it into MapPoint
	MapPoint *_mapPoint;


	RestClient* _client;
	PhotoHandler _handler;

	// use to get the position
    //but not use in here
	CLLocationManager* _manager;
}

#pragma mark - Initializers
- (instancetype)initWithData:(MapPoint*)data {
	if (self = [super init]) {
		//TODO : change it into MapPoint
		_mapPoint = data;
		_manager = [CLLocationManager new];
		_manager.delegate = self;
	}
	return self;
}

//TODO : use the CLLocation form MapPoint, not get form system
#pragma mark - Public Methods
- (void)uploadWithClient:(RestClient*)client andHandler:(PhotoHandler)handler {
	_client = client;
	_handler = handler;
	//
	CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
	//ask the authorize from manager;
	if (status != kCLAuthorizationStatusAuthorizedWhenInUse)
	{
		[_manager requestWhenInUseAuthorization];
	}

	//uploadImage
	//self.upoadMapPoint;
}

//if upload fall
#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager*)manager didFailWithError:(NSError*)error {
	[self uploadPhotoWithLocation:nil];
}

- (void)locationManager:(CLLocationManager*)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
	if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
		[manager requestLocation];
	}
}

//upload the photo from here
- (void)locationManager:(CLLocationManager*)manager didUpdateLocations:(NSArray<CLLocation*> *)locations
{
	CLLocation* location = locations.firstObject;
	[self uploadPhotoWithLocation:location];
}

//uplaod photo and get the result
#pragma mark - Private Methods
- (void)uploadPhotoWithLocation:(CLLocation*)location
{
    RestRequest* request = [_client path:@"/photos"];

    //midified the location from MapPoint
    MapPointLocation* mapPointLocation=_mapPoint.location;
    //ImageData
    NSData* _imageData = _mapPoint.image;

    if (mapPointLocation != nil)//location
    {
        NSString* geolocation = [NSString stringWithFormat:@"geo:%@,%@", @(mapPointLocation.latitude), @(mapPointLocation.longitude)];
        [request setValue:geolocation forHeader:@"Geolocation"];

    }
    if(_mapPoint.context!=nil)//context
    {
        [request setValue:_mapPoint.context forHeader:@"context"];
    }
    [request upload:_imageData withMethod:@"POST" andHandler:^(RestResponse* response)//Image
    {
        if (_handler != nil)
        {
            //if upload success ,get the result
            MapPoint* photo = nil;
            if (response.succeeded)
            {
                photo = [MapPoint photoFromJson:response.result];
                NSLog(@"commit success");
            }
            _handler(response.succeeded ? nil : response.error, @[ photo ]);
        }
    }];
}

@end
