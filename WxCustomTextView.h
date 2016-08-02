//
//  WxCustomTextView.h
//  TestProject
//
//  Created by mac_sqjr on 16/7/7.
//  Copyright © 2016年 mac_sqjr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WxCustomTextView : UITextView <UITextViewDelegate>

//设置默认提示
@property(nonatomic,strong) NSString *placeholder;

//设置限制输入的字数，若未设置则不限制
@property(nonatomic,assign) int limitWordsCount;

@property(nonatomic,strong) UILabel *placeholderLabel;

@property(nonatomic,strong) UILabel *wordsCountLabel;

@end
