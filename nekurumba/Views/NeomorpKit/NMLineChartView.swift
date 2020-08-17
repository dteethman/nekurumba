import UIKit
import Charts

class NMLineChartView: UIView {
    //MARK: - Variables
    public var chartDataEntries: [ChartDataEntry]?
    
    private var nmBackgroundView: NMView!
    private var chartView: LineChartView!
    private var titleLabel: UILabel!
    
    public var cornerRadius: CGFloat = 0 {
        didSet {
            nmBackgroundView?.cornerRadius = cornerRadius
            chartView?.setExtraOffsets(left: cornerRadius, top: cornerRadius, right: cornerRadius, bottom: cornerRadius)
            chartView?.layoutSubviews()
            
            layoutIfNeeded()
            updateConstraints()
        }
    }
    
    public var bgColors: ColorSet = ColorSet(light: UIColor.white, dark: UIColor.black) {
        didSet {
            self.backgroundColor = .clear
            nmBackgroundView?.bgColors = bgColors
            layoutSubviews()
        }
    }
    
    public var xAxisLabels: [String]? {
        didSet {
            if xAxisLabels != nil {
                chartView?.xAxis.valueFormatter = IndexAxisValueFormatter(values: xAxisLabels!)
            }
        }
    }
    
    public var label: String? {
        didSet {
            if label != nil {
                titleLabel?.text = label
            }
        }
    }
    
    public var granularity: Double = 1 {
        didSet {
            chartView?.xAxis.granularity = granularity
        }
    }
    
    //MARK: - Initialisers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(frame: CGRect, entries: [ChartDataEntry]) {
        self.init(frame: frame)
        setupData(entries: entries)
    }
    
    //MARK: - Layout
    private func setupViews() {
        self.backgroundColor = .blue
        self.isUserInteractionEnabled = false
        
        nmBackgroundView = NMView()
        nmBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        nmBackgroundView.cornerRadius = cornerRadius
        nmBackgroundView.backgroundColor = .clear
        self.addSubview(nmBackgroundView)
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        if label != nil {
            titleLabel.text = label
        }
        titleLabel.textAlignment = . left
        titleLabel.font = .systemFont(ofSize: 17, weight: .bold)
        self.addSubview(titleLabel)
        
        chartView = LineChartView()
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.clipsToBounds = true
        
        setupChartView()
        
        self.addSubview(chartView)
        
        NSLayoutConstraint.activate([
            nmBackgroundView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            nmBackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            nmBackgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            nmBackgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 15),
            titleLabel.heightAnchor.constraint(equalToConstant: 24),
            
            chartView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            chartView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            chartView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            chartView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
        ])
    }
    
    private func setupChartView() {
        chartView.backgroundColor = .clear
        chartView.rightAxis.enabled = false
        chartView.setExtraOffsets(left: 0, top: 30, right: 10, bottom: 10)
        
        chartView.leftAxis.labelFont = .systemFont(ofSize: 12, weight: .bold)
        chartView.leftAxis.labelPosition = .insideChart
        chartView.leftAxis.setLabelCount(4, force: false)
        chartView.leftAxis.axisMinimum = 0
        chartView.leftAxis.granularity = 1
        
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelFont = .systemFont(ofSize: 12, weight: .bold)
        chartView.xAxis.axisLineColor = .clear
        chartView.xAxis.avoidFirstLastClippingEnabled = true
        chartView.xAxis.granularity = granularity
        if xAxisLabels != nil {
            chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: xAxisLabels!)
            chartView.xAxis.setLabelCount(xAxisLabels!.count, force: false)
        }
        
        chartView.animate(yAxisDuration: 0.2)
        
        chartView.legend.enabled = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    //MARK: - Data loading
    public func setupData(entries: [ChartDataEntry]) {
        let set = LineChartDataSet(entries: entries, label: nil)
        set.mode = .horizontalBezier
        set.lineWidth = 3
        set.setColor(activeColor)
        set.drawHorizontalHighlightIndicatorEnabled = false
        set.drawVerticalHighlightIndicatorEnabled = false
        
        let gradientColors = [activeColor.cgColor, UIColor.clear.cgColor] as CFArray
        let colorLocations: [CGFloat] = [0.8, 0.0]
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations)
        set.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0)
        set.drawFilledEnabled = true
        
        set.drawCirclesEnabled = false
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        formatter.maximumFractionDigits = 0
        formatter.multiplier = 1.0
        let valueNumberFormater = ChartValueFormatter(numberFormatter: formatter)
        set.valueFormatter = valueNumberFormater
        
        let data = LineChartData(dataSet: set)
        data.setDrawValues(false)
 
        chartView.data = data
    }
}

//MARK: - Value Formater
class ChartValueFormatter: NSObject, IValueFormatter {
    fileprivate var numberFormatter: NumberFormatter?

    convenience init(numberFormatter: NumberFormatter) {
        self.init()
        self.numberFormatter = numberFormatter
    }

    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        guard let numberFormatter = numberFormatter
            else {
                return ""
        }
        return numberFormatter.string(for: value)!
    }
}
