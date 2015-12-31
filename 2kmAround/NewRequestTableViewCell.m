
#import "NewRequestTableViewCell.h"

@implementation NewRequestTableViewCell
//布局子视图,当视图的bounds发生改变的时候
-(void)layoutSubviews{
    //一定要调用父类方法
    [super layoutSubviews];
    
    
    CGRect rect1 = CGRectMake(10, 10, 40, 40);
    CGRect rect2 = CGRectMake(CGRectGetMaxX(rect1)+10, CGRectGetMinY(rect1), self.contentView.frame.size.width-70 , 20);
    CGRect rect3 = CGRectMake(CGRectGetMaxX(rect1)+2, CGRectGetMaxY(rect1)-30, self.contentView.frame.size.width-109 , 30);
    
    CGRect rect4 = CGRectMake(10, CGRectGetMaxY(rect1)+10, self.contentView.frame.size.width/2-20, 20);
    
    CGRect rect5 = CGRectMake(self.contentView.frame.size.width/2+20, CGRectGetMaxY(rect1)+10, self.contentView.frame.size.width/2-30, 20);
    
    self.acceptButton.frame=rect4;
    self.rejectButton.frame=rect5;
    [self.acceptButton setTitle:@"接受" forState:UIControlStateNormal];
    [self.rejectButton setTitle:@"拒绝" forState:UIControlStateNormal];
    
    //self.myIMV.layer.masksToBounds =YES;
    
   // self.myIMV.layer.cornerRadius =50;
    
    self.myIMV.frame= rect1;
    self.nameLabel.frame=rect2;
    self.emailLabel.frame=rect3;
}
-(void)p_setupViews{
    
    self.myIMV=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
    //self.myIMV.backgroundColor = [UIColor blueColor];
    
    self.nameLabel = [[UILabel alloc]init];
    //self.nameLabel.backgroundColor = [UIColor redColor];
    
    self.emailLabel =[[UILabel alloc]init];
    //self.emailLabel.backgroundColor = [UIColor redColor];
    
    
    
    self.acceptButton=[UIButton buttonWithType:UIButtonTypeSystem];
    self.acceptButton.backgroundColor=[UIColor orangeColor];
    
    
    self.rejectButton=[UIButton buttonWithType:UIButtonTypeSystem];
    self.rejectButton.backgroundColor=[UIColor orangeColor];
    
    [self.contentView addSubview:self.myIMV];
    [self.contentView addSubview:self.nameLabel];
   // [self.contentView addSubview:self.emailLabel];
    
    [self.contentView addSubview:self.acceptButton];
    [self.contentView addSubview:self.rejectButton];
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
