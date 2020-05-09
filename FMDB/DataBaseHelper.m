//
//  DataBaseHelper.m
//  FMDB
//
//  Created by ZhiYuan on 2019/6/17.
//  Copyright © 2019 ZhiYuan. All rights reserved.
//

#import "DataBaseHelper.h"

static FMDatabase * db = nil;

@implementation DataBaseHelper


/*创建数据库*/
+(void)creatSqlite:(NSString *)sqliteName{
   NSString * dbPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:sqliteName];
    ///判断是否z存在该地址, 如果存在说明已经创建过或者已经存在改地址
    NSFileManager * fileManager = [NSFileManager defaultManager];
    NSLog(@"%@", dbPath);
    BOOL result = [fileManager fileExistsAtPath:dbPath];
    db = [FMDatabase databaseWithPath:dbPath];
    if (result) {
        NSLog(@"已经创建过了");
    }else{
        NSLog(@"创建成功");
    }
}


/*创建表*/
+(void)creatTableName:(NSString *)tableName{
    //需要先k打开数据库
    [DataBaseHelper openSqlitestatueBlock:^(BOOL status) {
        if (status == YES) {
            
             //如果打开数据库成功那么就创建表格, ID是搜索关键字;
            NSString * tabelNameString = [NSString stringWithFormat:@"create table if not exists %@('ID' INTEGER PRIMARY KEY AUTOINCREMENT , 'name' TEXT NOT NULL, 'phone' TEXT NOT NULL, 'score' TEXT NOT NULL)",tableName];
            //判断是否创建成功
            BOOL result = [db executeUpdate:tabelNameString];
            if (result) {
                NSLog(@"创建成功");
            }else{
                NSLog(@"创建失败");
            }
            // 之后进行关闭
            [DataBaseHelper closeSqliteStatusBlock:^(BOOL status) {
                if (status == YES) {
                    NSLog(@"关闭成功");
                }else{
                    NSLog(@"关闭失败");
                }
            }];
            NSLog(@"打开成功");
        }else{
            NSLog(@"打开失败");
        }
    }];    
}

/*添加单条数据*/
+(void)AddSqliteID:(NSString *)ID name:(NSString *)name phone:(NSString *)phone score:(NSString *)score tableName:(NSString *)tableName success:(void(^)(BOOL stauts))success fail:(void(^)(BOOL status))fail{
    [DataBaseHelper openSqlitestatueBlock:^(BOOL status) {
        if (status == YES) {
            NSLog(@"打开数据库成功");
            
            [db beginTransaction];
            BOOL isRollBack = NO;
            @try {
                BOOL result = [db executeUpdate:[NSString stringWithFormat:@"insert into '%@'(ID,name,phone,score) values(?,?,?,?)", tableName] withArgumentsInArray:@[ID, name, phone, score]];
                if (result) {
                    NSLog(@"插入成功");
                    success(YES);
                    
                }else{
                    NSLog(@"插入失败");
                    fail(NO);
                }
            } @catch (NSException *exception) {
                isRollBack = YES;
                [db rollback];
            } @finally {
                if (!isRollBack) {
                    [db commit];
                }
            }

            
            [DataBaseHelper closeSqliteStatusBlock:^(BOOL status) {
                if (status == YES) {
                    NSLog(@"关闭数据库成功");
                }else{
                    NSLog(@"关闭数据库失败");
                }
            }];
        }else{
            NSLog(@"打开数据库失败");
        }
    }];
}

/*添加多条数据*/
+(void)addSqliteTableName:(NSString *)tableName modelArray:(NSArray * )modelArray failArray:(nonnull void (^)(NSArray * _Nonnull))failArray{
    NSMutableArray * failArrays = [@[]mutableCopy];
    [DataBaseHelper openSqlitestatueBlock:^(BOOL status) {
        if (status) {
            [db beginTransaction];
            BOOL isRollBack = NO;
            @try {
                for (int i = 0; i< modelArray.count; i++) {
                    BOOL result = [db executeUpdate:[NSString stringWithFormat:@"insert into '%@'(ID,name, phone, score) values(?,?,?,?)", tableName] withArgumentsInArray:@[modelArray[i][@"ID"], modelArray[i][@"name"], modelArray[i][@"phone"], modelArray[i][@"score"]]];
                    if (result) {
                        NSLog(@"插入成功");
                    }else{
                        [failArrays addObject:modelArray[i][@"ID"]];
                        NSLog(@"插入失败");
                    }
                }
                failArray(failArrays);
            } @catch (NSException *exception) {
                isRollBack = YES;
                [db rollback];
            } @finally {
                if (!isRollBack) {
                    [db commit];
                }
            }
           
            [DataBaseHelper closeSqliteStatusBlock:^(BOOL status) {
                if (status) {
                    NSLog(@"关闭数据库成功");
                }else{
                    NSLog(@"关闭数据库失败");
                }
            }];
            NSLog(@"打开数据库成功");
        }else{
            NSLog(@"打开数据库失败");
        }
    }];
}
/*查询数据*/
+(void)selectSqliteWithTable:(NSString *)tableName sqliteID:(NSString *)ID success:(void(^)(NSDictionary * dic))success faila:(void(^)(BOOL fail))fail{
    [DataBaseHelper openSqlitestatueBlock:^(BOOL status) {
        if (status == YES) {
            //                NSString * string = [NSString stringWithFormat:@"select * from %@ where ID < ?", tableName];查询ID小于多少的全部数据
            //                NSString * string = [NSString stringWithFormat:@"select * from %@ where ID > ?", tableName];查询ID大于多少的全部数据
            //                NSString * string = [NSString stringWithFormat:@"select * from %@ ", tableName];查询表内的全部数据
            [db beginTransaction];
            BOOL isRollBack = NO;
            @try {
                NSString * string = [NSString stringWithFormat:@"select * from %@ where ID = ?", tableName];
                FMResultSet * result = [db executeQuery:string withArgumentsInArray:@[ID]];
               if([result next]) {
                    NSString * sID = [result stringForColumn:@"ID"];
                    NSString * name = [result stringForColumn:@"name"];
                    NSString * phone = [result stringForColumn:@"phone"];
                    NSString * score = [result stringForColumn:@"score"];
                    NSMutableDictionary * dic = [@{}mutableCopy];
                    [dic setValue:sID forKey:@"ID"];
                    [dic setValue:name forKey:@"name"];
                    [dic setValue:phone forKey:@"phone"];
                    [dic setValue:score forKey:@"score"];
                    success(dic);
                }else if (![result next]) {
                    fail(NO);
                }
            } @catch (NSException *exception) {
                isRollBack = YES;
                [db rollback];
            } @finally {
                if (!isRollBack) {
                    [db commit];
                }
            }
           
            [DataBaseHelper closeSqliteStatusBlock:^(BOOL status) {
                if (status == YES) {
                    NSLog(@"关闭成功");
                }else{
                    NSLog(@"关闭失败");
                }
            }];
            NSLog(@"打开数据库成功");
        }else{
            NSLog(@"打开数据库失败");
        }
    }];
}

/*查询多条数据*/
+(void)selectArraySqliteWithTable:(NSString *)tableName sqliteArray:(NSArray *)sqliteArray success:(void(^)(NSArray * array, NSArray * notSelectArray))success fail:(void(^)(BOOL fail))fail{
    [DataBaseHelper openSqlitestatueBlock:^(BOOL status) {
        if (status == YES) {
            [db beginTransaction];
            BOOL isRollBack = NO;
            @try {
                NSMutableArray * array = [@[]mutableCopy];
                NSMutableArray * notSelectArray = [@[]mutableCopy];
                for (int i = 0; i < sqliteArray.count; i++) {
                    NSString * string = [NSString stringWithFormat:@"select * from %@ where ID = ?", tableName];
                    FMResultSet * result = [db executeQuery:string withArgumentsInArray:@[sqliteArray[i]]];
                    if ([result next]) {
                        NSString * sID = [result stringForColumn:@"ID"];
                        NSString * name = [result stringForColumn:@"name"];
                        NSString * phone = [result stringForColumn:@"phone"];
                        NSString * score = [result stringForColumn:@"score"];
                        NSMutableDictionary * dic = [@{}mutableCopy];
                        [dic setValue:sID forKey:@"ID"];
                        [dic setValue:name forKey:@"name"];
                        [dic setValue:phone forKey:@"phone"];
                        [dic setValue:score forKey:@"score"];
                        [array addObject:dic];
                    }else{
                        [ notSelectArray addObject:sqliteArray[i]];
                    }
                }
                success(array, notSelectArray);
            } @catch (NSException *exception) {
                isRollBack = YES;
                [db rollback];
            } @finally {
                if(!isRollBack){
                    [db commit];
                }
            }
        
            [DataBaseHelper closeSqliteStatusBlock:^(BOOL status) {
                if (status == YES) {
                    NSLog(@"关闭数据库成功");
                }else{
                    NSLog(@"关闭数据库失败");
                }
            }];
            
            NSLog(@"打开成功了");
        }else{
            NSLog(@"打开失败了");
        }
    }];
}
/*查询数据库中所有数据*/
+(void)selectSqliteAllModelWithTable:(NSString *)table success:(void(^)(NSArray * array))success fail:(void(^)(BOOL fail))fail{
    [DataBaseHelper openSqlitestatueBlock:^(BOOL status) {
        if (status == YES) {
            [db beginTransaction];
            BOOL isRollBack = NO;
            @try {
                NSMutableArray * array = [@[]mutableCopy];
                FMResultSet * set = [db executeQuery:[NSString stringWithFormat:@"select * from %@", table]] ;
                while ([set next]) {
                    NSMutableDictionary * dic = [@{}mutableCopy];
                    [dic setValue:[set stringForColumn:@"ID"] forKey:@"ID"];
                    [dic setValue:[set stringForColumn:@"name"] forKey:@"name"];
                    [dic setValue:[set stringForColumn:@"phone"] forKey:@"phone"];
                    [dic setValue:[set stringForColumn:@"score"] forKey:@"score"];
                    [array addObject:dic];
                }
                success(array);
            } @catch (NSException *exception) {
                isRollBack = YES;
                [db rollback];
            } @finally {
                if (!isRollBack) {
                    [db commit];
                }
            }
            
            [DataBaseHelper closeSqliteStatusBlock:^(BOOL status) {
                if (status == YES) {
                    NSLog(@"关闭数据库成功");
                }else{
                    NSLog(@"关闭数据库失败");
                }
            }];
        }else{
        }
    }];
}
/*删除数据库中的某一条数据*/
+(void)deleteSqlitiWithTable:(NSString *)table sqliteID:(NSString *)sqliteId success:(void(^)(BOOL success))success fail:(void(^)(BOOL fail))fail{
    [DataBaseHelper openSqlitestatueBlock:^(BOOL status) {
        if (status == YES) {
            [db beginTransaction];
            BOOL isRollBack = NO;
            @try {
                NSString * string = [NSString stringWithFormat:@"delete  from %@ where ID = ?", table];
                BOOL result = [db executeUpdate:string withArgumentsInArray:@[(sqliteId)]];
                if (result) {
                    success(YES);
                }else{
                    fail(NO);
                }
                NSLog(@"数据库打开成功");
            } @catch (NSException *exception) {
                isRollBack = YES;
                [db rollback];
            } @finally {
                if (!isRollBack) {
                    [db commit];
                }
            }
            
            [DataBaseHelper closeSqliteStatusBlock:^(BOOL status) {
                if(status == YES){
                    NSLog(@"数据库关闭成功");
                }else{
                    NSLog(@"数据库关闭失败");
                }
            }];
        }else{
            NSLog(@"数据库打开失败");
        }
    }];
}
/*删除数据库中的多条数据*/
+(void)deleteSqliteArrayWithTable:(NSString *)table sqliteArray:(NSArray *)sqliteArray success:(void(^)(BOOL success))success fail:(void(^)(NSArray * failArray))fail{
    [DataBaseHelper openSqlitestatueBlock:^(BOOL status) {
        if (status) {
//                BOOL result = [db executeUpdate:[NSString stringWithFormat:@"delete from %@ where ID = ?", table] withArgumentsInArray:sqliteArray];
            [db beginTransaction];
            BOOL isRollBack = NO;
            @try {
                NSString *strings = [NSString stringWithFormat:@"delete from %@ where ID = ?", table];
                NSMutableArray * array = [@[]mutableCopy];
                for (int i = 0; i < sqliteArray.count; i++) {
                    BOOL result = [db executeUpdate:strings withArgumentsInArray:@[sqliteArray[i]]];
                    if (result) {
                        NSLog(@"删除成功");
                    }else{
                        NSLog(@"删除失败");
                        [array addObject:sqliteArray[i]];
                    }
                }
                if (array.count == 0) {
                    success(YES);
                }else{
                    fail(array);
                }
                NSLog(@"打开数据库成功");
            } @catch (NSException *exception) {
                isRollBack = YES;
                [db rollback];
            } @finally {
                if (!isRollBack) {
                    [db commit];
                }
            }
           
            [DataBaseHelper closeSqliteStatusBlock:^(BOOL status) {
                if (status == YES) {
                    NSLog(@"关闭数据库成功");
                }else{
                    NSLog(@"关闭数据库失败");
                }
            }];
        }else{
            NSLog(@"打开数据库失败");
        }
    }];
}

/*删除数据库中的所有数据*/
+(void)deleteSqliteAllModelsWithTable:(NSString *)table success:(void(^)(BOOL success))success fail:(void(^)(NSArray *array))fail{
    [DataBaseHelper openSqlitestatueBlock:^(BOOL status) {
        if (status == YES) {
            [db beginTransaction];
            BOOL isRollBack = NO;
            @try {
                BOOL result = [db executeUpdate:[NSString stringWithFormat:@"delete from %@", table]];
                if (result) {
                    NSLog(@"删除成功");
                    success(YES);
                }else{
                    NSLog(@"删除失败");
                }
            } @catch (NSException *exception) {
                isRollBack = YES;
                [db rollback];
            } @finally {
                if (!isRollBack) {
                    [db commit];
                }
            }
            
            [DataBaseHelper closeSqliteStatusBlock:^(BOOL status) {
                if (status == YES) {
                    NSLog(@"关闭数据库成功");
                }else{
                    NSLog(@"关闭数据库失败");
                }
            }];
            NSLog(@"打开数据库成功");
        }else{
            NSLog(@"打开数据库失败");
        }
    }];
}

/*修改数据库中的单条数据*/
+(void)updataSqliteWithTable:(NSString *)table ID:(NSString *)ID name:(NSString *)name phone:(NSString *)phone score:(NSString *)score success:(void(^)(BOOL status))success fail:(void(^)(BOOL statue))fail{
    [DataBaseHelper openSqlitestatueBlock:^(BOOL status) {
        if (status == YES) {
            [db beginTransaction];
            BOOL isRollBack = NO;
            @try {
                NSString * string = [NSString stringWithFormat:@"update %@ set phone = ? where ID = ?", table];
                //             [db executeQuery:string withArgumentsInArray:@[phone, name, score , @299]];
                BOOL result = [db executeUpdate:@"update persionTable set phone = ? , name = ? , score = ?  where ID = ?",name ,phone, score,ID ];
                if (result) {
                    success(YES);
                }else{
                    fail(NO);
                }
            }
            @catch (NSException *exception) {
                isRollBack = YES;
                [db rollback];
            }
            @finally {
                if (!isRollBack) {
                    [db commit];
                }
            }
            
            [DataBaseHelper closeSqliteStatusBlock:^(BOOL status) {
                if (status == YES) {
                    NSLog(@"关闭数据库成功");
                }else{
                    NSLog(@"关闭数据库失败");
                }
            }];
            
            NSLog(@"打开数据库成功");
        }else{
            NSLog(@"打开数据库失败");
        }
    }];
   
}
/*修改数据库中的多组数据*/
+(void)updataSqliteWithTable:(NSString *)table sqliteArray:(NSArray * )sqliteArray success:(void(^)(BOOL status))success fail:(void(^)(NSArray * failArray))fail{
    NSMutableArray * notUpdateArray = [@[]mutableCopy];
    [DataBaseHelper openSqlitestatueBlock:^(BOOL status) {
        if (status == YES) {
            [db beginTransaction];
            BOOL isRollBack = NO;
            @try {
                for (int i = 0; i < sqliteArray.count; i++) {
                    NSString * string = [NSString stringWithFormat:@"update persionTable set name = ?, phone = ?, score = ? where ID = ?"];
                    //                BOOL result = [db executeQuery:string withArgumentsInArray:@[sqliteArray[i][@"name"], sqliteArray[i][@"phone"], sqliteArray[i][@"score"], sqliteArray[i][@"ID"]]];
                    BOOL result = [db executeUpdate:@"update persionTable set phone = ? , name = ? , score = ?  where ID = ?",sqliteArray[i][@"phone"] ,sqliteArray[i][@"name"], sqliteArray[i][@"score"],sqliteArray[i][@"ID"] ];
                    if (result) {
                        
                    }else{
                        [notUpdateArray addObject: sqliteArray[i]];
                    }
                }
                if (notUpdateArray.count == 0) {
                    success(YES);
                }else{
                    fail(notUpdateArray);
                }
            } @catch (NSException *exception) {
                isRollBack = YES;
                [db rollback];
            } @finally {
                if (!isRollBack) {
                    [db commit];
                }
            }
            
            
            
            [DataBaseHelper closeSqliteStatusBlock:^(BOOL status) {
                if (status == YES) {
                    NSLog(@"关闭数据库成功");
                }else{
                    NSLog(@"关闭数据库失败");
                }
            }];
            
            NSLog(@"打开数据库成功");
        }else{
            NSLog(@"打开数据库失败");
        }
    }];
   
    
}

/*打开数据库*/
+ (BOOL)openSqlitestatueBlock:(void(^)(BOOL status))statusBlock{
    
    [db open];
    if ([db open]) {
        statusBlock(YES);
        return  YES;
    }else{
        NSLog(@"打开失败了");
        statusBlock(NO);
        return NO;
    }
    
}
/*关闭数据库*/
+(BOOL)closeSqliteStatusBlock:(void (^)(BOOL))statusBlock{
    [db close];
    
    if ([db close]) {
        NSLog(@"关闭数据库了");
        statusBlock(YES);
         return YES;
    }else{
        statusBlock(NO);
        NSLog(@"关闭数据库失败了");
        return NO;
    }
}

@end
