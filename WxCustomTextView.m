//
//  WxCustomTextView.m
//  TestProject
//
//  Created by mac_sqjr on 16/7/7.
//  Copyright © 2016年 mac_sqjr. All rights reserved.
//

#import "WxCustomTextView.h"

@interface WxCustomTextView () {
    NSArray *wordsCountLabelConstraintsX;
    NSArray *wordsCountLabelConstraintsY;
}

@end

@implementation WxCustomTextView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.delegate = self;
        self.font = [UIFont systemFontOfSize:18];
        //取消连续布局属性，禁止自动重置滑动
        self.layoutManager.allowsNonContiguousLayout = NO;
        
        UILabel *placeholderLabel = [[UILabel alloc] init];
        [placeholderLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        placeholderLabel.textColor = [UIColor lightGrayColor];
        placeholderLabel.numberOfLines = 0;
        [self addSubview:placeholderLabel];
        _placeholderLabel = placeholderLabel;
        
        NSDictionary *labelVflDict = NSDictionaryOfVariableBindings(placeholderLabel);
        NSString *labelVfl1 = @"|-5-[placeholderLabel]";
        NSString *labelVfl2 = @"V:|-8-[placeholderLabel]";
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:labelVfl1 options:0 metrics:nil views:labelVflDict]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:labelVfl2 options:0 metrics:nil views:labelVflDict]];
        
        UILabel *wordsCountLabel = [[UILabel alloc] init];
        [wordsCountLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        wordsCountLabel.font = [UIFont systemFontOfSize:12];
        wordsCountLabel.textColor = [UIColor lightGrayColor];
        wordsCountLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:wordsCountLabel];
        _wordsCountLabel = wordsCountLabel;
        
        NSDictionary *wordsCountLabelVflDict = NSDictionaryOfVariableBindings(wordsCountLabel);
        NSString *wordsCountLabelVfl1 = @"|-100-[wordsCountLabel(40)]";
        NSString *wordsCountLabelVfl2 = @"V:|-0-[wordsCountLabel(20)]";
        wordsCountLabelConstraintsX = [NSLayoutConstraint constraintsWithVisualFormat:wordsCountLabelVfl1 options:0 metrics:nil views:wordsCountLabelVflDict];
        [self addConstraints:wordsCountLabelConstraintsX];
        wordsCountLabelConstraintsY = [NSLayoutConstraint constraintsWithVisualFormat:wordsCountLabelVfl2 options:0 metrics:nil views:wordsCountLabelVflDict];
        [self addConstraints:wordsCountLabelConstraintsY];
    }
    return self;
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    _placeholderLabel.text = placeholder;
}

- (void)setPlaceholderLabel:(UILabel *)placeholderLabel {
    _placeholderLabel = placeholderLabel;
}

- (void)setWordsCountLabel:(UILabel *)wordsCountLabel {
    _wordsCountLabel = wordsCountLabel;
}

- (void)setLimitWordsCount:(int)limitWordsCount {
    _limitWordsCount = limitWordsCount;
    if (_limitWordsCount > 0) {
        _wordsCountLabel.text = [NSString stringWithFormat:@"0/%d",limitWordsCount];
    }else{
        _wordsCountLabel.hidden = YES;
    }
}

- (void)setFont:(UIFont *)font {
    //修改UITextView的参数时，要调用super方法
    [super setFont:font];
    _placeholderLabel.font = font;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //设置子控件frame
    [self updateCountLabelConstraints];
}

- (void)updateCountLabelConstraints {
    [self removeConstraints:wordsCountLabelConstraintsX];
    [self removeConstraints:wordsCountLabelConstraintsY];
    NSDictionary *wordsCountLabelVflDict = NSDictionaryOfVariableBindings(_wordsCountLabel);
    NSDictionary *wordsCountLabelMetrics = @{@"width":@(self.frame.size.width-85),@"height":@(self.frame.size.height-20 + self.contentOffset.y)};
    NSString *wordsCountLabelVfl1 = @"|-(width)-[_wordsCountLabel(80)]";
    NSString *wordsCountLabelVfl2 = @"V:|-(height)-[_wordsCountLabel(20)]";
    wordsCountLabelConstraintsX = [NSLayoutConstraint constraintsWithVisualFormat:wordsCountLabelVfl1 options:0 metrics:wordsCountLabelMetrics views:wordsCountLabelVflDict];
    [self addConstraints:wordsCountLabelConstraintsX];
    wordsCountLabelConstraintsY = [NSLayoutConstraint constraintsWithVisualFormat:wordsCountLabelVfl2 options:0 metrics:wordsCountLabelMetrics views:wordsCountLabelVflDict];
    [self addConstraints:wordsCountLabelConstraintsY];
}

- (void)textViewDidChange:(UITextView *)textView {
    if (self.text.length == 0) {
        _placeholderLabel.hidden = NO;
    }else{
        _placeholderLabel.hidden = YES;
    }
    
    if (_limitWordsCount > 0) {
        NSString *toString = textView.text;
        //键盘输入模式
        NSString *language = [[textView textInputMode] primaryLanguage];
        if ([language isEqualToString:@"zh-Hans"]) {
            UITextRange *selectedRange = [textView markedTextRange];
            //获取高亮部分
            UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
            //计算高亮选择的字，对已经输入的文字进行统计和限制
            if (!position) {
                if (toString.length > _limitWordsCount) {
                    textView.text = [toString substringToIndex:_limitWordsCount];
                }
                _wordsCountLabel.text = [NSString stringWithFormat:@"%lu/%d", (unsigned long)textView.text.length, _limitWordsCount];
            }
        }else{
            if (toString.length > _limitWordsCount) {
                textView.text = [toString substringToIndex:_limitWordsCount];
            }
            _wordsCountLabel.text = [NSString stringWithFormat:@"%lu/%d", (unsigned long)textView.text.length, _limitWordsCount];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
