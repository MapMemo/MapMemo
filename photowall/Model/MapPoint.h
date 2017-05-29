//
//  MapPoint.h
//  photowall
//
//  Created by Spirit on 4/9/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import <Foundation/Foundation.h>

//the location of map point
@interface MapPointLocation : NSObject

- (instancetype)initWithLatitude:(double)latitude andLongitude:(double)longitude;

@property (nonatomic, readonly) double latitude;
@property (nonatomic, readonly) double longitude;

@end

//main map point
@interface MapPoint : NSObject

//user ID
@property (nonatomic, readonly) NSString* posterId;
//mapPoint ID ?
@property (nonatomic, readonly) NSString* identifier;
//PostTime
@property (nonatomic, readonly) NSDate* timestamp;
//Location
@property (nonatomic, readonly) MapPointLocation* location;
//memo
@property (nonatomic, readonly) NSString* memo;
//small image path
@property (nonatomic, readonly) NSString* thumbnailPath;
//large Image path
@property (nonatomic, readonly) NSString* fullSizeImagePath;


@end

//json of map point
@interface MapPoint (JSON)

+ (instancetype)photoFromJson:(id)json;

@end
