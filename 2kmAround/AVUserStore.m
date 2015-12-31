

#import "AVUserStore.h"
#import "AVOSCloud/AVOSCloud.h"
#import "Constrains.h"
#import "AVUser+Avatar.h"

@interface AVUserStore () {
    NSMutableDictionary *_users;
}

@end

@implementation AVUserStore

+(instancetype)sharedInstance {
    static AVUserStore *store = nil;
    if (!store) {
        store = [[AVUserStore alloc] init];
    }
    return store;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _users = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)fetchInfos:(NSArray*)userIds callback:(ArrayResultBlock)block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (!userIds || userIds.count < 1) {
            if (block) {
                block(nil, nil);
            }
            return;
        }
        NSLog(@"fetchInfos");
        NSInteger userCount = [userIds count];
        NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:userCount];
        for (int i = 0; i < userCount; i++) {
            NSString *userId = [userIds objectAtIndex:i];
            UserProfile *profile = [_users objectForKey:userId];
            if (!profile) {
                AVUser* targetUser = [AVUser objectWithoutDataWithClassName:kAVUserClassName objectId:userId];
                NSLog(@"targetUser=%@",targetUser);
               [targetUser fetch];
                AVFile *avatar = [targetUser objectForKey:@"avatar"];
                //AVFile *avfile=targetUser.avatarUrl;
                
                profile = [[UserProfile alloc] init];
                profile.nickname = targetUser.username;
                profile.objectId = targetUser.objectId;
                profile.avatarUrl = avatar.url;
                [_users setObject:profile forKey:userId];
            }
            [result addObject:profile];
        };
        if (block) {
            block(result, nil);
        }
    });
}

- (UserProfile*)getUserProfile:(NSString*)userId {
    UserProfile *profile = [_users objectForKey:userId];
    NSLog(@"getUserProfile");
    return profile;
}

@end
