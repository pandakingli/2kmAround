//
//  MyProfileViewController.m
//  2kmAround
//
//  Created by 李宁 on 15/12/24.
//  Copyright © 2015年 Nthan. All rights reserved.
//

#import "MyProfileViewController.h"
#import "Headers.h"
@interface MyProfileViewController ()<UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property(nonatomic,strong)UITableView *tableview;

@property (nonatomic, strong) MCPhotographyHelper *photographyHelper;
@end

@implementation MyProfileViewController
- (MCPhotographyHelper *)photographyHelper {
    if (_photographyHelper == nil) {
        _photographyHelper = [[MCPhotographyHelper alloc] init];
    }
    return _photographyHelper;
}
-(void)showProgress {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

-(void)hideProgress {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}





-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([UserHandle shareUser].isUserLogin) {
        self.title=@"个人信息";
    }else {
        self.title = @"未登录";
        
        
        
    }
    [self.tableview reloadData];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableview = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self.tableview registerClass:[UserTableViewCell class] forCellReuseIdentifier:@"ucell"];
    
    [self.view addSubview:self.tableview];
    
    
    if ([UserHandle shareUser].isUserLogin) {
        self.title=@"个人信息";
    }else {
        self.title = @"未登录";
        
        
        
        
        
        
    }
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([UserHandle shareUser].isUserLogin) {
        return 3;
    }
    else
    {
        return 2;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 3;
            break;
        case 2:
            return 1;
            break;
        default:
            return 0;
            break;
    }
}

-(void)tapIcon:(UITapGestureRecognizer*)sender
{
    NSLog(@"更换头像");
    [self pickImage];
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
        {
            
            if ([UserHandle shareUser].isUserLogin) {
                
                
                UserTableViewCell * ucell =[tableView dequeueReusableCellWithIdentifier:@"ucell" forIndexPath:indexPath];
                ucell.nameLabel.text=[AVUser currentUser].username;
                ucell.emailLabel.text=[AVUser currentUser].email;
                ucell.myIMV.userInteractionEnabled=YES;
                UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapIcon:)];
                [ucell.myIMV addGestureRecognizer:singleTap1];
                NSLog(@"name=%@",[AVUser currentUser].username);
                
                if ([[AVUser currentUser] objectForKey:@"emailVerified"]) {
                    ucell.emailTestLabel.text=@"邮箱已验证";
                }else {
                    ucell.emailTestLabel.text=@"邮箱未验证";
                }
                
                
                //获取图片
                [[UserHandle shareUser] getAvatarImageOfUser:[AVUser currentUser] block:^(UIImage *image) {
                    if(image){
                        
                        CGFloat avatarWidth = 60;
                        CGSize avatarSize = CGSizeMake(avatarWidth, avatarWidth);
                        
                        UIImage *resizedImage = [self resizeImage:image toSize:avatarSize];
                        
                        
                        
                        ucell.myIMV.image=resizedImage;
                      
                        
                    }
                }];
                
                
                
                
                
                return ucell;
                
            }
            else
            {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
                cell.textLabel.text = @"点击登录";
                return cell;
            }
        }
            break;
            
        case 1:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            
            switch (indexPath.row) {
                case 0:
                    
                    
                    cell.textLabel.text = @"语音助手";
                    
                    break;
                case 1:
                    
                    
                    cell.textLabel.text = @"实时汇率";
                    
                    break;
                case 2:
                    
                    
                    cell.textLabel.text = @"天气预报";
                    
                    break;
                default:
                    break;
            }
            
            
            return cell;
            
            
            
            
        }
            break;
            
        case 2:
        {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            cell.textLabel.text = @"退出登录";
            return cell;
            
            
            
            
        }
            break;
            
        default:
            return nil;
            break;
    }
    
    
    
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        
        //退出登录
        [AVUser logOut];  //清除缓存用户对象
        // AVUser *currentUser = [AVUser currentUser]; // 现在的currentUser是nil了
        [UserHandle shareUser].isUserLogin = NO;
        [UserHandle shareUser].myUser=nil;
        [self.tableview reloadData];
        NSLog(@"用户退出");
    
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSLog(@"点击%@",indexPath);
    switch (indexPath.section) {
        case 0:
        {
            [self.tableview deselectRowAtIndexPath:indexPath animated:NO];
            
            if (![UserHandle shareUser].isUserLogin) {
                LoginViewController * loginVC = [[LoginViewController alloc]init];
                
                [self presentViewController:loginVC animated:YES completion:nil];
                
            }else{
                [self showEditActionSheet:nil];
            }
            
            
        }
            break;
            
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                   // IATViewController *iatVC=[[IATViewController alloc]init];
                   // [self.navigationController pushViewController:iatVC animated:YES];
                    
                }
                    break;
                    
                default:
                    break;
            }
            
        }
            break;
            
        case 2:
        {
            NSLog(@"点击退出登录");
            
            /*
             
             UIAlertController *alertC=[UIAlertController alertControllerWithTitle:@"确定要退出吗？" message:@"确定要退出吗？" preferredStyle:UIAlertControllerStyleAlert];
             
             */
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确定要退出吗？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            alertView.tag = indexPath.row;
            [alertView show];
            
            
        }
            break;
        default:
            break;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            if ([UserHandle shareUser].isUserLogin)
                return 120;
            else return 40;
        }
            
            break;
        case 1:
            return 40;
            break;
        case 2:
            return 40;
            break;
        default:
            return 0;
            break;
    }
}
#pragma mark 更新头像和资料
- (void)showEditActionSheet:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"更新资料" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"更改头像", @"更改用户名",@"更改密码", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    if (buttonIndex == 0) {
        [self pickImage];//更换头像
    } else if (buttonIndex == 1) {
        //更改用户名
        NSLog(@"更改用户名");
        
        ChangeUserNameViewController *changenameVC=[[ChangeUserNameViewController alloc]init];
        
        [self presentViewController:changenameVC animated:YES completion:nil];
        
    }else if (buttonIndex == 2) {
        //更改用户名
        NSLog(@"更改密码");
        
        ChangePWDViewController *changepwdVC=[[ChangePWDViewController alloc]init];
        
       [self presentViewController:changepwdVC animated:YES completion:nil];
        
    }
}


- (UIImage *)roundImage:(UIImage *)image toSize:(CGSize)size radius:(float)radius;
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [[UIBezierPath bezierPathWithRoundedRect:rect
                                cornerRadius:radius] addClip];
    [image drawInRect:rect];
    UIImage *rounded = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return rounded;
}


-(UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)newSize {
    
    
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
//更改头像
-(void)pickImage {
    
    NSLog(@"图片");
    [self.photographyHelper showOnPickerViewControllerOnViewController:self completion:^(UIImage *image) {
        
        NSLog(@"处理图片");
        
        
        
        __weak typeof(self) weakself=self;
        if (image) {
            //UIImage *rounded = [CDUtils roundImage:image toSize:CGSizeMake(100, 100) radius:10];
            UIImage *rounded = [self roundImage:image toSize:CGSizeMake(100, 100) radius:10];
            
            [self showProgress];
            
            [[UserHandle shareUser] updateAvatarWithImage:rounded callback:^(BOOL succeeded, NSError *error) {
                [self hideProgress];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                  
                    
                    [weakself .tableview reloadData];
                    
                });
            }];
            
            
            //            [[CDUserManager manager] updateAvatarWithImage : rounded callback : ^(BOOL succeeded, NSError *error) {
            //                [self hideProgress];
            //                if ([self filterError:error]) {
            //                    [self loadDataSource];
            //                }
            //            }];
        }
    }];
}
@end
