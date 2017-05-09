//
//  ViewController.m
//  coreanimation.clock
//

#import "ViewController.h"

@interface ViewController (){
    
    CALayer *hourLayer;
    CALayer *minuteLayer;
    CALayer *secondsLayer;
}

@end

@implementation ViewController

-(CALayer*) createTicksForClockFrame:(CGFloat)size {
    
    CAShapeLayer* clockFrame = [CAShapeLayer layer];
//    [clockFrame setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0,0, size, size)] CGPath]];
//    [clockFrame setStrokeColor:[[UIColor blackColor] CGColor]];
//    clockFrame.lineWidth = 8;
//    [clockFrame setFillColor:[[UIColor clearColor] CGColor]];
    
    CAShapeLayer* dot = [CAShapeLayer layer];
    dot.position = CGPointMake(size/2 - 3, size/2 - 3);
    [dot setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0,0, 6, 6)] CGPath]];
    [dot setFillColor:[[UIColor blackColor] CGColor]];
    [clockFrame addSublayer:dot];
    
    //Add the second ticks
    for (int i = 0; i < 180; i ++) {
        
        double secondsLength = 10;
        double secondsWidth = 2;
        double degreeForOneThirdSecond = 2.0; //there is a line for every 2 degrees
        
        CALayer* innerClockFrame = [CALayer layer];
        innerClockFrame.backgroundColor = [[UIColor clearColor] CGColor];
        innerClockFrame.anchorPoint = CGPointMake(0, 0);
        innerClockFrame.position = CGPointMake(size/2, size/2);
        innerClockFrame.bounds = CGRectMake(0, 0, secondsWidth, size/2);
        
        if( i % 3 == 0) {
            secondsLength = 1.5 * secondsLength;
        }
        
        if( i % 15 == 0) {
            
            CALayer* innerClockFrameHourIndicator = [CALayer layer];
            innerClockFrameHourIndicator.backgroundColor = [[UIColor grayColor] CGColor];
            innerClockFrameHourIndicator.anchorPoint = CGPointMake(0, 0);
            innerClockFrameHourIndicator.position = CGPointMake(0 ,0.6 * size/2);
            innerClockFrameHourIndicator.cornerRadius = 2;
            innerClockFrameHourIndicator.bounds = CGRectMake(0, 0, 2 * secondsWidth, 0.2 * size/2);
            
            [innerClockFrame addSublayer:innerClockFrameHourIndicator];
        }
        
        CALayer* innerClockFrameTicks = [CALayer layer];
        innerClockFrameTicks.backgroundColor = [[UIColor blackColor] CGColor];
        innerClockFrameTicks.anchorPoint = CGPointMake(0, 0);
        innerClockFrameTicks.position = CGPointMake(0 ,size/2 - secondsLength);
        innerClockFrameTicks.bounds = CGRectMake(0, 0, secondsWidth, secondsLength);
        
        [innerClockFrame addSublayer:innerClockFrameTicks];
        innerClockFrame.transform = CATransform3DMakeRotation(i * ([self convertDegreesToRadians:degreeForOneThirdSecond]), 0, 0, 1);
        [clockFrame addSublayer:innerClockFrame];
    }
    return clockFrame;
}

- (CGFloat) convertDegreesToRadians:(CGFloat) degrees {
    return degrees * M_PI/180.0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    CALayer *layer = [CALayer layer];
    UIView* view2 = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 300.0f, 300.0f)];
    layer.frame = [view2 frame];
//    layer.sublayerTransform = CATransform3DMakeScale(1, -1, 1);
    [[view2 layer] addSublayer:layer];
    [self.view addSubview:view2];
    
    // Draw clock frame
    [layer addSublayer:[self createTicksForClockFrame:view2.bounds.size.height]];
    
    
    //Draw the hours layer
    hourLayer = [CALayer layer];
    hourLayer.backgroundColor = [[UIColor blackColor] CGColor];
    hourLayer.anchorPoint = CGPointMake(0.5, 1);
    hourLayer.position = CGPointMake(view2.bounds.size.width/2, view2.bounds.size.height/2);
    hourLayer.bounds = CGRectMake(0, 0, 5, view2.bounds.size.width/2 -100);
    [layer addSublayer:hourLayer];
    
    //Draw the minute layer
    minuteLayer = [CALayer layer];
    minuteLayer.backgroundColor = [[UIColor blueColor] CGColor];
    minuteLayer.anchorPoint = CGPointMake(0.5, 1);
    minuteLayer.position = CGPointMake(view2.bounds.size.width/2, view2.bounds.size.height/2);
    minuteLayer.bounds = CGRectMake(0, 0, 3, view2.bounds.size.width/2 -50);
    [layer addSublayer:minuteLayer];
    
    //Draw the seconds layer
    secondsLayer = [CALayer layer];
    secondsLayer.backgroundColor = [[UIColor redColor] CGColor];
    secondsLayer.anchorPoint = CGPointMake(0, 1);
    secondsLayer.position = CGPointMake(view2.bounds.size.width/2, view2.bounds.size.height/2);
    secondsLayer.bounds = CGRectMake(0, 0, 2, view2.bounds.size.width/2);
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
    
    CABasicAnimation *secondsAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    secondsAnimation.repeatCount = HUGE_VALF;
    secondsAnimation.duration = 60;
    secondsAnimation.removedOnCompletion = NO;
    secondsAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    secondsAnimation.fromValue = @([self convertDegreesToRadians:secondsAngle]);
    secondsAnimation.byValue = @(2 * M_PI);
    [secondsLayer addAnimation:secondsAnimation forKey:@"SecondAnimationKey"];
    
    CABasicAnimation *minutesAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    minutesAnimation.repeatCount = HUGE_VALF;
    minutesAnimation.duration = 60*60;
    minutesAnimation.removedOnCompletion = NO;
    minutesAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    minutesAnimation.fromValue = @([self convertDegreesToRadians:minuteAngle]);
    minutesAnimation.byValue = @(2 * M_PI);
    [minuteLayer addAnimation:minutesAnimation forKey:@"MinutesAnimationKey"];
    
    CABasicAnimation *hoursAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    hoursAnimation.repeatCount = HUGE_VALF;
    hoursAnimation.duration = 60*60*12;
    hoursAnimation.removedOnCompletion = NO;
    hoursAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    hoursAnimation.fromValue = @([self convertDegreesToRadians:hourAngle]);
    hoursAnimation.byValue = @(2 * M_PI);
    [hourLayer addAnimation:hoursAnimation forKey:@"HoursAnimationKey"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
