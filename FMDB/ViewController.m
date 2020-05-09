//
//  ViewController.m
//  FMDB
//
//  Created by ZhiYuan on 2019/6/17.
//  Copyright © 2019 ZhiYuan. All rights reserved.
//

#import "ViewController.h"
#import "DataBaseHelper.h"
#import "SDAutoLayout.h"
#import "TableViewCell.h"
#import "model.h"
@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UIButton * selectButton;//查询button
@property (nonatomic, strong)UIButton * selectArrayButton;//多条数据查询
@property (nonatomic, strong)UIButton * selectAllModelButton;
@property (nonatomic, strong)UIButton * addButton;//单条添加button
@property (nonatomic, strong)UIButton * addArrayButton;//多条添加Button

@property (nonatomic, strong)UIButton * changeButton;//改button
@property (nonatomic, strong)UIButton * updataArrayButton;//修改多条数据
@property (nonatomic, strong)UIButton * deleteButton;//删除button
@property (nonatomic, strong)UIButton * deleteArrayButton;//删除多条数据
@property (nonatomic, strong)UIButton * deleteAllModelsButton;//删除数据库中的所有数据

@property (nonatomic, strong)UITableView * table;
@property (nonatomic, strong)NSMutableArray * dataSourceArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.table];
    self.dataSourceArray = [@[]mutableCopy];
    [self creatView];
    [DataBaseHelper creatSqlite:@"persion"];
    [DataBaseHelper creatTableName:@"persionTable"];
}
#pragma mark -----点击方法
/*查询*/
- (void)selectSqlite{
    [DataBaseHelper selectSqliteWithTable:@"persionTable" sqliteID:@"135" success:^(NSDictionary * _Nonnull dic) {
        [self.dataSourceArray removeAllObjects];
        model * models = [[model alloc]initWithDic:dic];
        [self.dataSourceArray addObject:models];
        [self.table reloadData];
    } faila:^(BOOL fail) {
        UIAlertController * alter = [UIAlertController alertControllerWithTitle:@"无该条数据" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction * cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alter addAction:sure];
        [alter addAction:cancle];
        [self presentViewController:alter animated:YES completion:nil];
    }];
}
/*查询多条*/
- (void)selectArrayButtons{
    [DataBaseHelper selectArraySqliteWithTable:@"persionTable" sqliteArray:@[@"100", @"200", @"1", @"2", @"10", @"20", @"22", @"23", @"27", @"25", @"30", @"35", @"40"] success:^(NSArray * _Nonnull array ,NSArray * _Nonnull notSelectArray) {
        [self.dataSourceArray removeAllObjects];
        for (NSDictionary * dic in array) {
            model * models = [[model alloc]initWithDic:dic];
            [self.dataSourceArray addObject:models];
        }
        [self.table reloadData];
        if (notSelectArray.count == 0) {
            
        }else{
        NSString * string = @"";
        for (NSString * strings in notSelectArray) {
            string = [string stringByAppendingString:[NSString stringWithFormat:@"%@,", strings]];
        }
        UIAlertController * alter = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"未查到%@数据", string] message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction * cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alter addAction:sure];
        [alter addAction:cancle];
        [self presentViewController:alter animated:YES completion:nil];
        NSLog(@"%@----%@", array, notSelectArray);
        }
    } fail:^(BOOL fail) {
        UIAlertController * alter = [UIAlertController alertControllerWithTitle:@"查询失败" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction * cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alter addAction:sure];
        [alter addAction:cancle];
        [self presentViewController:alter animated:YES completion:nil];
    }];
}
/*查询数据库中所有数据*/
- (void)selectAllModelButtons{
    [DataBaseHelper selectSqliteAllModelWithTable:@"persionTable" success:^(NSArray * _Nonnull array) {
        [self.dataSourceArray removeAllObjects];
        for (NSDictionary * dic in array) {
            model * models = [[model alloc]initWithDic:dic];
            [self.dataSourceArray addObject:models];
        }
        [self.table reloadData];
        NSLog(@"%@", array);
    } fail:^(BOOL fail) {
        
    }];
}

/*添加单条数据到数据库*/
- (void)addToSqlite{
    [DataBaseHelper AddSqliteID:@"135" name:@"张三" phone:@"17533333333" score:@"100" tableName:@"persionTable" success:^(BOOL stauts) {
        [DataBaseHelper selectSqliteAllModelWithTable:@"persionTable" success:^(NSArray * _Nonnull array) {
            [self.dataSourceArray removeAllObjects];
            for (NSDictionary * dic in array) {
                model * models = [[model alloc]initWithDic:dic];
                [self.dataSourceArray addObject:models];
            }
            [self.table reloadData];
        } fail:^(BOOL fail) {
            
        }];
        UIAlertController * alter = [UIAlertController alertControllerWithTitle:@"数据添加成功" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction * cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alter addAction:sure];
        [alter addAction:cancle];
        [self presentViewController:alter animated:YES completion:nil];
    } fail:^(BOOL status) {
        UIAlertController * alter = [UIAlertController alertControllerWithTitle:@"数据添加失败" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction * cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alter addAction:sure];
        [alter addAction:cancle];
        [self presentViewController:alter animated:YES completion:nil];
    }];
}

/*添加多条数据到数据库*/
- (void)addArrayButtn{
    NSMutableArray * array = [NSMutableArray new];
    for (int i = 200; i < 300; i++) {
        NSString * ID = [NSString stringWithFormat:@"%d", i];
        NSString * name = [NSString stringWithFormat:@"张三%d", i];
        NSString * phone = [NSString stringWithFormat:@"175377%d", i];
        NSString * score = [NSString stringWithFormat:@"%d", i];
    
        NSMutableDictionary * dic = [@{} mutableCopy];
        [dic setValue:ID forKey:@"ID"];
        [dic setValue:name forKey:@"name"];
        [dic setValue:phone forKey:@"phone"];
        [dic setValue:score forKey:@"score"];
        [array addObject:dic];
    }
    [DataBaseHelper addSqliteTableName:@"persionTable" modelArray:array failArray:^(NSArray * _Nonnull failArray) {
        if (failArray.count == 0) {
            UIAlertController * alter = [UIAlertController alertControllerWithTitle:@"数据全部插入成功" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * sure = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            UIAlertAction * cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alter addAction:sure];
            [alter addAction:cancle];
            [self presentViewController:alter animated:YES completion:nil];
            
            [DataBaseHelper selectSqliteAllModelWithTable:@"persionTable" success:^(NSArray * _Nonnull array) {
                [self.dataSourceArray removeAllObjects];
                for (NSDictionary * dic in array) {
                    model * models = [[model alloc]initWithDic:dic];
                    [self.dataSourceArray addObject:models];
                }
                [self.table reloadData];
            } fail:^(BOOL fail) {
                
            }];
        }else{
             NSString * string = @"";
            for (NSString * dic in failArray) {
             string =   [string stringByAppendingString: [NSString stringWithFormat:@"%@,", dic]];
            }
            UIAlertController * alter = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"第%@插入失败", string] message:@"" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction * cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alter addAction:sure];
            [alter addAction:cancle];
            [self presentViewController:alter animated:YES completion:nil];
            
        }
    }];
}

/*修改*/
- (void)changeSqlite{
    [DataBaseHelper updataSqliteWithTable:@"persionTable" ID:@"299" name:@"李四" phone:@"1000000000000" score:@"99.5" success:^(BOOL status) {
        NSLog(@"修改成功");
        [DataBaseHelper selectSqliteAllModelWithTable:@"persionTable" success:^(NSArray * _Nonnull array) {
            [self.dataSourceArray removeAllObjects];
            for (NSDictionary * dic in array) {
                model * models = [[model alloc]initWithDic:dic];
                [self.dataSourceArray addObject:models];
            }
            [self.table reloadData];
        } fail:^(BOOL fail) {
            
        }];
    } fail:^(BOOL statue) {
        NSLog(@"修改失败");
    }];
    NSLog(@"修改数据库的内容");
}
/*修改多条数据*/
- (void)updataArrayButtons{
    NSArray * array = @[
  @{@"ID": @"278", @"name": @"hello", @"phone": @"13131313131313", @"score": @"98.5"},
  @{@"ID":@"277", @"name":@"李四", @"phone":@"1234567", @"score":@"96.5"},
  @{@"ID":@"276", @"name":@"王五", @"phone":@"7654321", @"score":@"95.5"},
  @{@"ID":@"275", @"name":@"王二麻子", @"phone":@"0987654321", @"score":@"94.5"},
  @{@"ID":@"274", @"name":@"张1123", @"phone":@"9087609870987y", @"score":@"93.5"}];
    [DataBaseHelper updataSqliteWithTable:@"persionTable" sqliteArray:array success:^(BOOL status) {
        UIAlertController * alter = [UIAlertController alertControllerWithTitle:@"所有数据修改成功" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction * cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alter addAction:cancle];
        [alter addAction:sure];
        [self presentViewController:alter animated:YES completion:nil];
        [DataBaseHelper selectSqliteAllModelWithTable:@"persionTable" success:^(NSArray * _Nonnull array) {
            [self.dataSourceArray removeAllObjects];
            for (NSDictionary * dic in array) {
                model * models = [[model alloc]initWithDic:dic];
                [self.dataSourceArray addObject:models];
            }
            [self.table reloadData];
        } fail:^(BOOL fail) {
            
        }];
    } fail:^(NSArray * _Nonnull failArray) {
        NSLog(@"%@", failArray);
    }];
}

/*删除*/
- (void)deleteSqlite{
    [DataBaseHelper deleteSqlitiWithTable:@"persionTable" sqliteID:@"135" success:^(BOOL success) {
        UIAlertController * alter = [UIAlertController alertControllerWithTitle:@"删除成功" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction * cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alter addAction:sure];
        [alter addAction:cancle];
        [self presentViewController:alter animated:YES completion:nil];
        [DataBaseHelper selectSqliteAllModelWithTable:@"persionTable" success:^(NSArray * _Nonnull array) {
            [self.dataSourceArray removeAllObjects];
            for (NSDictionary * dic in array) {
                model * models = [[model alloc]initWithDic:dic];
                [self.dataSourceArray addObject:models];
            }
            [self.table reloadData];
        } fail:^(BOOL fail) {
            
        }];
    } fail:^(BOOL fail) {
        UIAlertController * alter = [UIAlertController alertControllerWithTitle:@"删除失败" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction * cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alter addAction:sure];
        [alter addAction:cancle];
        [self presentViewController:alter animated:YES completion:nil];
    }];
    NSLog(@"删除数据库");
}
/*删除s多条数据*/
- (void)deleteArraybuttons{
    [DataBaseHelper deleteSqliteArrayWithTable:@"persionTable" sqliteArray:@[@"200", @"211", @"212", @"213", @"214", @"215", @"215"] success:^(BOOL success) {
        if (success == YES) {
            UIAlertController * alter = [UIAlertController alertControllerWithTitle:@"全部删除成功" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            UIAlertAction * cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alter addAction:sure];
            [alter addAction:cancle];
            [self presentViewController:alter animated:YES completion:nil];
            [DataBaseHelper selectSqliteAllModelWithTable:@"persionTable" success:^(NSArray * _Nonnull array) {
                [self.dataSourceArray removeAllObjects];
                for (NSDictionary * dic in array) {
                    model * models = [[model alloc]initWithDic:dic];
                    [self.dataSourceArray addObject:models];
                }
                [self.table reloadData];
            } fail:^(BOOL fail) {
                
            }];
        }
    } fail:^(NSArray * _Nonnull failArray) {
        
        NSString * string = @"";
        for (NSString * ID in failArray) {
            
            string = [string stringByAppendingString:[NSString stringWithFormat:@"%@,", ID]];
            }
        UIAlertController * alter = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"第%@删除失败, 因为不存在", string] message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction * cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alter addAction:sure];
        [alter addAction:cancle];
        [self presentViewController:alter animated:YES completion:nil];
    }];
}

- (void)deleteAllModels{
    [DataBaseHelper deleteSqliteAllModelsWithTable:@"persionTable" success:^(BOOL success) {
        NSLog(@"删除成功");
        [self.dataSourceArray removeAllObjects];
        [self.table reloadData];
    } fail:^(NSArray * _Nonnull array) {
        
    }];
}

#pragma mark - ---tableView的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    model * models = self.dataSourceArray[indexPath.row];
    cell.models = models;
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}


#pragma mark ---视图添加以及懒加载
/*创建view*/
- (void)creatView{
    [self.view addSubview:self.selectButton];
    [self.view addSubview:self.addButton];
    [self.view addSubview:self.changeButton];
    [self.view addSubview:self.deleteButton];
    [self.view addSubview:self.addArrayButton];
    [self.view addSubview:self.selectArrayButton];
    [self.view addSubview:self.selectAllModelButton];
    [self.view addSubview:self.deleteArrayButton];
    [self.view addSubview:self.deleteAllModelsButton];
    [self.view addSubview:self.updataArrayButton];
    [self layout];
}
- (UIView *)creat{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    NSArray * array = @[@"ID", @"name", @"phone", @"score"];
    for (int i = 0; i < 4; i++) {
        UILabel * lable = [[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 4 * i, 0, [UIScreen mainScreen].bounds.size.width / 4, 40)];
        lable.text = array[i];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.font = [UIFont systemFontOfSize:15];
        lable.textColor = [UIColor blueColor];
        [view addSubview:lable];
    }
    return  view;
}
- (void)layout{
    self.selectButton.sd_layout
    .leftSpaceToView(self.view, 0)
    .topSpaceToView(self.view, 64)
    .widthIs(50)
    .heightIs(30);
    
    self.addButton.sd_layout
    .leftSpaceToView(self.selectButton, 15)
    .topEqualToView(self.selectButton)
    .widthIs(50)
    .heightIs(30);
    
    self.changeButton.sd_layout.leftEqualToView(self.selectButton)
    .topSpaceToView(self.selectButton, 15)
    .widthIs(50)
    .heightIs(30);
    
    self.deleteButton.sd_layout
    .leftEqualToView(self.addButton)
    .topEqualToView(self.changeButton)
    .widthIs(50)
    .heightIs(30);
    
    self.addArrayButton.sd_layout
    .leftSpaceToView(self.addButton, 15)
    .topEqualToView(self.addButton)
    .heightIs(30)
    .widthIs(100);
    
    self.selectArrayButton.sd_layout
    .leftSpaceToView(self.addArrayButton, 15)
    .topEqualToView(self.addArrayButton)
    .widthIs(130)
    .heightIs(30);
    
    self.selectAllModelButton.sd_layout
    .leftSpaceToView(self.deleteButton, 15)
    .topEqualToView(self.deleteButton)
    .widthIs(150)
    .heightIs(30);
    
    self.deleteArrayButton.sd_layout
    .leftSpaceToView(self.view, 0)
    .topSpaceToView(self.changeButton, 15)
    .widthIs(150)
    .heightIs(30);
    
    self.deleteAllModelsButton.sd_layout
    .leftSpaceToView(self.deleteArrayButton, 15)
    .topEqualToView(self.deleteArrayButton)
    .widthIs(150)
    .heightIs(30);
    
    self.updataArrayButton.sd_layout
    .leftEqualToView(self.view)
    .topSpaceToView(self.deleteAllModelsButton, 15)
    .widthIs(150)
    .heightIs(30);
}


- (UIButton *)selectButton{
    if (!_selectButton) {
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectButton setTitle:@"查询" forState:UIControlStateNormal];
        [_selectButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _selectButton.sd_cornerRadius = @(5);
        _selectButton.layer.borderColor = [UIColor redColor].CGColor;
        _selectButton.layer.borderWidth = 1;
        [_selectButton addTarget:self action:@selector(selectSqlite) forControlEvents:UIControlEventTouchDown];
    }
    return _selectButton;
}

- (UIButton *)addButton{
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton setTitle:@"添加" forState:UIControlStateNormal];
        [_addButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _addButton.sd_cornerRadius = @(5);
        _addButton.layer.borderColor = [UIColor blueColor].CGColor;
        _addButton.layer.borderWidth = 1;
        [_addButton addTarget:self action:@selector(addToSqlite) forControlEvents:UIControlEventTouchDown];
    }
    return _addButton;
}

- (UIButton *)changeButton{
    if (!_changeButton) {
        _changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changeButton setTitle:@"改" forState:UIControlStateNormal];
        [_changeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _changeButton.sd_cornerRadius = @(5);
        _changeButton.layer.borderColor = [UIColor grayColor].CGColor;
        _changeButton.layer.borderWidth = 1;
        [_changeButton addTarget:self action:@selector(changeSqlite) forControlEvents:UIControlEventTouchDown];
    }
    return _changeButton;
}

- (UIButton *)deleteButton{
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        _deleteButton.sd_cornerRadius = @(5);
        _deleteButton.layer.borderWidth = 1;
        _deleteButton.layer.borderColor = [UIColor greenColor].CGColor;
        [_deleteButton addTarget:self action:@selector(deleteSqlite) forControlEvents:UIControlEventTouchDown];
    }
    return _deleteButton;
}

- (UIButton*)addArrayButton{
    if (!_addArrayButton) {
        _addArrayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addArrayButton setTitle:@"多条添加" forState:UIControlStateNormal];
        [_addArrayButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
        _addArrayButton.sd_cornerRadius = @(5);
        _addArrayButton.layer.borderColor = [UIColor yellowColor].CGColor;
        _addArrayButton.layer.borderWidth = 1;
        [_addArrayButton addTarget:self action:@selector(addArrayButtn) forControlEvents:UIControlEventTouchDown];
    }
    return _addArrayButton;
}

- (UIButton *)selectArrayButton{
    if (!_selectArrayButton) {
        _selectArrayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectArrayButton setTitle:@"多条数据查询" forState:UIControlStateNormal];
        [_selectArrayButton setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
        _selectArrayButton.sd_cornerRadius = @(5);
        _selectArrayButton.layer.borderColor = [UIColor purpleColor].CGColor;
        _selectArrayButton.layer.borderWidth = 1;
        [_selectArrayButton addTarget:self action:@selector(selectArrayButtons) forControlEvents:UIControlEventTouchDown];
    }
    return _selectArrayButton;
}

- (UIButton *)selectAllModelButton{
    if (!_selectAllModelButton) {
        _selectAllModelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectAllModelButton setTitle:@"查询所有数据" forState:UIControlStateNormal];
        [_selectAllModelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _selectAllModelButton.sd_cornerRadius = @(5);
        _selectAllModelButton.layer.borderColor = [UIColor blackColor].CGColor;
        _selectAllModelButton.layer.borderWidth = 1;
        [_selectAllModelButton addTarget:self action:@selector(selectAllModelButtons) forControlEvents:UIControlEventTouchDown];
    }
    return _selectAllModelButton;
}

- (UIButton *)deleteArrayButton{
    if (!_deleteArrayButton) {
        _deleteArrayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteArrayButton setTitle:@"删除多条数据" forState:UIControlStateNormal];
        [_deleteArrayButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        _deleteArrayButton.sd_cornerRadius = @(5);
        _deleteArrayButton.layer.borderColor = [UIColor darkGrayColor].CGColor;
        _deleteArrayButton.layer.borderWidth = 1;
        [_deleteArrayButton addTarget:self action:@selector(deleteArraybuttons) forControlEvents:UIControlEventTouchDown];
    }
    return _deleteArrayButton;
}

- (UIButton *)deleteAllModelsButton{
    if (!_deleteAllModelsButton) {
        _deleteAllModelsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteAllModelsButton setTitle:@"删除所有数据" forState:UIControlStateNormal];
        [_deleteAllModelsButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _deleteAllModelsButton.sd_cornerRadius = @(5);
        _deleteAllModelsButton.layer.borderColor = [UIColor blueColor].CGColor;
        _deleteAllModelsButton.layer.borderWidth = 1;
        [_deleteAllModelsButton addTarget:self action:@selector(deleteAllModels) forControlEvents:UIControlEventTouchDown];
    }
    return _deleteAllModelsButton;
}

- (UIButton *)updataArrayButton{
    if (!_updataArrayButton) {
        _updataArrayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_updataArrayButton setTitle:@"修改多条数据" forState:UIControlStateNormal];
        [_updataArrayButton setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
        _updataArrayButton.sd_cornerRadius = @(5);
        _updataArrayButton.layer.borderColor = [UIColor cyanColor].CGColor;
        _updataArrayButton.layer.borderWidth = 1;
        [_updataArrayButton addTarget:self action:@selector(updataArrayButtons) forControlEvents:UIControlEventTouchDown];
    }
    return _updataArrayButton;
}

- (UITableView *)table{
    if (!_table) {
        _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 245, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 234) style:UITableViewStylePlain];
        _table.delegate = self;
        _table.dataSource = self;
        [_table registerClass:[TableViewCell class] forCellReuseIdentifier:@"cell"];
        _table.tableHeaderView = [self creat];
    }
    return _table;
}
@end
