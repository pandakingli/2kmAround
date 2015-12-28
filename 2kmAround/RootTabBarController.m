

#import "RootTabBarController.h"
#import "Headers.h"
@interface RootTabBarController ()

@end

@implementation RootTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    
    
    
    
    //聊天
    RecentChatViewController *recentVC = [[RecentChatViewController alloc]init];
    
    
    UINavigationController * recentVCNC = [[UINavigationController alloc] initWithRootViewController:recentVC];
    
    recentVCNC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"聊天" image:[UIImage imageNamed:@"chat1.png"] tag:101];
    UIImage * select1 = [UIImage imageNamed:@"chat2.png"];
    
    recentVCNC.tabBarItem.selectedImage = [select1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //通通讯录
    
    FriendsViewController *friendVC = [[FriendsViewController alloc]init];
    UINavigationController * friendVCNC = [[UINavigationController alloc] initWithRootViewController:friendVC];
    
    friendVCNC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"朋友" image:[UIImage imageNamed:@"friends1.png"] tag:101];
    UIImage * select2 = [UIImage imageNamed:@"friends2.png"];
    
    friendVCNC.tabBarItem.selectedImage = [select2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    //地图和朋友圈
    
    MapAndCircleViewController *mapVC = [[MapAndCircleViewController alloc]init];
    
    
    UINavigationController * mapVCNC = [[UINavigationController alloc] initWithRootViewController:mapVC];
    
    mapVCNC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"圈子" image:[UIImage imageNamed:@"circle1.png"] tag:101];
    UIImage * select3 = [UIImage imageNamed:@"circle2.png"];
    
    mapVCNC.tabBarItem.selectedImage = [select3 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    //我的
    
    MyProfileViewController *myprofileVC = [[MyProfileViewController alloc]init];
    
    
    UINavigationController * myprofileVCNC = [[UINavigationController alloc] initWithRootViewController:myprofileVC];
    
    myprofileVCNC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:[UIImage imageNamed:@"me1.png"] tag:101];
    UIImage * select4 = [UIImage imageNamed:@"me2.png"];
    
    myprofileVCNC.tabBarItem.selectedImage = [select4 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    

    self.viewControllers = @[recentVCNC, friendVCNC, mapVCNC, myprofileVCNC];
    
    
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
