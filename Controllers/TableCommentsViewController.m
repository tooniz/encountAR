//
// TableCommentsViewController.m
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


#import "TableCommentsViewController.h"
#import "IADisquser.h"
#import "UIImageView+AFNetworking.h"
#import "IACommentCell.h"

#define CELL_CONTENT_WIDTH  320.0
#define CELL_CONTENT_MARGIN 4.0

@interface TableCommentsViewController (PrivateMethods)
- (void)getComments;
@end

@implementation TableCommentsViewController

@synthesize comments, threadID;

- (void)dealloc {
    [comments release];
    [indicator release];
    [threadID release];
    
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set view's interface
    [self.tableView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    UIBarButtonItem *refresh = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(getComments)] autorelease];
    [self.navigationItem setRightBarButtonItem:refresh];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    // get array of comments
    [self getComments];
}
     
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *comment = [(IADisqusComment *)[self.comments objectAtIndex:indexPath.row] rawMessage];
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000);
    CGSize size = [comment sizeWithFont:[UIFont fontWithName:@"Helvetica" size:12] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    return MAX(size.height + 80.0, 96.0);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.comments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    IACommentCell *cell = (IACommentCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[IACommentCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    
    // get the comment, configure it to the cell
    IADisqusComment *aComment = [self.comments objectAtIndex:indexPath.row];
    cell.nameLabel.text = aComment.authorName;
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"dd/MM/yy HH:mm:ss"];
    cell.dateLabel.text = [dateFormatter stringFromDate:aComment.date];
    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000);
    CGSize size = [aComment.rawMessage sizeWithFont:[UIFont fontWithName:@"Helvetica" size:12.0] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    cell.commentLabel.text = aComment.rawMessage;
    cell.commentLabel.frame = CGRectMake(4.0, 65.0, 
                                         CELL_CONTENT_WIDTH - (2 * CELL_CONTENT_MARGIN), 
                                         MAX(size.height, 10.0) + (2 * CELL_CONTENT_MARGIN));
    
    [cell.imageView setImageWithURL:[NSURL URLWithString:aComment.authorAvatar] 
                   placeholderImage:[UIImage imageNamed:@"noavatar.png"]];
    
    return cell;
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Class Methods 

- (void)getComments {
    // start activity indicator
    [[self indicator] startAnimating];
    [self.tableView setAlpha:0.5];
    
    // fire the request
    [IADisquser getCommentsFromThreadID:threadID
                                  success:^(NSArray *_comments) {
                                            // get the array of comments, reverse it (oldest comment on top) 
                                            self.comments = [[_comments reverseObjectEnumerator] allObjects];
                                            
                                            // start activity indicator
                                            [[self indicator] stopAnimating];
                                            [self.tableView setAlpha:1.0];
                                            
                                            // reload the table
                                            [self.tableView reloadData];
                                        } fail:^(NSError *error) {
                                            // start activity indicator
                                            [[self indicator] stopAnimating];
                                            [self.tableView setAlpha:1.0];
                                            
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
