//
//  MapPointSpotController.m
//  photowall
//
//  Created by Spirit on 4/30/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import "MapPointSpotController.h"

#import "MapPoint.h"

#import "UIImageView+WebImage.h"

@implementation MapPointSpotController

- (void)setPhoto:(MapPoint *)photo withContextString:(NSString*)context {
	self.nicknameLabel.text = context;
	[self.photoView setImageWithPath:photo.thumbnailPath andPlaceholder:nil];
}

@end
