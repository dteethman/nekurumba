import UIKit

class HomeViewController: UIViewController {
    let app = UIApplication.shared.delegate as? AppDelegate
    var plannedInterval: TimeInterval = 7200
    
    let coreDataManager = CoreDataManager()
    let statsManager = StatsProvider()
    var todayData: [SmokeTracker]?
    var yesterdayData: [SmokeTracker]?
    
    var highlightCollectionViewLayout: UICollectionViewFlowLayout!
    var highlightCollectionViewDelegate = HighlightCollectionViewDelegate()
    var highlightCollectionViewDataSource = HighlightCollectionViewDataSource()
    
    var timerView: NMProgressViewWithButton!
    var titleLabel: UILabel!
    var highlightsLabel: UILabel!
    var highlightCollectionView: UICollectionView!
    
    var isCountdown: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statsManager.dataManager = coreDataManager
        
        setupViews()
        setupHighlightCollectionView()
                
        timerView.buttonTouchUpInside = {
            self.app?.smokeTimer.start()
            self.timerView.deactivateButton()
            self.coreDataManager.addData(date: Date())
            self.setupHighlightCollectionView()
        }
        
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
            setupHighlightCollectionView()
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let defaults = UserDefaults.standard
        isCountdown = defaults.bool(forKey: "isCountdown")
    }
    
    private func setupViews() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let timerViewHeight = min(screenWidth - 60, screenHeight - 340)
        let highlightHeight: CGFloat = screenHeight < 800 ? 110 : 220
        self.view.backgroundColor = colorForMode(bgColors, isDarkMode: isDarkMode)
        
        let safeGuide = view.safeAreaLayoutGuide
        let safeAreaBoundsView = UIView()
        safeAreaBoundsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(safeAreaBoundsView)
        
        titleLabel = UILabel()
        titleLabel.text = "Некурёмба"
        titleLabel.font = .systemFont(ofSize: 34, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .left
        safeAreaBoundsView.addSubview(titleLabel)
        
        timerView = NMProgressViewWithButton(frame: .zero)
        timerView.cornerRadius = timerViewHeight / 2
        timerView.progressBar.progress = 1
        timerView.progressBar.startGradienttColor = .red
        timerView.progressBar.endGradientColor = .systemPink
        timerView.progressBar.transparentBackgroundLayer = true
        timerView.progressBar.disableText = true
        timerView.progressBar.animationDuration = 0.2
        timerView.progressBar.lineWidth = 30
        
        timerView.translatesAutoresizingMaskIntoConstraints = false
        safeAreaBoundsView.addSubview(timerView)
        
        highlightsLabel = UILabel()
        highlightsLabel.text = "Сводка"
        highlightsLabel.font = .systemFont(ofSize: 28, weight: .bold)
        highlightsLabel.translatesAutoresizingMaskIntoConstraints = false
        highlightsLabel.textAlignment = .left
        safeAreaBoundsView.addSubview(highlightsLabel)
        
        highlightCollectionViewLayout = UICollectionViewFlowLayout()
        highlightCollectionViewLayout.scrollDirection = .horizontal
        highlightCollectionViewLayout.minimumLineSpacing = 0
        highlightCollectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        highlightCollectionViewLayout.minimumInteritemSpacing = 0
        highlightCollectionViewLayout.sectionInsetReference = .fromContentInset
        
        highlightCollectionView = UICollectionView(frame: .zero,
                                                   collectionViewLayout: highlightCollectionViewLayout)
        highlightCollectionView.register(HighlightCollectionViewCell.self, forCellWithReuseIdentifier: "highlightCell")
        highlightCollectionView.delegate = highlightCollectionViewDelegate
        highlightCollectionView.dataSource = highlightCollectionViewDataSource
        highlightCollectionView.backgroundColor = .clear
        highlightCollectionView.clipsToBounds = false
        highlightCollectionView.layer.masksToBounds = false
        highlightCollectionView.showsHorizontalScrollIndicator = false
        highlightCollectionView.showsVerticalScrollIndicator = false
        highlightCollectionView.translatesAutoresizingMaskIntoConstraints = false
        safeAreaBoundsView.addSubview(highlightCollectionView)
         
        NSLayoutConstraint.activate([
            safeAreaBoundsView.topAnchor.constraint(equalTo: safeGuide.topAnchor),
            safeAreaBoundsView.bottomAnchor.constraint(equalTo: safeGuide.bottomAnchor),
            safeAreaBoundsView.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor),
            safeAreaBoundsView.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: safeGuide.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor, constant: 20),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            
            timerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            timerView.centerXAnchor.constraint(equalTo: safeAreaBoundsView.centerXAnchor),
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
    
    func setupHighlightCollectionView() {
        let provider = HighlightsProvider()
        let today = Date()
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
    
    func loadPlannedInterval() -> TimeInterval {
        let defaults = UserDefaults.standard
        var hours: Int = defaults.integer(forKey: "hours")
        let minutes: Int = defaults.integer(forKey: "minutes")

        if hours == 0 && minutes == 0 {
            defaults.setValue(2, forKey: "hours")
            hours = 2
        }
        
        return TimeInterval(hours * 3600 + minutes * 60)
    }
    
    @objc func viewWillResignActive() {
        app?.smokeTimer?.saveToDefaults()
    }

    @objc func viewWillEnterForeground() {
        app?.smokeTimer?.loadFromDefaults()
    }

    @objc func viewWillTerminate() {
        app?.smokeTimer?.saveToDefaults()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setupHighlightCollectionView()
        self.view.backgroundColor = colorForMode(bgColors, isDarkMode: isDarkMode)
        
    }

}






