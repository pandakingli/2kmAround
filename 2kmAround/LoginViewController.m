


#import "Headers.h"
#define kWidth self.view.frame.size.width
#define kHeight self.view.frame.size.height

@interface LoginViewController ()

@end

@implementation LoginViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([UserHandle shareUser].isUserLogin) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else{
       // [self p_setupViews];
    }
}
-(void)p_setupViews{

    
    self.view.backgroundColor=[UIColor whiteColor];
    //[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"login2.jpeg"]]];
    

    self.emailTF = [[UITextField alloc]init];
    CGRect rect1 = CGRectMake(40, 84, kWidth-80, 40);
    self.emailTF.placeholder = @"用户名";
    self.emailTF.textAlignment= NSTextAlignmentCenter;
    self.emailTF.backgroundColor =[UIColor colorWithRed:0.9 green:0.5 blue:0.1 alpha:0.6];
    self.emailTF.frame = rect1;
    
    self.emailTF.layer.cornerRadius = 10.0;
    
    
    
    
    
    self.pwdTF = [[UITextField alloc]init];
    CGRect rect2 = CGRectMake(40, CGRectGetMaxY(rect1)+5, kWidth-80, 40);
    self.pwdTF.placeholder = @"密码";
    [self.pwdTF setSecureTextEntry:YES];//设置为密码输入
     self.pwdTF.backgroundColor =[UIColor colorWithRed:0.9 green:0.5 blue:0.1 alpha:0.6];
    self.pwdTF.frame = rect2;
    
    
    
    
    self.pwdTF.layer.cornerRadius = 10.0;
    self.pwdTF.textAlignment= NSTextAlignmentCenter;
    
    self.loginButton =[UIButton buttonWithType:UIButtonTypeCustom];
    CGRect rect3 = CGRectMake(40, CGRectGetMaxY(rect2)+5, kWidth-80, 40);
   
        self.loginButton.backgroundColor =[UIColor colorWithRed:0.2 green:0.5 blue:0.5 alpha:0.6];
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    self.loginButton.frame =rect3;
    
    [self.loginButton.layer setMasksToBounds:YES];
    
    [self.loginButton.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
    [self.loginButton.layer setBorderWidth:1.0]; //边框宽度
    self.registerButton =[UIButton buttonWithType:UIButtonTypeCustom];
    CGRect rect4 = CGRectMake(40, CGRectGetMaxY(rect3)+5, kWidth-80, 40);
    
    self.registerButton.backgroundColor =[UIColor colorWithRed:0.2 green:0.5 blue:0.5 alpha:0.6];
    [self.registerButton setTitle:@"注册" forState:UIControlStateNormal];
    self.registerButton.frame =rect4;
    
    [self.registerButton.layer setMasksToBounds:YES];
    
    [self.registerButton.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
    [self.registerButton.layer setBorderWidth:1.0]; //边框宽度
    self.getPWDButton =[UIButton buttonWithType:UIButtonTypeCustom];
    CGRect rect5 = CGRectMake(40, CGRectGetMaxY(rect4)+5, kWidth-80, 40);
    
    [self.getPWDButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    self.getPWDButton.frame =rect5;
    
    self.getPWDButton.backgroundColor =[UIColor colorWithRed:0.2 green:0.5 blue:0.5 alpha:0.6];
    [self.getPWDButton.layer setMasksToBounds:YES];
    
    [self.getPWDButton.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
    [self.getPWDButton.layer setBorderWidth:1.0]; //边框宽度
    self.backButton =[UIButton buttonWithType:UIButtonTypeCustom];
    CGRect rect6 = CGRectMake(40, CGRectGetMaxY(rect5)+5, kWidth-80, 40);
    
    
    self.backButton.backgroundColor =[UIColor colorWithRed:0.2 green:0.5 blue:0.5 alpha:0.6];
    [self.backButton setTitle:@"返回" forState:UIControlStateNormal];
    self.backButton.frame =rect6;
    
    [self.backButton.layer setMasksToBounds:YES];
    
    [self.backButton.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
    [self.backButton.layer setBorderWidth:1.0]; //边框宽度
    
    [self.loginButton addTarget:self action:@selector(loginButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.registerButton addTarget:self action:@selector(registerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.getPWDButton addTarget:self action:@selector(getPWDButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.emailTF];
    [self.view addSubview:self.pwdTF];
    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.registerButton];
    [self.view addSubview:self.getPWDButton];
    
    [self.view addSubview:self.backButton];
    
}


#pragma mark 按钮的点击事件
-(void) loginButtonAction:(UIButton*)sender
{
    NSLog(@"点击登录按钮");
  
    if((![self.emailTF.text isEqualToString:@""])&&(![self.pwdTF.text isEqualToString:@""]))
    {
        
    [AVUser logInWithUsernameInBackground:self.emailTF.text password:self.pwdTF.text block:^(AVUser *user, NSError *error) {
        if (user != nil) {
            NSLog(@"登录成功");
            
            AVUser *currentUser = [AVUser currentUser];
            [UserHandle shareUser].isUserLogin = YES;
            [UserHandle shareUser].myUser=currentUser;
            /*
            UserInfo *u1 =[[UserInfo alloc]init];
            u1.usr_name = user.username;
            u1.usr_pwd = user.password;
            u1.usr_email=user.email;
            
            [UserHandle shareUser].myInfo=u1;
            
            [UserHandle shareUser].isUserLogin = YES;
            
            
            AVUser *currentUser = [AVUser currentUser];
            
            AVIMClient *imClient = [[AVIMClient alloc] init];
            [imClient openWithClientId:[currentUser objectId] callback:^(BOOL succeeded, NSError *error){
                if (error) {
                    NSLog(@"error=%@",error);
                } else {
                    myConversations *store = [myConversations sharedMyConversations];
                    store.myClient = imClient;
                    //[self.navigationController pushViewController:mainView animated:YES];
                }
            }];
*/
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        } else {
            NSLog(@"登录失败");
            [self showHUDText:@"用户名或密码不正确！"];
        }
        
    }];
    
    }
    else{
        [self showHUDText:@"用户名或密码为空！"];
    }
    
}
-(void) registerButtonAction:(UIButton*)sender
{
    NSLog(@"点击注册按钮");
    
    RegisterViewController *regVC = [[RegisterViewController alloc]init];
    [self presentViewController:regVC animated:YES completion:nil];
    
}
-(void) getPWDButtonAction:(UIButton*)sender
{
    NSLog(@"点击找回密码按钮");
    
    LostPWDViewController *lostPWDVC=[[LostPWDViewController alloc]init];
    
    [self presentViewController:lostPWDVC animated:YES completion:nil];
    

    
    //GetPWDViewController *getVC = [[GetPWDViewController alloc]init];
    //[self presentViewController:getVC animated:YES completion:nil];
    
    
}
-(void) backButtonAction:(UIButton*)sender
{
    NSLog(@"点击返回按钮");
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self p_setupViews];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
@end
