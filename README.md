Custom UIAlertView
====================

LKAccountPanel class can display custom UIAlertView to require username and password.

![](https://github.com/lakesoft/LKAccountPanel/raw/master/documents/LKAccountPanel-1.jpg)


Usage
-----

There are two methods.

(1) Asynchronous type

example1:

	[LKAccountPanel showWithTitle:@"Test"
		completion:^(BOOL result, NSString* username, NSString* password) {
			NSLog(@"result: %d\nusername: %@\npassword: %@",
				result, username, password);
	}];

'result' argument of the blocks is for detecting whether OK button is pushed. If 'result' is YES then OK button is pushed. This method does not block current execution.


example2:

    [LKAccountPanel showWithTitle:@"Test"
        username:@"default username"
        password:@"default password"
        completion:^(BOOL result, NSString* username, NSString* password) {
            NSLog(@"result: %d\nusername: %@\npassword: %@",
                result, username, password);
    }];

If there are default values for username and password, these values can be set as default values by passing username: and password:.


(2) Synchronous type

example:

	BOOL result = [LKAccountPanel showWithTitle:@"Test2"
									   username:&username
									   password:&password];
	NSLog(@"result2: %d\nusername: %@\npassword: %@",
		result, username, password);

This method blocks at the code. If username and password has not nil values, thease values are used as default values.



Customize
---------

You can change the placeholder label and the button label. Edit LKAccountPanel.strings file in each localized directory.

	"OK" = "OK";
	"Cancel" = "Cancel";
	"Username" = "Username";
	"Password" = "Password";


Installation
-----------

You should copy below files to your projects.

 LKAccountPanel.h
 LKAccountPanel.m
 en.lproj/LKAccountPanel.strings
 ja.lproj/LKAccountPanel.strings	*optional



License
-------
MIT

Copyright (c) 2011 Hiroshi Hashiguchi

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

