//
//  VoiceAssistantViewController.m
//  Frank
//
//  Created by fengjunwu on 2019/6/18.
//  Copyright © 2019 819134700@qq.com. All rights reserved.
//

#import "VoiceAssistantViewController.h"
#import "VoiceAssistantViewCell.h"
#import "VoiceAssistantViewModel.h"
#import "VoiceAssistantModel.h"
#import "ArchiveManager.h"
#import "MainViewController.h"
#import "BaseNavigationViewController.h"
#import "DrawerViewController.h"


@interface VoiceAssistantViewController ()<SDCycleScrollViewDelegate>

@property (nonatomic,strong)SDCycleScrollView *cycleScrollView;
@property (nonatomic,strong)NSMutableArray *dateSource;
@property (nonatomic,strong)NSMutableArray *bgImageSource;
@property (nonatomic,assign) BOOL isShow;
@end

@implementation VoiceAssistantViewController

- (void)viewWillAppear:(BOOL)animated{
    //设置导航栏背景图片为一个空的image，这样就透明了
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    //    如果不想让其他页面的导航栏变为透明 需要重置
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

-(NSMutableArray *)dateSource{
    if (!_dateSource) {
        _dateSource = [[NSMutableArray alloc] init];
    }
    return _dateSource;
}

-(NSMutableArray *)bgImageSource{
    if (!_bgImageSource) {
        _bgImageSource = [[NSMutableArray alloc] init];
    }
    return _bgImageSource;
}

-(SDCycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - Height_NavBar) delegate:self placeholderImage:[UIImage imageNamed:@"音频"]];
        _cycleScrollView.showPageControl = NO;
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        //    _cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"pageControlCurrentDot"];
        //    _cycleScrollView.pageDotImage = [UIImage imageNamed:@"pageControlDot"];
        //    _cycleScrollView.imageURLStringsGroup = self.dateSource;
        
        _cycleScrollView.localizationImageNamesGroup = self.bgImageSource;
        _cycleScrollView.autoScroll = NO;
        [self.view addSubview:_cycleScrollView];
        
        
        UIImageView *leftImg = [[UIImageView alloc] init];
        leftImg.image = [UIImage imageNamed:@"左翻页"];
        leftImg.size = CGSizeMake(Width(24), Width(24));
        leftImg.left = Width(15);
        leftImg.top = (kMainScreenHeight - Height_NavBar) / 2.0;
        leftImg.contentMode = UIViewContentModeScaleAspectFit;
        [_cycleScrollView addSubview:leftImg];
        
        
        UIImageView *rightImg = [[UIImageView alloc] init];
        rightImg.image = [UIImage imageNamed:@"右翻页"];
        rightImg.size = CGSizeMake(Width(24), Width(24));
        rightImg.left = kMainScreenWidth - Width(39);
        rightImg.top = (kMainScreenHeight - Height_NavBar) / 2.0;
        rightImg.contentMode = UIViewContentModeScaleAspectFit;
        [_cycleScrollView addSubview:rightImg];
    }
    return _cycleScrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Voice Assistant";
    self.view.backgroundColor = [UIColor blackColor];
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"菜单图标"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    self.navigationItem.leftBarButtonItem = back;
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self getDataSource];
    
}


-(void)getDataSource{

    [VoiceAssistantViewModel getCharacterListWithBlock:^(NSArray * _Nonnull dataSource, NSError * _Nonnull error) {
        
        if (!error) {
            for (DataModel *model in dataSource) {
                
                //查询数据库有没有缓存，没有则去下载
                NSString* where = [NSString stringWithFormat:@"where %@=%@ and %@=%@ ",bg_sqlKey(@"characterId"),bg_sqlValue(model.characterId),bg_sqlKey(@"ver"),bg_sqlValue(model.ver)];
                NSArray* arr = [VoiceAssistantModel bg_find:bg_tablename where:where];
                
                if (arr.count == 0) {
                    //没有数据
                    [[ArchiveManager manager] startRequest:model.resourceUrl];
                    [[ArchiveManager manager] setArrayBlock:^(NSString *hostPath, NSArray *nameArray){
                        
                        NSData *data = [[NSData alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/config.json",hostPath]];
                        // 对数据进行JSON格式化并返回字典形式
                        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                        
                        VoiceAssistantModel *model = [VoiceAssistantModel modelWithDictionary:dic];
                        model.bg_tableName = bg_tablename;//自定义数据库表名称(库自带的字段).
                        /**
                         存储.
                         */
                        [model bg_save];
                        
                        //添加数据
                        NSString *path = [NSString stringWithFormat:@"%@%@",[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject],model.bgImg];
                        [self.bgImageSource addObject:path];
                        [self.dateSource addObject:model];
                        self.cycleScrollView.localizationImageNamesGroup = self.bgImageSource;
                    }];

                }else{
                    
                    VoiceAssistantModel *model = arr[0];
                    NSString *path = [NSString stringWithFormat:@"%@%@",[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject],model.bgImg];
                    [self.bgImageSource addObject:path];
                    [self.dateSource addObject:model];
                    self.cycleScrollView.localizationImageNamesGroup = self.bgImageSource;
                }
            }
        }else{
            
        }
    }];
}

#pragma mark--显示左菜单
-(void)backClick{
    
    if (_isShow) {
        _isShow = NO;
        [self.xl_sldeMenu showLeftViewControllerAnimated:true];
    }else{
        
        [self.xl_sldeMenu showRootViewControllerAnimated:true];
        _isShow = YES;
    }
}



- (Class)customCollectionViewCellClassForCycleScrollView:(SDCycleScrollView *)view
{
    if (view != _cycleScrollView) {
        return nil;
    }
    return [VoiceAssistantViewCell class];
}

- (void)setupCustomCell:(UICollectionViewCell *)cell forIndex:(NSInteger)index cycleScrollView:(SDCycleScrollView *)view
{
    VoiceAssistantViewCell *myCell = (VoiceAssistantViewCell *)cell;
    VoiceAssistantModel *model = self.dateSource[index];
    [myCell setModel:model];
    
    myCell.confirmBut = ^{
        
        MainViewController *MainVC = [[MainViewController alloc] init];
        MainVC.ver = model.ver;
        MainVC.characterId = model.characterId;
        UINavigationController *nav = (UINavigationController *)self.xl_sldeMenu.rootViewController;
        [nav pushViewController:MainVC animated:NO];
    };
    
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
