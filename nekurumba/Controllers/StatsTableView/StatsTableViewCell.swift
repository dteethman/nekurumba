import UIKit
import Charts

class StatsTableViewCell: UITableViewCell {
    public var statsDataEntry: [ChartDataEntry]? {
        didSet {
            if let d = statsDataEntry {
                statView?.setupData(entries: d)
            }
        }
    }
    public var labelText: String? {
        didSet {
            if let text = labelText {
                statView?.label = text
            }
        }
    }
    public var xAxisLabels: [String]? {
        didSet {
            if let l = xAxisLabels {
                statView?.xAxisLabels = l
            }
        }
    }
    
    public var granularity: Double = 1 {
        didSet {
            statView.granularity = granularity
        }
    }
    
    private var statView: NMLineChartView!
    
    public var bgColors: ColorSet = ColorSet(light: UIColor.white, dark: UIColor.black){
        didSet {
            statView?.bgColors = bgColors
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
         
        statView = NMLineChartView()
        statView.translatesAutoresizingMaskIntoConstraints = false
        statView.bgColors = bgColors
        statView.cornerRadius = 10
        statView.granularity = granularity
        
        statView.backgroundColor = .clear
        self.addSubview(statView)
        
        NSLayoutConstraint.activate([
            statView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            statView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            statView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            statView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        granularity = 0
    }
    
}
