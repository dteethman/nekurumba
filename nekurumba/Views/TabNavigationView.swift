import UIKit

class TabNavigationView: UIView {
    var itemTapped: ((_ tab: Int) -> Void)?
    var activeItem: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(menuItems: [TabItem], frame: CGRect) {
        self.init(frame: frame)
        
        
        for i in 0 ..< menuItems.count {
            let itemWidth = self.frame.width / CGFloat(menuItems.count)
            let leadingAnchor = itemWidth * CGFloat(i)
            
            let itemView = self.createTabItem(item: menuItems[i])
            itemView.translatesAutoresizingMaskIntoConstraints = false
            itemView.clipsToBounds = true
            itemView.tag = i
            
            self.addSubview(itemView)
            
            NSLayoutConstraint.activate([
                itemView.heightAnchor.constraint(equalTo: self.heightAnchor),
                itemView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: leadingAnchor),
                itemView.widthAnchor.constraint(equalToConstant: itemWidth),
                itemView.topAnchor.constraint(equalTo: self.topAnchor),
            ])
        }
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
        self.activateTab(tab: 0)
    }
    
    func createTabItem(item: TabItem) -> UIView {
        let tabBarItem = UIView(frame: CGRect.zero)
        let itemTitleLabel = UILabel(frame: CGRect.zero)
        let itemIconView = UIImageView(frame: CGRect.zero)
        
        itemTitleLabel.text = item.displayTitle
        itemTitleLabel.font = .systemFont(ofSize: 10)
        itemTitleLabel.textColor = inactiveColor
        itemTitleLabel.textAlignment = .center
        itemTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        itemTitleLabel.clipsToBounds = true
        
        itemIconView.image = item.icon.withRenderingMode(.automatic)
        itemIconView.translatesAutoresizingMaskIntoConstraints = false
        itemIconView.clipsToBounds = true
        itemIconView.setImageColor(color: inactiveColor)
        
        tabBarItem.addSubview(itemIconView)
        tabBarItem.addSubview(itemTitleLabel)
        tabBarItem.translatesAutoresizingMaskIntoConstraints = false
        tabBarItem.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            itemIconView.topAnchor.constraint(equalTo: tabBarItem.topAnchor, constant: 6),
            itemIconView.centerXAnchor.constraint(equalTo: tabBarItem.centerXAnchor),
            itemIconView.heightAnchor.constraint(equalToConstant: 26),
            itemIconView.widthAnchor.constraint(equalToConstant: 26),
            
            itemTitleLabel.heightAnchor.constraint(equalToConstant: 12),
            itemTitleLabel.widthAnchor.constraint(equalTo: tabBarItem.widthAnchor),
            itemTitleLabel.centerXAnchor.constraint(equalTo: tabBarItem.centerXAnchor),
            itemTitleLabel.topAnchor.constraint(equalTo: itemIconView.bottomAnchor, constant: 3),
        ])
            
        tabBarItem.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap)))
        return tabBarItem
    }
    
    @objc func handleTap(_ sender: UIGestureRecognizer) {
        self.switchTab(from: self.activeItem, to: sender.view!.tag)
    }
    
    func switchTab(from: Int, to: Int) {
        self.deactivateTab(tab: from)
        self.activateTab(tab: to)
    }
    
    func activateTab(tab: Int) {
        let tabToActivate = self.subviews[tab]
        let itemIconView = tabToActivate.subviews[0] as! UIImageView
        let itemTitleView = tabToActivate.subviews[1] as! UILabel
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseIn, .allowUserInteraction], animations: {
                itemIconView.setImageColor(color: activeColor)
                itemTitleView.textColor = activeColor
                tabToActivate.setNeedsLayout()
                tabToActivate.layoutIfNeeded()
            })
            self.itemTapped?(tab)
        }
        self.activeItem = tab
    }
    
    func deactivateTab(tab: Int) {
        let inactiveTab = self.subviews[tab]
        let itemIconView = inactiveTab.subviews[0] as! UIImageView
        let itemTitleView = inactiveTab.subviews[1] as! UILabel
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseIn, .allowUserInteraction], animations: {
                itemIconView.setImageColor(color: inactiveColor)
                itemTitleView.textColor = inactiveColor
                inactiveTab.setNeedsLayout()
                inactiveTab.layoutIfNeeded()
            })
        }
    }
}
