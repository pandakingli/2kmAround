#import "Headers.h"

typedef void (^AVArrayResultBlock)(NSArray *objects, NSError *error);
typedef void (^myBlock)(BOOL succeeded, NSError *error);

@class UserInfo;
@class AVIMClient;

@interface UserHandle : NSObject

@property(nonatomic,assign)BOOL sendWelcomMessage;//是否发送欢迎信息
@property(nonatomic,assign)NSInteger unreadAddRequestCount;//未读好友请求数目
@property(nonatomic,assign)NSInteger newFriendCount;//新好友数目

@property (nonatomic, strong) AVIMClient *myClient;

@property(nonatomic,strong)AVUser *myUser;//当前的用户

@property(nonatomic,assign)BOOL isUserLogin;//用户是否登录成功


- (void)findUsersByUserName:(NSString *)UserName withBlock:(AVArrayResultBlock)block;

+(instancetype)shareUser;



//用户注册-写到LeanCloud
-(void)registerToDBWithUserInfo:(UserInfo*)userinfo WithBlock:(myBlock) myblock;
//用户更新信息


//第一次注册成功后，获取完整的用户信息
-(UserInfo*)getUserInfoWithUserEmail:(NSString*)useremail;

//发出申请添加好友申请
- (void)tryCreateAddRequestWithToUser:(AVUser *)user callback:(AVBooleanResultBlock)callback;

//获取好友请求
- (void)findAddRequestsWithBlock:(AVArrayResultBlock)block;

//添加好友
- (void)addFriend:(AVUser *)user callback:(AVBooleanResultBlock)callback;

//获取自己的好友列表
- (void)findFriendsWithBlock:(AVArrayResultBlock)block;

//拒绝？
//status0-对方没有同意-未读；
//status1-对方已经同意
//status2-对方同意，这边也已经查看到
//自己发送出去的好友申请是否已经被同意-如果已经同意就立刻加对方为自己粉丝，并


-(void)checkMyAddRequestsAndAddNewWithBlock:(AVArrayResultBlock)block;
//更新头像
- (void)updateAvatarWithImage:(UIImage *)image callback:(AVBooleanResultBlock)callback;


//从leancloud获取头像
- (void)getAvatarImageOfUser:(AVUser *)user block:(void (^)(UIImage *image))block;


//发出删除好友
- (void)tryCreateDeleteFriendRequestWithToUser:(AVUser *)user callback:(AVBooleanResultBlock)callback;

//获取未读的新添加好友申请
- (void)findNewUnreadAddRequestsWithBlock:(AVArrayResultBlock)block;

//判断是不是我的好友
- (void)isMyFriend:(AVUser *)user block:(AVBooleanResultBlock)block;

//推送消息给对方
- (void)pushMessage:(NSString *)message userIds:(NSArray *)userIds block:(AVBooleanResultBlock)block;

//清除小红点
- (void)cleanBadge;

//更新用户名
- (void)updateUsername:(NSString *)username block:(AVBooleanResultBlock)block;
@end
