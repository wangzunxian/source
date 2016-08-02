//
//  WXImageLoop.h
//  SaySecret
//
//  Created by wang on 16/1/25.
//  Copyright © 2016年 wang. All rights reserved.
//

#import <UIKit/UIKit.h>

//向左、向右滑动
typedef enum {
    Left,
    Right
}Position;

@interface WXImageLoop : UIView

@property(nonatomic,assign) Position position;
@property(nonatomic,assign) BOOL autoPlay;
@property(nonatomic,strong) NSArray *images;

- (instancetype) initWithFrame:(CGRect)frame imageArray:(NSArray *)imageArray position:(Position)position automaticPlay:(BOOL)automaticPlay;

@end
