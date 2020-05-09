//
//  model.h
//  FMDB
//
//  Created by ZhiYuan on 2019/6/18.
//  Copyright © 2019 ZhiYuan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface model : NSObject

@property(nonatomic, copy)NSString * ID;
@property (nonatomic, copy)NSString * name;
@property (nonatomic, copy)NSString * phone;
@property (nonatomic, copy)NSString * score;

- (id)initWithDic:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
