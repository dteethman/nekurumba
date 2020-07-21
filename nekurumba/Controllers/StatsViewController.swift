import UIKit

class StatsViewController: UIViewController {
    var segmentedControl: NMSegmentedControl!
    
    var segments: [SegmentItem]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = isDarkMode ? bgColors.dark : bgColors.light
        
        segments = [
            SegmentItem(displayTitle: "День", action: {print("1")} ),
            SegmentItem(displayTitle: "Неделя", action: {print("2")}),
            SegmentItem(displayTitle: "Месяц", action: {print("3")}),
        ]
        setupViews()
    }
    
    private func setupViews() {
        let segmentedControlFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 32 , height: 40)
        if segments == nil {
            segments = []
        }
        segmentedControl = NMSegmentedControl(segmentItems: segments, frame: segmentedControlFrame)
        segmentedControl.cornerRadius = 10
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(segmentedControl)
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            segmentedControl.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        
        segmentedControl.layoutSubviews()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        view.backgroundColor = isDarkMode ? bgColors.dark : bgColors.light
    }

}
