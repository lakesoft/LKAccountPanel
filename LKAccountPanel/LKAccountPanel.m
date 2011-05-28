//
//  LKAccountPanel.m
//  LKAccountPanel
//
//  Created by Hiroshi Hashiguchi on 11/05/08.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LKAccountPanel.h"

#define LOCALIZED_STRING_TABLE  @"LKAccountPanel"

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
static LKAccountPanel* accountPanel_ = nil;
static BOOL checkingEmptyEnabled_ = YES;

@interface LKAccountPanel()
@property (nonatomic, assign) BOOL showing;
@property (nonatomic, assign) BOOL finished;

@property (nonatomic, retain) UIAlertView* alertView;
@property (nonatomic, copy) void(^completionBlock)(BOOL result, NSString* username, NSString* password);
@property (nonatomic, retain) UITextField* usernameTextField;
@property (nonatomic, retain) UITextField* passwordTextField;

// result holder
@property (nonatomic, copy) NSString* username;
@property (nonatomic, copy) NSString* password;
@property (nonatomic, assign) BOOL ok;
@end

@implementation LKAccountPanel

@synthesize showing = showing_;
@synthesize finished = finished_;

@synthesize alertView = alertView_;
@synthesize completionBlock;
@synthesize usernameTextField;
@synthesize passwordTextField;

@synthesize username = username_;
@synthesize password = password_;
@synthesize ok = ok_;

//------------------------------------------------------------------------------
#pragma mark -
#pragma mark Initialization and deallocation
//------------------------------------------------------------------------------
- (void)_releaseObjects
{
    self.usernameTextField = nil;
    self.passwordTextField = nil;
    self.completionBlock = nil;
    self.alertView = nil;
}

- (void)dealloc {
    [self _releaseObjects];
    self.username = nil;
    self.password = nil;
    [super dealloc];
}

//------------------------------------------------------------------------------
#pragma mark -
#pragma mark UIAlertViewDelegate
//------------------------------------------------------------------------------
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    self.username = self.usernameTextField.text;
    self.password = self.passwordTextField.text;

    if (buttonIndex == 1) {
        if ([self.username length] == 0) {
            self.username = nil;
        }
        if ([self.password length] == 0) {
            self.password = nil;
        }
    } else {
        self.username = nil;
        self.password = nil;
    }
    
    self.ok = (buttonIndex == 1);
    
    if (self.completionBlock) {
        self.completionBlock(self.ok, self.username, self.password);
    }

    [self _releaseObjects];
    self.finished = YES;

    @synchronized (self) {
        self.showing = NO;
    }
}

//------------------------------------------------------------------------------
#pragma mark -
#pragma mark Private
//------------------------------------------------------------------------------
- (void)_setOkButtonEnabled:(BOOL)enabled
{
    if (!checkingEmptyEnabled_) {
        return;
    }

    UIControl* okButton = nil;
    for (UIView* view in self.alertView.subviews) {
        if (view.tag == 2) {
            okButton = (UIControl*)view;
            break;
        }
    }
    if (okButton) {
        okButton.enabled = enabled;
    }
}

- (void)_editingChanged:(id)sender
{
    BOOL okButtonEnabled = NO;
    if ([self.usernameTextField.text length] > 0 &&
        [self.passwordTextField.text length] > 0) {
        okButtonEnabled = YES;
    }
    [self _setOkButtonEnabled:okButtonEnabled];
}

- (void)_showWithTitle:(NSString*)title username:(NSString*)username password:(NSString*)password completion:(void(^)(BOOL result, NSString* username, NSString* password))completion;
{
    @synchronized (self) {
        if (self.showing) {
            return; // prevent to show the alert at twice
        } else {
            self.showing = YES;
        }
    }

    self.username = nil;
    self.password = nil;
    self.completionBlock = completion;

    self.alertView =
        [[[UIAlertView alloc] initWithTitle:title
                                    message:@"\n\n\n"
                                   delegate:self 
                          cancelButtonTitle:NSLocalizedStringFromTable(@"Cancel", LOCALIZED_STRING_TABLE, nil)
                          otherButtonTitles:NSLocalizedStringFromTable(@"OK", LOCALIZED_STRING_TABLE, nil), nil] autorelease];

    // NSLog(@"%@", NSStringFromCGRect(self.alertView.frame));
    // *NOTE* UIAlertView's frame is {{0,0},{0,0}} at this timing.  
    
    LKAccountPanelBackgroundView* backgroundView =
        [[[LKAccountPanelBackgroundView alloc]
          initWithFrame:CGRectMake(15.0, 47.0, 255.0, 65)] autorelease];
    [self.alertView addSubview:backgroundView];
    
    self.usernameTextField = [[[UITextField alloc] initWithFrame:
                               CGRectMake(20.0, 52.0, 245.0, 22.0)] autorelease];
    self.usernameTextField.placeholder = NSLocalizedStringFromTable(@"Username", LOCALIZED_STRING_TABLE, nil);
    self.usernameTextField.keyboardType = UIKeyboardTypeEmailAddress;
    self.usernameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.usernameTextField.returnKeyType = UIReturnKeyNext;
    self.usernameTextField.delegate = self;
    self.usernameTextField.clearButtonMode = UITextFieldViewModeAlways;
    [self.usernameTextField addTarget:self
                               action:@selector(_editingChanged:)
                     forControlEvents:UIControlEventEditingChanged];
    [self.alertView addSubview:self.usernameTextField];

    self.passwordTextField = [[[UITextField alloc] initWithFrame:
                               CGRectMake(20.0, 87.0, 245.0, 22.0)] autorelease];
    self.passwordTextField.placeholder = NSLocalizedStringFromTable(@"Password", LOCALIZED_STRING_TABLE, nil);
    self.passwordTextField.keyboardType = UIKeyboardTypeASCIICapable;
    self.passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.returnKeyType = UIReturnKeyDone;
    self.passwordTextField.delegate = self;
    self.passwordTextField.clearButtonMode = UITextFieldViewModeAlways;
    [self.passwordTextField addTarget:self
                               action:@selector(_editingChanged:)
                     forControlEvents:UIControlEventEditingChanged];
    [self.alertView addSubview:self.passwordTextField];
    
    if (username) {
        self.usernameTextField.text = username;
    }
    if (password) {
        self.passwordTextField.text = password;
    }
    [self _setOkButtonEnabled:(username && password)];
    
    
    [self.alertView show];
    [self.usernameTextField performSelector:@selector(becomeFirstResponder)
                                 withObject:nil
                                 afterDelay:0.4];
}

- (void)_blockUntilDone
{
    self.finished = NO;
    while (!self.finished) {
        [[NSRunLoop currentRunLoop]
         runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
    }
}

+ (void)_initializeSingleton
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        accountPanel_ = [[LKAccountPanel alloc] init];
    });   
}

+ (BOOL)_isRunningInMainThread
{
    dispatch_queue_t currentQueue = dispatch_get_current_queue();
    return (currentQueue == dispatch_get_main_queue());
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
+ (void)showWithTitle:(NSString*)title username:(NSString*)username password:(NSString*)password completion:(void(^)(BOOL result, NSString* username, NSString* password))completion
{
    [self _initializeSingleton];

    if ([self _isRunningInMainThread]) {
        [accountPanel_ _showWithTitle:title username:username password:password completion:completion];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [accountPanel_ _showWithTitle:title username:username password:password completion:completion];
        });
    }
}

+ (void)showWithTitle:(NSString*)title completion:(void(^)(BOOL result, NSString* username, NSString* password))completion
{
    [self showWithTitle:title username:nil password:nil completion:completion];
}

+ (BOOL)showWithTitle:(NSString*)title username:(NSString**)username password:(NSString**)password
{
    [self _initializeSingleton];
    
    if ([self _isRunningInMainThread]) {
        [accountPanel_ _showWithTitle:title username:*username password:*password completion:nil];
        [accountPanel_ _blockUntilDone];
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [accountPanel_ _showWithTitle:title username:*username password:*password completion:nil];
            [accountPanel_ _blockUntilDone];
        });        
    }
    *username = accountPanel_.username;
    *password = accountPanel_.password;    
    return accountPanel_.ok;
}

+ (void)setCheckingEmptyEnabled:(BOOL)enabled
{
    @synchronized (self) {
        checkingEmptyEnabled_ = enabled;
    }
}


@end
