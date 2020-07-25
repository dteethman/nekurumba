import UIKit

class TabBarController: UITabBarController {
    
    var customTabBar: TabNavigationView!
    var tabBarHeight: CGFloat = 67.0
    var controllers = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadTabBar()
    }
    
    func loadTabBar() {
        let tabItems: [TabItem] = [.home, .stats, .settings]
        self.setupCustomTabMenu(tabItems) { (controllers) in
            self.viewControllers = controllers
        }
        self.selectedIndex = 0
    }
    
    func setupCustomTabMenu(_ menuItems: [TabItem], completion: @escaping ([UIViewController]) -> Void) {
        let frame = CGRect(x: tabBar.frame.origin.x + 20, y: tabBar.frame.origin.y, width: tabBar.frame.width - 40, height: tabBar.frame.height)
        
        let safeGuide = view.safeAreaLayoutGuide
        
        
        // hide the tab bar
        tabBar.isHidden = true
        
        let nmBackgroundView = NMViev(frame: .zero)
        nmBackgroundView.cornerRadius = 10
        nmBackgroundView.isConvex = true
        nmBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        nmBackgroundView.bgColors = bgColors
        
        self.view.addSubview(nmBackgroundView)
        
        self.customTabBar = TabNavigationView(menuItems: menuItems, frame: frame)
        self.customTabBar.translatesAutoresizingMaskIntoConstraints = false
        self.customTabBar.clipsToBounds = true
        self.customTabBar.itemTapped = self.changeTab
        
        // Add it to the view
        self.view.addSubview(customTabBar)
        
        NSLayoutConstraint.activate([
            nmBackgroundView.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor, constant: 20),
            nmBackgroundView.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor, constant: -20),
            nmBackgroundView.bottomAnchor.constraint(equalTo: safeGuide.bottomAnchor, constant: -20),
            nmBackgroundView.heightAnchor.constraint(equalToConstant: 50),
            
            self.customTabBar.leadingAnchor.constraint(equalTo: nmBackgroundView.leadingAnchor),
            self.customTabBar.trailingAnchor.constraint(equalTo: nmBackgroundView.trailingAnchor),
            self.customTabBar.heightAnchor.constraint(equalTo: nmBackgroundView.heightAnchor),
            self.customTabBar.bottomAnchor.constraint(equalTo: nmBackgroundView.bottomAnchor)
        ])
        
        for i in 0 ..< menuItems.count {
            controllers.append(menuItems[i].viewController)
        }
        
        self.view.layoutIfNeeded()
        completion(controllers)
    }
    
    func changeTab(tab: Int) {
        self.selectedIndex = tab
        if tab == 1 {
            (controllers[tab] as! StatsViewController).updateData()
        }
    }
    
}
