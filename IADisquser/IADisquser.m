#import "IADisquser.h"
#import "IADisqusConfig.h"
#import "AFHTTPClient.h"
#import "JSONKit.h"

@implementation IADisquser

#pragma mark - View Threads
+ (void)getThreadsFromCategoryID:(NSString *)categoryID success:(DisqusFetchThreadSuccess)successBlock fail:(DisqusFail)failBlock{
    NSLog(@"the categoryID is %@", categoryID);
    // make the parameters dictionary 
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                DISQUS_API_SECRET, @"api_secret",
                                DISQUS_FORUM_NAME, @"forum",
                                categoryID, @"category",
                                nil];

    // make a http client for disqus
    AFHTTPClient *disqusClient = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:DISQUS_BASE_URL]];
    
    // make and send a get request by using the categoryID as a filter
    [disqusClient getPath:@"threads/list.json" 
               parameters:parameters
                  success:^(id object) {
                      // fetch the json response to a dictionary
                    
                      NSDictionary *responseDictionary = [object objectFromJSONData];
                      
                      // check the code (success is 0)
                      NSNumber *code = [responseDictionary objectForKey:@"code"];
                      
                      if ([code integerValue] != 0) {   // there's an error
                          NSString *errorMessage = @"Error on fetching threads from disqus";
                          
                          NSError *error = [NSError errorWithDomain:@"com.encountar.disquser" code:25 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:errorMessage, NSLocalizedDescriptionKey, nil]];
                          failBlock(error);
                      } else {  // fetching threads in json succeeded, now on to parsing
                          // mutable array for handling and storing threads in the end
                          NSMutableArray *threads = [NSMutableArray array];
                          
                          // parse into array of comments
                          NSArray *threadsArray = [responseDictionary objectForKey:@"response"];
                          if ([threadsArray count] == 0) {
                              successBlock(nil);
                          } else {
                              
                              // setting date format
                              NSDateFormatter *df = [[NSDateFormatter alloc] init];
                              NSLocale *locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease];
                              [df setLocale:locale];
                              [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

                              // traverse the array, getting data for comments
                              for (NSDictionary *threadDictionary in threadsArray) {
                                  // for every thread, wrap them with IADisqusThread
                                  IADisqusThread* aDisqusThread = [[IADisqusThread alloc] init];
                                  
                                  //forumName, authorID, date, likes, dislikes, ipAddress,threadID;
                                  aDisqusThread.forumName= [threadDictionary objectForKey:@"forum"];
                                  aDisqusThread.authorID= [threadDictionary objectForKey:@"author"];
                                  aDisqusThread.date= [df dateFromString:[[threadDictionary objectForKey:@"createdAt"] stringByReplacingOccurrencesOfString:@"T" withString:@" "]];
                                  aDisqusThread.likes = [threadDictionary objectForKey:@"likes"];
                                  aDisqusThread.dislikes = [threadDictionary objectForKey:@"dislikes"];  
                                  aDisqusThread.ipAddress = [threadDictionary objectForKey:@"ipAddress"];
                                  aDisqusThread.threadID= [threadDictionary objectForKey:@"id"];
                                  aDisqusThread.title= [threadDictionary objectForKey:@"title"];
                                  //NSLog(@"%@",aDisqusThread.forumName);
                                  //NSLog(@"%@",aDisqusThread.threadID);
                                  //NSLog(@"%@",aDisqusThread.title);
                                  // add the comment to the mutable array
                                  [threads addObject:aDisqusThread];
                                  [aDisqusThread release];
                
                              }
                              // release date formatting
                              [df release];
                              
                              // pass it to the block
                              successBlock(threads);
                              
                          }
                      }
                  }
                  failure:^(NSHTTPURLResponse *response, NSError *error) {
                      // pass error to the block
                      failBlock(error);
                  }];
}


#pragma mark - View comments
+ (void)getCommentsWithParameters:(NSDictionary *)parameters success:(DisqusFetchCommentsSuccess)successBlock fail:(DisqusFail)failBlock {
    // make a http client for disqus
    AFHTTPClient *disqusClient = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:DISQUS_BASE_URL]];
    
    // make and send a get request
    [disqusClient getPath:@"threads/listPosts.json" 
               parameters:parameters
                  success:^(id object) {
                      // fetch the json response to a dictionary
                      NSDictionary *responseDictionary = [object objectFromJSONData];
                      
                      // check the code (success is 0)
                      NSNumber *code = [responseDictionary objectForKey:@"code"];
                      
                      if ([code integerValue] != 0) {   // there's an error
                          NSString *errorMessage = @"Error on fetching comments from disqus";
                          
                          NSError *error = [NSError errorWithDomain:@"com.encountar.disquser" code:25 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:errorMessage, NSLocalizedDescriptionKey, nil]];
                          failBlock(error);
                          
                      } else {  // fetching comments in json succeeded, now on to parsing
                          // mutable array for handling comments
                          NSMutableArray *comments = [NSMutableArray array];
                          
                          // parse into array of comments
                          NSArray *commentsArray = [responseDictionary objectForKey:@"response"];
                          if ([commentsArray count] == 0) {
                              successBlock(nil);
                          } else {
                              // setting date format
                              NSDateFormatter *df = [[NSDateFormatter alloc] init];
                              NSLocale *locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease];
                              [df setLocale:locale];
                              [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                              
                              // traverse the array, getting data for comments
                              for (NSDictionary *commentDictionary in commentsArray) {
                                  // for every comment, wrap them with IADisqusComment
                                  IADisqusComment *aDisqusComment = [[IADisqusComment alloc] init];
                                  
                                  aDisqusComment.authorName = [[commentDictionary objectForKey:@"author"] objectForKey:@"name"];
                                  aDisqusComment.authorAvatar = [[[commentDictionary objectForKey:@"author"] objectForKey:@"avatar"] objectForKey:@"cache"];
                                  aDisqusComment.authorEmail = [[commentDictionary objectForKey:@"author"] objectForKey:@"email"];
                                  aDisqusComment.authorURL = [[commentDictionary objectForKey:@"author"] objectForKey:@"url"];
                                  aDisqusComment.ipAddress = [commentDictionary objectForKey:@"ipAddress"];
                                  aDisqusComment.forumName = [commentDictionary objectForKey:@"forum"];
                                  aDisqusComment.likes = [commentDictionary objectForKey:@"likes"];
                                  aDisqusComment.dislikes = [commentDictionary objectForKey:@"dislikes"];
                                  aDisqusComment.rawMessage = [commentDictionary objectForKey:@"raw_message"];
                                  aDisqusComment.htmlMessage = [commentDictionary objectForKey:@"message"];
                                  aDisqusComment.date = [df dateFromString:[[commentDictionary objectForKey:@"createdAt"] stringByReplacingOccurrencesOfString:@"T" withString:@" "]];
                                  aDisqusComment.threadID = [commentDictionary objectForKey:@"thread"];
                                  //NSLog(@"the comment is %@", aDisqusComment.rawMessage);
                                  NSLog(@"the url is %@", aDisqusComment.authorURL);
                                  // add the comment to the mutable array
                                  [comments addObject:aDisqusComment];
                                  [aDisqusComment release];
                              }
                              
                              // release date formatting
                              [df release];
                              
                              // pass it to the block
                              successBlock(comments);
                          }
                      }
                  }
                  failure:^(NSHTTPURLResponse *response, NSError *error) {
                      // pass error to the block
                      failBlock(error);
                  }];
}

+ (void)getCommentsFromThreadID:(NSString *)threadID success:(DisqusFetchCommentsSuccess)successBlock fail:(DisqusFail)failBlock {
    // make the parameters dictionary 
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                DISQUS_API_SECRET, @"api_secret",
                                threadID, @"thread",
                                nil];
    
    // send the request
    [IADisquser getCommentsWithParameters:parameters success:successBlock fail:failBlock];
}

+ (void)getMostRecentCommentsFromThreadID:(NSString *)threadID success:(DisqusFetchCommentsSuccess)successBlock fail:(DisqusFail)failBlock {
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                DISQUS_API_SECRET, @"api_secret",
                                threadID, @"thread",@"1", @"limit",
                                nil];
    
    // send the request
    [IADisquser getCommentsWithParameters:parameters success:successBlock fail:failBlock];
}
+ (void)getCommentsFromThreadIdentifier:(NSString *)threadIdentifier success:(DisqusFetchCommentsSuccess)successBlock fail:(DisqusFail)failBlock {
    // make the parameters dictionary 
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                DISQUS_API_SECRET, @"api_secret",
                                DISQUS_FORUM_NAME, @"forum",
                                threadIdentifier, @"thread:ident",
                                nil];
    
    // send the request
    [IADisquser getCommentsWithParameters:parameters success:successBlock fail:failBlock];
}

+ (void)getCommentsFromThreadLink:(NSString *)link success:(DisqusFetchCommentsSuccess)successBlock fail:(DisqusFail)failBlock {
    // make the parameters dictionary 
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                DISQUS_API_SECRET, @"api_secret",
                                DISQUS_FORUM_NAME, @"forum",
                                link, @"thread:link",
                                nil];
    
    // send the request
    [IADisquser getCommentsWithParameters:parameters success:successBlock fail:failBlock];
    
}

#pragma mark - Post comments
+ (void)getThreadIdParameters:(NSDictionary *)parameters success:(DisqusGetThreadIdSuccess)successBlock fail:(DisqusFail)failBlock {
    // make a http client for disqus
    AFHTTPClient *disqusClient = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:DISQUS_BASE_URL]];
    
    // fire the request
    [disqusClient getPath:@"threads/details.json" 
               parameters:parameters 
                  success:^(id object) {
                      // fetch the json response to a dictionary
                      NSDictionary *responseDictionary = [object objectFromJSONData];
                      
                      // get the code
                      NSNumber *code = [responseDictionary objectForKey:@"code"];
                      
                      if ([code integerValue] != 0) {
                          // there's an error
                          NSString *errorMessage = @"Error on getting the thread ID from disqus";
                          
                          NSError *error = [NSError errorWithDomain:@"com.encoutar.disquser" code:26 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:errorMessage, NSLocalizedDescriptionKey, nil]];
                          failBlock(error);
                      } else {
                          // get the thread ID, pass it to the block
                          NSNumber *threadId = [[responseDictionary objectForKey:@"response"] objectForKey:@"id"];
                          successBlock(threadId);
                      }
                  }
                  failure:^(NSHTTPURLResponse *response, NSError *error) {
                      failBlock(error);
                  }];
}

+ (void)getThreadIdWithIdentifier:(NSString *)threadIdentifier success:(DisqusGetThreadIdSuccess)successBlock fail:(DisqusFail)failBlock {
    // make parameters
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                DISQUS_API_SECRET, @"api_secret",
                                DISQUS_FORUM_NAME, @"forum",
                                threadIdentifier, @"thread:ident",
                                nil];
    
    // call general method
    [IADisquser getThreadIdParameters:parameters success:successBlock fail:failBlock];
}

+ (void)getThreadIdWithLink:(NSString *)link success:(DisqusGetThreadIdSuccess)successBlock fail:(DisqusFail)failBlock {
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                DISQUS_API_SECRET, @"api_secret",
                                DISQUS_FORUM_NAME, @"forum",
                                link, @"thread:link",
                                nil];
    
    // call general method
    [IADisquser getThreadIdParameters:parameters success:successBlock fail:failBlock];
}

+ (void)postComment:(IADisqusComment *)comment success:(DisqusPostCommentSuccess)successBlock fail:(DisqusFail)failBlock {
    // make a disqus client 
    AFHTTPClient *disqusClient = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:DISQUS_BASE_URL]];
    [disqusClient setParameterEncoding:AFFormURLParameterEncoding];
    
    [disqusClient postPath:@"posts/create.json"
                parameters:[NSDictionary dictionaryWithObjectsAndKeys:
                            DISQUS_API_SECRET, @"api_secret",
                            comment.threadID, @"thread",
                            comment.authorName, @"author_name",
                            comment.authorEmail, @"author_email",
                            comment.authorURL, @"author_url",
                            comment.rawMessage, @"message",
                            nil] 
                   success:^(id object) {
                       // fetch the json response to a dictionary
                       NSDictionary *responseDictionary = [object objectFromJSONData];
                       
                       // check the code (success is 0)
                       NSNumber *code = [responseDictionary objectForKey:@"code"];
                       
                       if ([code integerValue] != 0) {
                           // there's an error
                           NSString *errorMessage = @"Error on posting comment to disqus";
                           
                           NSError *error = [NSError errorWithDomain:@"com.encountar.disquser" code:27 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:errorMessage, NSLocalizedDescriptionKey, nil]];
                           failBlock(error);
                       } else {
                           successBlock();
                       }
                   }
                   failure:^(NSHTTPURLResponse *response, NSError *error) {
                       NSLog(@"response : %@", [response allHeaderFields]);
                       failBlock(error);
                   }];
}

@end
