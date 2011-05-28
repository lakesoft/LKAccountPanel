//
//  LKAccountPanel.h
//  LKAccountPanel
//
//  Created by Hiroshi Hashiguchi on 11/05/08.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LKAccountPanel : NSObject <UIAlertViewDelegate, UITextFieldDelegate> {

}

// API
+ (void)showWithTitle:(NSString*)title completion:(void(^)(BOOL result, NSString* username, NSString* password))completion;
+ (void)showWithTitle:(NSString*)title username:(NSString*)username password:(NSString*)password completion:(void(^)(BOOL result, NSString* username, NSString* password))completion;
+ (BOOL)showWithTitle:(NSString*)title username:(NSString**)username password:(NSString**)password;
+ (void)setCheckingEmptyEnabled:(BOOL)enabled;

@end
