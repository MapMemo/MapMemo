//
//  MapPointViewDetailBottomViewController.h
//  photowall
//
//  Created by andy840119 on 2017/05/30.
//  Copyright © 2017年 Picowork. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapPoint.h"
#import "MapPointViewBottomViewController.h"
#import "MapPointManager.h"

@class MapPointViewController;
@class UserManager;

@interface MapPointViewDetailBottomViewController : MapPointViewBottomViewController

//user
@property (weak, nonatomic) IBOutlet UILabel *userLabel;

//context
@property (weak, nonatomic) IBOutlet UILabel *contextLabel;

//image
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property UserManager *userManager;


@end
