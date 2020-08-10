import UIKit

class NMSegmentedControl: UIView {
    var itemTapped: ((_ segment: Int) -> Void)?
    private var activeItem: Int = 0
    private var segmentItems: [SegmentItem]!
    private var itemWidth: CGFloat!
    
    private var backgroundView: NMView!
    private var activeSegmentView: NMView!
    
    private var activeSegmentLeaging: NSLayoutConstraint!
    private var activeSegmentTrailing: NSLayoutConstraint!
    
    public var cornerRadius: CGFloat = 0 {
        didSet {
            backgroundView?.cornerRadius = cornerRadius
            activeSegmentView?.cornerRadius = cornerRadius - 2
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(segmentItems: [SegmentItem], frame: CGRect) {
        self.init(frame: frame)
        self.segmentItems = segmentItems
        
        backgroundView = NMView()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.cornerRadius = cornerRadius
        backgroundView.bgColors = bgColors
        self.addSubview(backgroundView)
        
        activeSegmentView = NMView()
        activeSegmentView.translatesAutoresizingMaskIntoConstraints = false
        activeSegmentView.cornerRadius = cornerRadius - 2
        activeSegmentView.bgColors = bgColors
        activeSegmentView.isConvex = false
        self.addSubview(activeSegmentView)
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        
        
        for i in 0 ..< segmentItems.count {
            itemWidth = self.frame.width / CGFloat(segmentItems.count)
            let leadingAnchorOffset = itemWidth * CGFloat(i)
            
            let itemView = self.createSegmentItem(item: segmentItems[i])
            itemView.translatesAutoresizingMaskIntoConstraints = false
            itemView.clipsToBounds = true
            itemView.tag = i
            
            self.addSubview(itemView)
            
            NSLayoutConstraint.activate([
                itemView.heightAnchor.constraint(equalTo: self.heightAnchor),
                itemView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: leadingAnchorOffset),
                itemView.widthAnchor.constraint(equalToConstant: itemWidth),
                itemView.topAnchor.constraint(equalTo: self.topAnchor),
            ])
        }
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
        self.activateSegment(segment: 0)
        
        activeSegmentLeaging = activeSegmentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: itemWidth * CGFloat(activeItem) + 5 )
        activeSegmentTrailing = activeSegmentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: itemWidth * -CGFloat((segmentItems.count - 1) - activeItem) - 5)
        
        NSLayoutConstraint.activate([
            activeSegmentView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            activeSegmentLeaging!,
            activeSegmentTrailing!,
            activeSegmentView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
        ])
    }
    
    func createSegmentItem(item: SegmentItem) -> UIView {
        let segmentItem = UIView(frame: CGRect.zero)
        let segmentLabel = UILabel(frame: CGRect.zero)
        
        segmentLabel.text = item.displayTitle
        segmentLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        segmentLabel.textColor = inactiveColor
        segmentLabel.textAlignment = .center
        segmentLabel.translatesAutoresizingMaskIntoConstraints = false
        segmentLabel.clipsToBounds = true
        
        segmentItem.addSubview(segmentLabel)
        segmentItem.translatesAutoresizingMaskIntoConstraints = false
        segmentItem.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            segmentLabel.topAnchor.constraint(equalTo: segmentItem.topAnchor, constant: 0),
            segmentLabel.bottomAnchor.constraint(equalTo: segmentItem.bottomAnchor, constant: 0),
            segmentLabel.widthAnchor.constraint(equalTo: segmentItem.widthAnchor),
            segmentLabel.centerXAnchor.constraint(equalTo: segmentItem.centerXAnchor),
            
            
        ])
            
        segmentItem.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap)))
        return segmentItem
    }
    
    @objc func handleTap(_ sender: UIGestureRecognizer) {
        self.switchSegment(from: self.activeItem, to: sender.view!.tag)
    }
    
    func switchSegment(from: Int, to: Int) {
        if from != to {
            self.deactivateSegment(segment: from)
            self.activateSegment(segment: to)
        }
    }
    
    func activateSegment(segment: Int) {
        let tabToActivate = self.subviews[segment + 2]
        let itemTitleLabel = tabToActivate.subviews[0] as! UILabel
        
        UIView.animate(withDuration: 0.15, delay: 0.0, options: [.curveEaseIn, .allowUserInteraction]) { [self] in
            activeSegmentLeaging?.constant = itemWidth * CGFloat(segment) + 5
            activeSegmentTrailing?.constant = itemWidth * -CGFloat((segmentItems.count - 1) - segment) - 5
            self.layoutIfNeeded()
        } completion: { (completed) in
            itemTitleLabel.textColor = activeColor
        }

        self.segmentItems?[segment].action?()
        self.activeItem = segment
    }
    
    func deactivateSegment(segment: Int) {
        let inactiveTab = self.subviews[segment + 2]
        let itemTitleLabel = inactiveTab.subviews[0] as! UILabel
        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseIn, .allowUserInteraction], animations: {
            itemTitleLabel.textColor = inactiveColor
            self.layoutIfNeeded()
        })
    }
}
