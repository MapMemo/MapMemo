//
//  MapPointViewEditBottomViewController.m
//  photowall
//
//  Created by andy840119 on 2017/05/30.
//  Copyright © 2017年 Picowork. All rights reserved.
//

#import "MapPointViewEditBottomViewController.h"
#import "MapPointManager.h"
#import "MapPointViewController.h"
#import "UserManager.h"
#import "AccountManager.h"
#import "RootViewController.h"

@interface MapPointViewEditBottomViewController ()

- (void)mapPoint:(MapPoint *)mapPoint;

//upload image
@property (weak, nonatomic)UIImage *uploadImage;

@property MapPoint *uploadTargetMapPoint;

@end

//TODO : flow up the textbox when typing
// https://stackoverflow.com/questions/1126726/how-to-make-a-uitextfield-move-up-when-keyboard-is-present
//
@implementation MapPointViewEditBottomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.setDefaultImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//TODO : if press image button , filter the image viewController for image selection
- (IBAction)SelectImageButtonPressUp:(id)sender
{
	UIImagePickerController* picker = [UIImagePickerController new];
	picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//	picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	picker.delegate = self;
	[self presentViewController:picker animated:YES completion:nil];
}

//if switch to viewMode
-(void)viewWillAppear:(BOOL)animated
{
    self.setDefaultImage;
}

// if selected upload image ,upload directly
//and notified map to update
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
	//save the image from ImagePicker
	[picker dismissViewControllerAnimated:YES completion:nil];
	self.uploadImage = [info valueForKey:UIImagePickerControllerOriginalImage];

}

//upload image
- (IBAction)ClickUploadImageButton:(id)sender
{
	//get now DataTime, but not use when upload
	NSDate* timestamp = [NSDate alloc];

	//get the position from the map
	MapPointLocation *location;
	location = self.mapPointViewController.getPositionFromMapViewCenter;

	NSString *userName=self.getUserName;

	NSString *context=_contextUITextView.text;

	//upload uploadTargetMapPoint
	self.uploadTargetMapPoint= [[MapPoint alloc]
			initWithIdentifier:nil
					  posterId:userName
					 timestamp:timestamp
				   andLocation:location
					andContext:context];	//get context form textBox


	//convert image into data
	@try {
		if(self.uploadImage!=nil)
			self.uploadTargetMapPoint.image = UIImagePNGRepresentation(self.uploadImage);
	}
	@catch (NSException *exception)
	{
		//if has error ,try upload default image
		self.setDefaultImage;
		self.uploadTargetMapPoint.image = UIImagePNGRepresentation(self.uploadImage);
	}

    NSLog(@"create MapPoint and prepare to upload");
	//uplaod profile
	[self.mapPointViewController.photoManager uploadMapPoint:self.uploadTargetMapPoint withHandler:^(NSError *error, NSArray *photos)
	{
		//refresh mapPointView
		//[self.mapPointViewController.rootViewController._mapPointGridViewController refreshPhotos];
		//[self.mapPointViewController ];
		NSLog(@"commit success");
	}];
}

//upload exist mapPoint
- (void)setExistMapPoint:(MapPoint *)targetMapPoint
{
	self.uploadTargetMapPoint=targetMapPoint;
}

-(NSString *)getUserName
{
	return self.mapPointViewController.accountManager.me.identifier;
}

//set default image;
-(void) setDefaultImage
{
	self.uploadImage=[UIImage imageNamed:@"MapButton"];
}

@end
