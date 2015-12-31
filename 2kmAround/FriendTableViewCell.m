
#import "FriendTableViewCell.h"

@implementation FriendTableViewCell

//布局子视图,当视图的bounds发生改变的时候
-(void)layoutSubviews{
    //一定要调用父类方法
    [super layoutSubviews];
    
    
    CGRect rect1 = CGRectMake(20, 10, 40, 40);
    CGRect rect2 = CGRectMake(CGRectGetMaxX(rect1)+20, CGRectGetMinY(rect1), self.contentView.frame.size.width-44 , 40);
    
    
    self.myIMV.frame= rect1;
    self.nameLabel.frame=rect2;
    
}
-(void)p_setupViews{
    
    self.myIMV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    //self.myIMV.backgroundColor = [UIColor blueColor];
    
    self.nameLabel = [[UILabel alloc]init];
    //self.nameLabel.backgroundColor = [UIColor redColor];
    
    
    [self.contentView addSubview:self.myIMV];
    [self.contentView addSubview:self.nameLabel];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //如果自定义cell，原来的属性都不要再使用，他们会影响布局。（属性名不要再重复）
        [self p_setupViews];
    }
    return self;
}
- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}
@end
