//
//  InformationViewController.m
//  Frank
//
//  Created by fengjunwu on 2019/6/18.
//  Copyright © 2019 819134700@qq.com. All rights reserved.
//

#import "InformationViewController.h"
#import "InformationTableViewCell.h"
#import "informationViewModel.h"
#import "InformationModel.h"
#import "InformationWebViewController.h"
#import "MainViewController.h"


@interface InformationViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataSource;

@end

@implementation InformationViewController

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - Height_NavBar) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = UIColorHex(0x151618);
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"information";
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    self.navigationItem.leftBarButtonItem = back;
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0],NSForegroundColorAttributeName:UIColorHex(0xFF9500)}];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setTintColor:UIColorHex(0xFF9500)];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [UIView new];
    
    [self getDataSource];
}

-(void)backClick{

    [self.navigationController popViewControllerAnimated:YES];
}
-(void)getDataSource{
    
    [InformationViewModel getNotificationListWithBlock:^(NSArray * _Nonnull dataSource, NSError * _Nonnull error) {
        if (!error) {
            self.dataSource = [NSMutableArray arrayWithArray:dataSource];
            
            
            [self.tableView reloadData];
        }
    }];
    
    
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InformationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[InformationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.backgroundColor = UIColorHex(0x151618);
    
    InformationModel *model = self.dataSource[indexPath.row];
    [cell setModel:model];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Width(152);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    InformationModel *model = self.dataSource[indexPath.row];
    
    if([model.type isEqualToString:@"1"]){
        MainViewController *MainVC = [[MainViewController alloc] init];
        
        MainVC.characterId = model.externalUrl;
        UINavigationController *nav = (UINavigationController *)self.xl_sldeMenu.rootViewController;
        [nav pushViewController:MainVC animated:NO];
    }else{
        InformationWebViewController *informationWenView = [[InformationWebViewController alloc] init];
        [informationWenView loadWebURLSring:model.internalUrl];
        [self.navigationController pushViewController:informationWenView animated:YES];
    }
    
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
