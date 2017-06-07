//
//  MapPointViewController.h
//  photowall
//
//  Created by Spirit on 4/2/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "PageUIViewController.h"

@class UserManager;
@class MapPointManager;
@class AccountManager;
@class MapPointLocation;

enum MapPointViewMode
{
    notThisPage=0,//if not on this page
    emptyAndReadyForEdit=1, //if there is not map in the center (selected area)
    onEdit=2,//onEditMap
    forceExistmapPoint=3 //if there have uploadTargetMapPoint in the map
};

@interface MapPointViewController : PageUIViewController<MKMapViewDelegate,UIGestureRecognizerDelegate>

//show the view or edit page
@property (weak, nonatomic) IBOutlet UIView* bottomViewContainer;

@property (weak, nonatomic) IBOutlet MKMapView* mapView;

@property (weak, nonatomic) UserManager* userManager;

@property (weak, nonatomic) MapPointManager* photoManager;

@property AccountManager* accountManager;

//update the mode
@property(nonatomic) enum MapPointViewMode mapPointViewMode;

//get map Location
-(MapPointLocation *) getPositionFromMapViewCenter;

@end
