//
//  DoActionSheet.h
//  TestActionSheet
//
//  Created by Donobono on 2014. 01. 01..
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#define DO_RGB(r, g, b)     [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define DO_RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

/* color set 1 -----------------------------------------------------------------------------
#define DO_BACK_COLOR               DO_RGB(255, 244, 244)

// button background color
#define DO_BUTTON_COLOR             DO_RGB(246, 224, 224)
#define DO_CANCEL_COLOR             DO_RGB(226, 204, 204)
#define DO_DESTRUCTIVE_COLOR        DO_RGB(242, 156, 159)

// button text color
#define DO_TITLE_TEXT_COLOR         DO_RGB(144, 110, 59)
#define DO_BUTTON_TEXT_COLOR        DO_RGB(255, 255, 255)
#define DO_CANCEL_TEXT_COLOR        DO_RGB(255, 255, 255)
#define DO_DESTRUCTIVE_TEXT_COLOR   DO_RGB(255, 255, 255)
*/

//#define DO_TITLE_BOX                DO_RGB(113, 208, 243)
//#define DO_NORMAL_BOX               DO_RGB(57, 185, 238)
//#define DO_BUTTON_BOX               DO_RGB(113, 208, 243)
//#define DO_DESTRUCTIVE_BOX          DO_RGB(235, 15, 93)
//#define DO_TEXT_COLOR               DO_RGB(255, 255, 255)
//#define DO_DESTRUCTIVE_TEXT_COLOR   DO_RGB(255, 255, 255)
//#define DO_DIMMED_COLOR             DO_RGBA(0, 0, 0, 0.7)

/* color set 2 -----------------------------------------------------------------------------
#define DO_BACK_COLOR               DO_RGBA(255, 255, 255, 0)

// button background color
#define DO_BUTTON_COLOR             DO_RGB(113, 208, 243)
#define DO_CANCEL_COLOR             DO_RGB(73, 168, 203)
#define DO_DESTRUCTIVE_COLOR        DO_RGB(235, 15, 93)

// button text color
#define DO_TITLE_TEXT_COLOR         DO_RGB(209, 247, 247)
#define DO_BUTTON_TEXT_COLOR        DO_RGB(255, 255, 255)
#define DO_CANCEL_TEXT_COLOR        DO_RGB(255, 255, 255)
#define DO_DESTRUCTIVE_TEXT_COLOR   DO_RGB(255, 255, 255)
*/

// color set 3 -----------------------------------------------------------------------------
#define DO_BACK_COLOR               DO_RGB(232, 229, 222)

// button background color
#define DO_BUTTON_COLOR             DO_RGB(158, 132, 103)
#define DO_CANCEL_COLOR             DO_RGB(240, 185, 103)
#define DO_DESTRUCTIVE_COLOR        DO_RGB(124, 192, 134)

// button text color
#define DO_TITLE_TEXT_COLOR         DO_RGB(95, 74, 50)
#define DO_BUTTON_TEXT_COLOR        DO_RGB(255, 255, 255)
#define DO_CANCEL_TEXT_COLOR        DO_RGB(255, 255, 255)
#define DO_DESTRUCTIVE_TEXT_COLOR   DO_RGB(255, 255, 255)



#define DO_DIMMED_COLOR         DO_RGBA(0, 0, 0, 0.7)

#define DO_TITLE_FONT           [UIFont fontWithName:@"Avenir-Heavy" size:14]
#define DO_BUTTON_FONT          [UIFont fontWithName:@"Avenir-Medium" size:14]

#define DO_TITLE_INSET          UIEdgeInsetsMake(10, 20, 10, 20)
#define DO_BUTTON_INSET         UIEdgeInsetsMake(5, 20, 5, 20)

#define DO_BUTTON_HEIGHT        40

#define DO_CANCEL_TAG           -100

typedef NS_ENUM(int, DoAlertViewTransitionStyle) {
    DoTransitionStyleNormal = 0,
    DoTransitionStyleFade,
    DoTransitionStylePop,
};

typedef NS_ENUM(int, DoAlertViewContentType) {
    DoContentNone = 0,
    DoContentImage,
    DoContentMap,
};

@class DoActionSheet;
typedef void(^DoActionSheetHandler)(int nResult);

@interface DoActionSheet : UIView <MKMapViewDelegate>
{
@private
    NSString                *_strTitle;
    NSString                *_strCancel;
    
    UIWindow                *_actionWindow;
    UIView                  *_vActionSheet;

    DoActionSheetHandler    _result;
    
    CGRect                  _rectActionSheet;
}

@property (readwrite)   int         nAnimationType;
@property (readwrite)   int         nContentMode;
@property (readwrite)   int         nDestructiveIndex;

@property (readwrite)   double      dRound;
@property (readwrite)   double      dButtonRound;

@property (readwrite)   BOOL        bDestructive;
@property (readonly)    int         nTag;

@property (strong, nonatomic)   NSArray         *aButtons;

// add content
// for UIImageView
@property (nonatomic, strong)   UIImage         *iImage;
// for Map view
@property (nonatomic, strong)   NSDictionary    *dLocation; // latitude, longitude

// with cancel button and other buttons
- (void)showC:(NSString *)strTitle
       cancel:(NSString *)strCancel
      buttons:(NSArray *)aButtons
       result:(DoActionSheetHandler)result;

// with cancel button and other buttons, without title
- (void)showC:(NSString *)strCancel
      buttons:(NSArray *)aButtons
       result:(DoActionSheetHandler)result;

// with only buttons
- (void)show:(NSString *)strTitle
     buttons:(NSArray *)aButtons
      result:(DoActionSheetHandler)result;

// with only buttons, without title
- (void)show:(NSArray *)aButtons
      result:(DoActionSheetHandler)result;


@end
