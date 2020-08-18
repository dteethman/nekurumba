import UIKit
import DTBunchOfExt

class SettingsViewController: UIViewController {
    // MARK: - Variables
    private var titleLabel: UILabel!
    
    private var intervalBackgroundView: NMView!
    private var intervalBackgroundViewMask: UIView!
    private var intervalLabel: UILabel!
    private var intervalSublabel: UILabel!
    private var intervalTextView: UITextView!
    private var intervalChangeButton: NMButton!
    
    private var nightModeBackgroundView: NMView!
    private var nightModeBackgroundViewMask: UIView!
    private var nightModeLabel: UILabel!
    private var nightModeSublabel: UILabel!
    private var nightModeTextView: UITextView!
    private var nightModeChangeButton: NMButton!

    private var timerCountdownBackgroundView: NMView!
    private var timerCountdownBackgroundViewMask: UIView!
    private var timerCountdownlLabel: UILabel!
    private var timerCountdownSwitch: NMSwitch!
    private var timerCountdownTextView: UITextView!
    
    private var intervalHours: Int!
    private var intervalMinutes: Int!
    private var nightModeHours: Int!
    
    private var timerCountdownSwitchState: Bool = true {
        didSet {
            changeCountdownDescription(timerCountdownSwitchState)
        }
    }
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = colorForMode(bgColors, isDarkMode: isDarkMode)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.tintColor = activeColor
        
        self.title = "Настройки"
        let defaults = UserDefaults.standard
        timerCountdownSwitchState = defaults.bool(forKey: isCountdownKey)
       
        setupViews()
        changeCountdownDescription(timerCountdownSwitchState)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        setupIntervalText()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.view.backgroundColor = colorForMode(bgColors, isDarkMode: isDarkMode)
        intervalSublabel?.textColor = colorForMode(secondaryLabelColors, isDarkMode: isDarkMode)
        intervalTextView?.textColor = colorForMode(secondaryLabelColors, isDarkMode: isDarkMode)
        nightModeSublabel?.textColor = colorForMode(secondaryLabelColors, isDarkMode: isDarkMode)
        nightModeTextView?.textColor = colorForMode(secondaryLabelColors, isDarkMode: isDarkMode)
        timerCountdownTextView?.textColor = colorForMode(secondaryLabelColors, isDarkMode: isDarkMode)
        setupIntervalText()
        
    }
    
    // MARK: - Layout Initialisation
    private func setupViews() {
        let safeGuide = view.safeAreaLayoutGuide
        
        let bodyHorizontalMargin: CGFloat = 20
        let bodyTopMargin: CGFloat = 20
        let bodyHeight: CGFloat = 70
        
        let labelHorizontalMargin: CGFloat = 12
        let labelHeight: CGFloat = 20
        
        let sublabelHeight: CGFloat = 18
        
        let textTopMargin: CGFloat = 8
        
        let controlHorizontalMargin: CGFloat = 20
        
        let buttonHeight: CGFloat = 40
        
        let switchHeight: CGFloat = 47
        let switchWidth: CGFloat = switchHeight + 20
        
        let descriptionTextViewWidth = UIScreen.main.bounds.width - 64
        let descriptionTextViewFont = UIFont.systemFont(ofSize: 13, weight: .regular)
        
        
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
        
        //MARK: Interval Settings
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
        intervalChangeButton.addAction(for: .touchUpInside, action: {
            let presentingController = IntervalChangerViewController()
            self.navigationController?.pushViewController(presentingController, animated: true)
        })
        intervalBackgroundViewMask.addSubview(intervalChangeButton)
        
        intervalLabel = UILabel()
        intervalLabel.translatesAutoresizingMaskIntoConstraints = false
        intervalLabel.text = "Перерыв"
        intervalLabel.font = .systemFont(ofSize: 17, weight: .regular)
        intervalLabel.textAlignment = .left
        intervalBackgroundViewMask.addSubview(intervalLabel)
        
        intervalSublabel = UILabel()
        intervalSublabel.translatesAutoresizingMaskIntoConstraints = false
        intervalSublabel.text = "1 час 12 минут"
        intervalSublabel.font = .systemFont(ofSize: 15, weight: .regular)
        intervalSublabel.textColor = colorForMode(secondaryLabelColors, isDarkMode: isDarkMode)
        intervalSublabel.textAlignment = .left
        intervalBackgroundViewMask.addSubview(intervalSublabel)
        
        intervalTextView = UITextView()
        intervalTextView.translatesAutoresizingMaskIntoConstraints = false
        
        let intervalText = "Вы можете поменять длину перерыва, который хотите выдерживать между каждой сигаретой."
        let intervalTextHeight = intervalText.calculateTextFieldHeight(width: descriptionTextViewWidth, font: descriptionTextViewFont)
        intervalTextView.text = intervalText
        intervalTextView.font = descriptionTextViewFont
        intervalTextView.textColor = colorForMode(secondaryLabelColors, isDarkMode: isDarkMode)
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
            intervalBackgroundView.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor, constant: bodyHorizontalMargin),
            intervalBackgroundView.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor, constant: -bodyHorizontalMargin),
            intervalBackgroundView.heightAnchor.constraint(equalToConstant: bodyHeight),

            intervalBackgroundViewMask.topAnchor.constraint(equalTo: intervalBackgroundView.topAnchor),
            intervalBackgroundViewMask.leadingAnchor.constraint(equalTo: intervalBackgroundView.leadingAnchor),
            intervalBackgroundViewMask.trailingAnchor.constraint(equalTo: intervalBackgroundView.trailingAnchor),
            intervalBackgroundViewMask.bottomAnchor.constraint(equalTo: intervalBackgroundView.bottomAnchor),
            
            intervalChangeButton.trailingAnchor.constraint(equalTo: intervalBackgroundView.trailingAnchor, constant: -controlHorizontalMargin),
            intervalChangeButton.centerYAnchor.constraint(equalTo: intervalBackgroundView.centerYAnchor),
            intervalChangeButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            intervalChangeButton.widthAnchor.constraint(equalTo: intervalChangeButton.heightAnchor),

            intervalLabel.leadingAnchor.constraint(equalTo: intervalBackgroundView.leadingAnchor, constant: labelHorizontalMargin),
            intervalLabel.trailingAnchor.constraint(equalTo: intervalChangeButton.leadingAnchor, constant: -10),
            intervalLabel.centerYAnchor.constraint(equalTo: intervalBackgroundView.centerYAnchor, constant: -10),
            intervalLabel.heightAnchor.constraint(equalToConstant: labelHeight),

            intervalSublabel.leadingAnchor.constraint(equalTo: intervalLabel.leadingAnchor),
            intervalSublabel.trailingAnchor.constraint(equalTo: intervalLabel.trailingAnchor),
            intervalSublabel.centerYAnchor.constraint(equalTo: intervalBackgroundView.centerYAnchor, constant: 12),
            intervalSublabel.heightAnchor.constraint(equalToConstant: sublabelHeight),

            intervalTextView.topAnchor.constraint(equalTo: intervalBackgroundView.bottomAnchor, constant: textTopMargin),
            intervalTextView.leadingAnchor.constraint(equalTo: intervalBackgroundView.leadingAnchor, constant: labelHorizontalMargin),
            intervalTextView.trailingAnchor.constraint(equalTo: intervalBackgroundView.trailingAnchor, constant: -labelHorizontalMargin),
            intervalTextView.heightAnchor.constraint(equalToConstant: intervalTextHeight),
        ])
        
        //MARK: NightMode Settings
        nightModeBackgroundView = NMView()
        nightModeBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        nightModeBackgroundView.bgColors = bgColors
        nightModeBackgroundView.cornerRadius = 10
        self.view.addSubview(nightModeBackgroundView)
        
        nightModeBackgroundViewMask = UIView()
        nightModeBackgroundViewMask.translatesAutoresizingMaskIntoConstraints = false
        nightModeBackgroundViewMask.clipsToBounds = true
        nightModeBackgroundViewMask.backgroundColor = .clear
        nightModeBackgroundViewMask.layer.cornerRadius = nightModeBackgroundView.cornerRadius
        self.view.addSubview(nightModeBackgroundViewMask)
        
        nightModeChangeButton = NMButton()
        nightModeChangeButton.translatesAutoresizingMaskIntoConstraints = false
        nightModeChangeButton.frame = CGRect(x: 20, y: 100, width: 100, height: 40)
        nightModeChangeButton.cornerRadius = 20
        nightModeChangeButton.bgColors = bgColors
        nightModeChangeButton.titleLabel?.text = "▶︎"
        nightModeChangeButton.titleLabel?.textAlignment = .center
        nightModeChangeButton.titleLabel?.textColor = activeColor
        nightModeChangeButton.addAction(for: .touchUpInside, action: {
            let presentingController = NightModeChangerViewController()
            self.navigationController?.pushViewController(presentingController, animated: true)
        })
        nightModeBackgroundViewMask.addSubview(nightModeChangeButton)
        
        nightModeLabel = UILabel()
        nightModeLabel.translatesAutoresizingMaskIntoConstraints = false
        nightModeLabel.text = "Ночной режим"
        nightModeLabel.font = .systemFont(ofSize: 17, weight: .regular)
        nightModeLabel.textAlignment = .left
        nightModeBackgroundViewMask.addSubview(nightModeLabel)
        
        nightModeSublabel = UILabel()
        nightModeSublabel.translatesAutoresizingMaskIntoConstraints = false
        nightModeSublabel.text = "00:00 – 02:00"
        nightModeSublabel.font = .systemFont(ofSize: 15, weight: .regular)
        nightModeSublabel.textColor = colorForMode(secondaryLabelColors, isDarkMode: isDarkMode)
        nightModeSublabel.textAlignment = .left
        nightModeBackgroundViewMask.addSubview(nightModeSublabel)
        
        nightModeTextView = UITextView()
        nightModeTextView.translatesAutoresizingMaskIntoConstraints = false
        
        let nightModeText = "В ночном режиме перекуры учитываются в прошедший день."
        let nightModeTextHeight = nightModeText.calculateTextFieldHeight(width: descriptionTextViewWidth, font: descriptionTextViewFont)
        nightModeTextView.text = nightModeText
        nightModeTextView.font = descriptionTextViewFont
        nightModeTextView.textColor = colorForMode(secondaryLabelColors, isDarkMode: isDarkMode)
        nightModeTextView.backgroundColor = .clear
        nightModeTextView.textContainer.lineBreakMode = .byWordWrapping
        nightModeTextView.textAlignment = .left
        nightModeTextView.isScrollEnabled = false
        nightModeTextView.isEditable = false
        nightModeTextView.isSelectable = false
        nightModeTextView.textContainerInset = .zero
        nightModeTextView.textContainer.lineFragmentPadding = 0
        self.view.addSubview(nightModeTextView)
        
        NSLayoutConstraint.activate([
            nightModeBackgroundView.topAnchor.constraint(equalTo: intervalTextView.bottomAnchor, constant: bodyTopMargin),
            nightModeBackgroundView.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor, constant: bodyHorizontalMargin),
            nightModeBackgroundView.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor, constant: -bodyHorizontalMargin),
            nightModeBackgroundView.heightAnchor.constraint(equalToConstant: bodyHeight),

            nightModeBackgroundViewMask.topAnchor.constraint(equalTo: nightModeBackgroundView.topAnchor),
            nightModeBackgroundViewMask.leadingAnchor.constraint(equalTo: nightModeBackgroundView.leadingAnchor),
            nightModeBackgroundViewMask.trailingAnchor.constraint(equalTo: nightModeBackgroundView.trailingAnchor),
            nightModeBackgroundViewMask.bottomAnchor.constraint(equalTo: nightModeBackgroundView.bottomAnchor),
            
            nightModeChangeButton.trailingAnchor.constraint(equalTo: nightModeBackgroundView.trailingAnchor, constant: -controlHorizontalMargin),
            nightModeChangeButton.centerYAnchor.constraint(equalTo: nightModeBackgroundView.centerYAnchor),
            nightModeChangeButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            nightModeChangeButton.widthAnchor.constraint(equalTo: nightModeChangeButton.heightAnchor),

            nightModeLabel.leadingAnchor.constraint(equalTo: nightModeBackgroundView.leadingAnchor, constant: labelHorizontalMargin),
            nightModeLabel.trailingAnchor.constraint(equalTo: nightModeChangeButton.leadingAnchor, constant: -10),
            nightModeLabel.centerYAnchor.constraint(equalTo: nightModeBackgroundView.centerYAnchor, constant: -10),
            nightModeLabel.heightAnchor.constraint(equalToConstant: labelHeight),

            nightModeSublabel.leadingAnchor.constraint(equalTo: nightModeLabel.leadingAnchor),
            nightModeSublabel.trailingAnchor.constraint(equalTo: nightModeLabel.trailingAnchor),
            nightModeSublabel.centerYAnchor.constraint(equalTo: nightModeBackgroundView.centerYAnchor, constant: 12),
            nightModeSublabel.heightAnchor.constraint(equalToConstant: sublabelHeight),

            nightModeTextView.topAnchor.constraint(equalTo: nightModeBackgroundView.bottomAnchor, constant: textTopMargin),
            nightModeTextView.leadingAnchor.constraint(equalTo: nightModeBackgroundView.leadingAnchor, constant: labelHorizontalMargin),
            nightModeTextView.trailingAnchor.constraint(equalTo: nightModeBackgroundView.trailingAnchor, constant: -labelHorizontalMargin),
            nightModeTextView.heightAnchor.constraint(equalToConstant: nightModeTextHeight),
        ])
        
        //MARK: Countdown Settings
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
        let timerCountdownTextHeight = timerCountdownText.calculateTextFieldHeight(width: descriptionTextViewWidth, font: descriptionTextViewFont)
        timerCountdownTextView.text = timerCountdownText
        timerCountdownTextView.font = descriptionTextViewFont
        timerCountdownTextView.textColor = colorForMode(secondaryLabelColors, isDarkMode: isDarkMode)
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
            timerCountdownBackgroundView.topAnchor.constraint(equalTo: nightModeTextView.bottomAnchor, constant: bodyTopMargin),
            timerCountdownBackgroundView.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor, constant: bodyHorizontalMargin),
            timerCountdownBackgroundView.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor, constant: -bodyHorizontalMargin),
            timerCountdownBackgroundView.heightAnchor.constraint(equalToConstant: bodyHeight),

            timerCountdownBackgroundViewMask.topAnchor.constraint(equalTo: timerCountdownBackgroundView.topAnchor),
            timerCountdownBackgroundViewMask.leadingAnchor.constraint(equalTo: timerCountdownBackgroundView.leadingAnchor),
            timerCountdownBackgroundViewMask.trailingAnchor.constraint(equalTo: timerCountdownBackgroundView.trailingAnchor),
            timerCountdownBackgroundViewMask.bottomAnchor.constraint(equalTo: timerCountdownBackgroundView.bottomAnchor),
            
            timerCountdownSwitch.centerYAnchor.constraint(equalTo: timerCountdownBackgroundView.centerYAnchor),
            timerCountdownSwitch.trailingAnchor.constraint(equalTo: timerCountdownBackgroundView.trailingAnchor, constant: -controlHorizontalMargin),
            timerCountdownSwitch.heightAnchor.constraint(equalToConstant: switchHeight),
            timerCountdownSwitch.widthAnchor.constraint(equalToConstant: switchWidth),
            
            timerCountdownlLabel.leadingAnchor.constraint(equalTo: timerCountdownBackgroundView.leadingAnchor, constant: labelHorizontalMargin),
            timerCountdownlLabel.trailingAnchor.constraint(equalTo: timerCountdownSwitch.leadingAnchor, constant: -10),
            timerCountdownlLabel.centerYAnchor.constraint(equalTo: timerCountdownBackgroundView.centerYAnchor),
            timerCountdownlLabel.heightAnchor.constraint(equalToConstant: labelHeight),
            
            timerCountdownTextView.topAnchor.constraint(equalTo: timerCountdownBackgroundView.bottomAnchor, constant: textTopMargin),
            timerCountdownTextView.leadingAnchor.constraint(equalTo: timerCountdownBackgroundView.leadingAnchor, constant: labelHorizontalMargin),
            timerCountdownTextView.trailingAnchor.constraint(equalTo: timerCountdownBackgroundView.trailingAnchor, constant: -labelHorizontalMargin),
            timerCountdownTextView.heightAnchor.constraint(equalToConstant: timerCountdownTextHeight),
        ])
    }
    
    // MARK: - Layout Changes
    private func setupIntervalText() {
        loadTimeFromDefaults()
        if let h = intervalHours, let m = intervalMinutes {
            let hoursStr = h.getNoun("час", singleEnd: "", dualEnd: "а", multipleEnd: "ов")
            let minutesStr = m.getNoun("минут", singleEnd: "а", dualEnd: "ы", multipleEnd: "")
            var timeStr = ""
            if h != 0 {
                timeStr.append("\(h) \(hoursStr) ")
            }
            
            if m != 0 {
                timeStr.append("\(m) \(minutesStr)")
            }
           
            intervalSublabel?.text = timeStr
        }
        
        if let h = nightModeHours {
            if h == 0 {
                nightModeSublabel?.text = "Отключен"
            } else {
                nightModeSublabel?.text = "00:00 – 0\(h):00"
            }
        }
    }
    
    private func changeCountdownDescription(_ isCountdown: Bool) {
            let isCountdownText = "Внутри таймера будет отображаться время до окончания перерыва."
            let isNotCountdownText = "Внутри таймера будет отображаться время от начала перерыва."
        timerCountdownTextView?.text = isCountdown ? isCountdownText : isNotCountdownText
    }
    
    // MARK: - Controlls Actions
    private func switchCountdown() {
        let defaults = UserDefaults.standard
        if timerCountdownSwitch != nil {
            if timerCountdownSwitch.isActive {
                timerCountdownSwitchState = true
                defaults.setValue(true, forKey: isCountdownKey)
            } else {
                timerCountdownSwitchState = false
                defaults.setValue(false, forKey: isCountdownKey)
            }
        }
    }
    
    
    // MARK: - UserDefaults loading
    private func loadTimeFromDefaults() {
        let defaults = UserDefaults.standard
        
        intervalHours = defaults.integer(forKey: intervalHoursKey)
        intervalMinutes = defaults.integer(forKey: intervalMinutesKey)
        
        if intervalHours == 0 && intervalMinutes == 0 {
            defaults.setValue(2, forKey: intervalHoursKey)
            intervalHours = 2
        }
        
        nightModeHours = defaults.integer(forKey: nightModeHoursKey)
    }
    
    
}
