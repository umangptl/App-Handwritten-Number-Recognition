//
//  ViewController.h
//  DigitRecognizer
//
//  Created by Umang Patel on 11/24/23.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController{
    BOOL fingerMovedOnScreen;
    CGPoint fingersLastPoint;
    
    CGFloat opacity;
    CGFloat brush;
    
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    
}

@end
