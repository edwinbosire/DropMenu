//
//  EBMenuItem.h
//  EBDropMenu
//
//  Created by edwin bosire on 31/05/2015.
//  Copyright (c) 2015 Edwin Bosire. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^Completion)();

@interface EBMenuItem : NSObject

@property (nonatomic) NSString *title;
@property (nonatomic) UIColor *colourScheme;
@property (nonatomic, copy) Completion completionBlock; // We are using a completion block to allow to lazily load the viewcontrollers.

+ (instancetype)initWithTitle:(NSString *)title withColourScheme:(UIColor *)colour;

@end
