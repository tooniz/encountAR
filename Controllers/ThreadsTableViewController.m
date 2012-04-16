//
//  ThreadsTableViewController.m
//  Disquser
//
//  Created by Sheng Xu on 12-03-17.
//

#import "ThreadsTableViewController.h"
#import "IADisquser.h"
#import "UIImageView+AFNetworking.h"
#import "IACommentCell.h"
#import "TableCommentsViewController.h"
#import "AppDelegate.h"

#define CELL_CONTENT_WIDTH  320.0
#define CELL_CONTENT_MARGIN 4.0

@interface ThreadsTableViewController (PrivateMethods)
- (void)getThreadList;
@end
@implementation ThreadsTableViewController
@synthesize threads, categoryID;

- (void)dealloc {
    [threads release];
    [indicator release];
    [categoryID release];
    
    [super dealloc];
}

- (UIActivityIndicatorView *)indicator {
    if (!indicator) {
        indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [indicator setCenter:CGPointMake(self.tableView.center.x, self.tableView.center.y-64.0)];
        [indicator setHidesWhenStopped:YES];
        [self.view addSubview:indicator];
    }
    
    return indicator;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    // set view's interface
    [self.tableView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    UIBarButtonItem *refresh = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(getThreadList)] autorelease];
    [self.navigationItem setRightBarButtonItem:refresh];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc ] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    self.navigationItem.leftBarButtonItem = doneButton;
    // get array of comments
    [doneButton release];
}

- (void) done {
    [self dismissModalViewControllerAnimated:YES];
    app.isPaused = 0;
    
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self getThreadList];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.threads count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ThreadCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // get the threads, configure it to the cell
    cell.textLabel.text = [(IADisqusThread*)[self.threads objectAtIndex:indexPath.row] title];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    TableCommentsViewController *tableCommentsViewController = [[[TableCommentsViewController alloc] init] autorelease];
    tableCommentsViewController.title = @"Table View";
    tableCommentsViewController.threadID = [(IADisqusThread *)[self.threads objectAtIndex:indexPath.row] threadID];
    [self.navigationController pushViewController:tableCommentsViewController animated:YES]; 
}

- (void)getThreadList {
    // start activity indicator
    [[self indicator] startAnimating];
    //[self.tableView setAlpha:0.5];
    
    // fire the request
    [IADisquser getThreadsFromCategoryID:categoryID 
                                 success:^(NSArray *_threadList) {
                                    // get the array of comments, reverse it (oldest thread on top) 
                                    //self.threads = [[_threadList reverseObjectEnumerator] allObjects];
                                     self.threads = _threadList;
                                    // start activity indicator
                                    [[self indicator] stopAnimating];
                                    //[self.tableView setAlpha:1.0];
                                    
                                    // reload the table
                                    [self.tableView reloadData];
                                } fail:^(NSError *error) {
                                    // start activity indicator
                                    [[self indicator] stopAnimating];
                                    //[self.tableView setAlpha:1.0];
                                    
                                    // alert the error
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Occured" 
                                                                                    message:[error localizedDescription] 
                                                                                   delegate:nil 
                                                                          cancelButtonTitle:@"OK" 
                                                                          otherButtonTitles:nil];
                                    [alert show];
                                    [alert release];
                                }];
}


@end
