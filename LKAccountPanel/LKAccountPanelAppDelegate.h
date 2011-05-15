//
//  LKAccountPanelAppDelegate.h
//  LKAccountPanel
//
//  Created by Hiroshi Hashiguchi on 11/05/08.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LKAccountPanelAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

- (IBAction)showAlert:(id)sender;
- (IBAction)showAlert2:(id)sender;


@end
