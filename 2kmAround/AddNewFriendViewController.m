
#import "Headers.h"
#import "AddNewFriendViewController.h"

@interface AddNewFriendViewController ()
@property(nonatomic,strong)UIButton * addNewFriendButton;
@property(nonatomic,strong) UILabel * userNameLab;

@property(nonatomic,strong) UILabel * userEmailLab;
@property(nonatomic,strong) UIImageView *userIMV;
@end

@implementation AddNewFriendViewController
-(void)showHUDText:(NSString*)text  {
    MBProgressHUD* hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    hud.labelText=text;
    hud.detailsLabelFont = [UIFont systemFontOfSize:14];
    hud.detailsLabelText = text;
    hud.margin=10.f;
    hud.removeFromSuperViewOnHide=YES;
    hud.mode=MBProgressHUDModeText;
    //[hud hide:YES afterDelay:2];
    
    [self.view addSubview:hud];
    
    typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)),
                   
                   dispatch_get_main_queue(), ^{
                       
                      // NSLog(@"第三种");
                       [hud hide:YES];
                      // NSInteger n =weakSelf.navigationController.viewControllers.count;
                      // [weakSelf.navigationController popToViewController:weakSelf.navigationController.viewControllers[n-2] animated:YES];
                        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                   
                   } );
}

-(void)showProgress {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

-(void)hideProgress {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
-(void)addNewAction:(UIButton*)sender{
    NSLog(@"申请添加%@为好友",self.addNewUser.username);
    [self showProgress];
   typeof(self) weakSelf = self;
    [[UserHandle shareUser] tryCreateAddRequestWithToUser:self.addNewUser callback:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"发送请求成功");
            [weakSelf hideProgress];
            weakSelf.addNewFriendButton.enabled=NO;
            [weakSelf showHUDText:@"发送请求成功" ];
            
 
        }
    }];
}
-(void)p_setupViews{
    self.view.backgroundColor=[UIColor whiteColor];
    
    
    CGRect rect1 = CGRectMake(10, 80, 100, 100);
    CGRect rect2 = CGRectMake(CGRectGetMaxX(rect1)+10, CGRectGetMinY(rect1), self.view.frame.size.width-110 , 30);
    CGRect rect3 = CGRectMake(CGRectGetMaxX(rect1)+10, CGRectGetMaxY(rect1)-30, self.view.frame.size.width-114 , 30);
    
    CGRect rect4 = CGRectMake(10, CGRectGetMaxY(rect1)+10, self.view.frame.size.width-30, 40);
    self.addNewFriendButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    self.addNewFriendButton.frame=rect4;
    [self.addNewFriendButton setTitle:@"添加好友" forState:UIControlStateNormal];
    [self.addNewFriendButton addTarget:self action:@selector(addNewAction:) forControlEvents:UIControlEventTouchUpInside];
    self.addNewFriendButton.backgroundColor=[UIColor grayColor];
    
    
    self.userIMV = [[UIImageView alloc]init];
    self.userIMV.frame=rect1;
   // self.userIMV.backgroundColor=[UIColor redColor];
    self.userNameLab = [[UILabel alloc]init];
    self.userNameLab.frame=rect2;
  //  self.userNameLab.backgroundColor=[UIColor redColor];
    
    self.userEmailLab=[[UILabel alloc]init];
    self.userEmailLab.frame=rect3;
 //   self.userEmailLab.backgroundColor=[UIColor redColor];
    
    
    [self.view addSubview:self.userIMV];
    [self.view addSubview:self.userNameLab];
   // [self.view addSubview:self.userEmailLab];
    
    [self.view addSubview:self.addNewFriendButton];
    
    
    self.userNameLab.text=self.addNewUser.username;
    self.userEmailLab.text=self.addNewUser.email;
    [[UserHandle shareUser] getAvatarImageOfUser:self.addNewUser block:^(UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
           self.userIMV.image=image;
        });
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self p_setupViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
