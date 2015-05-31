//
//  EBHeaderCollectionReusableView.h
//  EBDropMenu
//
//  Created by edwin bosire on 31/05/2015.
//  Copyright (c) 2015 Edwin Bosire. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HeaderViewProtocol <NSObject>

- (void)didPressSettings;

@end
@interface EBHeaderCollectionReusableView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (nonatomic) NSString * titleText;
@property (nonatomic) id<HeaderViewProtocol> delegate;

@end
