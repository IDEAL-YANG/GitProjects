//
//  ViewController.m
//  PopupSelectionBoxDemo
//
//  Created by csip on 15/3/24.
//  Copyright (c) 2015年 ylx. All rights reserved.
//

#import "ViewController.h"
#import "LXSelectItemView.h"

@interface Item : NSObject
@property (nonatomic, copy) NSString *name;
@end

@implementation Item
-(id)init{
    if (self = [super init]) {
    }
    return self;
}
@end

@interface ViewController ()<LXSelectItemViewDelegate>{
    NSMutableArray *carStyleDataArray;
    NSInteger currentIndex;
}
@property (weak, nonatomic) IBOutlet UILabel *carStyleLabel;

- (IBAction)clickMeAction:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initCarStyle];
}

/**
 * 初始化汽车类型数据
 */
-(void)initCarStyle{
    carStyleDataArray = [NSMutableArray array];
    
    NSString *carStyleFilePath = [[NSBundle mainBundle] pathForResource:@"CarStyleConfig" ofType:@"plist"];
    NSArray *tempArray = [[NSArray alloc] initWithContentsOfFile:carStyleFilePath];
    for (int i = 0;i < tempArray.count;i++) {
        Item *item= [[Item alloc] init];
        item.name = tempArray[i];
        
        [carStyleDataArray addObject:item];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickMeAction:(id)sender {
    [self.view endEditing:YES];
    
    NSArray *dataArr = carStyleDataArray;
    UIImage *headerImage = [UIImage imageNamed:@"car"];
    NSString *headerTitle = @"请选择汽车类型";
    NSInteger index= currentIndex;
    
    LXSelectItemView *selectItemView = [[LXSelectItemView alloc] initWithFrame:CGRectMake(20, (self.view.frame.size.height - 400) * 0.5, self.view.frame.size.width -  20 *2, 400) tagetView:self.view];
    
    selectItemView.delegate = self;
    selectItemView.unSelectItemImage = [UIImage imageNamed:@"people_radio"];
    selectItemView.selectItemImage = [UIImage imageNamed:@"people_radio_on"];
    
    selectItemView.headerImage = headerImage;
    selectItemView.headerTitle = headerTitle;
    selectItemView.defaultIndex = index;
    selectItemView.itemsDataSource = dataArr;
    
    [self.view addSubview:selectItemView];
}

#pragma mark -
#pragma mark LXSelectItemViewDelegate
/**
 * 选择弹框的回调
 */
-(void)selectItemView:(LXSelectItemView *)selectItemView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    _carStyleLabel.text = [NSString stringWithFormat:@"选中%@车",[selectItemView.itemsDataSource[indexPath.row] name]];
    currentIndex = indexPath.row;
}
@end
