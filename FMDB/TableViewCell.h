//
//  TableViewCell.h
//  FMDB
//
//  Created by ZhiYuan on 2019/6/18.
//  Copyright © 2019 ZhiYuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "model.h"
NS_ASSUME_NONNULL_BEGIN

@interface TableViewCell : UITableViewCell
@property (nonatomic, strong)model * models;
@end

NS_ASSUME_NONNULL_END
