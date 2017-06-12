//
//  MapPointSpotController.h
//  photowall
//
//  Created by Spirit on 4/30/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MapPoint;

//use to show single map view
@interface MapPointSpotController : UIView

@property (weak, nonatomic) IBOutlet UILabel* nicknameLabel;
@property (weak, nonatomic) IBOutlet UIImageView* photoView;

- (void)setPhoto:(MapPoint *)photo withContextString:(NSString*)nickname;

@end
