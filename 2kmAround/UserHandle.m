
#import "UserHandle.h"
#import "Headers.h"


static UserHandle * myUser = nil;
@implementation UserHandle


+(instancetype)shareUser{
    
    static dispatch_once_t onceToken;
    
    
    
    dispatch_once(&onceToken, ^{
        
        
        
        if (myUser==nil) {
            myUser = [[UserHandle alloc]init];
            myUser.isUserLogin = NO;
            
        }
    });
    return myUser;
}

-(void)registerToDBWithUserInfo:(UserInfo*)userinfo WithBlock:(myBlock) myblock {
    
    /*
    AVObject *post = [AVObject objectWithClassName:@"usr_info"];
    post[@"usr_name"] = userinfo.usr_name;
    post[@"usr_email"] = userinfo.usr_email;
    post[@"usr_pwd"] = userinfo.usr_pwd;
    post[@"usr_gender"] = userinfo.usr_gender;
    post[@"user_age"] = @(userinfo.usr_age);
    post[@"usr_icon"] = userinfo.usr_icon;
    post[@"usr_phonenum"]  = userinfo.usr_phonenum;
    
    [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        myblock(succeeded,error);
    }];
    
    */
    
}

-(UserInfo*)getUserInfoWithUserEmail:(NSString*)useremail{
    
    /*
    UserInfo *u1 = [[UserInfo alloc]init];
    AVQuery *query =[AVQuery queryWithClassName:@"user_info"];
    [query whereKey:@"usr_email" equalTo:useremail];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
    }];
    
    return u1;
     */
    return nil;
}

//查找好友
- (void)findUsersByUserName:(NSString *)UserName withBlock:(AVArrayResultBlock)block {
    AVQuery *q = [AVUser query];
    //[q setCachePolicy:kAVCachePolicyNetworkElseCache];
    //[q whereKey:@"username" containsString:UserName];//包含某个字段
    [q whereKey:@"username" equalTo:UserName];//等于某个字段
    AVUser *curUser = [AVUser currentUser];
    [q whereKey:@"objectId" notEqualTo:curUser.objectId];
    //[q orderByDescending:@"updatedAt"];
    [q findObjectsInBackgroundWithBlock:block];
}
//检查是否已经申请过好友--正在等待对方确认
- (void)haveWaitAddRequestWithToUser:(AVUser *)toUser callback:(AVBooleanResultBlock)callback {
    
    
    
    AVUser *user = [AVUser currentUser];
    //AVQuery *q = [CDAddRequest query];
    AVQuery *q = [AVQuery queryWithClassName:@"myAddRequest"];
    [q whereKey:kAddRequestFromUser equalTo:user];
    [q whereKey:kAddRequestToUser equalTo:toUser];
    [q whereKey:kAddRequestStatus equalTo:@(0)];
    //0等待
    //1
    [q countObjectsInBackgroundWithBlock: ^(NSInteger number, NSError *error) {
        if (error) {
            if (error.code == kAVErrorObjectNotFound) {
                callback(NO, nil);
            }
            else {
                callback(NO, error);
            }
        }
        else {
            if (number > 0) {
                callback(YES, error);
            }
            else {
                callback(NO, error);
            }
        }
    }];
     
    
}

//发出申请添加好友申请
- (void)tryCreateAddRequestWithToUser:(AVUser *)user callback:(AVBooleanResultBlock)callback {
    
    //先确认是否已经发送过请求
    
    
    [self haveWaitAddRequestWithToUser:user callback: ^(BOOL succeeded, NSError *error) {
        if (error) {
           
            callback(NO, error);
        }
        else {
            
            if (succeeded) {
                
                NSLog(@"已经请求过了");
                callback(YES, [NSError errorWithDomain:@"Add Request" code:0 userInfo:@{ NSLocalizedDescriptionKey:@"已经请求过了" }]);
            }
            else {
                
                NSLog(@"没有请求过");
                AVUser *curUser = [AVUser currentUser];
                
                
                AVObject *post = [AVObject objectWithClassName:@"myAddRequest"];
                post[@"fromUser"] = curUser;
                post[@"toUser"] = user;
                
                post[@"isRead"] = @(0);//0未读
                post[@"status"] = @(0);//0还在等待添加好友
                [post saveInBackgroundWithBlock:callback];
                
            }
        }
    }];
    
}
//发出删除好友
- (void)tryCreateDeleteFriendRequestWithToUser:(AVUser *)user callback:(AVBooleanResultBlock)callback {
    
    
    [self findOKAddRequestsWithBlock:^(NSArray *objects, NSError *error) {
        
        
        AVUser *curUser=[AVUser currentUser];
        if (objects.count>0) {
            
            
            for (int i=0; i<objects.count; i++) {
                
                AVUser *fromUser=[objects[i] valueForKey:@"fromUser"];
                
                AVUser *toUser=[objects[i] valueForKey:@"toUser"];
                
                
                NSString *isRead=[[objects[i] valueForKey:@"isRead"] stringValue];
                NSString *status=[[objects[i] valueForKey:@"status"] stringValue];
                
                //
                if (([toUser.objectId isEqualToString:curUser.objectId]||[fromUser.objectId isEqualToString:curUser.objectId])&&[status isEqualToString:@"2"])
                {
                    
                    if ([curUser.objectId isEqualToString:fromUser.objectId]) {
                        [curUser unfollow:toUser.objectId andCallback:^(BOOL succeeded, NSError *error) {
                            
                            NSString *s_objectId=[objects[i] valueForKey:@"objectId"];
                            
                            //// 知道 objectId，创建 AVObject
                            AVObject *post=[AVObject objectWithoutDataWithClassName:@"myAddRequest" objectId:s_objectId];
                            
                            post[@"status"] = @(3);//
                            
                            [post saveInBackground];
                            

                            
                            
                            callback(succeeded,error);
                        
                        }];
                        
                    }else{
                        
                        [curUser unfollow:fromUser.objectId andCallback:^(BOOL succeeded, NSError *error) {
                            
                            NSString *s_objectId=[objects[i] valueForKey:@"objectId"];
                       
                            //// 知道 objectId，创建 AVObject
                            AVObject *post=[AVObject objectWithoutDataWithClassName:@"myAddRequest" objectId:s_objectId];
                            
                            post[@"status"] = @(3);//
                            
                         callback(succeeded,error);
                            
                        }];
                        
                    }
                    
                    
                    
                }
                
                
                
            }//for (int i=0
            
        }//if (objects.count>0)
    
    }];//findOKAddRequestsWithBlock
   
    
}

//获取未读的新添加好友申请
- (void)findNewUnreadAddRequestsWithBlock:(AVArrayResultBlock)block {
    
    AVUser *curUser = [AVUser currentUser];
    AVQuery *q = [AVQuery queryWithClassName:@"myAddRequest"];
    //AVQuery *q = [CDAddRequest query];
    [q includeKey:@"fromUser"];
    [q whereKey:@"toUser" equalTo:curUser];
    [q whereKey:@"isRead" equalTo:@(0)];
    [q orderByDescending:@"createdAt"];
    [q findObjectsInBackgroundWithBlock:block];
}
//获取添加好友的请求
- (void)findAddRequestsWithBlock:(AVArrayResultBlock)block {
   
    
     
     AVUser *curUser = [AVUser currentUser];
     AVQuery *q = [AVQuery queryWithClassName:@"myAddRequest"];
     //AVQuery *q = [CDAddRequest query];
     [q includeKey:@"fromUser"];
     [q whereKey:@"toUser" equalTo:curUser];
     [q orderByDescending:@"createdAt"];
     [q findObjectsInBackgroundWithBlock:block];
    
}
//添加好友
- (void)addFriend:(AVUser *)user callback:(AVBooleanResultBlock)callback {
    AVUser *curUser = [AVUser currentUser];
   // [user follow:curUser.objectId andCallback:nil];
   
    [curUser follow:user.objectId andCallback:callback];
}
//获取自己的好友列表---应该是自己的粉丝列表
- (void)findFriendsWithBlock:(AVArrayResultBlock)block {
    AVUser *user = [AVUser currentUser];
    AVQuery *q = [user followeeQuery];
    q.cachePolicy = kAVCachePolicyNetworkElseCache;
    [q findObjectsInBackgroundWithBlock: ^(NSArray *objects, NSError *error) {
        
        if (error == nil) {
            //保存在本地
          //  [[CDCacheManager manager] registerUsers:objects];
//            if(objects.count>0){
//            for (AVUser *user in objects) {
//                [self.userCache setObject:user forKey:user.objectId];
//            }
//            }
        }
        
        block(objects, error);
    }];
}


//获取到未读的好友申请
-(void)checkMyAddRequestsWithBlock:(AVArrayResultBlock)block {
    
}
//拒绝？
//status0-对方没有同意-未读；
//status1-对方已经同意
//status2-对方同意，这边也已经查看到
//status3--被对方删除好友

//自己发送出去的好友申请是否已经被同意-如果已经同意就立刻加对方为自己粉丝，并

-(void)checkMyAddRequestsAndAddNewWithBlock:(AVArrayResultBlock)block {
    
    
    [self findOKAddRequestsWithBlock:^(NSArray *objects, NSError *error) {
       
        self.unreadAddRequestCount=0;
       self.newFriend=0;
        
        AVUser *curUser=[AVUser currentUser];
        if (objects.count>0) {
            
            
            for (int i=0; i<objects.count; i++) {
               
                AVUser *fromUser=[objects[i] valueForKey:@"fromUser"];
                
                AVUser *toUser=[objects[i] valueForKey:@"toUser"];
                
                NSString *isRead=[[objects[i] valueForKey:@"isRead"] stringValue];
                 NSString *status=[[objects[i] valueForKey:@"status"] stringValue];
                
                
                
                //别人删除我
                if ([status  isEqualToString:@"3"]&&([toUser.objectId isEqualToString:curUser.objectId]||[fromUser.objectId isEqualToString:curUser.objectId])) {
                    //self.unreadAddRequest++;
                    
                    NSString *who=toUser.objectId;
                    if ([curUser.objectId isEqualToString:toUser.objectId]) {
                        who=fromUser.objectId;
                    }
                    
                    
                    
                    [curUser unfollow:who andCallback:^(BOOL succeeded, NSError *error) {
                        
                        if (succeeded) {
                            NSLog(@"取消对删除我的人的关注");
                            }
                        else{
                            NSLog(@"取消对删除我的人的关注出错error=%@",error);
                        }
                    }];
                    
                    
                    
                }
                
                //别人发送给我的好友请求--未同意
                if ([isRead  isEqualToString:@"0"]&&[toUser.objectId isEqualToString:curUser.objectId]&&[status isEqualToString:@"0"]) {
                    self.unreadAddRequestCount++;
                }
                
                
                //我发送给别人的好友请求-并且别人已读-已经添加好友---新的好友
                if ([status isEqualToString:@"1"]&&[isRead isEqualToString:@"1"]&&[fromUser.objectId isEqualToString:curUser.objectId]) {
                    self.newFriend++;
                    NSString *s_objectId=[objects[i] valueForKey:@"objectId"];
                    
                    //更新对象
                    //// 知道 objectId，创建 AVObject
                    AVObject *post=[AVObject objectWithoutDataWithClassName:@"myAddRequest" objectId:s_objectId];
                    
                    post[@"status"] = @(2);//-添加好友已经成功，
                    
                    [post saveInBackground];
                    
                    AVUser *user=[objects[i] valueForKey:@"toUser"];
                    // AVUser *curUser = [AVUser currentUser];
                    // [user follow:curUser.objectId andCallback:nil];
                    
                    // [curUser follow:user.objectId andCallback:callback];
                    [curUser follow:user.objectId andCallback:nil];
                }
                
                
                
            }
            
            
            
            
        }
        
        block(objects,error);
    }];
    
    
    
    
    
    
    
}


//获取到好友请求
- (void)findOKAddRequestsWithBlock:(AVArrayResultBlock)block {
    
    //
    
    
    AVUser *curUser = [AVUser currentUser];
    AVQuery *q = [AVQuery queryWithClassName:@"myAddRequest"];
    
    
    [q includeKey:@"toUser"];
    [q includeKey:@"fromUser"];
    [q orderByDescending:@"createdAt"];
    [q findObjectsInBackgroundWithBlock:block];
    
}

//更新头像
- (void)updateAvatarWithImage:(UIImage *)image callback:(AVBooleanResultBlock)callback {
    NSData *data = UIImagePNGRepresentation(image);
    AVFile *file = [AVFile fileWithData:data];
    [file saveInBackgroundWithBlock: ^(BOOL succeeded, NSError *error) {
        if (error) {
            callback(succeeded, error);
        }
        else {
            AVUser *user = [AVUser currentUser];
            [user setObject:file forKey:@"avatar"];
            [user saveInBackgroundWithBlock:callback];
        }
    }];
}

//从leancloud获取头像
- (void)getAvatarImageOfUser:(AVUser *)user block:(void (^)(UIImage *image))block {
    AVFile *avatar = [user objectForKey:@"avatar"];
    if (avatar) {
        [avatar getDataInBackgroundWithBlock: ^(NSData *data, NSError *error) {
            if (error == nil) {
                block([UIImage imageWithData:data]);
            }
            else {
                block([self defaultAvatarOfUser:user]);
            }
        }];
    }
    else {
        block([self defaultAvatarOfUser:user]);
    }
}

//默认的头像，以名字的开头字母作为头像
- (UIImage *)defaultAvatarOfUser:(AVUser *)user {
    return [UIImage imageWithHashString:user.objectId displayString:[[user.username substringWithRange:NSMakeRange(0, 1)] capitalizedString]];
   // return nil;
}

//判断是不是我的好友
- (void)isMyFriend:(AVUser *)user block:(AVBooleanResultBlock)block {
    AVUser *currentUser = [AVUser currentUser];
    AVQuery *q = [currentUser followeeQuery];
    [q whereKey:@"followee" equalTo:user];
    [q findObjectsInBackgroundWithBlock: ^(NSArray *objects, NSError *error) {
        if (error) {
            block(NO, error);
        }
        else {
            if (objects.count > 0) {
                block(YES, nil);
            }
            else {
                block(NO, error);
            }
        }
    }];
}
//推送消息给对方
- (void)pushMessage:(NSString *)message userIds:(NSArray *)userIds block:(AVBooleanResultBlock)block {
    
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          message, @"alert",
                          @"Increment", @"badge",
                          @"6307.wav", @"sound",
                          @"chat", @"type",//聊天chat,加好友是request
                          nil];
    
    [AVPush setProductionMode:NO];
    AVPush *push = [[AVPush alloc] init];
    [push setChannels:userIds];
    //[push setMessage:message];
    [push setData:data];
    NSLog(@"push=%@",push);
    [push sendPushInBackgroundWithBlock:block];
}
//清除小红点
- (void)cleanBadge {
    UIApplication *application = [UIApplication sharedApplication];
    NSInteger num = application.applicationIconBadgeNumber;
    if (num != 0) {
        AVInstallation *currentInstallation = [AVInstallation currentInstallation];
        [currentInstallation setBadge:0];
        [currentInstallation saveInBackgroundWithBlock: ^(BOOL succeeded, NSError *error) {
            NSLog(@"%@", error ? error : @"succeed");
        }];
        application.applicationIconBadgeNumber = 0;
    }
    [application cancelAllLocalNotifications];
}
//更新用户名
- (void)updateUsername:(NSString *)username block:(AVBooleanResultBlock)block{
    AVUser *user = [AVUser currentUser];
    user.username = username;
    [user saveInBackgroundWithBlock:block];
}
@end
