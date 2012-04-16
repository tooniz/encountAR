//
//  HistoryViewCell.m
//  Cells
//
//  Created by Dave Mark on 8/31/11.
//  Copyright (c) 2011 Dave Mark. All rights reserved.
//

#import "HistoryViewCell.h"

@implementation HistoryViewCell
@synthesize addBtn;

@synthesize name;
@synthesize number;

@synthesize nameLabel;
@synthesize numberLabel;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setName:(NSString *)n {
    if (![n isEqualToString:name]) {
        name = [n copy];
        nameLabel.text = name;
    }
}

- (void)setNumber:(NSString *)n {
    if (![n isEqualToString:number]) {
        number = [n copy];
        numberLabel.text = number;
    }
}

- (IBAction)prsAdd:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" 
                                                    message:@"Add-Contact feature is coming out soon!"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    if (editing == YES) {
        addBtn.hidden = YES;
    }
    else {
        addBtn.hidden = NO;
    }
}
@end
