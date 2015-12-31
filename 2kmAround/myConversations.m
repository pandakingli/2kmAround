
#import "Headers.h"
#import "myConversations.h"

@interface myConversations()

@property(strong,nonatomic)NSMutableOrderedSet *conversations;
@property(nonatomic,strong)NSMutableDictionary *observerMapping;
@property(nonatomic,strong)NSMutableDictionary *conversationUnreadMsgMapping;

@end
@implementation myConversations
-(NSMutableOrderedSet *)conversations{
    if (_conversations==nil) {
        _conversations=[NSMutableOrderedSet orderedSet];
    }
    return _conversations;
}

-(NSMutableDictionary*)observerMapping{
    if (_observerMapping==nil) {
        _observerMapping=[NSMutableDictionary dictionary];
    }
    return _observerMapping;
}
-(NSMutableDictionary*)conversationUnreadMsgMapping{
    if (_conversationUnreadMsgMapping==nil) {
        _conversationUnreadMsgMapping=[NSMutableDictionary dictionary];
    }
    return _conversationUnreadMsgMapping;
}
+(instancetype)sharedMyConversations{
    static myConversations *myConver = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (nil == myConver) {
            
            myConver = [[myConversations alloc] init];
            
        }
    });
   
    return myConver;
}

//获取历史消息
- (void)queryMoreMessages:(AVIMConversation*)conversation from:(NSString*)msgId timestamp:(int64_t)ts limit:(int)limit callback:(ArrayResultBlock)callback {
    [self pullMessagesForConversation:conversation preceded:msgId timestamp:ts limit:limit callback:^(NSArray *objects, NSError *error) {
        
        //获取用户的头像和用户名
        [self fillWithUserInfo:objects invokeCallback:callback error:error];
    }];
}

//获取聊天双方的信息-头像 用户名
-(void)fillWithUserInfo:(NSArray*)messages invokeCallback:(ArrayResultBlock)block error:(NSError*)error {
    NSMutableArray *userClients = [[NSMutableArray alloc] init];
    NSMutableSet *userSet = [[NSMutableSet alloc] init];
    for (int i = 0; i < messages.count; i++) {
        Message *msg = messages[i];
        if (msg.clients) {
            for (NSString *tmp in msg.clients) {
                if (![userSet member:tmp]) {
                    [userSet addObject:tmp];
                    [userClients addObject:tmp];
                }
            }
        }
        if (msg.byClient && ![userSet member:msg.byClient]) {
            [userSet addObject:msg.byClient];
            [userClients addObject:msg.byClient];
        }
    }
    AVUserStore *userStore = [AVUserStore sharedInstance];
    [userStore fetchInfos:userClients callback:^(NSArray *objects, NSError *error) {
        if (block) {
            block(messages, error);
        }
    }];
}
- (void)newMessageSent:(AVIMMessage *)message conversation:(AVIMConversation *)conv {
    Message *newMessage = [[Message alloc] init];
    newMessage.imMessage = message;
    newMessage.eventType = CommonMessage;
    newMessage.convId =[conv conversationId];
    newMessage.clients = nil;
    newMessage.byClient = [message clientId];
    newMessage.sentTimestamp = message.sendTimestamp;
}
- (void)newMessageArrived:(AVIMMessage*)message conversation:(AVIMConversation*)conv {
    Message *newMessage = [[Message alloc] init];
    newMessage.imMessage = message;
    newMessage.eventType = CommonMessage;
    newMessage.convId =[conv conversationId];
    newMessage.clients = nil;
    newMessage.byClient = [message clientId];
    newMessage.sentTimestamp = message.sendTimestamp;
    [self fireNewMessage:newMessage conversation:conv];
}
- (void)fireNewMessage:(Message*)message conversation:(AVIMConversation*)conv{
    NSMutableArray *userClients = [[NSMutableArray alloc] initWithObjects:message.byClient, nil];
    if (message.clients) {
        [userClients addObjectsFromArray:message.clients];
    }
    [[AVUserStore sharedInstance] fetchInfos:userClients callback:^(NSArray *objects, NSError *error) {
        [self changeConversationToHead:conv];
        NSNumber *unreadCount = [_conversationUnreadMsgMapping objectForKey:conv.conversationId];
        if (unreadCount) {
            unreadCount = [NSNumber numberWithInt:(unreadCount.intValue + 1)];
        } else {
            unreadCount = [NSNumber numberWithInt:1];
        }
        [_conversationUnreadMsgMapping setObject:unreadCount forKey:conv.conversationId];
        
        NSMutableArray *observerChain = [_observerMapping objectForKey:@"*"];
        if (observerChain) {
            for (int i = 0; i < [observerChain count]; i++) {
                id<IMEventObserver> observer = [observerChain objectAtIndex:i];
                [observer newMessageArrived:message conversation:conv];
            }
        }
        observerChain = [_observerMapping objectForKey:[conv conversationId]];
        if (observerChain) {
            for (int i = 0; i < [observerChain count]; i++) {
                id<IMEventObserver> observer = [observerChain objectAtIndex:i];
                [observer newMessageArrived:message conversation:conv];
            }
        }
    }];
}


- (void)changeConversationToHead:(AVIMConversation*)conversation {
    if (!conversation) {
        return;
    }
    [_conversations removeObject:conversation];
    [_conversations insertObject:conversation atIndex:0];
}


- (void)pullMessagesForConversation:(AVIMConversation*)conversation preceded:(NSString*)lastMessageId timestamp:(int64_t)timestamp limit:(int)limit callback:(ArrayResultBlock)block {
    if (!lastMessageId || lastMessageId.length < 1) {
        [conversation queryMessagesFromServerWithLimit:limit callback:^(NSArray *objects, NSError *error) {
            NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:[objects count]];
            NSInteger objectCount = [objects count];
            for (int i = 0; i < objectCount; i++) {
                Message *msg = [[Message alloc] initWithAVIMMessage:objects[i]];
                [result addObject:msg];
            }
            if (block) {
                block(result, error);
            }
        }];
    } else {
        
        
        [conversation queryMessagesBeforeId:lastMessageId timestamp:timestamp limit:limit callback:^(NSArray *objects, NSError *error) {
            NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:[objects count]];
            NSInteger objectCount = [objects count];
            for (int i = 0; i < objectCount; i++) {
                Message *msg = [[Message alloc] initWithAVIMMessage:objects[i]];
                [result addObject:msg];
            }
            if (block) {
                block(result, error);
            }
        }];
    }
}

@end
