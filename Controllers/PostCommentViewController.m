//
// PostCommentViewController.m
// Disquser
// 
// Copyright (c) 2011 Ikhsan Assaat. All Rights Reserved 
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//


#import "PostCommentViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "IADisquser.h"

@interface PostCommentViewController (PrivateMethods)
- (void)alertMessage:(NSString *)message;
- (void)postTheComment:(IADisqusComment *)comment;
- (void)startLoading;
- (void)stopLoading;
@end

@implementation PostCommentViewController

@synthesize threadIdentifier;

- (void)dealloc {
    [threadIdentifier release];
    [usernameField release];
    [emailField release];
    [commentField release];
    [indicator release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // make a border for text view
    [commentField.layer setBorderWidth:3.0];
    [commentField.layer setBorderColor:[UIColor grayColor].CGColor];
    [commentField.layer setCornerRadius:8.0];
    
    // make a bar button item for post and dismiss
    UIBarButtonItem *cancelButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismiss)] autorelease];
    UIBarButtonItem *postButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(post)] autorelease];
    [self.navigationItem setLeftBarButtonItem:cancelButton];
    [self.navigationItem setRightBarButtonItem:postButton];
}

- (void)viewDidUnload {
    [usernameField release];
    usernameField = nil;
    [emailField release];
    emailField = nil;
    [commentField release];
    commentField = nil;
    [indicator release];
    indicator = nil;
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // load user's default data
    [usernameField setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"username"]];
    [emailField setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"email"]];
    
    // show up the keyboard
    if ([usernameField.text isEqualToString:@""]) {
        [usernameField becomeFirstResponder];
    } else if ([emailField.text isEqualToString:@""]) {
        [emailField becomeFirstResponder];
    } else {
        [commentField becomeFirstResponder];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Class Methods

- (void)startLoading {
    // set view to loading
    [indicator startAnimating];
    [self.view setAlpha:.5];
    [self.view setUserInteractionEnabled:NO];
}

- (void)stopLoading {
    // stop loading
    [indicator stopAnimating];
    [self.view setAlpha:1.0];
    [self.view setUserInteractionEnabled:YES];
}

- (void)alertMessage:(NSString *)message {
    // helper for alerting message
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Can't post" 
                                                    message:message 
                                                   delegate:nil 
                                          cancelButtonTitle:@"Oh, okay" 
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)post {
    // user input basic validation
    if ([usernameField.text isEqualToString:@""]) {
        [self alertMessage:@"Empty username"];
        return;
    } else if ([emailField.text isEqualToString:@""]) {
        [self alertMessage:@"Empty email"];
        return;
    } else if ([commentField.text isEqualToString:@""]) {
        [self alertMessage:@"Empty comment"];
        return;
    }
    
    [self startLoading];
    
    // get the thread id
    [IADisquser getThreadIdWithIdentifier:threadIdentifier 
                                  success:^(NSNumber *threadID) {
                                      // make the comment
                                      IADisqusComment *aComment = [[[IADisqusComment alloc] init] autorelease];
                                      aComment.authorName = usernameField.text;
                                      aComment.authorEmail = emailField.text;
                                      aComment.rawMessage = commentField.text;
                                      aComment.threadID = threadID;
                                      
                                      // lets send it!
                                      [self postTheComment:aComment];
                                  } fail:^(NSError *error) {
                                      [self stopLoading];
                                      
                                      NSLog(@"error : %@", [error localizedDescription]);
                                      [self alertMessage:@"Error on getting thread id"];
                                  }];
}

- (void)postTheComment:(IADisqusComment *)comment {
    // post the comment!
    [IADisquser postComment:comment 
                    success:^ {
                        // i don't know why, but it seems that we have to wait a while before the API loads the new comments
                        
                        // [self stopLoading];
                        // [self dismiss];
                        
                        [self performSelector:@selector(stopLoading) withObject:nil afterDelay:3.0];
                        [self performSelector:@selector(dismiss) withObject:nil afterDelay:3.1];
                    } fail:^ (NSError *error) {
                        [self stopLoading];
                        
                        NSLog(@"error : %@", [error localizedDescription]);
                        [self alertMessage:@"Error on posting comment"];
                    }];
}

- (void)dismiss {
    // save the username & email
    [[NSUserDefaults standardUserDefaults] setValue:usernameField.text forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] setValue:emailField.text forKey:@"email"];
    
    // dismiss me
    [self dismissModalViewControllerAnimated:YES];
}

@end
