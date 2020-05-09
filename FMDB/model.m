//
//  model.m
//  FMDB
//
//  Created by ZhiYuan on 2019/6/18.
//  Copyright © 2019 ZhiYuan. All rights reserved.
//

#import "model.h"

@implementation model

- (id)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
