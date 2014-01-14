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
    NSDictionary *attributes = @{NSFontAttributeName:lbText.font};
    CGRect rect = [lbText.text boundingRectWithSize:CGSizeMake(lbText.frame.size.width, MAXFLOAT)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:attributes
                                            context:nil];
    
    return ceil(rect.size.height);
}

- (void)setLabelAttributes:(UILabel *)lb
{
    lb.backgroundColor = [UIColor clearColor];
    lb.textAlignment = NSTextAlignmentCenter;
    lb.numberOfLines = 0;
    
    lb.font = DO_TITLE_FONT;
    lb.textColor = DO_TITLE_TEXT_COLOR;
}

- (void)setButtonAttributes:(UIButton *)bt cancel:(BOOL)bCancel
{
    bt.autoresizingMask = UIViewAutoresizingFlexibleWidth;

    if (bCancel)
    {
        bt.backgroundColor = DO_CANCEL_COLOR;
        bt.titleLabel.font = DO_TITLE_FONT;
        bt.titleLabel.textColor = DO_CANCEL_TEXT_COLOR;
    }
    else
    {
        bt.backgroundColor = DO_BUTTON_COLOR;
        bt.titleLabel.font = DO_BUTTON_FONT;
        bt.titleLabel.textColor = DO_BUTTON_TEXT_COLOR;
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
    self.backgroundColor = DO_DIMMED_COLOR;

    // make back view -----------------------------------------------------------------------------------------------
    _vActionSheet = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
    _vActionSheet.backgroundColor = DO_BACK_COLOR;
    [self addSubview:_vActionSheet];
    
    // Title --------------------------------------------------------------------------------------------------------
    if (_strTitle != nil && _strTitle.length > 0)
    {
        UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(DO_TITLE_INSET.left, DO_TITLE_INSET.top,
                                                                     _vActionSheet.frame.size.width - (DO_TITLE_INSET.left + DO_TITLE_INSET.right) , 0)];
        lbTitle.text = _strTitle;
        [self setLabelAttributes:lbTitle];
        lbTitle.frame = CGRectMake(DO_TITLE_INSET.left, DO_TITLE_INSET.top, lbTitle.frame.size.width, [self getTextHeight:lbTitle]);
        lbTitle.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [_vActionSheet addSubview:lbTitle];
        
        dHeight = lbTitle.frame.size.height + DO_TITLE_INSET.bottom;
        
        // underline
        UIView *vLine = [[UIView alloc] initWithFrame:CGRectMake(lbTitle.frame.origin.x, lbTitle.frame.origin.y + lbTitle.frame.size.height - 3, lbTitle.frame.size.width, 0.5)];
        vLine.backgroundColor = DO_TITLE_TEXT_COLOR;
        vLine.alpha = 0.2;
        vLine.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [_vActionSheet addSubview:vLine];
    }
    else
        dHeight += DO_TITLE_INSET.bottom;

    // add scrollview for many buttons and content
    UIScrollView *sc = [[UIScrollView alloc] initWithFrame:CGRectMake(0, dHeight + DO_BUTTON_INSET.top, 320, 370)];
    sc.backgroundColor = [UIColor clearColor];
    [_vActionSheet addSubview:sc];
    sc.autoresizingMask = UIViewAutoresizingFlexibleWidth;

    double dYContent = 0;

    dYContent += [self addContent:sc];
    if (dYContent > 0)
        dYContent += DO_BUTTON_INSET.bottom + DO_BUTTON_INSET.top;

    // add buttons
    int nTagIndex = 0;
    for (NSString *str in _aButtons)
    {
        UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
        bt.tag = nTagIndex;
        [bt setTitle:str forState:UIControlStateNormal];
        
        [self setButtonAttributes:bt cancel:NO];
        bt.frame = CGRectMake(DO_BUTTON_INSET.left, dYContent,
                              _vActionSheet.frame.size.width - (DO_BUTTON_INSET.left + DO_BUTTON_INSET.right), DO_BUTTON_HEIGHT);
        
        dYContent += DO_BUTTON_HEIGHT + DO_BUTTON_INSET.bottom;
        
        [sc addSubview:bt];
        
        if (nTagIndex == _nDestructiveIndex)
            bt.backgroundColor = DO_DESTRUCTIVE_COLOR;

        nTagIndex += 1;
   }
    
    sc.contentSize = CGSizeMake(sc.frame.size.width, dYContent);
    dHeight += DO_BUTTON_INSET.bottom + MIN(dYContent, sc.frame.size.height);
    
    // add Cancel button
    if (_strCancel != nil && _strCancel.length > 0)
    {
        UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
        bt.tag = DO_CANCEL_TAG;
        [bt setTitle:_strCancel forState:UIControlStateNormal];
        
        [self setButtonAttributes:bt cancel:YES];
        bt.frame = CGRectMake(DO_BUTTON_INSET.left, dHeight + DO_BUTTON_INSET.top + DO_BUTTON_INSET.bottom,
                              _vActionSheet.frame.size.width - (DO_BUTTON_INSET.left + DO_BUTTON_INSET.right), DO_BUTTON_HEIGHT);
        
        dHeight += DO_BUTTON_HEIGHT + (DO_BUTTON_INSET.top + DO_BUTTON_INSET.bottom) * 2;
        
        [_vActionSheet addSubview:bt];
    }
    else
        dHeight += DO_BUTTON_INSET.bottom;
    
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
    
    switch (_nContentMode) {
        case DoContentImage:
        {
            UIImageView *iv     = nil;
            if (_iImage != nil)
            {
                UIImage *iResized = [_iImage resizedImageWithMaximumSize:CGSizeMake(360, 360)];
                
                iv = [[UIImageView alloc] initWithImage:iResized];
                iv.contentMode = UIViewContentModeScaleAspectFit;
                iv.frame = CGRectMake(DO_BUTTON_INSET.left, DO_BUTTON_INSET.top, iResized.size.width / 2, iResized.size.height / 2);
                iv.center = CGPointMake(sc.center.x, iv.center.y);
                iv.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;

                [sc addSubview:iv];
                dContentOffset = iv.frame.size.height + DO_BUTTON_INSET.bottom + DO_BUTTON_INSET.bottom;
            }
        }
            break;
            
        case DoContentMap:
        {
            if (_dLocation == nil)
            {
                dContentOffset = 0;
                break;
            }
            
            MKMapView *vMap = [[MKMapView alloc] initWithFrame:CGRectMake(DO_BUTTON_INSET.left, DO_BUTTON_INSET.top,
                                                                          240, 180)];
            vMap.center = CGPointMake(sc.center.x, vMap.center.y);
            
            vMap.delegate = self;
            vMap.centerCoordinate = CLLocationCoordinate2DMake([_dLocation[@"latitude"] doubleValue], [_dLocation[@"longitude"] doubleValue]);
            vMap.camera.altitude = [_dLocation[@"altitude"] doubleValue];
            vMap.camera.pitch = 70;
            vMap.showsBuildings = YES;
            vMap.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;

            [sc addSubview:vMap];
            dContentOffset = 180 + DO_BUTTON_INSET.bottom;
            
//            [vMap showAnnotations:@[pointRavens,pointSteelers,pointBengals, pointBrowns] animated:YES];
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
        case DoTransitionStyleNormal:
        case DoTransitionStylePop:
            _vActionSheet.frame = CGRectMake(0, self.bounds.size.height,
                                             self.bounds.size.width, _vActionSheet.frame.size.height + _dRound + 5);
            break;

        case DoTransitionStyleFade:
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
            case DoTransitionStyleNormal:
                _vActionSheet.frame = CGRectMake(0, self.bounds.size.height - _vActionSheet.frame.size.height + 15,
                                                 self.bounds.size.width, _vActionSheet.frame.size.height);
                
                break;
                
            case DoTransitionStyleFade:
                _vActionSheet.alpha = 1.0;
                break;
                
            case DoTransitionStylePop:
                _vActionSheet.frame = CGRectMake(0, self.bounds.size.height - _vActionSheet.frame.size.height + 10,
                                                 self.bounds.size.width, _vActionSheet.frame.size.height);
                
                break;
                
            default:
                break;
        }
    } completion:^(BOOL finished) {

        if (_nAnimationType == DoTransitionStylePop)
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
            case DoTransitionStyleNormal:
                _vActionSheet.frame = CGRectMake(0, self.bounds.size.height,
                                                 self.bounds.size.width, _vActionSheet.frame.size.height);
                break;

            case DoTransitionStyleFade:
                _vActionSheet.alpha = 0.0;
                break;
                
            case DoTransitionStylePop:
                _vActionSheet.frame = CGRectMake(0, self.bounds.size.height - _vActionSheet.frame.size.height + 10,
                                                 self.bounds.size.width, _vActionSheet.frame.size.height);

                break;
        }

        [UIView setAnimationDelay:0.1];
        if (_nAnimationType != DoTransitionStylePop)
        {
            _vActionSheet.alpha = 0.0;
            self.alpha = 0.0;
        }
        
    } completion:^(BOOL finished) {
        
        if (_nAnimationType == DoTransitionStylePop)
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

    _result(DO_CANCEL_TAG);
    [self hideAnimation];
}

@end
