//
//  ViewController.m
//  NetWork
//
//  Created by 王海洋 on 2019/6/14.
//  Copyright © 2019 王海洋. All rights reserved.
//

#import "ViewController.h"
#import "VVNetWork/VVApiNetProxy.h"
#import "DemoService.h"
#import "DemoApiManager.h"

@interface ViewController () <VVAPIManagerDataCallBackDelegate, VVAPIManagerParamSource>
@property (strong , nonatomic) DemoApiManager *demoApiManager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    UIButton *loadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loadBtn setTitle:@"Load" forState:UIControlStateNormal];
    [loadBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [loadBtn setFrame:CGRectMake(100, 100, 100, 30)];
    [loadBtn addTarget:self action:@selector(loadData:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loadBtn];
    

//    NSDictionary *param = @{ @"relationType":@"2",
//                             @"fixedParameter":@"home"
//                             };
//    [self.demoApiManager loadDataWithParam:param success:^(VVBaseApiManager * _Nonnull apiManager) {
//        NSLog(@"%@",[apiManager fetchDataWithReformer:nil]);
//    } faild:^(VVBaseApiManager * _Nonnull apiManager) {
//        NSLog(@"%@",apiManager.errorMsg);
//
//    }];

}

- (void) loadData :(UIButton *) btn {
    [self.demoApiManager loadData];
}

- (NSDictionary *)paramsterForApi:(VVBaseApiManager *)apiManager {
    return @{ @"relationType":@"2",
              @"fixedParameter":@"home"
              };
}

- (void)managerCallApiSuccess:(VVBaseApiManager *)apiManager {
    
    id response  = [apiManager fetchDataWithReformer:nil];
    NSLog(@"Call Success %@",response);
}

- (void)managerCallApiFaild:(VVBaseApiManager *)apiManager {
    id response  = [apiManager fetchDataWithReformer:nil];

    NSLog(@"Call Faild %@",response);

}

- (DemoApiManager *)demoApiManager {
    if (_demoApiManager == nil) {
        _demoApiManager = [[DemoApiManager alloc] init];
        _demoApiManager.dataDelegate = self;
        _demoApiManager.paramSource = self;
        _demoApiManager.cachePolicy = VVNoCache;
    }
    return _demoApiManager;
}


@end
