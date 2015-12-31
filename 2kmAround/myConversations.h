
#import <Foundation/Foundation.h>
#import <AVOSCloudIM/AVOSCloudIM.h>
@class Message;
typedef void (^ArrayResultBlock)(NSArray *objects, NSError *error);
@protocol IMEventObserver <NSObject>

- (void)newMessageArrived:(Message*)message conversation:(AVIMConversation*)conversation;
- (void)messageDelivered:(Message*)message conversation:(AVIMConversation*)conversation;

@end
@protocol ConversationOperationDelegate <NSObject>

@optional
-(void)addMembers:(NSArray*)clients conversation:(AVIMConversation*)conversation;
-(void)kickoffMembers:(NSArray*)client conversation:(AVIMConversation*)conversation;
-(void)mute:(BOOL)on conversation:(AVIMConversation*)conversation;
-(void)changeName:(NSString*)newName conversation:(AVIMConversation*)conversation;
-(void)exitConversation:(AVIMConversation*)conversation;
-(void)switch2NewConversation:(AVIMConversation*)conversation;

@end

@interface myConversations : NSObject
@property(nonatomic,assign)id<IMEventObserver> delegate;
@property (nonatomic, strong) AVIMClient *myClient;
+(instancetype)sharedMyConversations;

// 获取某个对话的更多消息
- (void)queryMoreMessages:(AVIMConversation*)conversation from:(NSString*)msgId timestamp:(int64_t)ts limit:(int)limit callback:(ArrayResultBlock)callback;
- (void)newMessageSent:(AVIMMessage *)message conversation:(AVIMConversation *)conv;


//新消息到达
- (void)newMessageArrived:(AVIMMessage*)message conversation:(AVIMConversation*)conv;
@end
