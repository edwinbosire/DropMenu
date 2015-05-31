//
//  EBHeaderCollectionReusableView.m
//  EBDropMenu
//
//  Created by edwin bosire on 31/05/2015.
//  Copyright (c) 2015 Edwin Bosire. All rights reserved.
//

#import "EBHeaderCollectionReusableView.h"

@implementation EBHeaderCollectionReusableView

- (void)awakeFromNib {
	self.settingsButton.tintColor = [UIColor whiteColor];
}

- (void)setTitleText:(NSString *)titleText {
	
	_titleText = titleText;
	
	NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
	[paragraph setAlignment:NSTextAlignmentCenter];

	NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"Lato-Heavy" size:16.0f],
								 NSForegroundColorAttributeName : [UIColor whiteColor],
								 NSParagraphStyleAttributeName : paragraph,
								 NSKernAttributeName : @2};
	NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:_titleText.uppercaseString attributes:attributes];

	self.title.attributedText = attrString;
}

- (IBAction)showSettings:(id)sender {
	
	if ([self.delegate respondsToSelector:@selector(didPressSettings)]) {
		[self.delegate didPressSettings];
	}
}

@end
