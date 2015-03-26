//
//  LXSelectItemView.h
//  mobilely
//
//  Created by csip on 15/1/27.
//  Copyright (c) 2015年 ylx. All rights reserved.
//

#import <UIKit/UIKit.h>


@class LXSelectItemView;
/**
 *  监听选项弹出框的委托
 */
@protocol LXSelectItemViewDelegate <NSObject>

@optional

-(void)selectItemView:(LXSelectItemView*)selectItemView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

/**
 *  表格式选项弹出框，对数据源有一定的要求：必须是对象数组，且对象必须有name属性，即显示在列表中的标题。目前版本，只有一个section。
 */
@interface LXSelectItemView : UIView

@property (nonatomic,strong) id<LXSelectItemViewDelegate>delegate;

@property (nonatomic,strong) UIImage *headerImage;//顶部图片
@property (nonatomic,strong) NSString *headerTitle;//顶部标签

@property (nonatomic,strong) UIImage *unSelectItemImage;//未选择项图片
@property (nonatomic,strong) UIImage *selectItemImage;//选择项图片
@property (nonatomic,strong) NSArray *itemsDataSource;//选择项数据源

@property (nonatomic) NSInteger defaultIndex;//默认下标

@property (nonatomic) NSIndexPath *currentIndexPath;//当前indexPath

-(id)initWithFrame:(CGRect)frame tagetView:(UIView*)tView;

@end
