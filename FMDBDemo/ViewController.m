//
//  ViewController.m
//  FMDBDemo
//
//  Created by Mr_Jia on 2017/4/21.
//  Copyright © 2017年 Mr_Jia. All rights reserved.
//

#import "ViewController.h"
#import <FMDB.h>
#import <ReactiveCocoa.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    
    NSString *dbPath = [documentPath stringByAppendingPathComponent:@"demo.sqlite"];
    NSLog(@"DBPATH:%@",dbPath);
    FMDatabase *db = [FMDatabase databaseWithPath: dbPath];
    //设置缓存，提升效率
//    [db setShouldCacheStatements:YES];
    UIButton *openDB = [UIButton buttonWithType:UIButtonTypeCustom];
    openDB.backgroundColor = [UIColor grayColor];
    openDB.frame = CGRectMake(100, 50, 200, 50);
    [openDB setTitle:@"OpenDB" forState:UIControlStateNormal];
    [self.view addSubview:openDB];

    [[openDB rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if ([db open]) {
            NSLog(@"打开数据库成功");
        }else{
            NSLog(@"打开数据库失败");
        }
        
    }];
    
    UIButton *creatTable = [UIButton buttonWithType:UIButtonTypeCustom];
    creatTable.backgroundColor = [UIColor grayColor];
    creatTable.frame = CGRectMake(100, 120, 200, 50);
    [creatTable setTitle:@"CreateTable" forState:UIControlStateNormal];
    [self.view addSubview:creatTable];
    
    [[creatTable rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if ([db open]) {
            BOOL result = [db executeUpdate:@"create table if not exists shopCar(dbid integer PRIMARY KEY AUTOINCREMENT,specId integer NOT NULL, shopNum integer NOT NULL default 1, shopInfo TEXT NOT NULL)"];
            if (result) {
                NSLog(@"创建表成功");
            }else{
                NSLog(@"创建表失败");
            }
            [db close];
        }
    }];
    
    UIButton *insertData = [UIButton buttonWithType:UIButtonTypeCustom];
    insertData.backgroundColor = [UIColor grayColor];
    insertData.frame = CGRectMake(100, 190, 200, 50);
    [insertData setTitle:@"insertData" forState:UIControlStateNormal];
    [self.view addSubview:insertData];
    
    [[insertData rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if ([db open]) {
            NSString *sql = [NSString stringWithFormat:@"INSERT INTO shopCar (specId,shopNum,shopInfo) VALUES (%d,%d,'%@')",1,2,@"buzhidaojiale"];
            BOOL result = [db executeUpdate:sql];
            if (result) {
                NSLog(@"插入成功");
            }else{
                
                NSLog(@"插入失败");
            }
            [db close];
        }
    }];
    
    UIButton *selectAllData = [UIButton buttonWithType:UIButtonTypeCustom];
    selectAllData.backgroundColor = [UIColor grayColor];
    selectAllData.frame = CGRectMake(100, 260, 200, 50);
    [selectAllData setTitle:@"selectAllData" forState:UIControlStateNormal];
    [self.view addSubview:selectAllData];
    
    [[selectAllData rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if ([db open]) {
            NSString * sql = @"SELECT * FROM shopCar";
            FMResultSet * rs = [db executeQuery:sql];
            while ([rs next]) {
                int dbId = [rs intForColumn:@"dbid"];
                int specId = [rs intForColumn:@"specId"];
                int shopNum = [rs intForColumn:@"shopNum"];
                NSString * shopInfo = [rs stringForColumn:@"shopInfo"];
                NSLog(@"dbId = %d, specId = %d, shopNum = %d  shopInfo = %@", dbId, specId, shopNum, shopInfo);
            }
            [db close];

        }
    }];
    UIButton *selectDbidData = [UIButton buttonWithType:UIButtonTypeCustom];
    selectDbidData.backgroundColor = [UIColor grayColor];
    selectDbidData.frame = CGRectMake(100, 330, 200, 50);
    [selectDbidData setTitle:@"selectDbidData" forState:UIControlStateNormal];
    [self.view addSubview:selectDbidData];
    
    [[selectDbidData rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if ([db open]) {
            NSString * sql = @"SELECT * FROM shopCar WHERE dbid = '1'";
            FMResultSet * rs = [db executeQuery:sql];
            while ([rs next]) {
                int dbId = [rs intForColumn:@"dbid"];
                int specId = [rs intForColumn:@"specId"];
                int shopNum = [rs intForColumn:@"shopNum"];
                NSString * shopInfo = [rs stringForColumn:@"shopInfo"];
                NSLog(@"dbId = %d, specId = %d, shopNum = %d  shopInfo = %@", dbId, specId, shopNum, shopInfo);
            }
            [db close];
            
        }
    }];

    UIButton *updataDbidData = [UIButton buttonWithType:UIButtonTypeCustom];
    updataDbidData.backgroundColor = [UIColor grayColor];
    updataDbidData.frame = CGRectMake(100, 400, 200, 50);
    [updataDbidData setTitle:@"updataDbidData" forState:UIControlStateNormal];
    [self.view addSubview:updataDbidData];
    
    [[updataDbidData rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if ([db open]) {
            NSString *updateSql = [NSString stringWithFormat:@"update shopCar set shopNum = '88' where dbid ='1'"];
            BOOL res = [db executeUpdate:updateSql];
            if (res) {
                NSLog(@"修改数据成功");
            } else {
                NSLog(@"修改数据失败");
            }
            [db close];
            
        }
    }];


    UIButton *deleteDbidData = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteDbidData.backgroundColor = [UIColor grayColor];
    deleteDbidData.frame = CGRectMake(100, 470, 200, 50);
    [deleteDbidData setTitle:@"deleteDbidData" forState:UIControlStateNormal];
    [self.view addSubview:deleteDbidData];
    
    [[deleteDbidData rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if ([db open]) {
            NSString *updateSql = [NSString stringWithFormat:@"update shopCar set shopNum = '88' where dbid ='1'"];
            BOOL res = [db executeUpdate:updateSql];
            if (res) {
                NSLog(@"修改数据成功");
            } else {
                NSLog(@"修改数据失败");
            }
            [db close];
            
        }
    }];

    UIButton *deleteAllData = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteAllData.backgroundColor = [UIColor grayColor];
    deleteAllData.frame = CGRectMake(100, 540, 200, 50);
    [deleteAllData setTitle:@"deleteShopCarTable" forState:UIControlStateNormal];
    [self.view addSubview:deleteAllData];
    
    [[deleteAllData rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if ([db open]) {
            //清空数据表并将自增字段清零
            NSString *deleteSql = @"DELETE FROM shopCar";
            [db executeUpdate:@"UPDATE sqlite_sequence set seq = 0 where name = 'shopCar'"];
            BOOL res = [db executeUpdate:deleteSql];
            if (res) {
                NSLog(@"清空shopCar表数据成功");
            } else {
                NSLog(@"清空shopCar表数据失败");
            }
       }
    }];

    
    UIButton *deleteShopCarTable = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteShopCarTable.backgroundColor = [UIColor grayColor];
    deleteShopCarTable.frame = CGRectMake(100, 610, 200, 50);
    [deleteShopCarTable setTitle:@"deleteShopCarTable" forState:UIControlStateNormal];
    [self.view addSubview:deleteShopCarTable];
    
    [[deleteShopCarTable rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if ([db open]) {
            NSString *deleteSql = @"DROP TABLE shopCar";
            BOOL res = [db executeUpdate:deleteSql];
            
            if (res) {
                NSLog(@"删除shopCar表成功");
            } else {
                NSLog(@"删除shopCar表失败");
            }
            [db close];
        }
    }];

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
