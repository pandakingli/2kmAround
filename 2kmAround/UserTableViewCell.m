

#import "UserTableViewCell.h"

@implementation UserTableViewCell
//布局子视图,当视图的bounds发生改变的时候
-(void)layoutSubviews{
    //一定要调用父类方法
    [super layoutSubviews];
   
    
    CGRect rect1 = CGRectMake(10, 10, 100, 100);
    
    CGRect rect2 = CGRectMake(CGRectGetMaxX(rect1)+10, CGRectGetMinY(rect1), self.contentView.frame.size.width-130 , 30);
    
   CGRect rect3 = CGRectMake(CGRectGetMaxX(rect1)+10, CGRectGetMaxY(rect2)+10, self.contentView.frame.size.width-130 , 30);
    
    CGRect rect4 = CGRectMake(CGRectGetMaxX(rect1)+10, CGRectGetMaxY(rect3)+10, self.contentView.frame.size.width-130 , 30);
    
    self.myIMV.layer.masksToBounds =YES;
    
    self.myIMV.layer.cornerRadius =50;
    
    self.myIMV.frame= rect1;
    self.nameLabel.frame=rect2;
    //self.nameLabel.textAlignment=NSTextAlignmentCenter;
    self.emailLabel.frame=rect3;
    
   // self.emailLabel.textAlignment=NSTextAlignmentCenter;
    
    self.emailTestLabel.frame=rect4;
    
   // self.emailTestLabel.textAlignment=NSTextAlignmentCenter;
}
-(void)p_setupViews{
    
    self.myIMV=[[UIImageView alloc]initWithFrame:CGRectMake(5, 2, 100, 100)];
    self.myIMV.backgroundColor = [UIColor blueColor];
    
    self.nameLabel = [[UILabel alloc]init];
   // self.nameLabel.backgroundColor = [UIColor redColor];
    
    self.emailLabel =[[UILabel alloc]init];
   // self.emailLabel.backgroundColor = [UIColor redColor];
    self.emailTestLabel=[[UILabel alloc]init];
    
    [self.contentView addSubview:self.myIMV];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.emailLabel];
    
    [self.contentView addSubview:self.emailTestLabel];
    
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
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
