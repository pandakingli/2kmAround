

#import <Foundation/Foundation.h>

#import "AVOSCloudIM/AVOSCloudIM.h"

typedef int IMMessageType;
enum : IMMessageType {
    CommonMessage = 0,
    EventInvited = 1 << 0,
    EventMemberAdd = 1 << 1,
    EventMemberRemove = 1 << 2,
    EventKicked = 1 << 3,
};

@interface Message : NSObject <NSCopying, NSCoding>

@property (nonatomic) IMMessageType eventType;
@property (nonatomic, copy) NSString *convId;
@property (nonatomic) int64_t sentTimestamp;
@property (nonatomic, strong) AVIMMessage *imMessage;
@property (nonatomic, copy) NSString *byClient;
@property (nonatomic, copy) NSArray *clients;

- (id)initWithAVIMMessage:(AVIMMessage*)message;

+ (NSString*)getNotificationContent:(Message*)message;

@end
