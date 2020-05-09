//
//  TableViewCell.m
//  FMDB
//
//  Created by ZhiYuan on 2019/6/18.
//  Copyright © 2019 ZhiYuan. All rights reserved.
//

#import "TableViewCell.h"
#import "SDAutoLayout.h"

@interface TableViewCell ()
@property (nonatomic, strong)UILabel * IDLable;
@property (nonatomic, strong)UILabel * nameLable;
@property(nonatomic, strong)UILabel * phoneLable;
@property (nonatomic, strong)UILabel * scoreLable;
@end

@implementation TableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatView];
    }
    return self;
}

- (void)creatView{
    [self.contentView addSubview:self.IDLable];
    [self.contentView addSubview:self.nameLable];
    [self.contentView addSubview:self.phoneLable];
    [self.contentView addSubview:self.scoreLable];
    [self layout];
}
- (void)layout{
    self.IDLable.sd_layout
    .leftEqualToView(self.contentView)
    .topEqualToView(self.contentView)
    .heightIs(30)
    .widthIs([UIScreen mainScreen].bounds.size.width/4);
//    [self.IDLable setSingleLineAutoResizeWithMaxWidth:[UIScreen mainScreen].bounds.size.width/2/3];
    
    self.nameLable.sd_layout
    .leftSpaceToView(self.IDLable, 3)
    .topEqualToView(self.IDLable)
    .heightIs(30)
   .widthIs([UIScreen mainScreen].bounds.size.width/4);
//    [self.IDLable setSingleLineAutoResizeWithMaxWidth:[UIScreen mainScreen].bounds.size.width/2/3];
    
    self.phoneLable.sd_layout
    .leftSpaceToView(self.nameLable, 3)
    .topEqualToView(self.contentView)
    .heightIs(30)
    .widthIs([UIScreen mainScreen].bounds.size.width/4);
//    [self.phoneLable setSingleLineAutoResizeWithMaxWidth:[UIScreen mainScreen].bounds.size.width/2];
    
    self.scoreLable.sd_layout
   .leftSpaceToView(self.phoneLable, 3)
    .topEqualToView(self.nameLable)
    .heightIs(30)
.widthIs([UIScreen mainScreen].bounds.size.width/4);
//    [self.scoreLable setSingleLineAutoResizeWithMaxWidth:[UIScreen mainScreen].bounds.size.width / 2/3];
}


- (void)setModels:(model *)models{
    if (_models != models) {
        _models = models;
    }
    self.IDLable.text = models.ID;
    self.nameLable.text = models.name;
    self.phoneLable.text = models.phone;
    self.scoreLable.text = models.score;
    
}

- (UILabel *)IDLable{
    if (!_IDLable) {
        _IDLable = [[UILabel alloc]init];
        _IDLable.text = @"123";
        _IDLable.font = [UIFont systemFontOfSize:13];
        _IDLable.textColor = [UIColor blackColor];
        _IDLable.textAlignment = NSTextAlignmentCenter;
    }
    return _IDLable;
}

- (UILabel *)nameLable{
    if (!_nameLable) {
        _nameLable = [[UILabel alloc]init];
        _nameLable.text = @"hello";
        _nameLable.font = [UIFont systemFontOfSize:13];
        _nameLable.textColor = [UIColor grayColor];
        _nameLable.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLable;
}

- (UILabel *)phoneLable{
    if (!_phoneLable) {
        _phoneLable = [UILabel new];
        _phoneLable.text = @"121212121";
        _phoneLable.font = [UIFont systemFontOfSize:13];
        _phoneLable.textColor = [UIColor grayColor];
        _phoneLable.textAlignment = NSTextAlignmentCenter;
    }
    return _phoneLable;
}
- (UILabel *)scoreLable{
    if (!_scoreLable) {
        _scoreLable = [UILabel new];
        _scoreLable.text = @"99.5";
        _scoreLable.font = [UIFont systemFontOfSize:13];
        _scoreLable.textColor = [UIColor grayColor];
        _scoreLable.textAlignment = NSTextAlignmentCenter;
    }
    return _scoreLable;
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
