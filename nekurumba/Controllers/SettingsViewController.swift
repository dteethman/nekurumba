import UIKit

class SettingsViewController: UIViewController {
    private var titleLabel: UILabel!
    
    private var intervalBackgroundView: NMView!
    private var intervalBackgroundViewMask: UIView!
    private var intervalLabel: UILabel!
    private var intervaSublabel: UILabel!
    private var intervalTextView: UITextView!
    private var intervalChangeButton: NMButton!
    
    private var timerCountdownBackgroundView: NMView!
    private var timerCountdownBackgroundViewMask: UIView!
    private var timerCountdownlLabel: UILabel!
    private var timerCountdownSwitch: NMSwitch!
    private var timerCountdownTextView: UITextView!
    
    private var hours: Int!
    private var minutes: Int!
    private var timerCountdownSwitchState: Bool = true {
        didSet {
            if timerCountdownSwitchState {
                let timerCountdownText = "Внутри таймера будет отображаться время до окончания перерыва."
                timerCountdownTextView?.text = timerCountdownText
            } else {
                let timerCountdownText = "Внутри таймера будет отображаться время от начала перерыва."
                timerCountdownTextView?.text = timerCountdownText
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = isDarkMode ? bgColors.dark : bgColors.light
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = activeColor
        
        self.title = "Настройки"
        let defaults = UserDefaults.standard
        timerCountdownSwitchState = defaults.bool(forKey: "isCountdown")
       
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        setupIntervalText()
    }
    
    func setupViews() {
        let safeGuide = view.safeAreaLayoutGuide
        
        let descriptionTextViewWidth = UIScreen.main.bounds.width - 64
        let descriptionTextViewFont = UIFont.systemFont(ofSize: 13, weight: .regular)
        let descriptionTextAttributes = [NSAttributedString.Key.font: descriptionTextViewFont]
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Настройки"
        titleLabel.font = .systemFont(ofSize: 34, weight: .bold)
        titleLabel.textAlignment = .left
        self.view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeGuide.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor, constant: -20),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
        ])
        
        //Interval Settings
        intervalBackgroundView = NMView()
        intervalBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        intervalBackgroundView.bgColors = bgColors
        intervalBackgroundView.cornerRadius = 10
        self.view.addSubview(intervalBackgroundView)
        
        intervalBackgroundViewMask = UIView()
        intervalBackgroundViewMask.translatesAutoresizingMaskIntoConstraints = false
        intervalBackgroundViewMask.clipsToBounds = true
        intervalBackgroundViewMask.backgroundColor = .clear
        intervalBackgroundViewMask.layer.cornerRadius = intervalBackgroundView.cornerRadius
        self.view.addSubview(intervalBackgroundViewMask)
        
        intervalChangeButton = NMButton()
        intervalChangeButton.translatesAutoresizingMaskIntoConstraints = false
        intervalChangeButton.frame = CGRect(x: 20, y: 100, width: 100, height: 40)
        intervalChangeButton.cornerRadius = 20
        intervalChangeButton.bgColors = bgColors
        intervalChangeButton.titleLabel?.text = "▶︎"
        intervalChangeButton.titleLabel?.textAlignment = .center
        intervalChangeButton.titleLabel?.textColor = activeColor
        intervalChangeButton.buttonTouchUpInside = {
            let presentingController = IntervalChangerViewController()
            self.navigationController?.pushViewController(presentingController, animated: true)
        }
        intervalBackgroundViewMask.addSubview(intervalChangeButton)
        
        intervalLabel = UILabel()
        intervalLabel.translatesAutoresizingMaskIntoConstraints = false
        intervalLabel.text = "Перерыв"
        intervalLabel.font = .systemFont(ofSize: 17, weight: .regular)
        intervalLabel.textAlignment = .left
        intervalBackgroundViewMask.addSubview(intervalLabel)
        
        intervaSublabel = UILabel()
        intervaSublabel.translatesAutoresizingMaskIntoConstraints = false
        intervaSublabel.text = "1 час 12 минут"
        intervaSublabel.font = .systemFont(ofSize: 15, weight: .regular)
        intervaSublabel.textColor = isDarkMode ? secondaryLabelColors.dark : secondaryLabelColors.light
        intervaSublabel.textAlignment = .left
        intervalBackgroundViewMask.addSubview(intervaSublabel)
        
        intervalTextView = UITextView()
        intervalTextView.translatesAutoresizingMaskIntoConstraints = false
        
        let intervalText = "Вы можете поменять длину перерыва, который хотите выдерживать между каждой сигаретой."
        let intervalTextHeight = calculateTextFieldHeight(width: descriptionTextViewWidth,
                                 string: NSAttributedString(string: intervalText, attributes: descriptionTextAttributes))
        
        intervalTextView.text = intervalText
        intervalTextView.font = descriptionTextViewFont
        intervalTextView.textColor = isDarkMode ? secondaryLabelColors.dark : secondaryLabelColors.light
        intervalTextView.backgroundColor = .clear
        intervalTextView.textContainer.lineBreakMode = .byWordWrapping
        intervalTextView.textAlignment = .left
        intervalTextView.isScrollEnabled = false
        intervalTextView.isEditable = false
        intervalTextView.isSelectable = false
        intervalTextView.textContainerInset = .zero
        intervalTextView.textContainer.lineFragmentPadding = 0
        
        self.view.addSubview(intervalTextView)
        
        NSLayoutConstraint.activate([
            intervalBackgroundView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            intervalBackgroundView.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor, constant: 20),
            intervalBackgroundView.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor, constant: -20),
            intervalBackgroundView.heightAnchor.constraint(equalToConstant: 80),

            intervalBackgroundViewMask.topAnchor.constraint(equalTo: intervalBackgroundView.topAnchor),
            intervalBackgroundViewMask.leadingAnchor.constraint(equalTo: intervalBackgroundView.leadingAnchor),
            intervalBackgroundViewMask.trailingAnchor.constraint(equalTo: intervalBackgroundView.trailingAnchor),
            intervalBackgroundViewMask.bottomAnchor.constraint(equalTo: intervalBackgroundView.bottomAnchor),
            
            intervalChangeButton.topAnchor.constraint(equalTo: intervalBackgroundView.topAnchor, constant: 20),
            intervalChangeButton.bottomAnchor.constraint(equalTo: intervalBackgroundView.bottomAnchor, constant: -20),
            intervalChangeButton.trailingAnchor.constraint(equalTo: intervalBackgroundView.trailingAnchor, constant: -20),
            intervalChangeButton.widthAnchor.constraint(equalTo: intervalChangeButton.heightAnchor),

            intervalLabel.topAnchor.constraint(equalTo: intervalBackgroundView.topAnchor, constant: 20),
            intervalLabel.leadingAnchor.constraint(equalTo: intervalBackgroundView.leadingAnchor, constant: 12),
            intervalLabel.trailingAnchor.constraint(equalTo: intervalChangeButton.leadingAnchor, constant: -10),
            intervalLabel.heightAnchor.constraint(equalToConstant: 20),

            intervaSublabel.topAnchor.constraint(equalTo: intervalLabel.bottomAnchor, constant: 2),
            intervaSublabel.leadingAnchor.constraint(equalTo: intervalLabel.leadingAnchor),
            intervaSublabel.trailingAnchor.constraint(equalTo: intervalLabel.trailingAnchor),
            intervaSublabel.heightAnchor.constraint(equalToConstant: 18),

            intervalTextView.topAnchor.constraint(equalTo: intervalBackgroundView.bottomAnchor, constant: 12),
            intervalTextView.leadingAnchor.constraint(equalTo: intervalBackgroundView.leadingAnchor, constant: 12),
            intervalTextView.trailingAnchor.constraint(equalTo: intervalBackgroundView.trailingAnchor, constant: -12),
            intervalTextView.heightAnchor.constraint(equalToConstant: intervalTextHeight),
        ])
        
        //Timer countdown Settings
        timerCountdownBackgroundView = NMView()
        timerCountdownBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        timerCountdownBackgroundView.bgColors = bgColors
        timerCountdownBackgroundView.cornerRadius = 10
        self.view.addSubview(timerCountdownBackgroundView)
        
        timerCountdownBackgroundViewMask = UIView()
        timerCountdownBackgroundViewMask.translatesAutoresizingMaskIntoConstraints = false
        timerCountdownBackgroundViewMask.clipsToBounds = true
        timerCountdownBackgroundViewMask.backgroundColor = .clear
        timerCountdownBackgroundViewMask.layer.cornerRadius = timerCountdownBackgroundView.cornerRadius
        self.view.addSubview(timerCountdownBackgroundViewMask)
        
        timerCountdownSwitch = NMSwitch()
        timerCountdownSwitch.translatesAutoresizingMaskIntoConstraints = false
        timerCountdownSwitch.bgColors = bgColors
        timerCountdownSwitch.isActive = timerCountdownSwitchState
        timerCountdownSwitch.addAction(for: .on, action: switchCountdown)
        timerCountdownSwitch.addAction(for: .off, action: switchCountdown)
        timerCountdownBackgroundViewMask.addSubview(timerCountdownSwitch)
        
        timerCountdownlLabel = UILabel()
        timerCountdownlLabel.translatesAutoresizingMaskIntoConstraints = false
        timerCountdownlLabel.text = "Обратный отсчет"
        timerCountdownlLabel.font = .systemFont(ofSize: 17, weight: .regular)
        timerCountdownlLabel.textAlignment = .left
        timerCountdownBackgroundViewMask.addSubview(timerCountdownlLabel)
        
        timerCountdownTextView = UITextView()
        timerCountdownTextView.translatesAutoresizingMaskIntoConstraints = false
        
        let timerCountdownText = "Внутри таймера будет отображаться время до окончания перерыва."
        let timerCountdownTextHeight = calculateTextFieldHeight(width: descriptionTextViewWidth,
                                 string: NSAttributedString(string: timerCountdownText, attributes: descriptionTextAttributes))
        
        timerCountdownTextView.text = timerCountdownText
        timerCountdownTextView.font = descriptionTextViewFont
        timerCountdownTextView.textColor = isDarkMode ? secondaryLabelColors.dark : secondaryLabelColors.light
        timerCountdownTextView.backgroundColor = .clear
        timerCountdownTextView.textContainer.lineBreakMode = .byWordWrapping
        timerCountdownTextView.textAlignment = .left
        timerCountdownTextView.isScrollEnabled = false
        timerCountdownTextView.isEditable = false
        timerCountdownTextView.isSelectable = false
        timerCountdownTextView.textContainerInset = .zero
        timerCountdownTextView.textContainer.lineFragmentPadding = 0
        
        self.view.addSubview(timerCountdownTextView)
        
        NSLayoutConstraint.activate([
            timerCountdownBackgroundView.topAnchor.constraint(equalTo: intervalTextView.bottomAnchor, constant: 30),
            timerCountdownBackgroundView.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor, constant: 20),
            timerCountdownBackgroundView.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor, constant: -20),
            timerCountdownBackgroundView.heightAnchor.constraint(equalToConstant: 67),

            timerCountdownBackgroundViewMask.topAnchor.constraint(equalTo: timerCountdownBackgroundView.topAnchor),
            timerCountdownBackgroundViewMask.leadingAnchor.constraint(equalTo: timerCountdownBackgroundView.leadingAnchor),
            timerCountdownBackgroundViewMask.trailingAnchor.constraint(equalTo: timerCountdownBackgroundView.trailingAnchor),
            timerCountdownBackgroundViewMask.bottomAnchor.constraint(equalTo: timerCountdownBackgroundView.bottomAnchor),
            
            timerCountdownSwitch.topAnchor.constraint(equalTo: timerCountdownBackgroundViewMask.topAnchor, constant: 10),
            timerCountdownSwitch.bottomAnchor.constraint(equalTo: timerCountdownBackgroundViewMask.bottomAnchor, constant: -10),
            timerCountdownSwitch.trailingAnchor.constraint(equalTo: timerCountdownBackgroundViewMask.trailingAnchor, constant: -20),
            timerCountdownSwitch.widthAnchor.constraint(equalToConstant: 67),
            
            timerCountdownlLabel.topAnchor.constraint(equalTo: timerCountdownBackgroundView.topAnchor, constant: 20),
            timerCountdownlLabel.leadingAnchor.constraint(equalTo: timerCountdownBackgroundView.leadingAnchor, constant: 12),
            timerCountdownlLabel.trailingAnchor.constraint(equalTo: timerCountdownSwitch.leadingAnchor, constant: -10),
            timerCountdownlLabel.bottomAnchor.constraint(equalTo: timerCountdownBackgroundView.bottomAnchor, constant: -20),
            
            timerCountdownTextView.topAnchor.constraint(equalTo: timerCountdownBackgroundView.bottomAnchor, constant: 12),
            timerCountdownTextView.leadingAnchor.constraint(equalTo: timerCountdownBackgroundView.leadingAnchor, constant: 12),
            timerCountdownTextView.trailingAnchor.constraint(equalTo: timerCountdownBackgroundView.trailingAnchor, constant: -12),
            timerCountdownTextView.heightAnchor.constraint(equalToConstant: timerCountdownTextHeight),
        ])
        
    }

    func calculateTextFieldHeight(width: CGFloat, string: NSAttributedString) -> CGFloat {
        let maxSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let stringSize = string.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).size

        let range = CFRangeMake(0, string.length)
        let framesetter = CTFramesetterCreateWithAttributedString(string)
        let framesetterSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, range, nil, maxSize, nil)
        
        return max(stringSize.height.rounded(.up), framesetterSize.height.rounded(.up))
    }
    
    func getNounByNumber(root: String, singleEnd: String, dualEnd: String, multipleEnd: String, number: Int) -> String {
        var resStr = root
        switch number % 10 {
        case 1:
            resStr += singleEnd
        case 2, 3, 4:
            resStr += dualEnd
        default:
            resStr += multipleEnd
        }
        
        if number % 100 >= 11 &&  number % 100 <= 14 {
            resStr = root + multipleEnd
        }
        
        return resStr
    }
    
    private func setupIntervalText() {
        loadTimeFromDefaults()
        if let h = hours, let m = minutes {
            let hoursStr = getNounByNumber(root: "час", singleEnd: "", dualEnd: "а", multipleEnd: "ов", number: h)
            let minutesStr = getNounByNumber(root: "минут", singleEnd: "а", dualEnd: "ы", multipleEnd: "", number: m)
            var timeStr = ""
            if h != 0 {
                timeStr.append("\(h) \(hoursStr) ")
            }
            
            if m != 0 {
                timeStr.append("\(m) \(minutesStr)")
            }
           
            
            intervaSublabel?.text = timeStr
        }
    }
    
    private func switchCountdown() {
        let defaults = UserDefaults.standard
        if timerCountdownSwitch != nil {
            if timerCountdownSwitch.isActive {
                timerCountdownSwitchState = true
                defaults.setValue(true, forKey: "isCountdown")
            } else {
                timerCountdownSwitchState = false
                defaults.setValue(false, forKey: "isCountdown")
            }
        }
    }
    
    private func loadTimeFromDefaults() {
        let defaults = UserDefaults.standard
        
        hours = defaults.integer(forKey: "hours")
        minutes = defaults.integer(forKey: "minutes")
        
        
        if hours == 0 && minutes == 0 {
            defaults.setValue(2, forKey: "hours")
            hours = 2
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.view.backgroundColor = isDarkMode ? bgColors.dark : bgColors.light
        intervaSublabel?.textColor = isDarkMode ? secondaryLabelColors.dark : secondaryLabelColors.light
        intervalTextView?.textColor = isDarkMode ? secondaryLabelColors.dark : secondaryLabelColors.light
        timerCountdownTextView?.textColor = isDarkMode ? secondaryLabelColors.dark : secondaryLabelColors.light
        setupIntervalText()
        
    }
}
