//
//  HistoryViewCell.h
//  Cells
//
//  Created by Dave Mark on 8/31/11.
//  Copyright (c) 2011 Dave Mark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryViewCell : UITableViewCell

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *number;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *numberLabel;

- (IBAction)prsAdd:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *addBtn;
@end
