//
//  MapPointViewEditBottomViewController.m
//  photowall
//
//  Created by andy840119 on 2017/05/30.
//  Copyright © 2017年 Picowork. All rights reserved.
//

#import "MapPointViewEditBottomViewController.h"
#import "MapPointManager.h"

@interface MapPointViewEditBottomViewController ()

@end

//TODO : flow up the textbox when typing
// https://stackoverflow.com/questions/1126726/how-to-make-a-uitextfield-move-up-when-keyboard-is-present
//
@implementation MapPointViewEditBottomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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


// if selected upload image and return to the mapViewPage ?
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
	[picker dismissViewControllerAnimated:YES completion:nil];
	UIImage* image = [info valueForKey:UIImagePickerControllerOriginalImage];
	NSData* pngData = UIImagePNGRepresentation(image);

	//andy840119
	/*
	[self.photoManager uploadPhoto:pngData withHandler:^(NSError* error, NSArray* photos) {
		[_mapPointGridViewController refreshPhotos];
	}];
	 */
}



@end
