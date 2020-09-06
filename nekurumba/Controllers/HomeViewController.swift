import UIKit
import DTBunchOfExt

class HomeViewController: UIViewController {
    //MARK: - Variables
    private let app = UIApplication.shared.delegate as? AppDelegate
    private var plannedInterval: TimeInterval = 7200
    private let defaults = UserDefaults.standard
    
    private let coreDataManager = CoreDataManager()
    private let statsManager = StatsProvider()
    private var todayData: [SmokeTracker]?
    private var yesterdayData: [SmokeTracker]?
    
    private var highlightCollectionViewLayout: UICollectionViewFlowLayout!
    private var highlightCollectionViewDelegate = HighlightCollectionViewDelegate()
    private var highlightCollectionViewDataSource = HighlightCollectionViewDataSource()
    
    private var timerView: NMProgressViewWithButton!
    private var titleLabel: UILabel!
    private var highlightsLabel: UILabel!
    private var highlightCollectionView: UICollectionView!
    
    private var isCountdown: Bool = true
    private var isNightMode: Bool = false {
        didSet {
            DispatchQueue.main.async { [self] in
                titleLabel?.text = isNightMode ? "Некурёмба 🌙" : "Некурёмба"
                setupHighslightCollectionView()
                
                nightModeHintlWasShown = loadNightModeHint()
                if !nightModeHintlWasShown && isNightMode {
                    setupHintPopup()
                }
            }
        }
    }
    private var nightModeHintlWasShown: Bool = false
    
    //MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        statsManager.dataManager = coreDataManager
        
        setupViews()
        setupHighslightCollectionView()
                
        timerView.addAction(for: .touchUpInside, action: { [self] in
            app?.smokeTimer.start()
            timerView.deactivateButton()
            isNightMode = loadIsNightMode()
            
            if isNightMode {
                let calendar = Calendar.current
                let todayDate = Date()
                let yesterdayDate = Date().dayBefore
                
                let y = calendar.component(.year, from: yesterdayDate)
                let mo = calendar.component(.month, from: yesterdayDate)
                let d = calendar.component(.day, from: yesterdayDate)
                let h = 24 + calendar.component(.hour, from: todayDate)
                let min = calendar.component(.minute, from: todayDate)
                coreDataManager.addData(year: y, month: mo, day: d, hour: h, minute: min)
            } else {
                coreDataManager.addData(date: Date())
            }
            
            setupHighslightCollectionView()
        })
        
        plannedInterval = loadPlannedInterval()
        
        app?.smokeTimer = UDLoadableTimer()
        app?.smokeTimer.interval.value = plannedInterval
        app?.smokeTimer.currentTime.value = 0
        app?.smokeTimer.defaultsKey = "firstTimer"
        app?.smokeTimer.currentTime.bind { [unowned self] in
            self.timerView.progressBar.progress = CGFloat($0 / (app?.smokeTimer.interval.value)!)
            let remainingTime = (app?.smokeTimer.interval.value)! - $0
            let displayedTime = isCountdown ? remainingTime : $0
            if $0 >= (app?.smokeTimer.interval.value)! {
                self.timerView.changeButtonTitle("🚬", font: UIFont.systemFont(ofSize: 60))
                self.timerView.activateButton()
            } else {
                $0 < 61 ? self.timerView.deactivateButton() : self.timerView.activateButton()
                self.timerView.changeButtonTitle(displayedTime.timeString, font: UIFont.monospacedDigitSystemFont(ofSize: 32, weight: .bold))
            }
        }
        
        app?.smokeTimer.interval.bind { [unowned self] in
            plannedInterval = $0
            setupHighslightCollectionView()
        }
        
        if #available(iOS 13.0, *) { } else {
            app?.smokeTimer?.loadFromDefaults()
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(viewWillResignActive),
                                               name: UIApplication.willResignActiveNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(viewWillEnterForeground),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(viewWillTerminate),
                                               name: UIApplication.willTerminateNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(dayChanged),
                                               name: NSNotification.Name.NSCalendarDayChanged,
                                               object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        isCountdown = defaults.bool(forKey: isCountdownKey)
        
        isNightMode = loadIsNightMode()
        titleLabel?.text = isNightMode ? "Некурёмба 🌙" : "Некурёмба"
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setupHighslightCollectionView()
        self.view.backgroundColor = colorForMode(bgColors, isDarkMode: isDarkMode)
        
    }
    
    //MARK: - Layout
    private func setupViews() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let timerViewHeight = min(screenWidth - 60, screenHeight - 340)
        let highlightHeight: CGFloat = screenHeight < 800 ? 110 : 220
        self.view.backgroundColor = colorForMode(bgColors, isDarkMode: isDarkMode)
        
        let safeGuide = view.safeAreaLayoutGuide
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Некурёмба"
        titleLabel.font = .systemFont(ofSize: 34, weight: .bold)
        titleLabel.textAlignment = .left
        self.view.addSubview(titleLabel)
        
        timerView = NMProgressViewWithButton(frame: .zero)
        timerView.translatesAutoresizingMaskIntoConstraints = false
        timerView.cornerRadius = timerViewHeight / 2
        timerView.bgColors = bgColors
        timerView.lineWidth = 30
        timerView.progressBar.progress = 1
        timerView.progressBar.startGradienttColor = .red
        timerView.progressBar.endGradientColor = .systemPink
        timerView.progressBar.transparentBackgroundLayer = true
        timerView.progressBar.disableText = true
        timerView.progressBar.animationDuration = 0.2
        self.view.addSubview(timerView)
        
        highlightsLabel = UILabel()
        highlightsLabel.translatesAutoresizingMaskIntoConstraints = false
        highlightsLabel.text = "Сводка"
        highlightsLabel.font = .systemFont(ofSize: 28, weight: .bold)
        highlightsLabel.textAlignment = .left
        self.view.addSubview(highlightsLabel)
        
        highlightCollectionViewLayout = UICollectionViewFlowLayout()
        highlightCollectionViewLayout.scrollDirection = .horizontal
        highlightCollectionViewLayout.minimumLineSpacing = 0
        highlightCollectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        highlightCollectionViewLayout.minimumInteritemSpacing = 0
        highlightCollectionViewLayout.sectionInsetReference = .fromContentInset
        
        highlightCollectionView = UICollectionView(frame: .zero,
                                                   collectionViewLayout: highlightCollectionViewLayout)
        highlightCollectionView.translatesAutoresizingMaskIntoConstraints = false
        highlightCollectionView.register(HighlightCollectionViewCell.self, forCellWithReuseIdentifier: "highlightCell")
        highlightCollectionView.delegate = highlightCollectionViewDelegate
        highlightCollectionView.dataSource = highlightCollectionViewDataSource
        highlightCollectionView.backgroundColor = .clear
        highlightCollectionView.clipsToBounds = false
        highlightCollectionView.layer.masksToBounds = false
        highlightCollectionView.showsHorizontalScrollIndicator = false
        highlightCollectionView.showsVerticalScrollIndicator = false
        self.view.addSubview(highlightCollectionView)
         
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeGuide.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor, constant: -20),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            
            timerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            timerView.centerXAnchor.constraint(equalTo: safeGuide.centerXAnchor),
            timerView.heightAnchor.constraint(equalToConstant: timerViewHeight),
            timerView.widthAnchor.constraint(equalTo: timerView.heightAnchor),
            
            highlightsLabel.topAnchor.constraint(equalTo: timerView.bottomAnchor, constant: 25),
            highlightsLabel.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor, constant: 20),
            highlightsLabel.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor, constant: 20),
            highlightsLabel.heightAnchor.constraint(equalToConstant: 34),
            
            highlightCollectionView.topAnchor.constraint(equalTo: highlightsLabel.bottomAnchor, constant: -5),
            highlightCollectionView.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor, constant: 10),
            highlightCollectionView.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor, constant: 10),
            highlightCollectionView.heightAnchor.constraint(equalToConstant: highlightHeight),

        ])
    }
    
    private func setupHintPopup() {
        let safeArea = view.safeAreaLayoutGuide
        let hour = defaults.integer(forKey: nightModeHoursKey)
        var hourWord = ""
        
        switch hour {
        case 1:
            hourWord = "1 часа ночи"
        case 2, 3:
            hourWord = "\(hour) часов ночи"
        case 4, 5:
            hourWord = "\(hour) часов утра"
        default:
              break
        }
        
        let text = """
        Когда полумесяц появляется над кнопкой, это значит, что включился ночной режим. Когда он активен, перекуры будут учитываться в прошедший календарный день.\nСейчас он активен с полуночи до \(hourWord). Установите его в настройках вплоть до 5 утра или отключите, установив 0 часов
        """
        
        let backgroundView = UIView()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = UIColor.black
        backgroundView.alpha = 0.4
        backgroundView.isHidden = true
        self.view.addSubview(backgroundView)
        
        let popUpView = NMPopUpView(titleText: "Ночной режим 🌙", messageText: text)
        popUpView.translatesAutoresizingMaskIntoConstraints = false
        let popUpShownConstraint = popUpView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -100)
        let popUpHiddenConstraint = popUpView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: 400)
        popUpView.cornerRadius = 20
        popUpView.bgColors = bgColors
        popUpView.dismissButton.titleLabel.text = "Хорошо"
        popUpView.dismissButton.titleLabel.textColor = activeColor
        popUpView.dismissButton.addAction(for: .touchUpInside) { [self] in
            popUpShownConstraint.isActive = false
            popUpHiddenConstraint.isActive = true
            backgroundView.isHidden = true
            
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn], animations: { [self] in
                view.layoutIfNeeded()
            }, completion: { (completed) in
                backgroundView.removeFromSuperview()
                popUpView.removeFromSuperview()
                defaults.setValue(true, forKey: isNightModeHintKey)
            })
        }
        
        let height = popUpView.messageTextViewHeight + 124
        
        self.view.addSubview(popUpView)
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: self.view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            popUpHiddenConstraint,
            popUpView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            popUpView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            popUpView.heightAnchor.constraint(equalToConstant: height),
        ])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [self] in
            popUpShownConstraint.isActive = true
            popUpHiddenConstraint.isActive = false
            backgroundView.isHidden = false
            
            UIView.animate(withDuration: 0.15, delay: 0, options: [.curveEaseIn], animations: { [self] in
                view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    //MARK: - HighlightsCollectionView Setup
    private func setupHighslightCollectionView() {
        let provider = HighlightsProvider()
        var today = Date()
        if isNightMode {
            today = Date().dayBefore
        }
        
        let calendar = Calendar.current
        
        todayData = coreDataManager.loadForDate(year: calendar.component(.year, from: today),
                                            month: calendar.component(.month, from: today),
                                            day: calendar.component(.day, from: today))
        
        yesterdayData = coreDataManager.loadForDate(year: calendar.component(.year, from: today.dayBefore),
                                                month: calendar.component(.month, from: today.dayBefore),
                                                day: calendar.component(.day, from: today.dayBefore))
        
        var highlights: [HighlightData] = []
        
        let countHighlight = provider.makeCountHighlight(todayData: todayData, yesterdayData: yesterdayData, isDarkMode: isDarkMode)
        let intervalHighlight = provider.makeIntervalHighlight(todayData: todayData, plannedInteval: Int(plannedInterval) / 60, isDarkMode: isDarkMode)
        
        if countHighlight != nil {
            highlights.append(countHighlight!)
        }
        
        if intervalHighlight != nil {
            highlights.append(intervalHighlight!)
        }
        
        highlightCollectionViewDataSource.data = highlights
        highlightCollectionView.reloadData()
    }
    
    //MARK: - UserDefaults loading
    private func loadPlannedInterval() -> TimeInterval {
        let defaults = UserDefaults.standard
        var hours: Int = defaults.integer(forKey: intervalHoursKey)
        let minutes: Int = defaults.integer(forKey: intervalMinutesKey)

        if hours == 0 && minutes == 0 {
            defaults.setValue(2, forKey: intervalHoursKey)
            hours = 2
        }
        
        return TimeInterval(hours * 3600 + minutes * 60)
    }
    
    private func loadIsNightMode() -> Bool {
        let h = defaults.integer(forKey: nightModeHoursKey)
        return h > 0 && h > Calendar.current.component(.hour, from: Date())
    }
    
    private func loadNightModeHint() -> Bool {
        return defaults.bool(forKey: isNightModeHintKey)
    }
    
    //MARK: - NotificationCenter actions
    @objc private func viewWillResignActive() {
        app?.smokeTimer?.saveToDefaults()
    }

    @objc private func viewWillEnterForeground() {
        app?.smokeTimer?.loadFromDefaults()
    }

    @objc private func viewWillTerminate() {
        app?.smokeTimer?.saveToDefaults()
    }
    
    @objc private func dayChanged() {
        isNightMode = loadIsNightMode()
    }
    
}






