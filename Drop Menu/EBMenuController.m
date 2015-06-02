//
//  EBMenuController.m
//  EBDropMenu
//
//  Created by edwin bosire on 30/05/2015.
//  Copyright (c) 2015 Edwin Bosire. All rights reserved.
//

#import "EBMenuController.h"
#import "AppDelegate.h"
#import "EBMenuItem.h"
#import "EBMenuCollectionViewCell.h"
#import "EBHeaderCollectionReusableView.h"

static const CGFloat kMaxBlackMaskAlpha = 0.8f;
static const  CGFloat headerHeight = 64.0f;
static const CGFloat menuItemHeight = 150.0f;
static const CGFloat menuHeight = 368.0f;
static const CGFloat menuThresholdVelocity = 1000.0f;
static const CGFloat menuCloseVelocity = 1200.0f;
static const NSTimeInterval menuOpenAnimationDuration = 0.28f;
static const NSTimeInterval menuCloseAnimationDuration = 0.18f;
static  NSString *const menuItemCellReusableID = @"menuItemCellReusableID";
static  NSString *const menuCollectionViewHeader = @"menuCollectionViewHeader";


typedef NS_OPTIONS(NSInteger, MenuState) {
	Closed,
	Open,
	Showing
};

@interface EBMenuController () <UICollectionViewDataSource, UICollectionViewDelegate, HeaderViewProtocol>

@property (nonatomic) UICollectionView *menuCollectionView;
@property (nonatomic) UIViewController *contentViewController;
@property (nonatomic) UIView *animationMask;
@property (nonatomic) NSArray *menuItems;
@property (nonatomic) MenuState state;
@property (nonatomic) CGFloat menuDefaultHeight;

@end

@implementation EBMenuController


- (instancetype)initWithMenuItems:(NSArray *)menuItems forViewController:(UIViewController *)viewController
{
	self = [super init];
	if (self) {
		
		self.menuItems = menuItems;
		self.backgroundColor = [UIColor blackColor];
		self.contentViewController = viewController;
		[self addSubview:self.menuCollectionView];
		[self insertSubview:self.animationMask atIndex:0];

	}
	return self;
}
#pragma mark - Properties

- (CGFloat)menuDefaultHeight {
	
	if (!_menuCollectionView) {
		return menuHeight;
	}
	
	return self.menuCollectionView.contentSize.height;
}
- (UICollectionView *)menuCollectionView {
	
	if (!_menuCollectionView) {
		
		
		CGFloat screenWidth = CGRectGetWidth(self.frame);
		UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
		layout.itemSize = CGSizeMake(screenWidth/2 - 0.5, menuItemHeight);
		layout.headerReferenceSize = CGSizeMake(screenWidth, headerHeight);
		layout.minimumInteritemSpacing = 0.25;
		layout.minimumLineSpacing = 0.5;
		layout.sectionInset = UIEdgeInsetsMake(1, 0, 1, 0);
		
		_menuCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, screenWidth, self.menuDefaultHeight) collectionViewLayout:layout];
		_menuCollectionView.delegate = self;
		_menuCollectionView.dataSource = self;
		_menuCollectionView.backgroundColor = [UIColor colorWithWhite:0.3f alpha:0.5f];
		
		[_menuCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([EBMenuCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:menuItemCellReusableID];
		[_menuCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([EBHeaderCollectionReusableView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:menuCollectionViewHeader];
		
		/*Politics is selected by default, make sure it is reflected*/
		[_menuCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionTop];
		
	}
	
	return _menuCollectionView;
}

- (UIView *)animationMask {
	
	if (!_animationMask) {
		
		_animationMask = [[UIView alloc] initWithFrame:self.bounds];
		_animationMask.backgroundColor = [UIColor blackColor];
		_animationMask.alpha = 0.0;
		_animationMask.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	}
	
	return _animationMask;
}

- (void)setContentViewController:(UIViewController *)contentViewController {
	
	if (contentViewController == _contentViewController) {
		return;
	}
	
	_contentViewController = contentViewController;
	_contentViewController.view.backgroundColor = [UIColor lightGrayColor];
	
	UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
	[_contentViewController.view addGestureRecognizer:pan];
	
	UIViewController *menuView = [UIViewController new];
	menuView.view = self;
	
	AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
	appDelegate.window.rootViewController = menuView;
	[appDelegate.window addSubview:_contentViewController.view];
}

#pragma mark - Pan

- (void)didPan:(UIPanGestureRecognizer *)gesture {
	
	CGPoint viewCenter = gesture.view.center;
	CGPoint translation = [gesture translationInView:gesture.view.superview];
	CGSize screenSize = [UIScreen mainScreen].bounds.size;
	
	if (gesture.state == UIGestureRecognizerStateBegan || gesture.state == UIGestureRecognizerStateChanged) {
		
		if (viewCenter.y >= screenSize.height/2 && viewCenter.y <= screenSize.height/2 + self.menuDefaultHeight) {
			
			viewCenter.y = fabs(viewCenter.y + translation.y);
			
			if (viewCenter.y >= screenSize.height/2 && viewCenter.y <= screenSize.height/2 + self.menuDefaultHeight) {
				self.contentViewController.view.center = viewCenter;

				CGFloat transformPercentage = 1- fabs((CGRectGetMinY(self.contentViewController.view.frame) / self.menuDefaultHeight));
				[self transformAtPercentage:transformPercentage];
				[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
				 [self bringSubviewToFront:self.animationMask];

			}
		}
		[gesture setTranslation:CGPointZero inView:self.contentViewController.view];
		
	}else if (gesture.state == UIGestureRecognizerStateEnded){
		
		CGPoint velocity = [gesture velocityInView:gesture.view.superview];
		
		if (velocity.y > menuThresholdVelocity) {
			
			CGFloat menuOpenOffset = screenSize.height/2 + self.menuDefaultHeight;
			NSTimeInterval duration = (menuOpenOffset - self.contentViewController.view.center.y) / velocity.y;
			[self openMenuWithDuration:duration];
			return;
			
		}else if (velocity.y < -menuCloseVelocity){
			
			CGFloat menuOpenOffset = screenSize.height/2 + self.menuDefaultHeight;
			NSTimeInterval duration = (menuOpenOffset - self.contentViewController.view.center.y) / fabs(velocity.y);
			
			[self closeMenuWithDuration:duration];
			return;
		}
		
		if (viewCenter.y < self.contentViewController.view.frame.size.height) {
			
			[self closeMenu];
		}else {
			[self openMenu];
		}
	}
}

- (void)showMenu {
	
	if (self.state == Closed) {
		[self openMenu];
	}else {
		[self closeMenu];
	}
}

- (void)openMenu {
	
	[self openMenuWithDuration:menuOpenAnimationDuration];
}

- (void)openMenuWithDuration:(NSTimeInterval)duration {
	
	CGSize screenSize = [UIScreen mainScreen].bounds.size;
	
	[UIView animateWithDuration:duration
						  delay:0.0f
		 usingSpringWithDamping:0.56
		  initialSpringVelocity:20
						options:UIViewAnimationOptionCurveEaseOut
					 animations:^{
						 
						 [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
						 self.contentViewController.view.center = CGPointMake(self.contentViewController.view.center.x, screenSize.height/2 + self.menuDefaultHeight);
							
						 CGAffineTransform transf = CGAffineTransformIdentity;
						 self.menuCollectionView.transform = CGAffineTransformScale(transf, 1.0f, 1.0f);

						 self.animationMask.alpha = 0.0f;
						} completion:^(BOOL finished) {
							self.state = Open;
							[self sendSubviewToBack:self.animationMask];
						}];
}

- (void)closeMenu {
	
	[self closeMenuWithDuration:menuCloseAnimationDuration];
}

- (void)closeMenuWithDuration:(NSTimeInterval)duration {
	
	CGSize screenSize = [UIScreen mainScreen].bounds.size;
	
	[UIView animateWithDuration:duration
					 animations:^{
						 
						 [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
						 self.contentViewController.view.center = CGPointMake(self.contentViewController.view.center.x, screenSize.height/2);
						
						 CGAffineTransform transf = CGAffineTransformIdentity;
						 self.menuCollectionView.transform = CGAffineTransformScale(transf, 0.9f, 0.9f);

						 self.animationMask.alpha = kMaxBlackMaskAlpha;
					 } completion:^(BOOL finished) {
						 self.state = Closed;
						 [self bringSubviewToFront:self.animationMask];
					 }];
}

#pragma mark - Set the required transformation based on percentage
- (void) transformAtPercentage:(CGFloat)percentage {
	
	CGAffineTransform transf = CGAffineTransformIdentity;
	CGFloat newTransformValue =  fabs((percentage)/10 - 1);
	CGFloat newAlphaValue = percentage* kMaxBlackMaskAlpha;
	self.menuCollectionView.transform = CGAffineTransformScale(transf,newTransformValue,newTransformValue);
	self.animationMask.alpha = newAlphaValue;
}

#pragma mark - Menu Collection View Delegate/Datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)cv numberOfItemsInSection:(NSInteger)section {
	
	return self.menuItems.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
	
	if (kind == UICollectionElementKindSectionHeader) {
		
		EBHeaderCollectionReusableView *header = (EBHeaderCollectionReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:menuCollectionViewHeader forIndexPath:indexPath];
		header.titleText = @"Windmill";
		header.delegate = self;
		return header;
	}
	return nil;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
	
	EBMenuCollectionViewCell *cell = (EBMenuCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:menuItemCellReusableID forIndexPath:indexPath];
	EBMenuItem *item = [self.menuItems objectAtIndex:indexPath.row];
	[cell setMenuItem:item];
	return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
	
	EBMenuItem *item = [self.menuItems objectAtIndex:indexPath.row];
	item.completionBlock();
	[self performSelector:@selector(showMenu) withObject:nil afterDelay:0.4f];
}

#pragma mark - Header delegate

- (void)didPressSettings {
	
	NSIndexPath *selectedIndex = [[self.menuCollectionView indexPathsForSelectedItems] firstObject];
	[self.menuCollectionView deselectItemAtIndexPath:selectedIndex animated:YES];
	[self performSelector:@selector(showMenu) withObject:nil afterDelay:0.2f];
	
}

@end
