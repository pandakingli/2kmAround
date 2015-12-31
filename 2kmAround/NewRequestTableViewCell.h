

#import <UIKit/UIKit.h>

@interface NewRequestTableViewCell : UITableViewCell

@property(nonatomic,strong)UIImageView * myIMV;//头像
@property(nonatomic,strong)UILabel * nameLabel;//昵称
@property(nonatomic,strong)UILabel * emailLabel;//邮箱

@property(nonatomic,strong)UIButton * acceptButton;//接受添加好友

@property(nonatomic,strong)UIButton * rejectButton;//拒绝添加好友
@end
