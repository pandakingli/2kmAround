
#import "Headers.h"
#import "NewAddRequestFriendsListViewController.h"


@interface NewAddRequestFriendsListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *tableview;
@property(nonatomic,strong)NSMutableArray *requestArray;

@property(nonatomic,strong) AVUser *toWho;
@end

@implementation NewAddRequestFriendsListViewController
-(NSMutableArray*)requestArray{
    if (_requestArray==nil) {
        _requestArray=[NSMutableArray arrayWithCapacity:10];
    }
    return _requestArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    /*
    if ([[UserHandle shareUser].jump isEqualToString:@"request"]) {
        [UserHandle shareUser].jump=nil;
    }
     */
    
    self.title=@"新的好友请求";
    self.view.backgroundColor=[UIColor whiteColor];
    self.tableview=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    [self.view addSubview:self.tableview];
    [self.tableview registerClass:[NewRequestTableViewCell class] forCellReuseIdentifier:@"newcell"];
    [[UserHandle shareUser]  findNewUnreadAddRequestsWithBlock:^(NSArray *objects, NSError *error) {
        if (error==nil) {
            NSLog(@"objects=%@",objects);
            [self.requestArray addObjectsFromArray:objects];
            [self.tableview reloadData];
        }
    }];
    
  
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.requestArray.count;
}
-(void)showHUDText:(NSString*)text  {
    MBProgressHUD* hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    hud.labelText=text;
    hud.detailsLabelFont = [UIFont systemFontOfSize:14];
    hud.detailsLabelText = text;
    hud.margin=10.f;
    hud.removeFromSuperViewOnHide=YES;
    hud.mode=MBProgressHUDModeText;
    [hud hide:YES afterDelay:2];
    
}
-(void)showProgress {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

-(void)hideProgress {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
-(void)acceptAction:(UIButton*)sender{
    NSLog(@"点击接受按钮 %ld",sender.tag);
    [self showProgress];
    
    typeof(self) weakSelf = self;
    AVUser *user=[self.requestArray[sender.tag] valueForKey:@"fromUser"];
    
    [[UserHandle shareUser] addFriend:user callback:^(BOOL succeeded, NSError *error) {
       
        if (succeeded) {
           
            AVUser *curUser=[AVUser currentUser];
            NSString *s_objectId=[self.requestArray[sender.tag] valueForKey:@"objectId"];
            //更新对象
            //// 知道 objectId，创建 AVObject
            AVObject *post=[AVObject objectWithoutDataWithClassName:@"myAddRequest" objectId:s_objectId];
           // AVObject *post = [AVObject objectWithClassName:@"myAddRequest" ];
//            post[@"fromUser"] = user;
//            post[@"toUser"] = curUser;
            
            post[@"isRead"] = @(1);//0未读
            post[@"status"] = @(1);//0还在等待添加好友
            //[post save];
            //[post saveInBackgroundWithBlock:nil];
            [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                [weakSelf hideProgress];
                if (succeeded) {
                     [weakSelf showHUDText:@"添加成功！"];
                    
                    
                    /*
                    
                    //向谁聊天
                    AVUser *chatToUser = user;
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
                    

                    */
                    
                }
                else{
                    [weakSelf showHUDText:@"添加失败！"];

                }
            }];
        }
        else {
            [weakSelf hideProgress];
            [self showHUDText:@"添加失败！"];
        }
    }];
    
}
- (void)openConversation:(AVIMConversation*)conversation {
    /*
    
    TalkViewController *tVC = [[TalkViewController alloc] init];
    tVC.conversation = conversation;
    
    // AVUser *chatToUser = self.listArray[indexPath.row];
    tVC.toWho =self.toWho;
    tVC.isFirstTalk=YES;
    [UserHandle shareUser].sendWelcomMessage=YES;
    [self.navigationController pushViewController:tVC animated:YES];
     */
}
-(void)rejectAction:(UIButton*)sender{
    NSLog(@"点击拒绝按钮 %ld",sender.tag);
    
    [self showProgress];
    
   
     NSString *s_objectId=[self.requestArray[sender.tag] valueForKey:@"objectId"];
            //更新对象
            //// 知道 objectId，创建 AVObject
            AVObject *post=[AVObject objectWithoutDataWithClassName:@"myAddRequest" objectId:s_objectId];
            
            
            post[@"isRead"] = @(1);//0未读 1已读
            post[@"status"] = @(2);//0还在等待添加好友  1同意  2拒绝 3拉黑
    
     typeof(self) weakSelf = self;
            [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                [weakSelf hideProgress];
                
                if (succeeded) {
                    [weakSelf showHUDText:@"拒绝成功！"];
                     }
                else{
                    [weakSelf showHUDText:@"拒绝失败！"];
                 }
            }];
    
    
    
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewRequestTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"newcell" forIndexPath:indexPath];
    AVUser *user=[self.requestArray[indexPath.row] valueForKey:@"fromUser"];
    cell.nameLabel.text=user.username;
    cell.emailLabel.text=user.email;
    NSLog(@"user.username=%@",user.username);
    //说明是等待添加的状态
    if ([[self.requestArray[indexPath.row] valueForKey:@"status"] isEqual:@(0)]) {
         cell.acceptButton.tag = indexPath.row;
         cell.rejectButton.tag = indexPath.row;
        [cell.acceptButton addTarget:self action:@selector(acceptAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.rejectButton addTarget:self action:@selector(rejectAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [[UserHandle shareUser] getAvatarImageOfUser:user block:^(UIImage *image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                cell.myIMV.image=image;
            });
        }];
        
        
        
    }
    else {
        [cell.acceptButton setTitle:@"已经添加" forState:UIControlStateNormal];
        
        cell.acceptButton.enabled=NO;
        cell.rejectButton.enabled=NO;
    }
    
    return cell;
}
@end
