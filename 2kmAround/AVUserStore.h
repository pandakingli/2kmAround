

#import <Foundation/Foundation.h>
#import "UserProfile.h"
@interface AVUserStore : NSObject <UserProfileProvider>

+(instancetype)sharedInstance;

- (void)fetchInfos:(NSArray*)userIds callback:(ArrayResultBlock)block;
- (UserProfile*)getUserProfile:(NSString*)userId;

@end
