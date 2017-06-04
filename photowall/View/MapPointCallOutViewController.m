//
//  MapPointCallOutViewController.m
//  photowall
//
//  Created by Spirit on 4/30/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import "MapPointCallOutViewController.h"

#import "MapPoint.h"

#import "UIImageView+WebImage.h"

@implementation MapPointCallOutViewController

- (void)setPhoto:(MapPoint *)photo withContextString:(NSString*)context {
	self.nicknameLabel.text = context;
	[self.photoView setImageWithPath:photo.thumbnailPath andPlaceholder:nil];
}

@end
