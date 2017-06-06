//
//  MapPointViewEditBottomViewController.h
//  photowall
//
//  Created by andy840119 on 2017/05/30.
//  Copyright © 2017年 Picowork. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapPointViewBottomViewController.h"
#import "MapPoint.h"

@class MapPointManager;

@interface MapPointViewEditBottomViewController : MapPointViewBottomViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>



//context textbox view
@property (weak, nonatomic) IBOutlet UITextView *contextUITextView;

//uploadImage View
@property (weak, nonatomic, readonly) IBOutlet UIImage *uploadImage;



@end
