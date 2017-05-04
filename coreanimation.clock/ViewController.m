//
//  ViewController.m
//  coreanimation.clock
//
//  Created by Lisa Lau on 11/04/2017.
//  Copyright © 2017 Lisa Lau. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    
    CALayer *hourLayer;
    CALayer *minuteLayer;
    CALayer *secondsLayer;
}

@end

@implementation ViewController

-(CALayer*) createSecondsForClockFrame:(CGFloat)size {
    
    CAShapeLayer* clockFrame = [CAShapeLayer layer];
    [clockFrame setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0,0, size, size)] CGPath]];
    [clockFrame setStrokeColor:[[UIColor blackColor] CGColor]];
    clockFrame.lineWidth = 8;
    [clockFrame setFillColor:[[UIColor clearColor] CGColor]];
    
    for (int i = 0; i < 60; i ++) {
        
        double secondsLength = 10;
        double secondsWidth = 2;
        
        if(i%5 == 0) {
            secondsLength = 20;
        }
        
        CALayer* innerClockFrame = [CALayer layer];
        innerClockFrame.backgroundColor = [[UIColor clearColor] CGColor];
        innerClockFrame.anchorPoint = CGPointMake(0, 0);
        innerClockFrame.position = CGPointMake(size/2, size/2);
        innerClockFrame.bounds = CGRectMake(0, 0, secondsWidth, size/2);
        
        CALayer* innerClockFrameSeconds = [CALayer layer];
        innerClockFrameSeconds.backgroundColor = [[UIColor blackColor] CGColor];
        innerClockFrameSeconds.anchorPoint = CGPointMake(0, 0);
        innerClockFrameSeconds.position = CGPointMake(0 ,size/2 - secondsLength);
        innerClockFrameSeconds.bounds = CGRectMake(0, 0, secondsWidth, secondsLength);
        
        [innerClockFrame addSublayer:innerClockFrameSeconds];
        innerClockFrame.transform = CATransform3DMakeRotation(-i * (6.0/180 *M_PI), 0, 0, 1);
        [clockFrame addSublayer:innerClockFrame];
    }
    return clockFrame;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    CALayer *layer = [CALayer layer];
    UIView* view2 = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 300.0f, 300.0f)];
    layer.frame = [view2 frame];
    layer.sublayerTransform = CATransform3DMakeScale(1, -1, 1);
    [[view2 layer] addSublayer:layer];
    [self.view addSubview:view2];
    
    // Draw clock frame
    [layer addSublayer:[self createSecondsForClockFrame:view2.bounds.size.height]];
    
    
    //Draw the hours layer
    hourLayer = [CALayer layer];
    hourLayer.backgroundColor = [[UIColor blackColor] CGColor];
    hourLayer.anchorPoint = CGPointMake(0.5, 0);
    hourLayer.position = CGPointMake(view2.bounds.size.width/2, view2.bounds.size.height/2);
    hourLayer.bounds = CGRectMake(0, 0, 5, view2.bounds.size.width/2 -100);
    [layer addSublayer:hourLayer];
    
    //Draw the minute layer
    minuteLayer = [CALayer layer];
    minuteLayer.backgroundColor = [[UIColor blueColor] CGColor];
    minuteLayer.anchorPoint = CGPointMake(0.5, 0);
    minuteLayer.position = CGPointMake(view2.bounds.size.width/2, view2.bounds.size.height/2);
    minuteLayer.bounds = CGRectMake(0, 0, 3, view2.bounds.size.width/2 -50);
    [layer addSublayer:minuteLayer];
    
    //Draw the seconds layer
    secondsLayer = [CALayer layer];
    secondsLayer.backgroundColor = [[UIColor redColor] CGColor];
    secondsLayer.anchorPoint = CGPointMake(0, 0);
    secondsLayer.position = CGPointMake(view2.bounds.size.width/2, view2.bounds.size.height/2);
    secondsLayer.bounds = CGRectMake(0, 0, 2, view2.bounds.size.width/2 -20);
    [layer addSublayer:secondsLayer];
    
    //Place the hands at correct location
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitSecond | NSCalendarUnitMinute | NSCalendarUnitHour fromDate:[NSDate date]];
    
    NSInteger seconds = dateComponents.second;
    NSInteger minutes = dateComponents.minute;
    NSInteger hours = dateComponents.hour;
    
    CGFloat hourAngle = (hours * (360/12)) + (minutes * (1.0/60) * (360/12));
    CGFloat minuteAngle = minutes * (360/60);
    CGFloat secondsAngle = seconds * 360/60;
    
    
    hourLayer.transform = CATransform3DMakeRotation(hourAngle/180 *M_PI, 0, 0, 1);
    minuteLayer.transform = CATransform3DMakeRotation(minuteAngle /180 *M_PI, 0, 0, 1);
    secondsLayer.transform = CATransform3DMakeRotation(secondsAngle /180 *M_PI, 0, 0, 1);
    
    CABasicAnimation *secondsAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    secondsAnimation.repeatCount = HUGE_VALF;
    secondsAnimation.duration = 60;
    secondsAnimation.removedOnCompletion = NO;
    secondsAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    secondsAnimation.fromValue = @(secondsAngle * M_PI / 180);
    secondsAnimation.byValue = @(-2 * M_PI);
    [secondsLayer addAnimation:secondsAnimation forKey:@"SecondAnimationKey"];
    
    CABasicAnimation *minutesAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    minutesAnimation.repeatCount = HUGE_VALF;
    minutesAnimation.duration = 60*60;
    minutesAnimation.removedOnCompletion = NO;
    minutesAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    minutesAnimation.fromValue = @(-minuteAngle * M_PI / 180);
    minutesAnimation.byValue = @(-2 * M_PI);
    [minuteLayer addAnimation:minutesAnimation forKey:@"MinutesAnimationKey"];
    
    CABasicAnimation *hoursAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    hoursAnimation.repeatCount = HUGE_VALF;
    hoursAnimation.duration = 60*60*12;
    hoursAnimation.removedOnCompletion = NO;
    hoursAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    hoursAnimation.fromValue = @(-hourAngle * M_PI / 180);
    hoursAnimation.byValue = @(-2 * M_PI);
    [hourLayer addAnimation:hoursAnimation forKey:@"HoursAnimationKey"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
