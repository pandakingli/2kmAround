

#define kWidth self.view.frame.size.width
#define kHeight  self.view.frame.size.height
#import "LostPWDViewController.h"
#import "Headers.h"
@interface LostPWDViewController ()

@end

@implementation LostPWDViewController
-(void)p_setupViews{
    self.view.backgroundColor = [UIColor whiteColor];
     [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"ppp.jpeg"]]];
    self.nameLabel = [[UILabel alloc]init];
    self.emailLabel = [[UILabel alloc]init];
    self.pwdLabel = [[UILabel alloc]init];
    
    CGRect rect1 = CGRectMake(5, 44, 80, 40);
    CGRect rect2 = CGRectMake(5, CGRectGetMaxY(rect1)+10, 80, 40);
    CGRect rect3 = CGRectMake(5, CGRectGetMaxY(rect2)+10, 80, 40);
    
    //self.nameLabel.backgroundColor = [UIColor grayColor];
   // self.emailLabel.backgroundColor = [UIColor grayColor];
   // self.pwdLabel.backgroundColor = [UIColor grayColor];
    
    
    
    [self.emailLabel.layer setMasksToBounds:YES];
    self.emailLabel.layer.cornerRadius = 10.0;
    
    self.emailLabel.backgroundColor =[UIColor colorWithRed:0.9 green:0.5 blue:0.1 alpha:0.4];
    
    self.nameLabel.frame = rect1;
    self.emailLabel.frame=rect2;
    self.pwdLabel.frame=rect3;
    
    self.nameLabel.text=@"昵称:";
    self.nameLabel.textAlignment= NSTextAlignmentCenter;
    self.emailLabel.text=@"邮箱:";
    self.emailLabel.textAlignment= NSTextAlignmentCenter;
    self.pwdLabel.text=@"密码:";
    
    self.pwdLabel.textAlignment= NSTextAlignmentCenter;
    
    
    self.nameTF = [[UITextField alloc]init];
    self.emailTF = [[UITextField alloc]init];
    self.pwdTF = [[UITextField alloc]init];
    self.nameTF.backgroundColor = [UIColor blueColor];
    //self.emailTF.backgroundColor = [UIColor blueColor];
    self.pwdTF.backgroundColor = [UIColor blueColor];
    
    self.emailTF.backgroundColor =[UIColor colorWithRed:0.9 green:0.5 blue:0.1 alpha:0.6];
    
    self.emailTF.layer.cornerRadius = 10.0;
    CGRect rect4 = CGRectMake(CGRectGetMaxX(rect1)+2, CGRectGetMinY(rect1), kWidth-89, 40);
    CGRect rect5 = CGRectMake(CGRectGetMaxX(rect2)+2, CGRectGetMinY(rect2), kWidth-89, 40);
    CGRect rect6 = CGRectMake(CGRectGetMaxX(rect3)+2, CGRectGetMinY(rect3), kWidth-89, 40);
    
    self.nameTF.frame=rect4;
   // self.nameTF.backgroundColor=[UIColor orangeColor];
    self.emailTF.frame=rect5;
    
   // self.emailTF.backgroundColor=[UIColor orangeColor];
    self.pwdTF.frame=rect6;
    [self.pwdTF setSecureTextEntry:YES];//设置为密码输入
    
    self.pwdTF.backgroundColor=[UIColor orangeColor];
    
    
    self.registerButton =[UIButton buttonWithType:UIButtonTypeCustom];
    //self.registerButton.backgroundColor = [UIColor grayColor];
    [self.registerButton.layer setMasksToBounds:YES];
    
    [self.registerButton.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
    [self.registerButton.layer setBorderWidth:1.0]; //边框宽度
    self.registerButton.backgroundColor =[UIColor colorWithRed:0.2 green:0.5 blue:0.5 alpha:0.6];
    self.backButton =[UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton.backgroundColor = [UIColor grayColor];
    [self.backButton.layer setMasksToBounds:YES];
    
    [self.backButton.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
    [self.backButton.layer setBorderWidth:1.0]; //边框宽度
    self.backButton.backgroundColor =[UIColor colorWithRed:0.2 green:0.5 blue:0.5 alpha:0.6];
    CGRect rect7 = CGRectMake(CGRectGetMinX(rect1), CGRectGetMaxY(rect3)+10, kWidth-10, 40);
    CGRect rect8 = CGRectMake(CGRectGetMinX(rect1), CGRectGetMaxY(rect7)+10, kWidth-10, 40);
    
    self.registerButton.frame = rect7;
    self.backButton.frame=rect8;
    
    
    [self.registerButton setTitle:@"发送邮件" forState:UIControlStateNormal];
    
    
    [self.backButton setTitle:@"返回" forState:UIControlStateNormal];
    
    //[self.view addSubview:self.nameLabel];
    [self.view addSubview:self.emailLabel];
    //[self.view addSubview:self.pwdLabel];
    
    
   // [self.view addSubview:self.nameTF];
    [self.view addSubview:self.emailTF];
    //[self.view addSubview:self.pwdTF];
    
    [self.view addSubview:self.registerButton];
    
    [self.view addSubview:self.backButton];
    
    
    [self.registerButton addTarget:self action:@selector(registerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark button点击事件
-(void) registerButtonAction:(UIButton*)sender{
    NSLog(@"点击注册按钮");
    
    
    //判断不为空
    
    if(![self.emailTF.text isEqual:@""])
    {
        [AVUser requestPasswordResetForEmailInBackground:self.emailTF.text block:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [self showHUDText:@"发送成功，请进入邮箱查看！"];
            } else {
                NSLog(@"error=%@",error);
                [self showHUDText:@"发送不成功！"];
            }
            [self clearTF];
        }];
        
    }
    else{
        
        [self showHUDText:@"请填写注册邮箱！"];
    }
    
    
    
    
}
-(void) backButtonAction:(UIButton*)sender{
    NSLog(@"点击返回按钮");
    [self dismissViewControllerAnimated:YES completion:nil];
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
-(void)clearTF{
    self.nameTF.text=nil;
    self.emailTF.text=nil;
    self.pwdTF.text=nil;
}

@end
