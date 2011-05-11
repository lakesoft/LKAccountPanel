//
//  LKAccountPanel.m
//  LKAccountPanel
//
//  Created by Hiroshi Hashiguchi on 11/05/08.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LKAccountPanel.h"

#define LOCALIZED_STRING_TABLE  @"LKAccountPanel"

static LKAccountPanel* accountPanel_ = nil;


@interface LKAccountPanelBackgroundView : UIView {
}
@end

@implementation LKAccountPanelBackgroundView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                    cornerRadius:5.0];
    [path moveToPoint:CGPointMake(0, self.bounds.size.height/2.0)];
    [path addLineToPoint:CGPointMake(self.bounds.size.width-1.0,
                                     self.bounds.size.height/2.0)];
    [[UIColor whiteColor] set];
    [path fill];
    [[UIColor lightGrayColor] set];
    [path stroke];
}

@end


//------------------------------------------------------------------------------
@interface LKAccountPanel()
@property (nonatomic, retain) UIAlertView* alertView;
@property (nonatomic, retain) void(^completionBlock)(BOOL result, NSString* username, NSString* password);

@end

@implementation LKAccountPanel

@synthesize usernameTextField;
@synthesize passwordTextField;

@synthesize alertView = alertView_;
@synthesize completionBlock;


//------------------------------------------------------------------------------
#pragma mark -
#pragma mark Initialization and deallocation
//------------------------------------------------------------------------------
- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)_releaseObjects
{
    self.usernameTextField = nil;
    self.passwordTextField = nil;
    self.completionBlock = nil;
    self.alertView = nil;
}

- (void)dealloc {
    [self _releaseObjects];
    [super dealloc];
}

//------------------------------------------------------------------------------
#pragma mark -
#pragma mark UIAlertViewDelegate
//------------------------------------------------------------------------------
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString* username = self.usernameTextField.text;
    NSString* password = self.passwordTextField.text;
    if (buttonIndex == 1) {
        if ([username length] == 0) {
            username = nil;
        }
        if ([password length] == 0) {
            password = nil;
        }
    } else {
        username = nil;
        password = nil;
    }
    self.completionBlock(buttonIndex == 1, username, password);
    [self _releaseObjects];
}

//------------------------------------------------------------------------------
#pragma mark -
#pragma mark Private
//------------------------------------------------------------------------------
- (void)_showWithTitle:(NSString*)title completion:(void(^)(BOOL result, NSString* username, NSString* password))completion;
{
    self.completionBlock = completion;
    self.alertView =
        [[[UIAlertView alloc] initWithTitle:title
                                    message:@"\n\n\n"
                                   delegate:self 
                          cancelButtonTitle:NSLocalizedStringFromTable(@"Cancel", LOCALIZED_STRING_TABLE, nil)
                          otherButtonTitles:NSLocalizedStringFromTable(@"OK", LOCALIZED_STRING_TABLE, nil), nil] autorelease];

    LKAccountPanelBackgroundView* backgroundView =
        [[[LKAccountPanelBackgroundView alloc]
          initWithFrame:CGRectMake(15.0, 47.0, 255.0, 65)] autorelease];
    [self.alertView addSubview:backgroundView];
    
    self.usernameTextField = [[[UITextField alloc] initWithFrame:
                               CGRectMake(20.0, 52.0, 245.0, 30.0)] autorelease];
    self.usernameTextField.placeholder = NSLocalizedStringFromTable(@"Username", LOCALIZED_STRING_TABLE, nil);
    self.usernameTextField.keyboardType = UIKeyboardTypeEmailAddress;
    self.usernameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.usernameTextField.returnKeyType = UIReturnKeyNext;
    self.usernameTextField.delegate = self;
    [self.alertView addSubview:self.usernameTextField];

    self.passwordTextField = [[[UITextField alloc] initWithFrame:
                               CGRectMake(20.0, 87.0, 245.0, 30.0)] autorelease];
    self.passwordTextField.placeholder = NSLocalizedStringFromTable(@"Password", LOCALIZED_STRING_TABLE, nil);
    self.passwordTextField.keyboardType = UIKeyboardTypeASCIICapable;
    self.passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.returnKeyType = UIReturnKeyDone;
    self.passwordTextField.delegate = self;
    [self.alertView addSubview:self.passwordTextField];

    [self.alertView show];
    [self.usernameTextField becomeFirstResponder];
}

//------------------------------------------------------------------------------
#pragma mark -
#pragma mark UITextFieldDelegate
//------------------------------------------------------------------------------
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.usernameTextField) {
        [self.passwordTextField becomeFirstResponder];
    } else if (textField == self.passwordTextField) {
        [self.alertView dismissWithClickedButtonIndex:1 animated:YES];
        [self alertView:self.alertView clickedButtonAtIndex:1];
    }
    return YES;
}


//------------------------------------------------------------------------------
#pragma mark -
#pragma mark API
//------------------------------------------------------------------------------
+ (void)showWithTitle:(NSString*)title completion:(void(^)(BOOL result, NSString* username, NSString* password))completion
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        accountPanel_ = [[LKAccountPanel alloc] init];
    });
    
    [accountPanel_ _showWithTitle:title completion:completion];
}

@end
