

#import <UIKit/UIKit.h>

@interface UserTableViewCell : UITableViewCell
@property(nonatomic,strong)UIImageView * myIMV;//头像
@property(nonatomic,strong)UILabel * nameLabel;//昵称
@property(nonatomic,strong)UILabel * emailLabel;//邮箱

@property(nonatomic,strong)UILabel * emailTestLabel;//邮箱是否验证
@end
