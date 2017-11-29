//
//  ViewController.m
//  RollerCoasterOC
//
//  Created by Stan on 2017-04-28.
//  Copyright © 2017 stan. All rights reserved.
//

#import "ViewController.h"

#define k_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define k_LAND_BEGIN_HEIGHT k_SCREEN_HEIGHT - 20
#define k_SIZE self.view.frame.size

@interface ViewController ()
@property(strong,nonatomic)CALayer *landLayer;
@property(strong,nonatomic)CAShapeLayer *greenTrack;
@property(strong,nonatomic)CAShapeLayer *yellowTrack;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
//    初始化背景渐变的天空
    [self initBackgroundSky];
//    初始化雪山
    [self initSnowberg];
//    加载草坪
    [self initLawn];
//    加载大地
    [self initLand];
//    加载黄色轨道
    [self initYellowTrack];
//    加载绿色轨道
    [self initGreenTrack];
//    点缀小树
    [self initTree];
//    启动云彩
    [self initCloudAnimation];
//    添加黄色轨道小车动画
    [self carAnimationWith:@"car" TrackLayer:_yellowTrack AnimationDuration:8.0 BeginTime:CACurrentMediaTime() + 1];
//    添加绿色轨道小车动画
    [self carAnimationWith:@"otherCar" TrackLayer:_greenTrack AnimationDuration:5.0 BeginTime:CACurrentMediaTime()];}

//初始化背景天空渐变色
- (void)initBackgroundSky{
    CAGradientLayer *backgroundLayer = [[CAGradientLayer alloc] init];
    //    设置背景渐变色层的大小。要减去屏幕最下方土地那条水平线的高度
    backgroundLayer.frame = CGRectMake(0, 0, k_SIZE.width, k_LAND_BEGIN_HEIGHT);
    
    UIColor *lightColor = [UIColor colorWithRed:40.0 / 255.0 green:150.0 / 255.0 blue:200.0 / 255.0 alpha:1.0];
    UIColor *darkColor = [UIColor colorWithRed:255.0 / 255.0 green:250.0 / 255.0 blue:250.0 / 255.0 alpha:1.0];
    backgroundLayer.colors = @[(__bridge id)lightColor.CGColor,(__bridge id)darkColor.CGColor];
    
    //    让变色层成45度角变色
    backgroundLayer.startPoint = CGPointMake(0, 0);
    backgroundLayer.endPoint = CGPointMake(1, 1);
    
    [self.view.layer addSublayer:backgroundLayer];
}

//初始化雪山，有两个雪山
- (void)initSnowberg{
    
    //    左边第一座山顶,其实就是一个白色的三角形
    CAShapeLayer *leftSnowberg = [[CAShapeLayer alloc] init];
    UIBezierPath *leftSnowbergPath = [[UIBezierPath alloc] init];
    
    //    把bezierpath的起点移动到雪山左下角
    [leftSnowbergPath moveToPoint:CGPointMake(0, k_SIZE.height - 120)];
    
    //    画一条线到山顶
    [leftSnowbergPath addLineToPoint:CGPointMake(100, 100)];
    
    //    画一条线到右下角->左下角->闭合
    [leftSnowbergPath addLineToPoint:CGPointMake(k_SIZE.width / 2, k_LAND_BEGIN_HEIGHT)];
    [leftSnowbergPath addLineToPoint:CGPointMake(0, k_LAND_BEGIN_HEIGHT)];
    [leftSnowbergPath closePath];
    
    leftSnowberg.path = leftSnowbergPath.CGPath;
    leftSnowberg.fillColor = [UIColor whiteColor].CGColor;
    [self.view.layer addSublayer:leftSnowberg];
    
    
    //    开始画山体没有被雪覆盖的部分
    CAShapeLayer *leftSnowbergBody = [[CAShapeLayer alloc] init];
    UIBezierPath *leftSnowbergBodyPath = [[UIBezierPath alloc] init];
    
    //    把bezierpath的起点移动到雪山左下角相同的位置
    CGPoint startPoint = CGPointMake(0, k_SIZE.height - 120);
    CGPoint endPoint = CGPointMake(100, 100);
    CGPoint firstPathPoint = [self calculateWithXValue:20 startPoint:startPoint endpoint:endPoint];
    [leftSnowbergBodyPath moveToPoint:startPoint];
    
    [leftSnowbergBodyPath addLineToPoint:firstPathPoint];
    [leftSnowbergBodyPath addLineToPoint:CGPointMake(60, firstPathPoint.y)];
    [leftSnowbergBodyPath addLineToPoint:CGPointMake(100, firstPathPoint.y + 30)];
    [leftSnowbergBodyPath addLineToPoint:CGPointMake(140, firstPathPoint.y)];
    [leftSnowbergBodyPath addLineToPoint:CGPointMake(180, firstPathPoint.y - 20)];
    
    CGPoint secondPathPoint = [self calculateWithXValue:(k_SIZE.width / 2 - 125) startPoint:endPoint endpoint:CGPointMake(k_SIZE.width / 2, k_LAND_BEGIN_HEIGHT)];
    [leftSnowbergBodyPath addLineToPoint:CGPointMake(secondPathPoint.x - 30, firstPathPoint.y)];
    
    [leftSnowbergBodyPath addLineToPoint:secondPathPoint];
    
    [leftSnowbergBodyPath addLineToPoint:CGPointMake(k_SIZE.width / 2, k_LAND_BEGIN_HEIGHT)];
    [leftSnowbergBodyPath addLineToPoint:CGPointMake(0, k_LAND_BEGIN_HEIGHT)];
    [leftSnowbergBodyPath closePath];
    
    leftSnowbergBody.path = leftSnowbergBodyPath.CGPath;
    UIColor *snowColor = [UIColor colorWithDisplayP3Red:139.0 /255.0 green:92.0 /255.0 blue:0.0 /255.0 alpha:1.0];
    leftSnowbergBody.fillColor = snowColor.CGColor;
    [self.view.layer addSublayer:leftSnowbergBody];
    
    
    //   中间的山
    CAShapeLayer *middleSnowberg = [[CAShapeLayer alloc] init];
    UIBezierPath *middleSnowbergPath = [[UIBezierPath alloc] init];
    
    //    把bezierpath的起点移动到雪山左下角。然后画一条线到山顶，再画一条线到右下角，闭合。
    CGPoint middleStartPoint = CGPointMake(k_SIZE.width / 3, k_LAND_BEGIN_HEIGHT);
    CGPoint middleTopPoint = CGPointMake(k_SIZE.width /2, 200);
    CGPoint middleEndPoint = CGPointMake(k_SIZE.width / 1.2, k_LAND_BEGIN_HEIGHT);
    
    [middleSnowbergPath moveToPoint:middleStartPoint];
    [middleSnowbergPath addLineToPoint:middleTopPoint];
    [middleSnowbergPath addLineToPoint:middleEndPoint];
    
    [middleSnowbergPath closePath];
    
    middleSnowberg.path = middleSnowbergPath.CGPath;
    middleSnowberg.fillColor = [UIColor whiteColor].CGColor;
    [self.view.layer insertSublayer:middleSnowberg above:leftSnowbergBody];
    
    //    开始画山体没有被雪覆盖的部分
    CAShapeLayer *middleSnowbergBody = [[CAShapeLayer alloc] init];
    UIBezierPath *middleSnowbergBodyPath = [[UIBezierPath alloc] init];
    
    //    把bezierpath的起点移动到雪山左下角相同的位置
    [middleSnowbergBodyPath moveToPoint:middleStartPoint];
    
    
    CGPoint middleFirstPathPoint = [self calculateWithXValue:(middleStartPoint.x + 70) startPoint:middleStartPoint endpoint:middleTopPoint];
    
    [middleSnowbergBodyPath addLineToPoint:middleFirstPathPoint];
    [middleSnowbergBodyPath addLineToPoint:CGPointMake(middleFirstPathPoint.x + 20, middleFirstPathPoint.y)];
    [middleSnowbergBodyPath addLineToPoint:CGPointMake(middleFirstPathPoint.x + 50, middleFirstPathPoint.y + 30)];
    [middleSnowbergBodyPath addLineToPoint:CGPointMake(middleFirstPathPoint.x + 80, middleFirstPathPoint.y - 10)];
    [middleSnowbergBodyPath addLineToPoint:CGPointMake(middleFirstPathPoint.x + 120, middleFirstPathPoint.y + 20)];
    
    CGPoint middleSecondPathPoint = [self calculateWithXValue:(middleEndPoint.x - 120) startPoint:middleTopPoint endpoint:middleEndPoint];
    
    [middleSnowbergBodyPath addLineToPoint:CGPointMake(middleSecondPathPoint.x - 30, middleSecondPathPoint.y)];
    [middleSnowbergBodyPath addLineToPoint:middleSecondPathPoint];
    
    [middleSnowbergBodyPath addLineToPoint:middleEndPoint];
    
    [middleSnowbergBodyPath closePath];
    
    middleSnowbergBody.path = middleSnowbergBodyPath.CGPath;
    UIColor *middleSnowColor = [UIColor colorWithDisplayP3Red:125.0 /255.0 green:87.0 /255.0 blue:7.0 /255.0 alpha:1.0];
    middleSnowbergBody.fillColor = middleSnowColor.CGColor;
    [self.view.layer insertSublayer:middleSnowbergBody above:middleSnowberg];
    
}

//初始化草坪
- (void)initLawn{
    CAShapeLayer *leftLawn = [[CAShapeLayer alloc] init];
    UIBezierPath *leftLawnPath = [[UIBezierPath alloc] init];
    
    CGPoint leftStartPoint = CGPointMake(0, k_LAND_BEGIN_HEIGHT);
    
    [leftLawnPath moveToPoint:leftStartPoint];
    [leftLawnPath addLineToPoint:CGPointMake(0, k_SIZE.height - 100)];
    
    //    画一个二次贝塞尔曲线
    [leftLawnPath addQuadCurveToPoint:CGPointMake(k_SIZE.width / 3.0, k_LAND_BEGIN_HEIGHT) controlPoint:CGPointMake(k_SIZE.width / 5.0, k_SIZE.height - 100)];
    
    leftLawn.path = leftLawnPath.CGPath;
    leftLawn.fillColor = [UIColor colorWithDisplayP3Red:82.0 / 255.0 green:177.0 / 255.0 blue:52.0 / 255.0 alpha:1.0].CGColor;
    [self.view.layer addSublayer:leftLawn];
    
    CAShapeLayer *rightLawn = [[CAShapeLayer alloc] init];
    UIBezierPath *rightLawnPath = [[UIBezierPath alloc] init];
    
    [rightLawnPath moveToPoint:leftStartPoint];
    //    画一个二次贝塞尔曲线
    [rightLawnPath addQuadCurveToPoint:CGPointMake(k_SIZE.width, k_SIZE.height - 80) controlPoint:CGPointMake(k_SIZE.width / 2.0, k_SIZE.height - 100)];
    [rightLawnPath addLineToPoint:CGPointMake(k_SIZE.width, k_LAND_BEGIN_HEIGHT)];
    
    rightLawn.path = rightLawnPath.CGPath;
    rightLawn.fillColor = [UIColor colorWithDisplayP3Red:92.0/255.0 green:195.0/255.0 blue:52.0/255.0 alpha:1.0].CGColor;
    [self.view.layer insertSublayer:rightLawn above:leftLawn];
}


//初始化土地
- (void)initLand{
    _landLayer = [[CALayer alloc] init];
    _landLayer.frame = CGRectMake(0, k_LAND_BEGIN_HEIGHT, k_SIZE.width, 20);
    _landLayer.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ground"]].CGColor;
    [self.view.layer addSublayer:_landLayer];
}

//初始化黄色轨道
- (void)initYellowTrack{
    _yellowTrack = [[CAShapeLayer alloc] init];
    _yellowTrack.lineWidth = 5;
    _yellowTrack.strokeColor = [UIColor colorWithDisplayP3Red:210.0 / 255.0 green:179.0 / 255.0 blue:54.0 / 255.0 alpha:1.0].CGColor;
    
    UIBezierPath *trackPath = [[UIBezierPath alloc] init];
    //    画一个三次贝塞尔曲线+一个二次贝塞尔曲线
    //    左侧两个拐弯的三次贝塞尔曲线
    [trackPath moveToPoint:CGPointMake(0, k_SIZE.height - 60)];
    [trackPath addCurveToPoint:CGPointMake(k_SIZE.width / 1.5, k_SIZE.height / 2.0 - 20) controlPoint1:CGPointMake(k_SIZE.width / 6.0, k_SIZE.height - 200) controlPoint2:CGPointMake(k_SIZE.width / 3.0, k_SIZE.height + 50)];
    //    右侧一个弯度的二次贝塞尔曲线
    [trackPath addQuadCurveToPoint:CGPointMake(k_SIZE.width + 50, k_SIZE.height / 3.0) controlPoint:CGPointMake(k_SIZE.width - 100, 50)];
    
    [trackPath addLineToPoint:CGPointMake(k_SIZE.width + 10, k_SIZE.height + 10)];
    [trackPath addLineToPoint:CGPointMake(0, k_SIZE.height + 10)];
    
    _yellowTrack.fillColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"yellow"]].CGColor;
    _yellowTrack.path = trackPath.CGPath;
    [self.view.layer insertSublayer:_yellowTrack below:_landLayer];
    
    //    为了能够让弧线更好看一点，需要加入镂空的虚线
    CAShapeLayer *trackLine = [[CAShapeLayer alloc] init];
    trackLine.lineCap = kCALineCapRound;
    trackLine.strokeColor = [UIColor whiteColor].CGColor;
    
    trackLine.lineDashPattern = @[@1.0,@6.0];
    trackLine.lineWidth = 2.5;
    trackLine.fillColor = [UIColor clearColor].CGColor;
    trackLine.path = trackPath.CGPath;
    [_yellowTrack addSublayer:trackLine];
    
}

//初始化绿色轨道
- (void)initGreenTrack{
    _greenTrack = [[CAShapeLayer alloc] init];
    _greenTrack.lineWidth = 5;
    _greenTrack.strokeColor = [UIColor colorWithDisplayP3Red:0.0 / 255.0 green:147.0 / 255.0 blue:163.0 /255.0  alpha:1.0].CGColor;
    //    绿色铁轨的火车从右侧进入，所以从右侧开始绘画。需要画三条曲线，右边一条+中间的圆圈+左边一条
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(k_SIZE.width + 10, k_LAND_BEGIN_HEIGHT)];
    [path addLineToPoint:CGPointMake(k_SIZE.width + 10, k_SIZE.height - 70)];
    [path addQuadCurveToPoint:CGPointMake(k_SIZE.width / 1.5, k_SIZE.height - 70) controlPoint:CGPointMake(k_SIZE.width - 150, 200)];
    
    //    画圆圈
    [path addArcWithCenter:CGPointMake(k_SIZE.width / 1.6, k_SIZE.height - 140) radius:70 startAngle:M_PI_2 endAngle:2.5 * M_PI clockwise:YES];
    
    [path addCurveToPoint:CGPointMake(0, k_SIZE.height - 100) controlPoint1:CGPointMake(k_SIZE.width / 1.8 - 60, k_SIZE.height - 60) controlPoint2:CGPointMake(150, k_SIZE.height / 2.3)];
    
    [path addLineToPoint:CGPointMake(- 10, k_LAND_BEGIN_HEIGHT)];
    _greenTrack.path = path.CGPath;
    _greenTrack.fillColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"green"]].CGColor;
    [self.view.layer addSublayer:_greenTrack];
    
    //    为了能够让弧线更好看一点，需要加入镂空的虚线
    CAShapeLayer *trackLine = [[CAShapeLayer alloc] init];
    trackLine.lineCap = kCALineCapRound;
    trackLine.strokeColor = [UIColor whiteColor].CGColor;
    
    trackLine.lineDashPattern = @[@1.0,@6.0];
    trackLine.lineWidth = 2.5;
    trackLine.fillColor = [UIColor clearColor].CGColor;
    trackLine.path = path.CGPath;
    [_greenTrack addSublayer:trackLine];
}

//添加点缀的小树
- (void)initTree{
    
    [self addTreesWithNumber:7 treeFrame:CGRectMake(0, k_LAND_BEGIN_HEIGHT - 20, 13, 23)];
    [self addTreesWithNumber:7 treeFrame:CGRectMake(0, k_LAND_BEGIN_HEIGHT - 64, 18, 32)];
    [self addTreesWithNumber:5 treeFrame:CGRectMake(0, k_LAND_BEGIN_HEIGHT - 90, 13, 23)];
}

////添加小树
- (void)addTreesWithNumber:(NSInteger)treesNumber treeFrame:(CGRect)frame{
    UIImage *tree = [UIImage imageNamed:@"tree"];
    for (NSInteger i = 0; i < treesNumber + 1; i++) {
        CALayer *treeLayer = [[CALayer alloc] init];
        treeLayer.contents = (__bridge id _Nullable)(tree.CGImage);
        treeLayer.frame = CGRectMake(k_SIZE.width - 50 * i * (arc4random_uniform(4) + 1), frame.origin.y, frame.size.width, frame.size.height);
        [self.view.layer insertSublayer:treeLayer above:_greenTrack];
            }
}
//云彩的动画
- (void)initCloudAnimation{
    CALayer *cloud = [[CALayer alloc]init];
    cloud.contents = (__bridge id _Nullable)([UIImage imageNamed:@"cloud"].CGImage);
    cloud.frame = CGRectMake(0, 0, 63, 20);
    [self.view.layer addSublayer:cloud];
    
    UIBezierPath *cloudPath = [[UIBezierPath alloc] init];
    [cloudPath moveToPoint:CGPointMake(k_SIZE.width + 63, 50)];
    [cloudPath addLineToPoint:CGPointMake(-63, 50)];
    
    CAKeyframeAnimation *ani = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    ani.path = cloudPath.CGPath;
    ani.duration = 30;
    ani.autoreverses = NO;
    ani.repeatCount = CGFLOAT_MAX;
    ani.calculationMode = kCAAnimationPaced;
    
    [cloud addAnimation:ani forKey:@"position"];
}



//抽取过山车的动画
- (CAKeyframeAnimation *)carAnimationWith:(NSString *)carImageName TrackLayer:(CAShapeLayer *)track AnimationDuration:(CFTimeInterval)duration BeginTime:(CFTimeInterval)beginTime{
    CALayer *car = [[CALayer alloc] init];
    car.frame = CGRectMake(0, 0, 22, 15);
    car.contents = (__bridge id _Nullable)([UIImage imageNamed:carImageName].CGImage);
    
    CAKeyframeAnimation *ani = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    ani.path = track.path;
    
    ani.duration = duration;
    ani.beginTime = beginTime;
    ani.autoreverses = NO;
    ani.repeatCount = CGFLOAT_MAX;
    ani.calculationMode = kCAAnimationPaced;
    ani.rotationMode = kCAAnimationRotateAuto;
    
    [track addSublayer:car];
    [car addAnimation:ani forKey:@"carAni"];
    
    return ani;
}

//根据起始点，算出指定的x在这条线段上对应的y。返回这个point。知道两点，根据两点坐标，求出两点连线的斜率。y=kx+b求出点坐标。
- (CGPoint)calculateWithXValue:(CGFloat)xvalue startPoint:(CGPoint)startPoint endpoint:(CGPoint)endpoint{
    //    求出两点连线的斜率
    CGFloat k = (endpoint.y - startPoint.y) / (endpoint.x - startPoint.x);
    CGFloat b = startPoint.y - startPoint.x * k;
    CGFloat yvalue = k * xvalue + b;
    return CGPointMake(xvalue, yvalue);
}

@end
