//
//  HistoryViewController.m
//  trackfriend
//
//  Created by Ming Zhou on 12-02-14.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HistoryViewController.h"
#import "AppDelegate.h"
#import "HistoryViewCell.h"

@implementation HistoryViewController
@synthesize comments;
@synthesize tableView;

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
    comments = app.comments;
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    comments = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)tableView:(UITableView *)aTableView
 numberOfRowsInSection:(NSInteger)section {
    return [self.comments count];
}

-(UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellId";
    UINib *nib = [UINib nibWithNibName:@"HistoryViewCell" bundle:nil];
    [aTableView registerNib:nib forCellReuseIdentifier:cellId];
    
    HistoryViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:
                           cellId];
    if (cell == nil) {
        cell = [[HistoryViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    // Storing information into the cell
    cell.nameLabel.text = [[self.comments objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.numberLabel.text = [[self.comments objectAtIndex:indexPath.row] objectForKey:@"comment"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60; // Same number we used in Interface Builder
}

- (void)tableView:(UITableView *)aTableView  commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSUInteger reverserow = [comments count] - indexPath.row - 1;
        [comments removeObjectAtIndex:reverserow];
        [tableView reloadData];
        
    }
}

- (BOOL)tableView:(UITableView *)aTableView   canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - Edit Mode
- (IBAction) Edit:(id)sender{
    if (self.editing) {
        [self setEditing:NO animated:NO];
        [tableView setEditing:NO animated:NO];
        [tableView reloadData];
        [self.navigationItem.rightBarButtonItem setTitle:@"Edit"];
        [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStylePlain];
    }
    else {
        [self setEditing:YES animated:YES];
        [tableView setEditing:YES animated:YES];
        [tableView reloadData];        
        [self.navigationItem.rightBarButtonItem setTitle:@"Done"];
        [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStyleDone];
    }
}


- (IBAction)prsBack:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
@end
