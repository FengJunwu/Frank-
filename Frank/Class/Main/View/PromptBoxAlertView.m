
//
//  PromptBoxAlertView.m
//  Frank
//
//  Created by fengjunwu on 2019/6/27.
//  Copyright © 2019 819134700@qq.com. All rights reserved.
//

#import "PromptBoxAlertView.h"
#import "VoiceAssistantModel.h"

@interface PromptBoxAlertView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UIView *bg_View;

@property (nonatomic,strong)UITableView *tabelView;
@property (nonatomic,strong)NSMutableArray *textRecognizeDataSource;

@end

@implementation PromptBoxAlertView

-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

-(UITableView *)tabelView{
    if (!_tabelView) {
        _tabelView = [[UITableView alloc] initWithFrame:CGRectMake(15, 60, kMainScreenWidth *0.8 - 30, kMainScreenHeight *0.55 - 90) style:UITableViewStylePlain];
        _tabelView.delegate = self;
        _tabelView.dataSource = self;
        _tabelView.backgroundColor = [UIColor clearColor];
        
    }
    return _tabelView;
}

-(NSMutableArray *)textRecognizeDataSource{
    if (!_textRecognizeDataSource) {
        _textRecognizeDataSource = [[NSMutableArray alloc] init];
    }
    return _textRecognizeDataSource;
}


-(void)setDataSource:(NSArray *)dataSource{
    VoiceAssistantModel *model = dataSource[0];
    for (NSDictionary *dic in model.textRecognize) {
        textRecognize *textRModel = [textRecognize modelWithDictionary:dic];
        [self.textRecognizeDataSource addObject:textRModel];
        [self.tabelView reloadData];
    }
}



-(void)configUI{
    
    UIView *bg_View = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    bg_View.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1f];
    [self addSubview:bg_View];
    self.bg_View = bg_View;
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap)];
    [singleTapGestureRecognizer setNumberOfTapsRequired:1];
    [self.bg_View  addGestureRecognizer:singleTapGestureRecognizer];
    

    
    UIView *white_View = [[UIView alloc] init];
    white_View.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [self addSubview:white_View];
    //    [bg_View addSubview:white_View];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"Voice commands";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:15];
    titleLabel.numberOfLines = 1;
    [white_View addSubview:titleLabel];
    
    ///添加tableView
    [white_View addSubview:self.tabelView];
    
    
    white_View.sd_layout
    .centerXEqualToView(bg_View)
    .centerYEqualToView(bg_View)
    .widthRatioToView(bg_View, 0.8)
    .heightRatioToView(bg_View, 0.55);
    white_View.sd_cornerRadius = @20;
    
//    white_View.sd_layout
//    .centerXEqualToView(self)
//    .centerYEqualToView(self)
//    .widthRatioToView(self, 1)
//    .heightRatioToView(self,1);
//    white_View.sd_cornerRadius = @20;
    
    
    titleLabel.sd_layout
    .topSpaceToView(white_View, 18)
    .leftSpaceToView(white_View, 30)
    .rightSpaceToView(white_View, 20)
    .heightIs(21);
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.textRecognizeDataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    textRecognize *model = self.textRecognizeDataSource[indexPath.row];
    NSString *path = [NSString stringWithFormat:@"%@%@",[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject],model.commandImg];
    cell.imageView.image = [UIImage imageWithContentsOfFile:path];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.textLabel.text = model.keyWord;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Width(44);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


#pragma mark-- 单击手势
-(void)singleTap{
    [self removeFromSuperview];
    [self.bg_View removeFromSuperview];
    [[self.bg_View subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.bg_View = nil;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
