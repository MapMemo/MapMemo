//
//  ChangableMapButton.m
//  photowall
//
//  Created by andy840119 on 2017/06/04.
//  Copyright © 2017年 Picowork. All rights reserved.
//

#import "ChangableMapButton.h"

@interface ChangableMapButton ()

@property float _pressDownTime;

@property float _pressTime;

@end

@implementation ChangableMapButton

//sitch icon
-(void)switchButotnImage:(enum MapPointViewMode ) type
{
    UIImage* changeImage;
    switch(type)
    {
        case notThisPage:
            changeImage=[UIImage imageNamed:@"MapButton"];
            break;

        case emptyAndReadyForEdit:
            changeImage=[UIImage imageNamed:@"MapEditButton"];
            break;

        case onEdit:
            changeImage=[UIImage imageNamed:@"MapEditOKButton"];
            break;

        case forceExistmapPoint:
            changeImage=[UIImage imageNamed:@"MapEditButton"];
            break;

    }
    [self setImage:changeImage forState:UIControlStateNormal];
}

//TODO : impliment get button press time in the future
-(float)getButtonPressTime
{
    return self._pressTime;
}

@end
