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
@property (nonatomic, retain) IBOutlet UITextField* usernameTextFiled;
@property (nonatomic, retain) IBOutlet UITextField* passwordTextFiled;
@property (nonatomic, retain) IBOutlet UISwitch* passwordSwitch;

- (IBAction)showAsyncInMain:(id)sender;
- (IBAction)showSyncInMain:(id)sender;
- (IBAction)showAsyncInOther:(id)sender;
- (IBAction)showSyncInOther:(id)sender;
- (IBAction)changePasswordSwitch:(id)sender;


@end
