//
//  MapPointManager.m
//  photowall
//
//  Created by Spirit on 4/9/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import "MapPointManager.h"

#import "RestClient.h"
#import "MapPointUploadTask.h"

#import "NSDate+Utils.h"

@implementation MapPointManager {
	RestClient* _client;
	NSMutableArray* _tasks;
}

#pragma mark - Initializers
- (instancetype)initWithClient:(RestClient*)client {
	if (self = [super init]) {
		_client = client;
		_tasks = [NSMutableArray new];
	}
	return self;
}

//upload uploadTargetMapPoint form here
#pragma mark - Public Methods
- (void)uploadMapPoint:(MapPoint *)photoData withHandler:(PhotoHandler)handler
{
	NSLog(@"Create Task!");
	//create uploadClass to upload
	MapPointUploadTask* task = [[MapPointUploadTask alloc] initWithData:photoData];
	//add uploadClass to task array
	[_tasks addObject:task];
	//Upload
	[task uploadWithClient:_client andHandler:^(NSError* error, NSArray* photos)
	{
		[_tasks removeObject:task];
		if (handler != nil) {
			handler(error, photos);
		}
	}];
}

- (void)loadPhotosAfter:(NSDate*)after before:(NSDate*)before ofUser:(NSString*)userId withHandler:(PhotoHandler)handler {
	RestRequest* request = [_client path:@"/photos"];
	if (after != nil) {
		[request query:@"after" withValue:after.timestampInMilliseconds];
	}
	if (before != nil) {
		[request query:@"before" withValue:before.timestampInMilliseconds];
	}
	if (userId != nil) {
		[request query:@"poster" withValue:userId];
	}
	[request get:[self forwardPhotos:handler]];
}

//load the uploadTargetMapPoint near the map regino
- (void)loadMapPointsNear:(MapPointRegion *)region withHandler:(PhotoHandler)handler {
	if (region == nil) {
		if (handler != nil) {
			handler(nil, @[]);
		}
		return;
	}
	NSString* geolocation = [NSString stringWithFormat:@"geo:%@,%@;r=%@", @(region.latitude), @(region.longitude), @(region.radius)];
	RestRequest* request = [_client path:@"/nearby-photos"];
	[request setValue:geolocation forHeader:@"Geolocation"];
	[request get:[self forwardPhotos:handler]];
}

#pragma mark - Code Blocks
- (ResponseHandler)forwardPhotos:(PhotoHandler)handler {
	return ^(RestResponse* response) {
		if (response.succeeded) {
			NSMutableArray* photos = [NSMutableArray new];
			for (id json in response.result) {
				[photos addObject:[MapPoint photoFromJson:json]];
			}
			if (handler) {
				handler(nil, photos);
			}
		}
		else {
			if (handler) {
				handler(response.error, nil);
			}
		}
	};
}

@end
