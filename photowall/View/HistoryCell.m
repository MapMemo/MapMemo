//
//  HistoryCell.m
//  photowall
//
//  Created by andy840119 on 2017/06/09.
//  Copyright © 2017年 Picowork. All rights reserved.
//

#import "HistoryCell.h"

#import "MapPoint.h"

#import "UIImageView+WebImage.h"

NSString* const HistoryCellIdentifier = @"HistoryCell";

@implementation HistoryCell

- (void)setPhoto:(MapPoint*)photo {
    [self.photoView setImageWithPath:photo.thumbnailPath andPlaceholder:nil];
    self.postContext.text=photo.context;

    //postDate and userName should assign in outside
}

@end
