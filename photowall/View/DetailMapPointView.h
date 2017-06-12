//
//  DetailMapPointView.h
//  photowall
//
//  Created by andy840119 on 2017/06/11.
//  Copyright © 2017年 Picowork. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;
@class MapPoint;
@class UserManager;

@interface DetailMapPointView : UIViewController

@property (nonatomic, weak) UserManager* userManager;

@property (weak, nonatomic) UIViewController* host;

@property (weak, nonatomic) IBOutlet UILabel *contextLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *userLabel;

@property (weak, nonatomic) IBOutlet UIImageView *photoUIImageView;

-(void) setMapPoint:(MapPoint *)mapPoint;


@end
