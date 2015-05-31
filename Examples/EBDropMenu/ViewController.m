//
//  ViewController.m
//  EBDropMenu
//
//  Created by edwin bosire on 30/05/2015.
//  Copyright (c) 2015 Edwin Bosire. All rights reserved.
//

#import "ViewController.h"
#import "EBNavitionController.h"
#import "EBMenuItem.h"
#import "UIColor+FlatColors.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *iconImage = [UIImage imageNamed:@"burgerButton"];
    UIBarButtonItem *icon = [[UIBarButtonItem alloc] initWithImage:iconImage
                                                             style:UIBarButtonItemStylePlain
                                                            target:self.navigationController
                                                            action:@selector(showMenu)];
	
	icon.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = icon;
	self.navigationItem.titleView = [UIView new];

	self.view.backgroundColor = self.menuItem.colourScheme;
	
	NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
	[paragraph setAlignment:NSTextAlignmentCenter];
	
	NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"Lato-Light" size:26.0f],
								 NSForegroundColorAttributeName : [UIColor whiteColor],
								 NSParagraphStyleAttributeName : paragraph,
								 NSKernAttributeName : @2};
	NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:self.menuItem.title.capitalizedString attributes:attributes];

	UILabel *titleLabel = [[UILabel alloc] init];
	titleLabel.frame = CGRectMake(0.0f, 75.0f, CGRectGetWidth(self.view.frame), 35.0f);
	titleLabel.attributedText = attrString;
	
	[self.view addSubview:titleLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
