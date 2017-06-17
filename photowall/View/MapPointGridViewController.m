//
//  MapPointGridViewController.m
//  photowall
//
//  Created by Spirit on 4/2/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import "MapPointGridViewController.h"

#import "UserManager.h"
#import "MapPointManager.h"

#import "PhotoCell.h"
#import "PhotoGridSectionHeader.h"
#import "PhotoShowcaseViewController.h"

#import "NSDate+Utils.h"
#import "RootViewController.h"
#import "DetailMapPointView.h"
#import "UIView+Utils.h"

@implementation MapPointGridViewController {
	CGFloat _cellSize;

	NSDate* _latest;
	NSDate* _oldest;
	NSMutableArray* _cache;
	NSMutableDictionary* _photos;
}

#pragma mark - ViewController Lifecycle
- (void)viewDidLoad {
	[super viewDidLoad];
	_cache = [NSMutableArray new];
	_photos = [NSMutableDictionary new];
	_cellSize = ([UIScreen mainScreen].bounds.size.width - 3) / 4;
	UINib* cellNib = [UINib nibWithNibName:@"PhotoCell" bundle:nil];
	[self.photosView registerNib:cellNib forCellWithReuseIdentifier:PhotoCellIdentifier];
	UINib* headerNib = [UINib nibWithNibName:@"PhotoGridSectionHeader" bundle:nil];
	[self.photosView registerNib:headerNib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:PhotoGridSectionHeaderIdentifier];
	self.photosView.delegate = self;
	self.photosView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.rootViewController setTitle:@"MapPointGridView"];
	[self refreshPhotos];
}

#pragma mark - Public Methods
- (void)refreshPhotos {
	[self.photoManager loadPhotosAfter:_latest before:nil ofUser:self.posterId withHandler:[self indexPhotosAndUpdateView]];
}

#pragma mark - UICollectionViewDataSource
- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
	MapPoint* photo = [[_cache objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	PhotoCell* cell = (PhotoCell*)[collectionView dequeueReusableCellWithReuseIdentifier:PhotoCellIdentifier forIndexPath:indexPath];
	[cell setPhoto:photo];
	cell.posterName.text = [self.userManager getUser:photo.posterId].nickname;
	return cell;
}

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section {
	return [[_cache objectAtIndex:section] count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return [_cache count];
}

//TODO : split by user account
- (UICollectionReusableView*)collectionView:(UICollectionView*)collectionView viewForSupplementaryElementOfKind:(NSString*)kind atIndexPath:(NSIndexPath*)indexPath
{
	MapPoint* photo = [[_cache objectAtIndex:indexPath.section] objectAtIndex:0];
	PhotoGridSectionHeader* header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:PhotoGridSectionHeaderIdentifier forIndexPath:indexPath];
	header.dateLabel.text = [self.userManager getUser:photo.posterId].nickname;//photo.timestamp.dayString;
	return header;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath {
	return CGSizeMake(_cellSize, _cellSize);
}

- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
	return CGSizeMake(0, 30);
}

- (CGFloat)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
	return 1;
}

- (CGFloat)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
	return 1;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
	// top, left, bottom, right
	return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView
{
	float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
	if (scrollView.contentOffset.y <= 0) {
		[self refreshPhotos];
	}
	if (bottomEdge >= scrollView.contentSize.height) {
		[self.photoManager loadPhotosAfter:nil before:_oldest ofUser:self.posterId withHandler:[self indexPhotosAndUpdateView]];
	}
}

//todo : midified to show single MapPoint view
- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath
{
	MapPoint* photo = [[_cache objectAtIndex:indexPath.section] objectAtIndex:indexPath.item];
	DetailMapPointView* controller = [[DetailMapPointView alloc] initWithNibName:@"DetailMapPointView" bundle:nil];
	NSMutableArray* photos = [NSMutableArray new];
	for (NSArray* section in _cache) {
		[photos addObjectsFromArray:section];
	}
	controller.host = self.rootViewController;
	[controller setMapPoint:photo];
	//set mapPoint
	//controller.photos = photos;
	//controller.currentPhotoIndex = [photos indexOfObject:photo];
	//self.rootViewController.viewContainer addSubview:controller.view fit:YES];
	[self.rootViewController presentViewController:controller animated:YES completion:nil];
}

#pragma mark - Private Methods
- (void)addPhotos:(NSArray*)photos
{
	for (MapPoint* photo in photos)
	{
		if (_latest == nil || photo.timestamp.timeIntervalSince1970 > _latest.timeIntervalSince1970) {
			_latest = photo.timestamp;
		}
		if (_oldest == nil || photo.timestamp.timeIntervalSince1970 < _oldest.timeIntervalSince1970) {
			_oldest = photo.timestamp;
		}

		//Midified classfied by userOD
		NSString* key = photo.posterId  ;//photo.timestamp.dayString;
		NSMutableDictionary* section = [_photos objectForKey:key];
		if (section == nil) {
			section = [NSMutableDictionary new];
			[_photos setObject:section forKey:key];
		}
		[section setObject:photo forKey:photo.identifier];
	}
	[self makeCache];
}

- (void)makeCache {
	[_cache removeAllObjects];
	NSArray* keys = [[_photos allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSString* key1, NSString* key2) {
		return [key2 compare:key1];
	}];
	for (NSString* key in keys) {
		NSMutableDictionary* section = [_photos objectForKey:key];
		[_cache addObject:[[section allValues] sortedArrayUsingComparator:^NSComparisonResult(MapPoint* photo1, MapPoint* photo2) {
			return [photo2.timestamp compare:photo1.timestamp];
		}]];
	}
}

#pragma mark - Code Blocks
- (PhotoHandler)indexPhotosAndUpdateView {
	return ^(NSError* error, NSArray* photos) {
		if (error != nil) {
			return;
		}
		[self addPhotos:photos];
		[self.photosView reloadData];
	};
}

@end
