//
//  IADisqusThread.m
//  Disquser
//
//  Created by Sheng Xu on 12-03-17.
//  Copyright (c) 2012 Beetlebox. All rights reserved.
//

#import "IADisqusThread.h"

@implementation IADisqusThread
@synthesize forumName, authorID, date, likes, dislikes, ipAddress,threadID, title;

- (void)dealloc {
    [forumName release];
    [likes release];
    [dislikes release];
    [ipAddress release];
    [date release];
    [threadID release];
    [authorID release];
    [title release];
    
    [super dealloc];
}
@end
