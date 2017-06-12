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
//uploadTargetMapPoint ID ?
@property (nonatomic, readonly) NSString* identifier;
//PostTime
@property (nonatomic, readonly) NSDate* timestamp;
//Location
@property (nonatomic, readonly) MapPointLocation* location;
//memo
@property (nonatomic) NSString* context;
//small image path
@property (nonatomic, readonly) NSString* thumbnailPath;
//large Image path
@property (nonatomic, readonly) NSString* fullSizeImagePath;

//TODO : will move to "uploadMapPoint" class
//uploadImageView
@property (nonatomic) NSData* image;

- (instancetype)initWithIdentifier:(NSString *)identifier posterId:(NSString *)posterId timestamp:(NSDate *)timestamp andLocation:(MapPointLocation *)location andContext:(NSString *)context;
@end

//json of map point
@interface MapPoint (JSON)

+ (instancetype)photoFromJson:(id)json;

@end
