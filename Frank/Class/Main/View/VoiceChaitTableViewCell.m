//
//  VoiceChaitTableViewCell.m
//  Frank
//
//  Created by fengjunwu on 2019/7/4.
//  Copyright © 2019 819134700@qq.com. All rights reserved.
//

#import "VoiceChaitTableViewCell.h"

@interface VoiceChaitTableViewCell()

@property (nonatomic,strong)UILabel *askLabel;
@property (nonatomic,strong)UIView *bgView;

@end

@implementation VoiceChaitTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
        _bgView.left = 0;
        _bgView.top = 0;
        _bgView.width = kMainScreenWidth * 0.7;
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.cornerRadius = 5;
        [self.contentView addSubview:_bgView];
        
        _askLabel = [[UILabel alloc] init];
        _askLabel.textColor = [UIColor whiteColor];
        _askLabel.font = [UIFont systemFontOfSize:12];
        _askLabel.left = 8;
        _askLabel.top = 8;
        _askLabel.width = kMainScreenWidth * 0.7 - 16;
        _askLabel.numberOfLines = 0;
        [self.contentView addSubview:_askLabel];
        
    }
    return self;
}

-(void)setModel:(VoiceChaitModel *)model{
    
    _bgView.height = model.height + 16;
    _askLabel.height = model.height;
    _askLabel.text = model.ask;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
