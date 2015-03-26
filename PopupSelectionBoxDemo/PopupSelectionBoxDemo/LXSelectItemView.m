//
//  LXSelectItemView.m
//  mobilely
//
//  Created by csip on 15/1/27.
//  Copyright (c) 2015年 ylx. All rights reserved.
//

#import "LXSelectItemView.h"

#define kHeaderView_H 40//顶部视图高度

#define kHeaderImageView_WH 20//左上角图标的宽高

#define kLeftRightGap 10//左右边距
#define kUpDownGap 10//上下边距

#define kBottomButton_H 35//底部视图高度

#define kSelectItemCellIdentifier @"SelectItemCell"

@interface LXSelectItemView ()<UITableViewDataSource,UITableViewDelegate>{
    @private
    
    UIView *bg;//模态背景，黑色透明
    
    UIView *headerView;
    UIImageView *headerImageView;
    UILabel *headerTitleLabel;
    UITableView *listView;
    
    NSMutableArray *flags;
}



@end

@implementation LXSelectItemView

-(id)initWithFrame:(CGRect)frame tagetView:(UIView*)tView{
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        bg = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        bg.alpha = 0.53;
        bg.backgroundColor = [UIColor darkGrayColor];
        [tView addSubview:bg];
        
        self.backgroundColor = [UIColor whiteColor];
        // Create a mask layer and the frame to determine what will be visible in the view.
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        CGRect maskRect = frame;
        // Create a path and add the rectangle in it.
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, nil, maskRect);
        // Set the path to the mask layer.
        [maskLayer setPath:path];
        // Release the path since it's not covered by ARC.
        CGPathRelease(path);
        // Set the mask of the view.
        self.layer.mask = maskLayer;
        
        //头部
        headerView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), CGRectGetWidth(frame),kHeaderView_H)];
        headerView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
        [self addSubview:headerView];
        
        headerImageView = [[UIImageView alloc] init];
        headerImageView.backgroundColor = [UIColor clearColor];
        [headerView addSubview:headerImageView];
        
        headerTitleLabel = [[UILabel alloc] init];
        headerTitleLabel.backgroundColor = [UIColor clearColor];
        [headerView addSubview:headerTitleLabel];
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        cancelBtn.frame = CGRectMake(CGRectGetMinX(frame) + kLeftRightGap, CGRectGetMaxY(frame) - kBottomButton_H - kUpDownGap, (CGRectGetWidth(frame) - kLeftRightGap*3)*0.5, kBottomButton_H);
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(clickHideSelf:) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn setBackgroundColor:headerView.backgroundColor];
        [cancelBtn setTintColor:[UIColor darkGrayColor]];
        cancelBtn.layer.cornerRadius = 5;
        cancelBtn.layer.masksToBounds = YES;
        [self addSubview:cancelBtn];
        
        UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        confirmBtn.frame = CGRectMake(CGRectGetMaxX(cancelBtn.frame) + kLeftRightGap, CGRectGetMaxY(frame) - kBottomButton_H - kUpDownGap, (CGRectGetWidth(frame) - kLeftRightGap*3)*0.5, kBottomButton_H);
        [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [confirmBtn addTarget:self action:@selector(clickConfirmAndHideSelf:) forControlEvents:UIControlEventTouchUpInside];
        [confirmBtn setBackgroundColor:[UIColor colorWithRed:216.0/255.0 green:82.0/255.0 blue:92.0/255.0 alpha:1.0f]];
        [confirmBtn setTintColor:[UIColor whiteColor]];
        confirmBtn.layer.cornerRadius = 5;
        confirmBtn.layer.masksToBounds = YES;
        [self addSubview:confirmBtn];
        
        //初始化视图
        listView = [[UITableView alloc] initWithFrame:CGRectMake(CGRectGetMinX(frame), CGRectGetMaxY(headerView.frame), CGRectGetWidth(frame), CGRectGetHeight(frame) - kHeaderView_H - kBottomButton_H - kUpDownGap * 2) style:UITableViewStylePlain];
        listView.delegate = self;
        listView.dataSource = self;
        [self addSubview:listView];
        
        [listView registerClass:[UITableViewCell class] forCellReuseIdentifier:kSelectItemCellIdentifier];
        
        _currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        
    }
    return self;
}

-(void)setHeaderImage:(UIImage *)headerImage{
    _headerImage = headerImage;
    if (_headerImage) {
        headerImageView.frame = CGRectMake(kUpDownGap, kUpDownGap, kHeaderImageView_WH, kHeaderImageView_WH);
        headerImageView.image = _headerImage;
    }
}

-(void)setHeaderTitle:(NSString *)headerTitle{
    _headerTitle = headerTitle;
    if (_headerTitle) {
        CGRect titleFrame;
        if (headerImageView.image == nil) {
            titleFrame = CGRectMake(kLeftRightGap, 0, CGRectGetWidth(headerView.frame) - kLeftRightGap * 2, CGRectGetHeight(headerView.frame));
        }else{
            titleFrame = CGRectMake(CGRectGetMaxX(headerImageView.frame) + kLeftRightGap, 0, CGRectGetWidth(headerView.frame) - CGRectGetWidth(headerImageView.frame), CGRectGetHeight(headerView.frame));
        }
        headerTitleLabel.frame = titleFrame;
        headerTitleLabel.text = _headerTitle;
    }
}

-(void)setItemsDataSource:(NSArray *)itemsDataSource{
    _itemsDataSource = itemsDataSource;
    
    //初始flags数组
    [self resetFlagsArray];
    
    [listView selectRowAtIndexPath:_currentIndexPath animated:YES  scrollPosition:UITableViewScrollPositionMiddle];
    
}

-(void)resetFlagsArray{
    flags = [NSMutableArray array];
    for (int i = 0; i < _itemsDataSource.count; i++) {
        if (i == _currentIndexPath.row) {
            [flags addObject:@"1"];
            continue;
        }
        [flags addObject:@"0"];
    }
}

-(void)setDefaultIndex:(NSInteger)defaultIndex{
    _defaultIndex = defaultIndex;
    
    _currentIndexPath = [NSIndexPath indexPathForRow:_defaultIndex inSection:0];
}

#pragma mark -
#pragma mark UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _itemsDataSource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSelectItemCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageView.image = [flags[indexPath.row] integerValue] ==1?_selectItemImage:_unSelectItemImage;
    cell.textLabel.text = [_itemsDataSource[indexPath.row] name];
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //cx[tableView deselectRowAtIndexPath:indexPath animated:YES];
    _currentIndexPath = indexPath;
    
    [self resetFlagsArray];
    [listView reloadData];
}


#pragma mark -
-(void)clickHideSelf:(id)sender{
    [bg removeFromSuperview];
    [self removeFromSuperview];
}

-(void)clickConfirmAndHideSelf:(id)sender{
    
    [_delegate selectItemView:self didSelectItemAtIndexPath:_currentIndexPath];
    
    [self clickHideSelf:nil];
}
@end
