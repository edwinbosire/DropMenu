//
//  EBMenuController.h
//  EBDropMenu
//
//  Created by edwin bosire on 30/05/2015.
//  Copyright (c) 2015 Edwin Bosire. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EBMenuController : UIView

- (instancetype)initWithMenuItems:(NSArray *)menuItems forViewController:(UIViewController *)viewController;

- (void)showMenu;

@end
