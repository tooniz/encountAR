#import <Foundation/Foundation.h>
#import "IADisqusComment.h"
#import "IADisqusThread.h"

typedef void (^DisqusFetchCommentsSuccess)(NSArray *);
// define a block for situation when we successfully retrieved threadIDs from a categoryID
typedef void (^DisqusFetchThreadSuccess)(NSArray *);
//
typedef void (^DisqusGetThreadIdSuccess)(NSNumber *);
typedef void (^DisqusPostCommentSuccess)(void);
typedef void (^DisqusFail)(NSError *);

@class IADisqusComment;

@interface IADisquser : NSObject
// we list out the threads from a specific forum
#pragma mark - View Threads
+ (void)getThreadsFromCategoryID:(NSString *)categoryID success:(DisqusFetchThreadSuccess)successBlock fail:(DisqusFail)failBlock;

#pragma mark - View comments
+ (void)getCommentsFromThreadID:(NSString *)threadID success:(DisqusFetchCommentsSuccess)successBlock fail:(DisqusFail)failBlock;
+ (void)getMostRecentCommentsFromThreadID:(NSString *)threadID success:(DisqusFetchCommentsSuccess)successBlock fail:(DisqusFail)failBlock;
+ (void)getCommentsFromThreadIdentifier:(NSString *)threadIdentifier success:(DisqusFetchCommentsSuccess)successBlock fail:(DisqusFail)failBlock;
+ (void)getCommentsFromThreadLink:(NSString *)link success:(DisqusFetchCommentsSuccess)successBlock fail:(DisqusFail)failBlock;

#pragma mark - Post comments
+ (void)getThreadIdWithIdentifier:(NSString *)threadIdentifier success:(DisqusGetThreadIdSuccess)successBlock fail:(DisqusFail)failBlock;
+ (void)getThreadIdWithLink:(NSString *)link success:(DisqusGetThreadIdSuccess)successBlock fail:(DisqusFail)failBlock;
+ (void)postComment:(IADisqusComment *)comment success:(DisqusPostCommentSuccess)successBlock fail:(DisqusFail)failBlock;

@end
