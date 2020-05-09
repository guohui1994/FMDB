//
//  DataBaseHelper.h
//  FMDB
//
//  Created by ZhiYuan on 2019/6/17.
//  Copyright © 2019 ZhiYuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"

NS_ASSUME_NONNULL_BEGIN

@interface DataBaseHelper : NSObject



/*创建数据库*/
+(void)creatSqlite:(NSString *)sqliteName;
/*创建表*/
+(void)creatTableName:(NSString *)tableName;


/*添加单条数据*/
+(void)AddSqliteID:(NSString *)ID name:(NSString *)name phone:(NSString *)phone score:(NSString *)score tableName:(NSString *)tableName success:(void(^)(BOOL stauts))success fail:(void(^)(BOOL status))fail;
/*添加多条数据*/
+(void)addSqliteTableName:(NSString *)tableName modelArray:(NSArray * )modelArray failArray:(void(^)(NSArray * failArray)) failArray;
/*查询单条数据*/
+(void)selectSqliteWithTable:(NSString *)tableName sqliteID:(NSString *)ID success:(void(^)(NSDictionary * dic))success faila:(void(^)(BOOL fail))fail;
/*查询多条数据*/
+(void)selectArraySqliteWithTable:(NSString *)tableName sqliteArray:(NSArray *)sqliteArray  success:(void(^)(NSArray * array, NSArray * notSelectArray))success fail:(void(^)(BOOL fail))fail;
/*查询数据库中所有数据*/
+(void)selectSqliteAllModelWithTable:(NSString *)table success:(void(^)(NSArray * array))success fail:(void(^)(BOOL fail))fail;
/*删除数据库中的某一条数据*/
+(void)deleteSqlitiWithTable:(NSString *)table sqliteID:(NSString *)sqliteId success:(void(^)(BOOL success))success fail:(void(^)(BOOL fail))fail;
/*删除数据库中的多条数据*/
+(void)deleteSqliteArrayWithTable:(NSString *)table sqliteArray:(NSArray *)sqliteArray success:(void(^)(BOOL success))success fail:(void(^)(NSArray * failArray))fail;
/*删除数据库中的所有数据*/
+(void)deleteSqliteAllModelsWithTable:(NSString *)table success:(void(^)(BOOL success))success fail:(void(^)(NSArray *array))fail;

/*修改数据库中的单条数据*/
+(void)updataSqliteWithTable:(NSString *)table ID:(NSString *)ID name:(NSString *)name phone:(NSString *)phone score:(NSString *)score success:(void(^)(BOOL status))success fail:(void(^)(BOOL statue))fail;
/*修改数据库中的多组数据*/
+(void)updataSqliteWithTable:(NSString *)table sqliteArray:(NSArray * )sqliteArray success:(void(^)(BOOL status))success fail:(void(^)(NSArray * failArray))fail;
/*打开数据库*/
+ (BOOL)openSqlitestatueBlock:(void(^)(BOOL status))statusBlock;
/*关闭数据库*/
+(BOOL)closeSqliteStatusBlock:(void(^)(BOOL status))statusBlock;


@end

NS_ASSUME_NONNULL_END
