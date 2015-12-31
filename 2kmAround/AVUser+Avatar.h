

#import <Foundation/Foundation.h>
#import "AVOSCloud/AVOSCloud.h"

@interface AVUser (Avatar)

- (NSString*)avatarUrl;
- (void)updateAvatarWithImage:(UIImage*)image callback:(AVBooleanResultBlock)block;

@end
