
#import <Foundation/Foundation.h>

@interface IADisqusComment : NSObject

@property (nonatomic, copy) NSString *forumName;

@property (nonatomic, copy) NSString *authorName;
@property (nonatomic, copy) NSString *authorAvatar;
@property (nonatomic, copy) NSString *authorEmail;
@property (nonatomic, copy) NSString *authorURL;


@property (nonatomic, copy) NSString *rawMessage;
@property (nonatomic, copy) NSString *htmlMessage;

@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSNumber *likes;
@property (nonatomic, retain) NSNumber *dislikes;
@property (nonatomic, copy) NSString *ipAddress;

@property (nonatomic, retain) NSNumber *threadID;

@end
