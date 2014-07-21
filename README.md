DoActionSheet
=============

  An replacement for UIActionSheet : block-based, customizable theme, easy to use with image or map

## Preview

### with title, with destructive button, with cancel button and with image
![DoAlertView Screenshot](https://raw.github.com/donobono/DoActionSheet/master/p1.png)

### support scroll if there are many buttons but cancel button’s position is fixed
![DoAlertView Screenshot](https://raw.github.com/donobono/DoActionSheet/master/p2.png)

### customizable color set
![DoAlertView Screenshot](https://raw.github.com/donobono/DoActionSheet/master/p3.png)

### with map
![DoAlertView Screenshot](https://raw.github.com/donobono/DoActionSheet/master/p4.png)


## Requirements
- iOS 7.0 and greater
- ARC

## ChangeLog
### 1.1.1
1. custom buttons enable
	
### 1.1.2
1. underLineEnable enable

	@property (assign, nonatomic) BOOL underLineEnable;


## Examples

**Code:**

```objc

DoActionSheet *vActionSheet = [[DoActionSheet alloc] init];
// required
vActionSheet.nAnimationType = _sgType.selectedSegmentIndex;	// there are 3 type of animation

// optional
vActionSheet.dButtonRound = 2;	

// with image
vActionSheet.iImage = [UIImage imageNamed:@"pic1.jpg"];
vActionSheet.nContentMode = DoContentImage;


// with map
vActionSheet.nContentMode = DoContentMap;
vActionSheet.dLocation = @{@"latitude" : @(37.78275123), @"longitude" : @(-122.40416442), @"altitude" : @200};


// launch DoActionSheet! - With destructive button, cancel button and title
vActionSheet.nDestructiveIndex = 2;

[vActionSheet showC:@"What do you want for this photo?"
             cancel:@"Cancel"
            buttons:@[@"Post to facebook", @"Post to Instagram", @"Delete this photo"]
             result:^(int nResult) {
                 
                 NSLog(@"---------------> result : %d", nResult);
                 
             }];


// launch DoActionSheet! - With title and without cancel button
[vActionSheet show:@"What do you want?"
            buttons:@[@"Open with Safari", @"Copy the link"]
            result:^(int nResult) {
                
                NSLog(@"---------------> result : %d", nResult);
                
            }];

```

```objc
// customizable theme
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
```


## Credits

DoActionSheet was created by Dono Cho.


## License

DoActionSheet is available under the MIT license. See the LICENSE file for more info.
