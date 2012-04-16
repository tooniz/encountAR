//
//  CommentViewController.m
//  ImageTargets
//
//  Created by Sheng Xu on 12-03-06.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CommentViewController.h"
#import "AppDelegate.h"

@implementation CommentViewController
@synthesize titleTextField;
@synthesize commentTextField, tap, comment, terminate;

- (UIGestureRecognizer *) tap {
    if (!tap) {
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    }
    return tap;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.view addGestureRecognizer:self.tap];
}

-(void)dismissKeyboard {
    [commentTextField resignFirstResponder];
    [self.view removeGestureRecognizer:self.tap];
}

- (void)viewDidUnload
{
    [self setTitleTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.commentTextField = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (IBAction)commentDidEnd:(id)sender {
    [commentTextField resignFirstResponder];
}

-(IBAction)done {
    
    
    //NSLog(@"the length of the current entry is %i", [[[NSUserDefaults standardUserDefaults] objectForKey:@"current entry"]count]);
    // all the space must be filled in order to proceed
    if (self.commentTextField.text.length==0) {
        // alert user that they must fill everything
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" 
                                                        message:@"Please enter some comments"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" 
                                                        message:@"Comment posted"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        app.tempComment = self.commentTextField.text;
        if (self.titleTextField.text.length == 0)
            app.tempTitle = @"encountAR";
        else
            app.tempTitle = self.titleTextField.text;

        /*
        NSMutableArray *currentEntry = [[[NSUserDefaults standardUserDefaults] objectForKey:@"current entry"] mutableCopy];
        NSMutableDictionary *commentEntry = [NSMutableDictionary dictionaryWithObject:titleTextField.text forKey:@"title"];
        [commentEntry setObject:commentTextField.text forKey:@"comment"];
         */
        /*
        // add the new person to that array
        [currentEntry addObject:commentEntry];
        // add the the array back to the NSUserDefault
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"current entry"];
        [[NSUserDefaults standardUserDefaults] setObject:currentEntry forKey:@"current entry"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey: @"saved"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [currentEntry release];

        [app.comments addObject:commentEntry];
         */
        [self dismissModalViewControllerAnimated:YES];
        
    }
    
}

- (IBAction)cancel {
    [self dismissModalViewControllerAnimated:YES];
}

- (void) dealloc {
    [tap release];
    [titleTextField release];
    [super dealloc];
}

@end
