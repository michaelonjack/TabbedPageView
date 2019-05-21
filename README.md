# TabbedPageView

## Overview

TabbedPageView is a UIView subclass that allows you to quickly create a tabbed subview anywhere in your application

<div style="display:flex;">
    <img src="https://i.imgur.com/U0H0tTv.gif" width="250">
    <img src="https://i.imgur.com/XqxmKB6.gif" width="250">
    <img src="https://i.imgur.com/df8q0aL.gif" width="250">
</div>

## Information

### Delegate methods:

```func tabbedPageView(_ tabbedPageView: TabbedPageView, didSelectTabAt index: Int)``` - Called when the user selects the tab at index ```index```

### DataSource methods:

```func numberOfTabs(in tabbedPageView: TabbedPageView) -> Int``` - The number of tabs that are present in the tabbed page view

```func tabbedPageView(_ tabbedPageView: TabbedPageView, tabForIndex index: Int) -> Tab``` - Returns the tab object that should be displayed at index ```index```

### Customizabe Properties

```tabBar.position``` - Positon of the tab bar in the view. Two possible values: ```TabBarPosition.top```, ```TabBarPosition.bottom```. By default, ```TabBarPosition.top``` is used.

```tabBar.tabWidth``` - Width of the tabs in the view. By default, the width will be calculated as viewWidth / # of tabs.

```tabBar.transitionStyle``` - Transition style used when switching tabs. Two possible values: ```TabBarTransitionStyle.normal```, ```TabBarTransitionStyle.sticky```. By default, ```TabBarTransitionStyle.normal``` is used.

```tabBar.height``` - Height of the tab bar. By default, the height will be 7% of the total view height.

```tabBar.sliderColor``` - Color of the slider used to inidicator which tab is currently selected.

Since ```TabBar``` is a subclass of ```UIView```, other standard  ```UIView``` properties can also be modified.

### Tab Types

```TabType.icon(UIImage?)``` - Tab that contains a single image

```TabType.text(String)```  - Tab that contains a single label using a standard string as its text source

```TabType.attributedText(NSAttributedString?)``` - Tab that contains a single label using an attributed string as its text source

```TabType.iconWithText(UIImage?, NSAttributedString?)``` - Tab that contains a both an icon and label with the icon positioned above the label

### Tab Sources

```TabSource.view(UIView)``` - Tab whose content view comes from a UIView

```TabSource.viewController(UIViewController)```  - Tab whose content source comes from the view of a UIViewController

## Usage Example

### Step 1

Add a UIView to your view controller in storyboard and specify its class as ```TabbedPageView```

![](https://i.imgur.com/LZ0Quj6.png)

### Step 2

Create an outlet for the TabbedPageView in your code from your storyboard
```swift
@IBOutlet weak var tabbedPageView: TabbedPageView!
```

### Step 3

Create the view controllers that will represent your tabs in the ```TabbedPageView```

![](https://i.imgur.com/ARtc25z.png)

### Step 4

Extend your UIViewController class to conform to the ```TabbedPageViewDataSource``` and ```TabbedPageViewDelegate``` protocols
```swift
extension ViewController: TabbedPageViewDelegate {
    func tabbedPageView(_ tabbedPageView: TabbedPageView, didSelectTabAt index: Int) {
        print("tab selected!")
    }
}

extension ViewController: TabbedPageViewDataSource {
    func numberOfTabs(in tabbedPageView: TabbedPageView) -> Int {
        return tabs.count
    }
    
    func tabbedPageView(_ tabbedPageView: TabbedPageView, tabForIndex index: Int) -> Tab {
        return tabs[index]
    }
}
```

### Step 5

In your controller's viewDidLoad method, initialize your tabs and specify the TabbedPageView's data source and delegate and reload the view

```swift
override func viewDidLoad() {
    super.viewDidLoad()

    let myAttribute = [ NSAttributedString.Key.font: UIFont(name: "Chalkduster", size: 12.0)!, NSAttributedString.Key.foregroundColor: UIColor.red]
    let myString = NSMutableAttributedString(string: "TAB3", attributes: myAttribute )

    let controller1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "View1")
    let controller2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "View2")
    let controller3 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "View3")

    tabs = [
        Tab(contentSource: .viewController(controller1), type: .icon(UIImage(named: "Grid")!)),
        Tab(contentSource: .viewController(controller2), type: .text("TAB2")),
        Tab(contentSource: .viewController(controller3), type: .attributedText(myString))
    ]

    tabbedPageView.tabBar.sliderColor = UIColor.magenta
    tabbedPageView.tabBar.position = .top
    tabbedPageView.tabBar.transitionStyle = .sticky
    tabbedPageView.tabBar.tabWidth = 130

    tabbedPageView.delegate = self
    tabbedPageView.dataSource = self
    tabbedPageView.reloadData()
}
```

## Installation
TabbedPageView is available through CocoaPods.

Edit your ```Podfile``` and specify the dependency:

```pod 'TabbedPageView'```

## Requirements
<ul>
    <li>iOS 9.0+</li>
    <li>Swift 4.2</l>
</ul>

## License
TabbedPageView is available under the MIT license. See the LICENSE file for more info.
