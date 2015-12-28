//
//  ChangeUserNameViewController.h
//  Travelling Together
//
//  Created by 李宁 on 15/12/14.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangeUserNameViewController : UIViewController

@property(nonatomic,strong)UILabel *nameLabel;

@property(nonatomic,strong)UILabel *nameLabel1;
@property(nonatomic,strong)UITextField *nameTF;

@property(nonatomic,strong)UILabel *emailLabel;
@property(nonatomic,strong)UITextField *emailTF;

@property(nonatomic,strong)UILabel *pwdLabel;
@property(nonatomic,strong)UITextField *pwdTF;

@property(nonatomic,strong)UIButton *registerButton;
@property(nonatomic,strong)UIButton *backButton;
@end
