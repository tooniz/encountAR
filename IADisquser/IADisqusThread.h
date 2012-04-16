//
//  IADisqusThread.h
//  Disquser
//
//  Created by Sheng Xu on 12-03-17.
//  
//

#import <Foundation/Foundation.h>

@interface IADisqusThread : NSObject 
    

@property (nonatomic, copy) NSString *forumName;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSNumber *likes;
@property (nonatomic, retain) NSNumber *dislikes;
@property (nonatomic, copy) NSString *ipAddress;
@property (nonatomic, retain) NSNumber *authorID;
@property (nonatomic, copy) NSString *threadID;
@property (nonatomic, copy) NSString *title;
@end
