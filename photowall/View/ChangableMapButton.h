//
//  ChangableMapButton.h
//  photowall
//
//  Created by andy840119 on 2017/06/04.
//  Copyright © 2017年 Picowork. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapPointViewController.h"

//switch image when different edit mode
//amazing button
@interface ChangableMapButton : UIButton

-(void)switchButotnImage:(enum MapPointViewMode ) type;

-(float)getButtonPressTime;
@end
