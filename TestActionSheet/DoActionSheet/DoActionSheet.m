//
//  DoActionSheet.m
//  TestActionSheet
//
//  Created by Donobono on 2014. 01. 01..
//

#import "DoActionSheet.h"
#import "UIImage+ResizeMagick.h"    //  Created by Vlad Andersen on 1/5/13.

#pragma mark - DoAlertViewController

@interface DoActionSheetController : UIViewController

@property (nonatomic, strong) DoActionSheet *actionSheet;

@end

@implementation DoActionSheetController

#pragma mark - View life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view = _actionSheet;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return [UIApplication sharedApplication].statusBarStyle;
}

- (BOOL)prefersStatusBarHidden
{
    return [UIApplication sharedApplication].statusBarHidden;
}

@end

@implementation DoActionSheet

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];
        
        _nDestructiveIndex = -1;
    }
    return self;
}

// with cancel button and other buttons
- (void)showC:(NSString *)strTitle
       cancel:(NSString *)strCancel
      buttons:(NSArray *)aButtons
       result:(DoActionSheetHandler)result
{
    _strTitle   = strTitle;
    _strCancel  = strCancel;
    _aButtons   = aButtons;
    _result     = result;
    
    [self showActionSheet];
}

// with cancel button and other buttons, without title
- (void)showC:(NSString *)strCancel
      buttons:(NSArray *)aButtons
       result:(DoActionSheetHandler)result
{
    _strTitle   = nil;
    _strCancel  = strCancel;
    _aButtons   = aButtons;
    _result     = result;
    
    [self showActionSheet];
}

// with only buttons
- (void)show:(NSString *)strTitle
     buttons:(NSArray *)aButtons
      result:(DoActionSheetHandler)result
{
    _strTitle   = strTitle;
    _strCancel  = nil;
    _aButtons   = aButtons;
    _result     = result;
    
    [self showActionSheet];
}

// with only buttons, without title
- (void)show:(NSArray *)aButtons
      result:(DoActionSheetHandler)result
{
    _strTitle   = nil;
    _strCancel  = nil;
    _aButtons   = aButtons;
    _result     = result;
    
    [self showActionSheet];
}

- (double)getTextHeight:(UILabel *)lbText
{
    double dHeight = 0.0;
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0)
    {
        NSDictionary *attributes = @{NSFontAttributeName:lbText.font};
        CGRect rect = [lbText.text boundingRectWithSize:CGSizeMake(lbText.frame.size.width, MAXFLOAT)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:attributes
                                         context:nil];
        
        dHeight = ceil(rect.size.height);
    }
    else
    {
        CGSize size = [lbText.text sizeWithFont:lbText.font
                              constrainedToSize:CGSizeMake(lbText.frame.size.width, MAXFLOAT)
                                  lineBreakMode:NSLineBreakByWordWrapping];
        
        dHeight = ceil(size.height);
    }
    
    return dHeight;
}

- (void)setLabelAttributes:(UILabel *)lb
{
    lb.backgroundColor = [UIColor clearColor];
    lb.textAlignment = NSTextAlignmentCenter;
    lb.numberOfLines = 0;
    
    lb.font = (self.doTitleFont == nil) ? DO_AS_TITLE_FONT : self.doTitleFont;
    lb.textColor = (self.doTitleTextColor == nil) ? DO_AS_TITLE_TEXT_COLOR : self.doTitleTextColor;
}

- (void)setButtonAttributes:(UIButton *)bt cancel:(BOOL)bCancel
{
    bt.autoresizingMask = UIViewAutoresizingFlexibleWidth;

    if (bCancel)
    {
        bt.backgroundColor = (self.doCancelColor == nil) ? DO_AS_CANCEL_COLOR : self.doCancelColor;
        bt.titleLabel.font = (self.doCancelFont == nil) ? DO_AS_TITLE_FONT : self.doCancelFont;
        [bt setTitleColor:(self.doCancelTextColor == nil) ? DO_AS_CANCEL_TEXT_COLOR : self.doCancelTextColor forState:UIControlStateNormal];
    }
    else
    {
        bt.backgroundColor = (self.doButtonColor == nil) ? DO_AS_BUTTON_COLOR : self.doButtonColor;
        bt.titleLabel.font = (self.doButtonFont == nil) ? DO_AS_BUTTON_FONT : self.doButtonFont;
        [bt setTitleColor:(self.doButtonTextColor == nil) ? DO_AS_BUTTON_TEXT_COLOR : self.doButtonTextColor forState:UIControlStateNormal];
    }

    if (_dButtonRound > 0)
    {
        CALayer *layer = [bt layer];
        [layer setMasksToBounds:YES];
        [layer setCornerRadius:_dButtonRound];
    }

    [bt addTarget:self action:@selector(buttonTarget:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)showActionSheet
{
    double dHeight = 0;
    self.backgroundColor = (self.doDimmedColor == nil) ? DO_AS_DIMMED_COLOR : self.doDimmedColor;

    // make back view -----------------------------------------------------------------------------------------------
    _vActionSheet = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
    _vActionSheet.backgroundColor = (self.doBackColor == nil) ? DO_AS_BACK_COLOR : self.doBackColor;
    [self addSubview:_vActionSheet];
    
    // Title --------------------------------------------------------------------------------------------------------
    if (_strTitle != nil && _strTitle.length > 0)
    {
        if (self.doTitleInset.top == 0 && self.doTitleInset.left == 0 && self.doTitleInset.bottom == 0 && self.doTitleInset.right == 0) {
            self.doTitleInset = DO_AS_TITLE_INSET;
        }
        
        UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(self.doTitleInset.left, self.doTitleInset.top,
                                                                     _vActionSheet.frame.size.width - (self.doTitleInset.left + self.doTitleInset.right) , 0)];
        lbTitle.text = _strTitle;
        [self setLabelAttributes:lbTitle];
        lbTitle.frame = CGRectMake(self.doTitleInset.left, self.doTitleInset.top, lbTitle.frame.size.width, [self getTextHeight:lbTitle]);
        lbTitle.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [_vActionSheet addSubview:lbTitle];
        
        dHeight = lbTitle.frame.size.height + self.doTitleInset.bottom;
        
        // underline
        UIView *vLine = [[UIView alloc] initWithFrame:CGRectMake(lbTitle.frame.origin.x, lbTitle.frame.origin.y + lbTitle.frame.size.height - 3, lbTitle.frame.size.width, 0.5)];
        vLine.backgroundColor = (self.doTitleTextColor == nil) ? DO_AS_TITLE_TEXT_COLOR : self.doTitleTextColor;
        vLine.alpha = 0.2;
        vLine.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [_vActionSheet addSubview:vLine];
    }
    else
        dHeight += self.doTitleInset.bottom;

    if (self.doButtonInset.top == 0 && self.doButtonInset.left == 0 && self.doButtonInset.bottom == 0 && self.doButtonInset.right == 0) {
        self.doButtonInset = DO_AS_BUTTON_INSET;
    }
    // add scrollview for many buttons and content
    UIScrollView *sc = [[UIScrollView alloc] initWithFrame:CGRectMake(0, dHeight + self.doButtonInset.top, 320, 370)];
    sc.backgroundColor = [UIColor clearColor];
    [_vActionSheet addSubview:sc];
    sc.autoresizingMask = UIViewAutoresizingFlexibleWidth;

    double dYContent = 0;

    dYContent += [self addContent:sc];
    if (dYContent > 0)
        dYContent += self.doButtonInset.bottom + self.doButtonInset.top;

    // add buttons
    int nTagIndex = 0;
    for (NSString *str in _aButtons)
    {
        UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
        bt.tag = nTagIndex;
        [bt setTitle:str forState:UIControlStateNormal];
        
        [self setButtonAttributes:bt cancel:NO];
        bt.frame = CGRectMake(self.doButtonInset.left, dYContent,
                              _vActionSheet.frame.size.width - (self.doButtonInset.left + self.doButtonInset.right), (self.doButtonHeight > 0) ? self.doButtonHeight : DO_AS_BUTTON_HEIGHT);
        
        dYContent += ((self.doButtonHeight > 0) ? self.doButtonHeight : DO_AS_BUTTON_HEIGHT) + self.doButtonInset.bottom;
        
        [sc addSubview:bt];
        
        if (nTagIndex == _nDestructiveIndex)
        {
            bt.backgroundColor = (self.doDestructiveColor == nil) ? DO_AS_DESTRUCTIVE_COLOR : self.doDestructiveColor;
            [bt setTitleColor:(self.doDestructiveTextColor == nil) ? DO_AS_DESTRUCTIVE_TEXT_COLOR : self.doDestructiveTextColor forState:UIControlStateNormal];
        }

        nTagIndex += 1;
   }
    
    sc.contentSize = CGSizeMake(sc.frame.size.width, dYContent);
    dHeight += self.doButtonInset.bottom + MIN(dYContent, sc.frame.size.height);
    
    // add Cancel button
    if (_strCancel != nil && _strCancel.length > 0)
    {
        UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
        bt.tag = DO_AS_CANCEL_TAG;
        [bt setTitle:_strCancel forState:UIControlStateNormal];
        
        [self setButtonAttributes:bt cancel:YES];
        bt.frame = CGRectMake(self.doButtonInset.left, dHeight + self.doButtonInset.top + self.doButtonInset.bottom,
                              _vActionSheet.frame.size.width - (self.doButtonInset.left + self.doButtonInset.right), (self.doButtonHeight > 0) ? self.doButtonHeight : DO_AS_BUTTON_HEIGHT);
        
        dHeight += ((self.doButtonHeight > 0) ? self.doButtonHeight : DO_AS_BUTTON_HEIGHT) + (self.doButtonInset.top + self.doButtonInset.bottom) * 2;
        
        [_vActionSheet addSubview:bt];
    }
    else
        dHeight += self.doButtonInset.bottom;
    
    _vActionSheet.frame = CGRectMake(0, 0, _vActionSheet.frame.size.width, dHeight + 10);

    DoActionSheetController *viewController = [[DoActionSheetController alloc] initWithNibName:nil bundle:nil];
    viewController.actionSheet = self;
    
    if (!_actionWindow)
    {
        UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        window.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        window.opaque = NO;
        window.windowLevel = UIWindowLevelAlert;
        window.rootViewController = viewController;
        _actionWindow = window;
        
        self.frame = window.frame;
        _vActionSheet.center = window.center;
    }
    [_actionWindow makeKeyAndVisible];
    
    if (_dRound > 0)
    {
        CALayer *layer = [_vActionSheet layer];
        [layer setMasksToBounds:YES];
        [layer setCornerRadius:_dRound];
    }

    [self showAnimation];
}

- (void)buttonTarget:(id)sender
{
    _result([sender tag]);
    [self hideAnimation];
}

- (double)addContent:(UIScrollView *)sc
{
    double dContentOffset = 0;
    
    if (self.doButtonInset.top == 0 && self.doButtonInset.left == 0 && self.doButtonInset.bottom == 0 && self.doButtonInset.right == 0) {
        self.doButtonInset = DO_AS_BUTTON_INSET;
    }
    switch (_nContentMode) {
        case DoASContentImage:
        {
            UIImageView *iv     = nil;
            if (_iImage != nil)
            {
                UIImage *iResized = [_iImage resizedImageWithMaximumSize:CGSizeMake(360, 360)];
                
                iv = [[UIImageView alloc] initWithImage:iResized];
                iv.contentMode = UIViewContentModeScaleAspectFit;
                iv.frame = CGRectMake(self.doButtonInset.left, self.doButtonInset.top, iResized.size.width / 2, iResized.size.height / 2);
                iv.center = CGPointMake(sc.center.x, iv.center.y);
                iv.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;

                [sc addSubview:iv];
                dContentOffset = iv.frame.size.height + self.doButtonInset.bottom + self.doButtonInset.bottom;
            }
        }
            break;
            
        case DoASContentMap:
        {
            if (_dLocation == nil)
            {
                dContentOffset = 0;
                break;
            }
            
            MKMapView *vMap = [[MKMapView alloc] initWithFrame:CGRectMake(self.doButtonInset.left, self.doButtonInset.top,
                                                                          240, 180)];
            vMap.center = CGPointMake(sc.center.x, vMap.center.y);
            
            vMap.delegate = self;
            vMap.centerCoordinate = CLLocationCoordinate2DMake([_dLocation[@"latitude"] doubleValue], [_dLocation[@"longitude"] doubleValue]);
            vMap.camera.altitude = [_dLocation[@"altitude"] doubleValue];
            vMap.camera.pitch = 70;
            vMap.showsBuildings = YES;
            vMap.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;

            [sc addSubview:vMap];
            dContentOffset = 180 + self.doButtonInset.bottom;
            
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            annotation.coordinate = vMap.centerCoordinate;
            annotation.title = @"Here~";
            [vMap addAnnotation:annotation];
        }
            break;
            
        default:
            break;
    }
    
    return dContentOffset;
}

- (void)hideActionSheet
{
    [self removeFromSuperview];
    [_actionWindow removeFromSuperview];
    _actionWindow = nil;
}

- (void)showAnimation
{
    self.alpha = 0.0;

    switch (_nAnimationType) {
        case DoASTransitionStyleNormal:
        case DoASTransitionStylePop:
            _vActionSheet.frame = CGRectMake(0, self.bounds.size.height,
                                             self.bounds.size.width, _vActionSheet.frame.size.height + _dRound + 5);
            break;

        case DoASTransitionStyleFade:
            _vActionSheet.alpha = 0.0;
            _vActionSheet.frame = CGRectMake(0, self.bounds.size.height - _vActionSheet.frame.size.height + 5,
                                             self.bounds.size.width, _vActionSheet.frame.size.height + _dRound + 5);
            break;

        default:
            break;
    }
    
    [UIView animateWithDuration:0.2 animations:^(void) {
        self.alpha = 1.0;

        [UIView setAnimationDelay:0.1];

        switch (_nAnimationType) {
            case DoASTransitionStyleNormal:
                _vActionSheet.frame = CGRectMake(0, self.bounds.size.height - _vActionSheet.frame.size.height + 15,
                                                 self.bounds.size.width, _vActionSheet.frame.size.height);
                
                break;
                
            case DoASTransitionStyleFade:
                _vActionSheet.alpha = 1.0;
                break;
                
            case DoASTransitionStylePop:
                _vActionSheet.frame = CGRectMake(0, self.bounds.size.height - _vActionSheet.frame.size.height + 10,
                                                 self.bounds.size.width, _vActionSheet.frame.size.height);
                
                break;
                
            default:
                break;
        }
    } completion:^(BOOL finished) {

        if (_nAnimationType == DoASTransitionStylePop)
        {
            [UIView animateWithDuration:0.1 animations:^(void) {

                _vActionSheet.frame = CGRectMake(0, self.bounds.size.height - _vActionSheet.frame.size.height + 18,
                                                 self.bounds.size.width, _vActionSheet.frame.size.height);

            } completion:^(BOOL finished) {

                [UIView animateWithDuration:0.1 animations:^(void) {
                    _vActionSheet.frame = CGRectMake(0, self.bounds.size.height - _vActionSheet.frame.size.height + 15,
                                                     self.bounds.size.width, _vActionSheet.frame.size.height);
                    
                }];
            }];
        }
    }];
}

- (void)hideAnimation
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];

    [UIView animateWithDuration:0.2 animations:^(void) {

        switch (_nAnimationType) {
            case DoASTransitionStyleNormal:
                _vActionSheet.frame = CGRectMake(0, self.bounds.size.height,
                                                 self.bounds.size.width, _vActionSheet.frame.size.height);
                break;

            case DoASTransitionStyleFade:
                _vActionSheet.alpha = 0.0;
                break;
                
            case DoASTransitionStylePop:
                _vActionSheet.frame = CGRectMake(0, self.bounds.size.height - _vActionSheet.frame.size.height + 10,
                                                 self.bounds.size.width, _vActionSheet.frame.size.height);

                break;
        }

        [UIView setAnimationDelay:0.1];
        if (_nAnimationType != DoASTransitionStylePop)
        {
            _vActionSheet.alpha = 0.0;
            self.alpha = 0.0;
        }
        
    } completion:^(BOOL finished) {
        
        if (_nAnimationType == DoASTransitionStylePop)
        {
            [UIView animateWithDuration:0.1 animations:^(void) {
                
                [UIView setAnimationDelay:0.1];
                _vActionSheet.frame = CGRectMake(0, self.bounds.size.height,
                                                 self.bounds.size.width, _vActionSheet.frame.size.height);
                
            } completion:^(BOOL finished) {

                [UIView animateWithDuration:0.1 animations:^(void) {
                    
                    [UIView setAnimationDelay:0.1];
                    self.alpha = 0.0;

                } completion:^(BOOL finished) {

                    [self hideActionSheet];
                
                }];
            }];
        }
        else
        {
            [self hideActionSheet];
        }
    }];
}

-(void)receivedRotate: (NSNotification *)notification
{
	dispatch_async(dispatch_get_main_queue(), ^(void) {
        
        [UIView animateWithDuration:0.2 animations:^(void) {
            _vActionSheet.frame = CGRectMake(0, self.bounds.size.height - _vActionSheet.frame.size.height + 15,
                                             self.bounds.size.width, _vActionSheet.frame.size.height);
        }];
    });
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint pt = [[touches anyObject] locationInView:self];
    if (CGRectContainsPoint(_vActionSheet.frame, pt))
        return;

    _result(DO_AS_CANCEL_TAG);
    [self hideAnimation];
}

@end
