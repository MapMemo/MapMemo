//
//  HistoryCell.h
//  photowall
//
//  Created by andy840119 on 2017/06/09.
//  Copyright © 2017年 Picowork. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MapPoint;

FOUNDATION_EXPORT NSString* const HistoryCellIdentifier;

@interface HistoryCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel* posterName;
@property (weak, nonatomic) IBOutlet UILabel* postContext;
@property (weak, nonatomic) IBOutlet UILabel* postDate;
@property (weak, nonatomic) IBOutlet UIImageView* photoView;

- (void)setPhoto:(MapPoint*)photo;

@end
