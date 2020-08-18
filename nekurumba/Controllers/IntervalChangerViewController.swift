import UIKit
import DTBunchOfExt

class IntervalChangerViewController: UIViewController {
    //MARK: - Variables
    private var sliderView: NMMultiLevelCircularSlider!
    private var segmentControll: NMSegmentedControl!
    private var sliderLabel: UILabel!
    private var backButton: NMButton!
    
    private var hours: Int!
    private var minutes: Int!
    private var hoursSliderValue: CGFloat = 0
    private var minutesSliderValue: CGFloat = 0
    private var activeSegment: Int = 0
    
    private var segments: [SegmentItem] = []
    
    private var sliderItems: [SliderItem] = []
    
    //MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
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
                if activeSegment == 0 {
                    sliderLabel.text = "\(hours!)"
                }
                saveToDefaults(hours!, forKey: intervalHoursKey)
            }
            
        }
        
        sliderItems[1].sliderValue.bind { [unowned self] (value) in
            if sliderView != nil {
                minutes = Int(round(value * sliderView!.sliderItems[1].maxValue))
                if activeSegment == 1 {
                    sliderLabel?.text = "\(minutes!)"
                }
                saveToDefaults(minutes!, forKey: intervalMinutesKey)
            }
        }
        
        segments = [
            SegmentItem(displayTitle: "Часы", action: { [self] in
                sliderView?.switchSliderForItem(0)
                activeSegment = 0
                if let h = hours {
                    sliderLabel?.text = "\(h)"
                }
                
            }),
            SegmentItem(displayTitle: "Минуты", action: { [self] in
                sliderView?.switchSliderForItem(1)
                activeSegment = 1
                if let m = minutes {
                    sliderLabel?.text = "\(m)"
                }
            })
        ]

        setupViews()
        sliderView.layoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if let h = hours, let m = minutes {
            (UIApplication.shared.delegate as? AppDelegate)?.smokeTimer?.interval.value = (TimeInterval(h * 3600 + m * 60))
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super .traitCollectionDidChange(previousTraitCollection)
        view.backgroundColor = colorForMode(bgColors, isDarkMode: isDarkMode)
        sliderLabel?.textColor = colorForMode(primaryLabelColors, isDarkMode: isDarkMode)
    }
    
    //MARK: - Layout
    private func setupViews() {
        view.backgroundColor = colorForMode(bgColors, isDarkMode: isDarkMode)
        let safeGuide = view.safeAreaLayoutGuide
        
        backButton = NMButton()
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.bgColors = bgColors
        backButton.cornerRadius = 20
        backButton.addAction(for: .touchUpInside, action: {
            self.navigationController?.popViewController(animated: true)
        })
        backButton.titleLabel.text = "◀︎"
        backButton.titleLabel.font = .systemFont(ofSize: 17, weight: .regular)
        backButton.titleLabel.textColor = activeColor
        self.view.addSubview(backButton)
        
        sliderView = NMMultiLevelCircularSlider()
        sliderView.translatesAutoresizingMaskIntoConstraints = false
        sliderView.numberOfDivisions = 12
        sliderView.cornerRadius = (UIScreen.main.bounds.width - 40 ) / 2
        sliderView.sliderItems = sliderItems
        sliderView.progressBar.startGradienttColor = .systemPink
        sliderView.progressBar.endGradientColor = .systemPink
        view.addSubview(sliderView)
        
        let width = UIScreen.main.bounds.width - 40
        let frame = CGRect(x: 20, y: 450, width: width, height: 40)
        
        segmentControll = NMSegmentedControl(segmentItems: segments, frame: frame)
        segmentControll.translatesAutoresizingMaskIntoConstraints = false
        segmentControll.cornerRadius = 20
        segmentControll.bgColors = bgColors
        self.view.addSubview(segmentControll)
        
        sliderLabel = UILabel()
        sliderLabel.translatesAutoresizingMaskIntoConstraints = false
        sliderLabel.textColor = colorForMode(primaryLabelColors, isDarkMode: isDarkMode)
        sliderLabel.text = activeSegment == 0 ? "\(hours!)" : "\(minutes!)"
        sliderLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 54, weight: .bold)
        sliderLabel.textAlignment = .center
        self.view.addSubview(sliderLabel)
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: safeGuide.topAnchor, constant: 14),
            backButton.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            backButton.heightAnchor.constraint(equalToConstant: 40),
            
            segmentControll.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 30),
            segmentControll.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor, constant: 20),
            segmentControll.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor, constant: -20),
            segmentControll.heightAnchor.constraint(equalToConstant: 40),
            
            sliderView.topAnchor.constraint(equalTo: segmentControll.bottomAnchor, constant: 20),
            sliderView.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor, constant: 20),
            sliderView.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor, constant: -20),
            sliderView.heightAnchor.constraint(equalTo: sliderView.widthAnchor),
            
            sliderLabel.topAnchor.constraint(equalTo: sliderView.topAnchor, constant: 50),
            sliderLabel.leadingAnchor.constraint(equalTo: sliderView.leadingAnchor, constant: 50),
            sliderLabel.trailingAnchor.constraint(equalTo: sliderView.trailingAnchor, constant: -50),
            sliderLabel.bottomAnchor.constraint(equalTo: sliderView.bottomAnchor, constant: -50),

        ])
    }
    
    //MARK: - UserDefaults methods
    private func loadTimeFromDefaults() {
        let defaults = UserDefaults.standard
        
        hours = defaults.integer(forKey: intervalHoursKey)
        minutes = defaults.integer(forKey: intervalMinutesKey)
        
        
        if hours == 0 && minutes == 0 {
            defaults.setValue(2, forKey: intervalHoursKey)
            hours = 2
        }
            
        hoursSliderValue = CGFloat(hours) / 12
        minutesSliderValue = CGFloat(Int(minutes) % 60) / 60
    }
    
    private func saveToDefaults(_ value: Any, forKey: String) {
        let defaults = UserDefaults.standard
        defaults.setValue(value, forKey: forKey)
    }
    
    


}




