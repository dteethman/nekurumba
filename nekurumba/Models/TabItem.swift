import UIKit

enum TabItem: String, CaseIterable {
    case home = "главная"
    case stats = "статистика"
    case settings = "настройки"
    
    var viewController: UIViewController {
        switch self {
        case .home:
            return HomeViewController()
        case .stats:
            return StatsViewController()
        case .settings:
            return UINavigationController(rootViewController: SettingsViewController()) 
        }
    }
    
    var icon: UIImage {
        switch self {
        case .home:
            return UIImage(named: "vc_home")!
        case .stats:
            return UIImage(named: "vc_stats")!
        case .settings:
            return UIImage(named: "vc_settings")!
        }
    }
    
    var displayTitle: String {
        return self.rawValue.capitalized(with: nil)
    }
}

