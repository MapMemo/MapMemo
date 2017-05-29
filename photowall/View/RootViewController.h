//
//  RootViewController.h
//  photowall
//
//  Created by Spirit on 4/1/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserManager;
@class MapPointManager;
@class AccountManager;

//RowView 順序 : FriendList,mapList,histery,setting(personal profile)
//RowView 正中間 : Map(Add,Edit...)

@interface RootViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView* viewContainer;

//Friend list
@property (weak, nonatomic) IBOutlet UIButton* friendsTabButton;
//map list view
@property (weak, nonatomic) IBOutlet UIButton* gridTabButton;
//Histery
@property (weak, nonatomic) IBOutlet UIButton* takePictureTabButton;
//setting
@property (weak, nonatomic) IBOutlet UIButton* profileTabButton;

//View map and add,enit new MapPoint in the map
@property (weak, nonatomic) IBOutlet UIButton* photoMapTabButton;

@property UserManager* userManager;
@property MapPointManager* photoManager;
@property AccountManager* accountManager;

- (void)showPhotosOfUser:(NSString*)userId;

@end
