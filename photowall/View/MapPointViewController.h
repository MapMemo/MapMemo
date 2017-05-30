//
//  MapPointViewController.h
//  photowall
//
//  Created by Spirit on 4/2/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class UserManager;
@class MapPointManager;

enum MapPointViewMode
{
    empty=0,//if there is not map in the center (selected area)
    forceExistmapPoint=1 //if there have mapPoint in the map
};

@interface MapPointViewController : UIViewController<MKMapViewDelegate>

//show the view or edit page
@property (weak, nonatomic) IBOutlet UIView* barViewContainer;

@property (weak, nonatomic) UIViewController* rootViewController;

@property (weak, nonatomic) IBOutlet MKMapView* mapView;

@property (weak, nonatomic) UserManager* userManager;
@property (weak, nonatomic) MapPointManager* photoManager;


//Notofied by rootView
- (void)PressButtonDown:(float)PressTime;
//Notified by rootView
- (void)PressButtonUp:(float)PressUpTime;

@end
