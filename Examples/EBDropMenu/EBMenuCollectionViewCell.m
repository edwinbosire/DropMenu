//
//  EBMenuCollectionViewCell.m
//  EBDropMenu
//
//  Created by edwin bosire on 31/05/2015.
//  Copyright (c) 2015 Edwin Bosire. All rights reserved.
//

#import "EBMenuCollectionViewCell.h"
#import "EBMenuItem.h"
#import "UIColor+FlatColors.h"

@interface EBMenuCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIView *decorator;

@end
@implementation EBMenuCollectionViewCell

- (void)awakeFromNib {
	
	self.backgroundColor = [UIColor blackColor];
}

- (void)setMenuItem:(EBMenuItem *)menuItem {
	
	_menuItem = menuItem;
	
	NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
	[paragraph setAlignment:NSTextAlignmentCenter];
	
	NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"Lato-Black" size:14.0f],
								 NSForegroundColorAttributeName : [UIColor whiteColor],
								 NSParagraphStyleAttributeName : paragraph,
								 NSKernAttributeName : @2};
	NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:menuItem.title.uppercaseString attributes:attributes];
	self.title.attributedText = attrString;
	
	[self.title sizeToFit];
	
	self.decorator.backgroundColor = menuItem.colourScheme;
}

- (void)setSelected:(BOOL)selected {
	
	[UIView animateWithDuration:0.3f
					 animations:^{
						 self.backgroundColor = (selected) ? [UIColor colorWithWhite:0.1f alpha:0.8f] : [UIColor blackColor];
					 }];
	[super setSelected:selected];
}
@end
