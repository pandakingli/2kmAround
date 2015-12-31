
#import "Headers.h"
#import "SearchFriendViewController.h"

@interface SearchFriendViewController ()<UISearchBarDelegate>
@property(nonatomic,strong)UISearchBar *mySearchBar;
@end

@implementation SearchFriendViewController
-(void)showHUDText:(NSString*)text{
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
- (void)searchUser:(NSString *)name {
    [self showProgress];
    
    [[UserHandle shareUser] findUsersByUserName:name withBlock:^(NSArray *objects, NSError *error) {
        if(objects.count>0){
        
            AVUser *user= objects[0];
            NSLog(@"查找到");
            NSLog(@"objects=%@",objects);
            NSLog(@"user.username=%@",user.username);
            
            
            [[UserHandle shareUser] isMyFriend:user block:^(BOOL succeeded, NSError *error) {
                
                
                if (succeeded) {
                    //此人已经是我的好友了
                    
                    [self hideProgress];
                    NSLog(@"此人已经是你的好友");
                    [self showHUDText:@"已经是好友"];
                    
                }else {
                    
                    AddNewFriendViewController *addVC=[[AddNewFriendViewController alloc]init];
                    addVC.addNewUser=user;
                    [self hideProgress];
                    [self.navigationController pushViewController:addVC animated:YES];
                    
                }
                
            }];
            
            
            
            
        }
        else
        {
            NSLog(@"error=%@",error);
            
            [self hideProgress];
            NSLog(@"未查找到用户");
            [self showHUDText:@"不存在此用户"];
        }
    }];
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"点击查找");
    
    [searchBar resignFirstResponder];
    NSString *content = searchBar.text;
    NSLog(@"content=%@",content);
    //[self searchUser:content];
    [self searchUser:content];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.title = @"查找好友";
    self.mySearchBar=[[UISearchBar alloc]init];
    CGRect rect_mySearchBar = CGRectMake(10, 80, self.view.frame.size.width-20, 40);
    self.mySearchBar.backgroundColor=[UIColor blueColor];
    self.mySearchBar.frame=rect_mySearchBar;
    self.mySearchBar.delegate=self;
    [self.view addSubview:self.mySearchBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
