# TabbedPageView

## Overview

TabbedPageView is a UIView subclass that allows you to quickly create a tabbed subview anywhere in your application

<div style="display:flex;">
  <img src="Resources/TabbedPageViewExample1.gif" width="250">
  <img src="Resources/TabbedPageViewExample2.gif" width="250">
  <img src="Resources/TabbedPageViewExample3.gif" width="250">
</div>

## Usage Example

### Step 1

Add a UIView to your view controller in storyboard and specify its class as ```TabbedPageView```

![](Resources/ExampleScreen2.png)

### Step 2

Create an outlet for the TabbedPageView in your code from your storyboard
```swift
@IBOutlet weak var tabbedPageView: TabbedPageView!
```

### Step 3

Create the view controllers that will represent your tabs in the ```TabbedPageView```

![](Resources/ExampleScreen1.png)

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

Here's a breakdown of the required DataSource methods

```func numberOfTabs(in tabbedPageView: TabbedPageView) -> Int``` - The number of tabs that are present in the tabbed page view

```func tabbedPageView(_ tabbedPageView: TabbedPageView, tabForIndex index: Int) -> Tab``` - Returns the tab object that should be displayed at index ```index```

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
        Tab(viewController: controller1, type: .icon(UIImage(named: "Grid")!)),
        Tab(viewController: controller2, type: .text("TAB2")),
        Tab(viewController: controller3, type: .attributedText(myString))
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
