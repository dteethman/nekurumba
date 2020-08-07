import UIKit

class IntervalChangerViewController: UIViewController {
    var sliderView: NMDualCircularSlider!
    var segmentControll: NMSegmentedControl!
    var separatorLabel: UILabel!
    var hoursLabel: UILabel!
    var minutesLabel: UILabel!
    
    var hours: Int!
    var minutes: Int!
    var hoursSliderValue: CGFloat = 0
    var minutesSliderValue: CGFloat = 0
    
    var segments: [SegmentItem] = []
    
    var sliderItems: [SliderItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTimeFromDefaults()
        
        
        sliderItems = [
            SliderItem(sliderValue: Box(hoursSliderValue), minValue: 0, maxValue: 12, minSliderValue: 0, maxSliderValue: 1, numberOfDivisions: 12),
            SliderItem(sliderValue: Box(minutesSliderValue), minValue: 0, maxValue: 60, minSliderValue: 0, maxSliderValue: 59/60, numberOfDivisions: 60)
        ]
        
        sliderItems[0].sliderValue.bind { [unowned self] (value) in
            if sliderView != nil {
                hours = Int(round(value * sliderView!.sliderItems[0].maxValue))
                if hours == 0 {
                    if sliderView?.sliderItems[1].sliderValue.value == 0 {
                        sliderView?.sliderItems[1].sliderValue.value = 1 / 60
                    }
                    sliderView?.sliderItems[1].minSliderValue = 1 / 60
                } else {
                    sliderView?.sliderItems[1].minSliderValue = 0
                }
                hoursLabel?.text = hours < 10 ? "0\(hours!)" : "\(hours!)"
                saveToDefaults(hours!, forKey: "hours")
            }
            
        }
        
        sliderItems[1].sliderValue.bind { [unowned self] (value) in
            if sliderView != nil {
                minutes = Int(round(value * sliderView!.sliderItems[1].maxValue))
                minutesLabel?.text = minutes < 10 ? "0\(minutes!)" : "\(minutes!)"
                saveToDefaults(minutes!, forKey: "minutes")
            }
        }
        
        segments = [
            SegmentItem(displayTitle: "Часы", action: { [self] in
                sliderView?.switchSliderForItem(0)
            }),
            SegmentItem(displayTitle: "Минуты", action: { [self] in
                sliderView?.switchSliderForItem(1)
            })
        ]

        setupViews()
        sliderView.layoutSubviews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if let h = hours, let m = minutes {
            (UIApplication.shared.delegate as? AppDelegate)?.smokeTimer?.interval.value = (TimeInterval(h * 3600 + m * 60))
        }
        
    }
    
    private func setupViews() {
        view.backgroundColor = isDarkMode ? bgColors.dark : bgColors.light
        let safeGuide = view.safeAreaLayoutGuide
        
        sliderView = NMDualCircularSlider()
        sliderView.translatesAutoresizingMaskIntoConstraints = false
        sliderView.numberOfDivisions = 12
        sliderView.cornerRadius = (UIScreen.main.bounds.width - 40 ) / 2
        sliderView.sliderItems = sliderItems
        view.addSubview(sliderView)
        
        let width = UIScreen.main.bounds.width - 40
        let frame = CGRect(x: 20, y: 450, width: width, height: 40)
        
        segmentControll = NMSegmentedControl(segmentItems: segments, frame: frame)
        segmentControll.cornerRadius = 20
        segmentControll.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(segmentControll)
        
        separatorLabel = UILabel()
        separatorLabel.translatesAutoresizingMaskIntoConstraints = false
        separatorLabel.textColor = inactiveColor
        separatorLabel.text = ":"
        separatorLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 32, weight: .bold)
        separatorLabel.textAlignment = .center
        self.view.addSubview(separatorLabel)
        
        hoursLabel = UILabel()
        hoursLabel.translatesAutoresizingMaskIntoConstraints = false
        hoursLabel.textColor = activeColor
        hoursLabel.text = hours < 10 ? "0\(hours!)" : "\(hours!)"
        hoursLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 32, weight: .bold)
        hoursLabel.textAlignment = .right
        self.view.addSubview(hoursLabel)
        
        minutesLabel = UILabel()
        minutesLabel.translatesAutoresizingMaskIntoConstraints = false
        minutesLabel.textColor = inactiveColor
        minutesLabel.text = minutes < 10 ? "0\(minutes!)" : "\(minutes!)"
        minutesLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 32, weight: .bold)
        minutesLabel.textAlignment = .left
        self.view.addSubview(minutesLabel)
        
        
        NSLayoutConstraint.activate([
            segmentControll.topAnchor.constraint(equalTo: safeGuide.topAnchor, constant: 10),
            segmentControll.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor, constant: 20),
            segmentControll.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor, constant: -20),
            segmentControll.heightAnchor.constraint(equalToConstant: 40),
            
            sliderView.topAnchor.constraint(equalTo: segmentControll.bottomAnchor, constant: 20),
            sliderView.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor, constant: 20),
            sliderView.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor, constant: -20),
            sliderView.heightAnchor.constraint(equalTo: sliderView.widthAnchor),
            
            separatorLabel.topAnchor.constraint(equalTo: sliderView.bottomAnchor, constant: 20),
            separatorLabel.heightAnchor.constraint(equalToConstant: 50),
            separatorLabel.widthAnchor.constraint(equalToConstant: 10),
            separatorLabel.centerXAnchor.constraint(equalTo: sliderView.centerXAnchor),
            
            hoursLabel.topAnchor.constraint(equalTo: separatorLabel.topAnchor, constant: 0),
            hoursLabel.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor, constant: 20),
            hoursLabel.trailingAnchor.constraint(equalTo: separatorLabel.leadingAnchor, constant: 0),
            hoursLabel.heightAnchor.constraint(equalTo: separatorLabel.heightAnchor),
            
            minutesLabel.topAnchor.constraint(equalTo: separatorLabel.topAnchor, constant: 0),
            minutesLabel.leadingAnchor.constraint(equalTo: separatorLabel.trailingAnchor, constant: 0),
            minutesLabel.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor, constant: -20),
            minutesLabel.heightAnchor.constraint(equalTo: separatorLabel.heightAnchor),

        ])
    }
    
    private func loadTimeFromDefaults() {
        let defaults = UserDefaults.standard
        
        hours = defaults.integer(forKey: "hours")
        minutes = defaults.integer(forKey: "minutes")
        
        
        if hours == 0 && minutes == 0 {
            defaults.setValue(2, forKey: "hours")
            hours = 2
        }
            
        hoursSliderValue = CGFloat(hours) / 12
        minutesSliderValue = CGFloat(Int(minutes) % 60) / 60
    }
    
    private func saveToDefaults(_ value: Any, forKey: String) {
        let defaults = UserDefaults.standard
        defaults.setValue(value, forKey: forKey)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super .traitCollectionDidChange(previousTraitCollection)
        view.backgroundColor = isDarkMode ? bgColors.dark : bgColors.light
    }


}




