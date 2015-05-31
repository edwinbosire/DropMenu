//
//  EBMenuItem.m
//  EBDropMenu
//
//  Created by edwin bosire on 31/05/2015.
//  Copyright (c) 2015 Edwin Bosire. All rights reserved.
//

#import "EBMenuItem.h"

@implementation EBMenuItem

+ (instancetype)initWithTitle:(NSString *)title withColourScheme:(UIColor *)colour
{
	EBMenuItem *menu = [EBMenuItem new];
	if (menu) {
		
		menu.title = title;
		menu.colourScheme = colour;
	}
	return menu;
}
@end
