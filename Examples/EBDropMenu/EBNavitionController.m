//
//  EBNavitionController.m
//  EBDropMenu
//
//  Created by edwin bosire on 30/05/2015.
//  Copyright (c) 2015 Edwin Bosire. All rights reserved.
//

#import "EBNavitionController.h"
#import "EBMenuController.h"
#import "EBMenuItem.h"
#import "UIColor+FlatColors.h"
#import "PoliticsViewController.h"
#import "NatureViewController.h"
#import "TravelViewController.h"
#import "CultureViewController.h"
#import "ViewController.h"

@interface EBNavitionController ()

@property (nonatomic) EBMenuController *menu;
@end

@implementation EBNavitionController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
	self.navigationBar.shadowImage = [UIImage new];
	self.navigationBar.translucent = YES;
	
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
	
	EBMenuItem *politics = [EBMenuItem initWithTitle:@"Politics" withColourScheme:[UIColor flatEmeraldColor]];
	EBMenuItem *culture = [EBMenuItem initWithTitle:@"Culture" withColourScheme:[UIColor flatAlizarinColor]];
	EBMenuItem *travel = [EBMenuItem initWithTitle:@"Travel" withColourScheme:[UIColor flatOrangeColor]];
	EBMenuItem *nature = [EBMenuItem initWithTitle:@"Nature" withColourScheme:[UIColor flatWisteriaColor]];
	
	UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	
	PoliticsViewController *politicsInitialView = [storyBoard instantiateViewControllerWithIdentifier:@"Politics"];
	politicsInitialView.menuItem = politics;
	self.viewControllers = @[politicsInitialView];

	politics.completionBlock = ^{
		
		self.viewControllers = @[politicsInitialView];
	};
	
	__weak typeof(EBMenuItem) *weakCulture = culture;
	culture.completionBlock = ^{
		
		CultureViewController *culture = [storyBoard instantiateViewControllerWithIdentifier:@"Culture"];
		culture.menuItem = weakCulture;
		self.viewControllers = @[culture];
	};
	
	__weak typeof(EBMenuItem) *weakTravel = travel;
	travel.completionBlock = ^{
		
		TravelViewController *travel = [storyBoard instantiateViewControllerWithIdentifier:@"Travel"];
		travel.menuItem = weakTravel;
		self.viewControllers = @[travel];
	};
	
	__weak typeof(EBMenuItem) *weakNature = nature;
	nature.completionBlock = ^{
		
		NatureViewController	*nature = [storyBoard instantiateViewControllerWithIdentifier:@"Nature"];
		nature.menuItem = weakNature;
		self.viewControllers = @[nature];
	};
	
	NSArray *menuItems = @[politics, culture, travel, nature];
    self.menu = [[EBMenuController alloc] initWithMenuItems:menuItems forViewController:self];
}

- (void)showMenu {
    
    [self.menu showMenu];
}



@end
