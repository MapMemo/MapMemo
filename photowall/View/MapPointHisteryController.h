//
//  MapPointHisteryController.h
//  photowall
//
//  Created by andy840119 on 2017/05/30.
//  Copyright © 2017年 Picowork. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserManager;
@class MapPointManager;

@interface MapPointHisteryController : UIViewController

@property (weak, nonatomic) UIViewController* rootViewController;


@property (weak, nonatomic) UserManager* userManager;
@property (weak, nonatomic) MapPointManager* photoManager;

@end
