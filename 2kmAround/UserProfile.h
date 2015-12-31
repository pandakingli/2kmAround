

#import <Foundation/Foundation.h>
#import "Constrains.h"

@interface UserProfile : NSObject

@property (nonatomic, copy) NSString *objectId;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *avatarUrl;

@end

@protocol UserProfileProvider <NSObject>

- (void)fetchInfos:(NSArray*)userIds callback:(ArrayResultBlock)block;

@end