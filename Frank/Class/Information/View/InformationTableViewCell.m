//
//  InformationTableViewCell.m
//  Frank
//
//  Created by fengjunwu on 2019/7/6.
//  Copyright © 2019 819134700@qq.com. All rights reserved.
//

#import "InformationTableViewCell.h"

@interface InformationTableViewCell()

@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)YYLabel *contentLabel;
@property(nonatomic,strong)UIImageView *imgView;

@end

@implementation InformationTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = UIColorHex(0x151618);
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"MISSDOLL MARK-1-ORAL published during 2019 AVN";
        _titleLabel.font = [UIFont systemFontOfSize:Font(12)];
        _titleLabel.textColor = UIColorHex(0xFFFFFF);
        _titleLabel.size = CGSizeMake(kMainScreenWidth - Width(30), Width(17));
        _titleLabel.origin = CGPointMake(Width(15), Width(15));
        [self.contentView addSubview:_titleLabel];
        
        _imgView = [[UIImageView alloc] init];
        _imgView.image = [UIImage imageNamed:@"音频"];
        _imgView.size = CGSizeMake(Width(135), Width(100));
        _imgView.origin = CGPointMake(Width(15), _titleLabel.bottom + Width(5));
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.layer.masksToBounds = YES;
        [self.contentView addSubview:_imgView];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.text = @"2019-05-24";
        _timeLabel.font = [UIFont systemFontOfSize:Font(11)];
        _timeLabel.textColor = [UIColorHex(0xFFFFFF) colorWithAlphaComponent:0.3];
        _timeLabel.size = CGSizeMake(kMainScreenWidth - Width(160), Width(17));
        _timeLabel.origin = CGPointMake(_imgView.right + Width(10), _titleLabel.bottom + Width(5));
        [self.contentView addSubview:_timeLabel];
//
        
        _contentLabel = [[YYLabel alloc] init];
        _contentLabel.text = @"This entry was posted in Uncategorized on January 10, 2019 by ruiai. MARK-1-ORAL published during 2019 AVNMISSDOLL MARK-1-ORAL published duringMARK-1-ORAL published during posted in Uncategorized on January 10, 2019 by ruiai. MARK-1-ORAL published during 2019 AVNMISSDOLL MARK-1-ORAL published duringMARK-1-ORAL published during ";
        _contentLabel.font = [UIFont systemFontOfSize:Font(11)];
        _contentLabel.textColor = [UIColorHex(0xFFFFFF) colorWithAlphaComponent:0.3];
        _contentLabel.numberOfLines = 0;
        _contentLabel.left = _imgView.right + Width(10);
        _contentLabel.top = _timeLabel.bottom + Width(5);
        _contentLabel.width = kMainScreenWidth - Width(160);
        _contentLabel.height = _imgView.height - _timeLabel.height;
        _contentLabel.textVerticalAlignment = YYTextVerticalAlignmentTop;
        
        [self.contentView addSubview:_contentLabel];
        
    }
    return self;
}

-(void)setModel:(InformationModel *)model{
    _titleLabel.text  = model.title;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:model.pic]];
    _contentLabel.text = model.content;
    
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
