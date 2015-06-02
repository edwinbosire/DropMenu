# Drop Menu

A custom menu implementation with a slide in menu similar to Medium's menu.

Inspired by [RBMenu](https://github.com/RoshanNindrai/RBMenu) and [Medium](https://github.com/pixyzehn/MediumMenu).


To see how it works, have a look at the Examples folder.

This has not been designed to be dropped into a project as it is, a bit of re-working must be done. I will set it up as an independent component soon.


->![](http://i.imgur.com/ese3dUO.gif)<-

##Setup

Drag `EBMenucontroller & EBMenuItem` from the **Drop Menu** folder into your project.

Create your menu items.

```

	EBMenuItem *politics = [EBMenuItem initWithTitle:@"Politics" withColourScheme:[UIColor flatEmeraldColor]];
	EBMenuItem *culture = [EBMenuItem initWithTitle:@"Culture" withColourScheme:[UIColor flatAlizarinColor]];
	EBMenuItem *travel = [EBMenuItem initWithTitle:@"Travel" withColourScheme:[UIColor flatOrangeColor]];
	EBMenuItem *nature = [EBMenuItem initWithTitle:@"Nature" withColourScheme:[UIColor flatWisteriaColor]];	
	

```

For each menu item, there is a corresponding completionBlock that gets called when the menu is tapped. Also, we are using completion block to lazy load view controllers.

```

	PoliticsViewController *politicsInitialView = [storyBoard instantiateViewControllerWithIdentifier:@"Politics"];
	politicsInitialView.menuItem = politics;
	self.viewControllers = @[politicsInitialView];

	politics.completionBlock = ^{
		
		self.viewControllers = @[politicsInitialView];
	};
```

Note, that the implementation in the example happens inside a custom `UINavigationController`, this doesn't have to be case with everyone. You can easily setup the menu items in the delegate and instead of adding the viewcontrollers to self.viewcontrollers you'll do it in `self.navigationcontroller.viewcontrollers'

#FAQ
1. Does it support storyboards?   
**YES**

2. Can I have more than 4 menu items   

    **YES, but this isn't tested, you 
    might need to modify `menuHeight` constant in `EBMenuController.m` to make it all fit.
**  
3. Does it support iPad?  
**Yes, maybe, its not been tested, but there is no reason it shouldn't work** 


If you get to use it, please let me know on [Twitter](http://www.twitter.com/edwinbosire)

##AUTHOR

This component has been lovingly crafted by [Edwin B](http://www.twitter.com/edwinbosire)

##LICENSE

[Apache License](https://github.com/edwinbosire/DropMenu/blob/master/LICENSE)
