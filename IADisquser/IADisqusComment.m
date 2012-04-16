
#import "IADisqusComment.h"

@implementation IADisqusComment

@synthesize forumName, authorName, authorAvatar, authorEmail, authorURL, rawMessage, htmlMessage, date, likes, dislikes, ipAddress, threadID;

- (void)dealloc {
    [forumName release];
    [authorName release];
    [authorAvatar release];
    [authorEmail release];
    [authorURL release];
    [rawMessage release];
    [htmlMessage release];
    [likes release];
    [dislikes release];
    [ipAddress release];
    [date release];
    [threadID release];
    
    [super dealloc];
}

@end
