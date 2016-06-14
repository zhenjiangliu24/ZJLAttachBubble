//
//  ZJLAttachBubble.m
//  ZJLAttachBubble
//
//  Created by ZhongZhongzhong on 16/6/14.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import "ZJLAttachBubble.h"

#define BubbleColor [UIColor colorWithRed:55/255.0 green:197/255.0 blue:240/255.0 alpha:1.0]
static const CGFloat BubbleWidth = 60.0f;

@interface ZJLAttachBubble()
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint endPoint;
@end

@implementation ZJLAttachBubble

- (instancetype)init
{
    CGRect frame = CGRectMake(0, 0, BubbleWidth, BubbleWidth);
    if (self = [super initWithFrame:frame]) {
        _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BubbleWidth, BubbleWidth)];
        _backgroundView.clipsToBounds = YES;
        _backgroundView.backgroundColor = [BubbleColor colorWithAlphaComponent:0.5f];
        _backgroundView.userInteractionEnabled = NO;
        _backgroundView.layer.cornerRadius = BubbleWidth/2;
        [self addSubview:_backgroundView];
        
        UIView *imageBackground = [[UIView alloc] initWithFrame:CGRectMake(5, 5, (BubbleWidth-10), (BubbleWidth-10))];
        imageBackground.clipsToBounds = YES;
        imageBackground.backgroundColor = [BubbleColor colorWithAlphaComponent:0.7f];
        imageBackground.userInteractionEnabled = NO;
        imageBackground.layer.cornerRadius = (BubbleWidth-10)/2;
        [self addSubview:imageBackground];
        
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"setting"]];
        _imageView.frame = CGRectMake(0, 0, 30, 30);
        _imageView.tintColor = [UIColor whiteColor];
        _imageView.center = CGPointMake(BubbleWidth/2, BubbleWidth/2);
        [self addSubview:_imageView];
        
        self.layer.cornerRadius = BubbleWidth/2;
        
        [self startBreathing];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bubbleTap:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (UIDynamicAnimator *)animator
{
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.superview];
    }
    return _animator;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *finger = [touches anyObject];
    self.startPoint = [finger locationInView:self.superview];
    [self.animator removeAllBehaviors];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *finger = [touches anyObject];
    self.center = [finger locationInView:self.superview];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *finger = [touches anyObject];
    self.endPoint = [finger locationInView:self.superview];
    if (fabs(self.startPoint.x-self.endPoint.x)<10 && fabs(self.startPoint.y-self.endPoint.y)<10) {
        
    }
    self.center = self.endPoint;
    CGFloat superWidth = self.superview.bounds.size.width;
    CGFloat superHeight = self.superview.bounds.size.height;
    CGFloat positionX = self.endPoint.x;
    CGFloat positionY = self.endPoint.y;
    CGFloat top = positionY;
    CGFloat down = superHeight-positionY;
    CGFloat left = positionX;
    CGFloat right = superWidth-positionX;
    CGFloat minX = left>right?right:left;
    CGFloat minY = top>down?down:top;
    CGFloat minimal = minX>minY?minY:minX;
    
    CGPoint finalPosition;
    if (minimal == top) {
        positionX = (positionX-BubbleWidth/2)<0?BubbleWidth/2:positionX;
        positionX = superWidth-positionX<BubbleWidth/2?superWidth-BubbleWidth/2:positionX;
        finalPosition = CGPointMake(positionX, BubbleWidth/2);
    }else if (minimal == down){
        positionX = (positionX-BubbleWidth/2)<0?BubbleWidth/2:positionX;
        positionX = superWidth-positionX<BubbleWidth/2?superWidth-BubbleWidth/2:positionX;
        finalPosition = CGPointMake(positionX, superHeight - BubbleWidth/2);
    }else if (minimal == left){
        positionY = (positionY-BubbleWidth/2)<0?BubbleWidth/2:positionY;
        positionY = (superHeight-positionY)<BubbleWidth/2?superHeight-positionY:positionY;
        finalPosition = CGPointMake(BubbleWidth/2, positionY);
    }else{
        positionY = (positionY-BubbleWidth/2)<0?BubbleWidth/2:positionY;
        positionY = (superHeight-positionY)<BubbleWidth/2?superHeight-positionY:positionY;
        finalPosition = CGPointMake(superWidth - BubbleWidth/2, positionY);
    }
    UIAttachmentBehavior *attach = [[UIAttachmentBehavior alloc] initWithItem:self attachedToAnchor:finalPosition];
    attach.length = 0;
    attach.frequency = 3;
    attach.damping = 0.3;
    [self.animator addBehavior:attach];
}

#pragma mark - bubble tap
- (void)bubbleTap:(UITapGestureRecognizer *)tap
{
    [UIView animateWithDuration:0.5 animations:^{
        self.imageView.transform = CGAffineTransformMakeRotation(M_PI);
    } completion:^(BOOL finished) {
        self.imageView.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark - bubble breathing

- (void)startBreathing
{
    __weak ZJLAttachBubble *weakSelf = self;
    [UIView animateWithDuration:1.5f animations:^{
        weakSelf.backgroundView.backgroundColor = [BubbleColor colorWithAlphaComponent:0.1f];
    } completion:^(BOOL finished) {
        [self breathBack];
    }];
}

- (void)breathBack
{
    __weak ZJLAttachBubble *weakSelf = self;
    [UIView animateWithDuration:1.5f animations:^{
        weakSelf.backgroundView.backgroundColor = [BubbleColor colorWithAlphaComponent:0.5f];
    } completion:^(BOOL finished) {
        [self startBreathing];
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
