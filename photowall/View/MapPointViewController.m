//
//  MapPointViewController.m
//  photowall
//
//  Created by Spirit on 4/2/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "MapPointViewController.h"

#import "UserManager.h"
#import "MapPointManager.h"

#import "PhotoAnnotation.h"
#import "MapPointSpotController.h"

#import "UIView+Utils.h"
#import "MapPointRegion+Utils.h"
#import "MapPointViewEditBottomViewController.h"
#import "MapPointViewDetailBottomViewController.h"
#import "RootViewController.h"
#import "ChangableMapButton.h"
#import "AccountManager.h"
#import "MapPoint.h"
#import "MapPointMKMapView.h"

NSString* const PhotoAnnotationViewIdentifier = @"PhotoAnnotationView";


//about get the map center position :
//https://cg2010studio.com/2014/04/08/ios-%E4%BD%BF%E7%94%A8%E5%9C%B0%E5%9C%96%E7%8D%B2%E5%BE%97%E7%B6%93%E7%B7%AF%E5%BA%A6/
@implementation MapPointViewController {

    //point detail view
    MapPointViewDetailBottomViewController* _viewMapPointBarController;

	//point edit or create view
	MapPointViewEditBottomViewController* _editMapPointBottomController;

	//if hasn't focus any point
	MapPointViewBottomViewController* _mapPointBarController;

    //now MapPoint dats
    MapPoint *_nowMapPoint;

	//all the points int the mapView
	NSMutableArray* _annotations;

	//all the mapPoints objects
	NSMutableArray* _nearByMapPoints;

	//if pressDeltaTime > 1000ms,set as longPress
    float TriggerDeltaPressTime;

    float barFrame_Y;
}

#pragma mark - event
- (void)viewDidLoad
{
	[super viewDidLoad];
	_annotations = [NSMutableArray new];
	_nearByMapPoints = [NSMutableArray new];

	TriggerDeltaPressTime=1000;

	//set the position_Y
	//barFrame_Y=380.0f;
	barFrame_Y=[self.bottomViewContainer frame].origin.y-40;

    //construct bottom page
    _viewMapPointBarController=[[MapPointViewDetailBottomViewController alloc] initWithNibName:@"MapPointViewDetailBottomView" bundle:nil];
    _editMapPointBottomController=[[MapPointViewEditBottomViewController alloc] initWithNibName:@"MapPointViewEditBottomView" bundle:nil];
    _mapPointBarController=[[MapPointViewBottomViewController alloc] initWithNibName:@"MapPointViewBottomView" bundle:nil];
    //set value
    _viewMapPointBarController.mapPointViewController=self;
    _viewMapPointBarController.userManager=self.userManager;
    _editMapPointBottomController.mapPointViewController=self;
    _mapPointBarController.mapPointViewController=self;

    //get keyboard appear and disappear event
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];

    //add map event
	UIPanGestureRecognizer* panRec = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didDragMap:)];
	[panRec setDelegate:self];
	[self.mapView addGestureRecognizer:panRec];

    //set initial state and update view
    [self updateView:emptyAndReadyForEdit];
	//set to the position
	self.setToNowPosition;
}

#pragma mark - event
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //update view
    [self updateView:emptyAndReadyForEdit];
    //update title
    [self.rootViewController setTitle:@"points On Map"];
}

//if switch to this view
#pragma mark - event
- (void)viewDidAppear:(BOOL)animated
{
    //set to the area


}

//if switch to another view
#pragma mark - event
-(void)viewWillDisappear:(BOOL)animated
{
    //update view and set not on this view
    [self updateView:notThisPage];
}

#pragma mark - event
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void)setToNowPosition
{
	MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(25.044013, 121.533954), 500, 500);
	[self.mapView setRegion:region animated:YES];
	[self loadPhotosInRegion:[MapPointRegion fromMKCoordinateRegion:region]];
}

//keyboard show and start typing
#pragma mark - event
- (void)keyboardWillShow:(NSNotification*)notification {
    NSDictionary* info = [notification userInfo];
    //get the keyboard size
    CGSize size = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [UIView animateWithDuration:0.25 animations:^
    {
		//move the bottom view
        CGRect newFrame = [self.bottomViewContainer frame];
        newFrame.origin.y =barFrame_Y - size.height; // tweak here to adjust the moving position
        [self.bottomViewContainer setFrame:newFrame];

		//[self.mapView setFrame:newFrame];


	}completion:^(BOOL finished)
    {

    }];


	//TODO : show the map
	[UIView animateWithDuration:0.25 animations:^
	{
		//move the bottom view
		CGRect newFrame = [self.mapView frame];
		newFrame.origin.y = - size.height;
		[self.mapView setFrame:newFrame];
		[self.mapPointerLabel setFrame:newFrame];


	}completion:^(BOOL finished)
	{

	}];
}

//hide the keyboard
#pragma mark - event
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
	//TODO : hide the map
	[UIView animateWithDuration:0.25 animations:^
	{
		//move the bottom view
		CGRect newFrame = [self.mapView frame];
		newFrame.origin.y =0;
		[self.mapView setFrame:newFrame];
		[self.mapPointerLabel setFrame:newFrame];

	}completion:^(BOOL finished)
	{

	}];

    self.setBottomViewShow;
}

//if touch another place ,end editing
#pragma mark - event
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

//if draging map
#pragma mark - event
- (void)didDragMap:(UIGestureRecognizer*)gestureRecognizer
{
	if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
	{
		//stop draging
		NSLog(@"drag ended");
	}
	else
	{
		//if contains ,catch the nearest center map Points
		MapPoint *nearestMapPoint= [self getNearestCenterMapPoint:self.getZoomLevel/150000];

        //if catch is not same as last state
        if(_nowMapPoint!=nearestMapPoint)
        {
            //update the mapPoint and the view
            _nowMapPoint=nearestMapPoint;
            if(_nowMapPoint!=nil)
            {
                //Show the detail
                [self updateView:forceExistmapPoint];
            }
            else
            {
                //swich to null page
                [self updateView:emptyAndReadyForEdit];
            }
        }
	}
}

//TODO : get the nearest mapPoint in the map area
#pragma mark - function
-(MapPoint *)getNearestCenterMapPoint:(double)maximunValue
{
	if(_nearByMapPoints==nil)
		return nil;
	if(_nearByMapPoints.count<=0)
		return nil;

	MapPointLocation * centerPosition = self.getPositionFromMapViewCenter;
	MapPoint *nearestPoint=nil;
	double nearestValue=10000;

	for(MapPoint *singlePoint in _nearByMapPoints)
	{
		//get distence
		double singleValue= [self calculteTwoDistence:centerPosition :singlePoint.location];
		if(singleValue<nearestValue)
		{
			nearestPoint = singlePoint;
			nearestValue = singleValue;
		}
	}

    //if is near than assign value
    //NSLog([NSNumber numberWithDouble:maximunValue].stringValue);
    //NSLog([NSNumber numberWithDouble:nearestValue].stringValue);
    if(nearestValue>maximunValue)
        return nil;

    return nearestPoint;
}

#pragma mark - calculate
-(double )calculteTwoDistence:(MapPointLocation *) position1 :(MapPointLocation *) position2
{
	double dx = (position2.latitude - position1.latitude);
	double dy = (position2.longitude - position1.longitude);
	double dist = sqrt(dx*dx + dy*dy);
	return dist;
}

#pragma mark - MKMapViewDelegate
- (void)mapView:(MKMapView*)mapView regionDidChangeAnimated:(BOOL)animated
{
	MapPointRegion* region = [MapPointRegion fromMKCoordinateRegion:mapView.region];
	[self loadPhotosInRegion:region];
}

//Add a point on MapView
//override the mapView viewForAnnotation function
- (MKAnnotationView*)mapView:(MKMapView*)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
	//change the type into PhotoAnnotation
	PhotoAnnotation* photoAnnotation = (PhotoAnnotation*)annotation;
	//
	MKAnnotationView* view = [mapView dequeueReusableAnnotationViewWithIdentifier:PhotoAnnotationViewIdentifier];
	if (view == nil)
	{
		view = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:PhotoAnnotationViewIdentifier];
	}
	//the class will point to the map
	MapPointSpotController* callOutView = [[[NSBundle mainBundle] loadNibNamed:@"MapPointSpot" owner:nil options:nil] firstObject];
	callOutView.translatesAutoresizingMaskIntoConstraints = NO;
	//set the photo and the string context

    [callOutView setPhoto:photoAnnotation.photo withContextString:[self.userManager getUser:photoAnnotation.photo.posterId].nickname];
	view.canShowCallout = YES;
	//set the position
	view.frame = CGRectMake(-20, -20, 40, 40);
	[view addSubview:callOutView fit:YES];
	return view;
}

//update photos from region
#pragma mark - Private Methods
- (void)loadPhotosInRegion:(MapPointRegion*)region
{

	self.mapView.tag = region.hash;
	//get list photos form region
    [self.photoManager loadMapPointsNear:region withHandler:[self updateAnnoationsWithTag:region.hash]];
}

//update all the map points
#pragma mark - Code Blocks
- (PhotoHandler)updateAnnoationsWithTag:(NSInteger)tag
{
	return ^(NSError* error, NSArray* mapPoints)
	{
		if (self.mapView.tag != tag) {
			return;
		}
		[_nearByMapPoints removeAllObjects];
		[self.mapView removeAnnotations:_annotations];
		[_annotations removeAllObjects];
		if (error == nil)
		{
			[_nearByMapPoints addObjectsFromArray:mapPoints];
			//add the points that not in the map
			for (MapPoint* mapPoint in mapPoints)
			{
				PhotoAnnotation* annotation = [PhotoAnnotation new];
				annotation.photo = mapPoint;
				annotation.poster = [self.userManager getUser:mapPoint.posterId].nickname;
				[_annotations addObject:annotation];
			}
		}
		[self.mapView addAnnotations:_annotations];
	};
}

#pragma mark - event
- (void)PressButtonDown
{

}

#pragma mark - event
- (void)PressButtonUp
{
	float deltaTime = self.rootViewController.mapPointViewTabButton.getButtonPressTime;
	//see as long press
	if(deltaTime>TriggerDeltaPressTime)
	{
		[self LongPressUpMapButton];
	}
    else
    {
        self.SlowPressUpMapButton;
    }
}

//long press Button,
-(void) LongPressUpMapButton
{

}

//slowPressUpButton
-(void) SlowPressUpMapButton
{
    switch(self.mapPointViewMode)
    {
        case notThisPage:
            //do nothing
            break;

        case emptyAndReadyForEdit:
            [self updateView:onEdit];//show edit page
            break;

        case onEdit://cancel edit
            if(_nowMapPoint!=nil)
                [self updateView:forceExistmapPoint];
            else
                [self updateView:emptyAndReadyForEdit];
            break;

        case forceExistmapPoint:
            [self updateView:onEdit];//show edit page
            break;
    }
}

//update view
-(void)updateView:(enum MapPointViewMode ) type
{
    self.mapPointViewMode=	type;
    //update bottomContainer and interactive or not
    [self updateBottmeView:self.mapPointViewMode];
    //update Info to container
    [_viewMapPointBarController setExistMapPoint:_nowMapPoint];
    //update button Icon
    [self.rootViewController.mapPointViewTabButton switchButotnImage:self.mapPointViewMode];

}

//update bottom view
-(void) updateBottmeView:(enum MapPointViewMode ) type
{
    [self updateInteractable:false];

    switch(type)
    {
        case notThisPage:
            [self setSelectedIndex:_mapPointBarController];//did not appear view
            //hide the view
            self.setBottonViewHide;
            break;

        case emptyAndReadyForEdit:
            [self setSelectedIndex:_mapPointBarController];//did not appear view
            //hide the view
            self.setBottonViewHide;
            break;

        case onEdit:
            [self setSelectedIndex:_editMapPointBottomController];//edit view
            [self updateInteractable:true];
            break;

        case forceExistmapPoint:
            [self setSelectedIndex:_viewMapPointBarController];//detail voew
            break;
    }
}

//switch the page
#pragma mark - Private Methods
- (void)setSelectedIndex:(MapPointViewBottomViewController *)targetView
{
	//get now controller
    UIViewController* controller = targetView;
    //hide the view
    self.setBottonViewHide;

    //remove all views
    NSArray *viewsToRemove = [self.bottomViewContainer subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    //add view
    [self.bottomViewContainer addSubview:controller.view fit:YES];

	//show the view
	self.setBottomViewShow;
}

//update is interactive or not
#pragma mark - Private Methods
-(void) updateInteractable:(bool)editable
{
    self.bottomViewContainer.userInteractionEnabled=editable;
}

//show the whole view
#pragma mark - Private Methods
-(void) setBottomViewShow
{
	[UIView animateWithDuration:0.25 animations:^
	{
		CGRect newFrame = [self.bottomViewContainer frame];
		newFrame.origin.y =barFrame_Y ;  // tweak here to adjust the moving position
		[self.bottomViewContainer setFrame:newFrame];

	}completion:^(BOOL finished)
	{

	}];

}

//hide the view
#pragma mark - Private Methods
-(void) setBottonViewHide
{
	[UIView animateWithDuration:0.25 animations:^
	{
		CGRect newFrame = [self.bottomViewContainer frame];
		newFrame.origin.y =barFrame_Y + 300 ;  // tweak here to adjust the moving position
		[self.bottomViewContainer setFrame:newFrame];

	}completion:^(BOOL finished)
	{

	}];

}

//get map Location
-(MapPointLocation *) getPositionFromMapViewCenter
{
	//get the uploadTargetMapPoint
	MKMapView* mapView=self.mapView;
	//get the location
	MapPointLocation * location = [[MapPointLocation alloc]
			initWithLatitude:mapView.centerCoordinate.latitude
				andLongitude:mapView.centerCoordinate.longitude];
	//return the location
	return location;
}


#define MERCATOR_RADIUS 85445659.44705395
#define MAX_GOOGLE_LEVELS 20
//get zoon region
- (double)getZoomLevel
{
    //all taiwan : 9427.435253675447,point : 0.06511818684892541
    //taipei tech : 19.70400032439055,point : 0.0001382921443705329

	CLLocationDegrees longitudeDelta = self.mapView.region.span.longitudeDelta;
	CGFloat mapWidthInPixels = self.mapView.bounds.size.width;
	double zoomScale = longitudeDelta * MERCATOR_RADIUS * M_PI / (180.0 * mapWidthInPixels);
	return zoomScale;
}


@end
