//
//  ViewController.m
//  DigitRecognizer
//
//  Created by Umang Patel on 11/24/23.
//

#import "ViewController.h"
#import <CoreML/CoreML.h>
#import <Vision/Vision.h>
#import "MNISTClassifier.h"


@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *drawingCanvas;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (strong,nonatomic) CIImage *imageToDetect;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpCanvasColors];
}

- (IBAction)predictButtonPressed:(id)sender {
    [self predictDigit];
}

- (IBAction)clearButtonPressed:(id)sender {
    self.drawingCanvas.image = nil;
    self.imageToDetect = nil;
    self.resultLabel.text = @"Draw a number or tap on an image";
}

# pragma Canvas Setup
-(void)setUpCanvasColors{
    
    brush = 10.0;
    opacity = 1.0;
    
    // White
    red = 255.0/255.0;
    green = 255.0/255.0;
    blue = 255.0/255.0;
    
    //Canvas Background
    self.drawingCanvas.backgroundColor = [UIColor blackColor];
    
}

- (IBAction)test3ButtonPressed:(id)sender {
    self.drawingCanvas.image = [UIImage imageNamed:@"3.png"];
    self.resultLabel.text = @"Hit predict...";
}

- (IBAction)test4ButtonPressed:(id)sender {
    self.drawingCanvas.image = [UIImage imageNamed:@"4.png"];
    self.resultLabel.text = @"Hit predict...";
}

- (IBAction)test5ButtonPressed:(id)sender {
    self.drawingCanvas.image = [UIImage imageNamed:@"5.png"];
    self.resultLabel.text = @"Hit predict...";
}

- (IBAction)test6ButtonPressed:(id)sender {
    self.drawingCanvas.image = [UIImage imageNamed:@"6.png"];
    self.resultLabel.text = @"Hit predict...";
}

- (IBAction)test7ButtonPressed:(id)sender {
    self.drawingCanvas.image = [UIImage imageNamed:@"7.png"];
    self.resultLabel.text = @"Hit predict...";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma predictions
-(void)predictDigit{
    
    //scaled image to 28x28
    UIImage *scaledCanvasImage = [self imageWithImage:self.drawingCanvas.image scaledToSize:CGSizeMake(28, 28)];
    self.imageToDetect = [[CIImage alloc]initWithImage:scaledCanvasImage];
    
    MLModel *ml_model = [[[MNISTClassifier alloc] init] model];
    VNCoreMLModel *vnc_core_ml_model = [VNCoreMLModel modelForMLModel: ml_model error:nil];
    
    VNCoreMLRequest *request = [[VNCoreMLRequest alloc] initWithModel: vnc_core_ml_model completionHandler: (VNRequestCompletionHandler) ^(VNRequest *request, NSError *error){
        NSArray *results = [request.results copy];
        
        NSMutableString *resultString = [NSMutableString string];
        for (VNClassificationObservation *res in results) {
            [resultString appendFormat:@"Digit: %@, Probability: %f\n", res.identifier, res.confidence];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.resultLabel.text = resultString;
        });
    }];
    
    NSDictionary *options_dict = [[NSDictionary alloc] init];
    NSArray *request_array = @[request];
    
    VNImageRequestHandler *handler = [[VNImageRequestHandler alloc] initWithCIImage:self.imageToDetect options:options_dict];
    dispatch_queue_t myCustomQueue;
    myCustomQueue = dispatch_queue_create("com.example.VNImageRequestHandlerQueue", NULL);
    
    self.resultLabel.text = @"Predicting...";
    dispatch_sync(myCustomQueue, ^{
        [handler performRequests:request_array error:nil];
        
    });
}


// scale uiimage
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 1.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma Touch and Draw Delegates
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    fingerMovedOnScreen = NO;
    UITouch *touch = [touches anyObject];
    fingersLastPoint = [touch locationInView:self.drawingCanvas];
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    fingerMovedOnScreen = YES;
    UITouch *touch = [touches anyObject];
    
    CGPoint currentPoint = [touch locationInView:self.drawingCanvas];
    UIGraphicsBeginImageContext(self.drawingCanvas.frame.size);
    
    [self.drawingCanvas.image drawInRect:CGRectMake(0,
                                                    0,
                                                    self.drawingCanvas.frame.size.width,
                                                    self.drawingCanvas.frame.size.height)];
    
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), fingersLastPoint.x, fingersLastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush );
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, 1.0);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.drawingCanvas.image = UIGraphicsGetImageFromCurrentImageContext();
    [self.drawingCanvas setAlpha:opacity];
    UIGraphicsEndImageContext();
    
    fingersLastPoint = currentPoint;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(!fingerMovedOnScreen) {
        UIGraphicsBeginImageContext(self.drawingCanvas.frame.size);
        [self.drawingCanvas.image drawInRect:CGRectMake(0,
                                                        0,
                                                        self.drawingCanvas.frame.size.width,
                                                        self.drawingCanvas.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, opacity);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), fingersLastPoint.x, fingersLastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), fingersLastPoint.x, fingersLastPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        CGContextFlush(UIGraphicsGetCurrentContext());
        self.drawingCanvas.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
}

@end
