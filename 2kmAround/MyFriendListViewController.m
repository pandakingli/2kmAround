

#import "MyFriendListViewController.h"
#import "Headers.h"


@interface MyFriendListViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *listArray;
@property(nonatomic,strong) AVUser *toWho;

@end

@implementation MyFriendListViewController
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark 小菊花
-(void)showProgress {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
-(void)hideProgress {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(NSMutableArray*)listArray{
        if (_listArray==nil) {
            _listArray=[NSMutableArray arrayWithCapacity:10];
        }
    
    return _listArray;
}
#pragma mark viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.tableview=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableview registerClass:[FriendTableViewCell class] forCellReuseIdentifier:@"fcell"];
    
    [self.tableview registerClass:[ChatTableViewCell class] forCellReuseIdentifier:@"ccell"];
    [self.view addSubview:self.tableview];
    
    
    
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addFriend:)];
    /*
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"addnew_black"] style:UIBarButtonItemStylePlain target:self action:@selector(addFriend:)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
    //set NavigationBar 背景颜色&title 颜色
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:16/255.0 green:135/255.0 blue:217/255.0 alpha:1.0]];
    
    */
    
    
    
   
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   // [self showProgress];
    __weak typeof(self) ws = self;
     [self getFriendList];
    [[UserHandle shareUser] checkMyAddRequestsAndAddNewWithBlock:^(NSArray *objects, NSError *error) {
        
        
        
        
       // [ws hideProgress];
        [ws.tableview reloadData];
        
        
        
    }];

}
#pragma mark 添加好友按钮
-(void)addFriend:(UIBarButtonItem*)sender{
    NSLog(@"点击添加好友按钮。");
    
    if (![UserHandle shareUser].isUserLogin) {
        //[self.tableview deselectRowAtIndexPath:indexPath animated:NO];
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        [self presentViewController:loginVC animated:YES completion:nil];
        
    }else{
        SearchFriendViewController *searchVC = [[SearchFriendViewController alloc]init];
        [self.navigationController pushViewController:searchVC animated:YES];}
    
}
#pragma mark 获取好友列表
-(void)getFriendList{
    AVQuery *query = [AVUser query];
    [query addAscendingOrder:@"username"];
    [query whereKey:@"objectId" notEqualTo:[AVUser currentUser].objectId];
    
   // NSLog(@"id=%@",[AVUser currentUser].objectId);
    
    query.limit = 100;
    __weak typeof(self) ws = self;
    
    [self showProgress];
    [[UserHandle shareUser] findFriendsWithBlock:^(NSArray *objects, NSError *error) {
        if (error == nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [ws.listArray removeAllObjects];
                [ws.listArray addObjectsFromArray:objects];
                [ws.tableview reloadData];
                NSLog(@"获取好友objects=%@",objects);
                [ws hideProgress];
            });
            
        } else {
            [ws hideProgress];
            NSLog(@"获取好友error=%@",error);
        }
    }];
    
    
    



}



#pragma mark tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
                return self.listArray.count;
            break;
        default:
            return 0;
            break;
    }
    

    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
        {
            
            
            
            
            ChatTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"ccell" forIndexPath:indexPath];
            
            
            static NSInteger kBadgeViewTag = 103;
            JSBadgeView *badgeView = (JSBadgeView *)[cell viewWithTag:kBadgeViewTag];
            if (badgeView) {
                [badgeView removeFromSuperview];
            }
            cell.nameLabel.text=@"新的朋友";
            cell.myIMV.image=[UIImage imageNamed:@"newmyfriend.png"];
            
            
                
                if ([UserHandle shareUser].unreadAddRequestCount > 0) {
                    
                    badgeView = [[JSBadgeView alloc] initWithParentView:cell.myIMV alignment:JSBadgeViewAlignmentTopRight];
                    badgeView.tag = kBadgeViewTag;
                    badgeView.badgeText = [NSString stringWithFormat:@"%ld", [UserHandle shareUser].unreadAddRequestCount];
                    
                    NSLog(@"unreadAddRequest=%ld",[UserHandle shareUser].unreadAddRequestCount);
                    
                }//if
                
            

            
            
            
            
            
            
            
            
            
            return cell;
        }
            break;
        case 1:
        {
            AVUser *u=self.listArray[indexPath.row];
            
            FriendTableViewCell *fcell=[tableView dequeueReusableCellWithIdentifier:@"fcell" forIndexPath:indexPath];
            fcell.nameLabel.text=u.username;
            
            [[UserHandle shareUser]getAvatarImageOfUser:u block:^(UIImage *image) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    fcell.myIMV.image=image;
                });
                
            }];
            
            return fcell;
        }
            break;
        
        default:
            return nil;
            break;
    }
    
   
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section==0) {
        //去查看新的好友申请
        
        NewAddRequestFriendsListViewController *newVC=[[NewAddRequestFriendsListViewController alloc]init];
        
        newVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:newVC animated:YES];
        
        
    }
    
    //点击聊天
    if (indexPath.section==1) {
        
   
    //向谁聊天
    AVUser *chatToUser = self.listArray[indexPath.row];
    self.toWho=chatToUser;
    //自己
    AVUser *currentUser = [AVUser currentUser];
    //聊天的数组
    NSArray *clientIds = [[NSArray alloc] initWithObjects:currentUser.objectId, chatToUser.objectId, nil];
    //AVIMClient
    AVIMClient *myClient = [[myConversations sharedMyConversations] myClient];
    NSLog(@"myClient=%@",myClient);
    AVIMConversationQuery *query = [myClient conversationQuery];
    query.limit = 10;
    query.skip = 0;
    [query whereKey:kAVIMKeyMember containsAllObjectsInArray:clientIds];
    [query whereKey:AVIMAttr(@"type") equalTo:[NSNumber numberWithInt:0]];
    [query findConversationsWithCallback:^(NSArray *objects, NSError *error) {
    
    NSLog(@"objects=%@",objects);
    
    if (error) {
        NSLog(@"error=%@",error);
        
    }
    else if (!objects || [objects count] < 1) {
        
        //没有历史对话，就创建新的对话
        [myClient createConversationWithName:nil clientIds:clientIds attributes:@{@"type":[NSNumber numberWithInt:0]} options:AVIMConversationOptionNone callback:^(AVIMConversation *conversation, NSError *error) {
            if (error) {
                 NSLog(@"error=%@",error);
            } else {
                [self openConversation:conversation];//打开对话
            }
        }];
        
        
    }
    else {
        //存在历史对话-则打开对话
        AVIMConversation *conversation = [objects objectAtIndex:0];
        [self openConversation:conversation];
    }
    
    
    
}];
    
    NSLog(@"选择usernem=%@",chatToUser.username);
    
    
    
     }
    
    
    
}

- (void)openConversation:(AVIMConversation*)conversation {
    /*
    TalkViewController *tVC = [[TalkViewController alloc] init];
    tVC.conversation = conversation;
    
   // AVUser *chatToUser = self.listArray[indexPath.row];
    tVC.toWho =self.toWho;
    [self.navigationController pushViewController:tVC animated:YES];
     */
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"解除好友关系吗" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        alertView.tag = indexPath.row;
        [alertView show];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSLog(@"点击删除好友");
        //删除好友
        //删除两人的对话
        //删除我对对方的关注
        //删除对方对我的关注
        
        [self showProgress];
        AVUser *myUser=[AVUser currentUser];
        AVUser *deleteUser=self.listArray[alertView.tag];
        
        [myUser unfollow:deleteUser.objectId andCallback:^(BOOL succeeded, NSError *error) {
            
            
            
            if (succeeded) {
                
                NSLog(@"我取消对对方的关注");
                
                [[UserHandle shareUser] tryCreateDeleteFriendRequestWithToUser:deleteUser callback:^(BOOL succeeded, NSError *error) {}];
                
                
                
                [self hideProgress];
                
                [self getFriendList];
                
                
            }
            else { NSLog(@"我取消对对方关注关注出错error=%@",error);}
            
            
        }];
        
       
        
       }
  
}
@end
