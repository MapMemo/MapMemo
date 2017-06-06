//
//  MapPointViewController.m
//  photowall
//
//  Created by Spirit on 4/2/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import "MapPointViewController.h"

#import "UserManager.h"
#import "MapPointManager.h"

#import "PhotoAnnotation.h"
#import "MapPointCallOutViewController.h"

#import "UIView+Utils.h"
#import "MapPointRegion+Utils.h"
#import "MapPointViewEditBottomViewController.h"
#import "MapPointViewDetailBottomViewController.h"
#import "RootViewController.h"
#import "ChangableMapButton.h"
#import "AccountManager.h"
#import "MapPoint.h"

NSString* const PhotoAnnotationViewIdentifier = @"PhotoAnnotationView";


//TODO : about get the map center position :
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

    NSInteger _selectedIndex;
    NSArray* _barControllers;
    UIViewController* _currentController;

	//all the points int the mapView
	NSMutableArray* _annotations;

	//all the mapPoints objects
	NSMutableArray* _nearByMapPoints;

	//if pressDeltaTime > 1000ms,set as longPress
    float TriggerDeltaPressTime;

	float pressDownTime;

    float barFrame_Y;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	_annotations = [NSMutableArray new];
	_nearByMapPoints = [NSMutableArray new];

	TriggerDeltaPressTime=1000;

	//set the position_Y
	barFrame_Y=400.0f;

    //construct bottom page
    _viewMapPointBarController=[[MapPointViewDetailBottomViewController alloc] initWithNibName:@"MapPointViewDetailBottomView" bundle:nil];
    _editMapPointBottomController=[[MapPointViewEditBottomViewController alloc] initWithNibName:@"MapPointViewEditBottomView" bundle:nil];
    _mapPointBarController=[[MapPointViewBottomViewController alloc] initWithNibName:@"MapPointViewBottomView" bundle:nil];
    //set value
    _viewMapPointBarController.mapPointViewController=self;
    _editMapPointBottomController.mapPointViewController=self;
    _mapPointBarController.mapPointViewController=self;

    //idol , view ,edit
    _barControllers = @[_mapPointBarController,  _viewMapPointBarController,_editMapPointBottomController ];

    //get keyboard appear and disappear event
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];

    //set now page index is 0
    _selectedIndex = 2;
    //set index
    [self setSelectedIndex:_selectedIndex];

	//add map event
	UIPanGestureRecognizer* panRec = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didDragMap:)];
	[panRec setDelegate:self];
	[self.mapView addGestureRecognizer:panRec];
}

//if draging map
- (void)didDragMap:(UIGestureRecognizer*)gestureRecognizer
{
	if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
	{
		//
		NSLog(@"drag ended");
	}
	else
	{
		//if contains ,catch the nearest center map Points
		MapPoint *nearestMapPoint=[self getNearestMapPoint];
        //if catch is not same as last state
        if(_nowMapPoint!=nearestMapPoint)
        {
            _nowMapPoint=nearestMapPoint;
            [self changeViewData:_nowMapPoint];
        }
	}
}

//TODO : get the nearest mapPoint in the map area
-(MapPoint *)getNearestMapPoint
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
    return nearestPoint;
}

-(double )calculteTwoDistence:(MapPointLocation *) position1 :(MapPointLocation *) position2
{
	double dx = (position2.latitude - position1.latitude);
	double dy = (position2.longitude - position1.longitude);
	double dist = sqrt(dx*dx + dy*dy);
	return dist;
}


-(void) changeViewData : (MapPoint *) mapPoint
{
    [_viewMapPointBarController setExistMapPoint:mapPoint];

    if(mapPoint!=nil)
    {
        //Show the detail

    }
    else
    {
        //swich to null page
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
	return YES;
}

//keyboard show and start typing
- (void)keyboardWillShow:(NSNotification*)notification {
	NSDictionary* info = [notification userInfo];
	//get the keyboard size
	CGSize size = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
	[UIView animateWithDuration:0.25 animations:^
	{
		CGRect newFrame = [self.bottomViewContainer frame];
		newFrame.origin.y =barFrame_Y - size.height; // tweak here to adjust the moving position
		[self.bottomViewContainer setFrame:newFrame];

	}completion:^(BOOL finished)
	{

	}];
}

//hide the keyboard
- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
	self.setBottomViewShow;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.rootViewController setTitle:@"points On Map"];
}

//if switch to this page
- (void)viewDidAppear:(BOOL)animated
{
	//set to the area
	MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(25.044013, 121.533954), 500, 500);
	[self.mapView setRegion:region animated:YES];
	[self loadPhotosInRegion:[MapPointRegion fromMKCoordinateRegion:region]];

	//
	[self swithViewMode:emptyAndReadyForEdit];
}

//if switch to another view
-(void)viewDidDisappear:(BOOL)animated 
{
	[self swithViewMode:notThisPage];
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
	MapPointCallOutViewController* callOutView = [[[NSBundle mainBundle] loadNibNamed:@"MapPointCallOutView" owner:nil options:nil] firstObject];
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


- (void)PressButtonDown:(float )PressTime
{
	pressDownTime=PressTime;
}


- (void)PressButtonUp:(float )PressUpTime
{
	float deltaTime=PressUpTime-pressDownTime;

	//see as long press
	if(deltaTime>TriggerDeltaPressTime)
	{
		[self LongPressMapButton];
	}
}

//long press Button,
-(void) LongPressMapButton
{

}

//switch view mode;
-(void)swithViewMode:(enum MapPointViewMode ) type
{
	self.mapPointViewMode=	type;
	[self.rootViewController.mapPointViewTabButton switchButotnImage:type];
}

//display the bottom edit view
-(void) SwitchToEditBottomView : (CLLocationCoordinate2D *) coordinate
{
    //TODO : if already hase point ,set to the edit controller
    MapPoint *point= [self getMapPointByCLLocationCoordinate2D:coordinate];
    //set the point to the controller
	[_editMapPointBottomController setExistMapPoint:point];
    //set to the edit mode
    [self setSelectedIndex:1];
}

//display the bottom deatil view by latitude,set the position
-(void) SwitchToDetailBottomView :(CLLocationCoordinate2D *) coordinate
{
    //TODO : if already hase point ,set to the edit controller
    MapPoint *point= [self getMapPointByCLLocationCoordinate2D:coordinate];
    //set the point to the controller
	[_viewMapPointBarController setExistMapPoint:point];
    //set to the view mode
    [self setSelectedIndex:1];
}

//get the nearest
-(MapPoint *) getMapPointByCLLocationCoordinate2D:(CLLocationCoordinate2D *) coordinate
{
    return 0;
}

//switch the page
#pragma mark - Private Methods
- (void)setSelectedIndex:(NSInteger)index
{

    if (index < 0 || index > [_barControllers count])
    {
		self.setBottonViewHide;
        return;
    }
    _selectedIndex = index;
	//get now controller
    UIViewController* controller = [_barControllers objectAtIndex:index];
    if (_currentController == controller)
    {
        return;
    }
	//hide the view
	self.setBottonViewHide;
	//switch the view
    [_currentController.view removeFromSuperview];
    [self.bottomViewContainer addSubview:controller.view fit:YES];
    _currentController = controller;
	//show the view
	self.setBottomViewShow;
    //TODO : if is edit barView,set touch as enable;
    if(index==2)
    {
        self.bottomViewContainer.userInteractionEnabled=true;
    }
    else
    {
        self.bottomViewContainer.userInteractionEnabled=false;
    }
}

//show the whole view
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


@end
