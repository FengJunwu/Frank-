//
//  VideoTableViewCell.m
//  Frank
//
//  Created by fengjunwu on 2019/6/29.
//  Copyright © 2019 819134700@qq.com. All rights reserved.
//

#import "VideoTableViewCell.h"

@implementation VideoTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = UIColorHex(0x151618);
        
        self.imgView = [[UIImageView alloc] init];
        self.imgView.size = CGSizeMake(kScreenWidth - 30, 108 *  (kScreenWidth - 30) / 330.0);
        self.imgView.origin = CGPointMake(Width(15), Width(8));
        self.imgView.layer.cornerRadius = Width(5);
        self.imgView.layer.masksToBounds = YES;
        self.imgView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.imgView];
        
        UIView *maskView = [[UIView alloc] init];
        maskView.size = self.imgView.size;
        maskView.origin = CGPointMake(0, 0);
        maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
        [self.imgView addSubview:maskView];
        
        self.titlelabel = [[UILabel alloc] init];
        self.titlelabel.font = [UIFont boldSystemFontOfSize:Font(21)];
        self.titlelabel.textColor = [UIColor whiteColor];
        self.titlelabel.size = CGSizeMake(kScreenWidth - Width(60), Width(26));
        self.titlelabel.origin = CGPointMake(Width(15), Width(60));
        [maskView addSubview:self.titlelabel];
        
        self.sublabel = [[UILabel alloc] init];
        self.sublabel.font = [UIFont boldSystemFontOfSize:Font(12)];
        self.sublabel.textColor = [UIColor whiteColor];
        self.sublabel.size = CGSizeMake(kScreenWidth - Width(60), Width(22));
        self.sublabel.origin = CGPointMake(Width(15), Width(86));
        [maskView addSubview:self.sublabel];
        
        
        
    }
    return self;
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
