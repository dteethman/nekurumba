import UIKit

class StatsViewController: UIViewController {
    var segmentedControl: NMSegmentedControl!
    var titleLabel: UILabel!
    var statsTableView: UITableView!
    
    var statsTableViewDelegate = StatsTableViewDelegate()
    var statsTableViewDataSource = StatsTableViewDataSource()
    
    var segments: [SegmentItem]!
    var selectedSegment: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = colorForMode(bgColors, isDarkMode: isDarkMode)
        
        segments = [
            SegmentItem(displayTitle: "День", action: {
                self.selectedSegment = 1
                self.presentTodayStats()
            }),
            SegmentItem(displayTitle: "Неделя", action: {
                self.selectedSegment = 2
                self.presentWeeklyStats()
                
            }),
            SegmentItem(displayTitle: "Месяц", action: {
                self.selectedSegment = 3
                self.presentMonthlyStats()
                
            }),
        ]
        setupViews()
    }
    
    private func setupViews() {
        let safeGuide = view.safeAreaLayoutGuide
        
        titleLabel = UILabel()
        titleLabel.text = "Статистика"
        titleLabel.font = .systemFont(ofSize: 34, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .left
        self.view.addSubview(titleLabel)
        
        let segmentedControlFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 32 , height: 40)
        if segments == nil {
            segments = []
        }
        segmentedControl = NMSegmentedControl(segmentItems: segments, frame: segmentedControlFrame)
        segmentedControl.cornerRadius = 20
        segmentedControl.bgColors = bgColors
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(segmentedControl)
        
        statsTableView = UITableView()
        statsTableView.translatesAutoresizingMaskIntoConstraints = false
        statsTableView.delegate = statsTableViewDelegate
        statsTableView.dataSource = statsTableViewDataSource
        statsTableView.register(StatsTableViewCell.self, forCellReuseIdentifier: "statsCell")
        statsTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        statsTableView.backgroundColor = .clear
        statsTableView.allowsSelection = false
        self.view.addSubview(statsTableView)
        
        updateData()
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeGuide.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor, constant: 20),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            
            segmentedControl.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            segmentedControl.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor, constant: -16),
            segmentedControl.heightAnchor.constraint(equalToConstant: 40),
            
            statsTableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10),
            statsTableView.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor, constant: 0),
            statsTableView.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor, constant: 0),
            statsTableView.bottomAnchor.constraint(equalTo: safeGuide.bottomAnchor, constant: -70)

            
        ])
        
        
        segmentedControl.layoutSubviews()
    }
    
    func presentTodayStats() {
        let provider = StatsProvider()
        provider.dataManager = CoreDataManager()
        
        let date = Date()
        let calendaer = Calendar.current
        let year = calendaer.component(.year, from: date)
        let month = calendaer.component(.month, from: date)
        let day = calendaer.component(.day, from: date)
        
        let dailySmoked = provider.getDailySmokedStats(year: year, month: month, day: day)
        let dailyInterval = provider.getDailyIntervalsStats(year: year, month: month, day: day)
        
        var data: [StatData]? = []
        
        if dailySmoked != nil {
            data?.append(dailySmoked!)
        }
        
        if dailyInterval != nil {
            data?.append(dailyInterval!)
        }
        
        statsTableViewDataSource.stats = data
        statsTableView?.reloadData()
    }
    
    func presentWeeklyStats() {
        let provider = StatsProvider()
        provider.dataManager = CoreDataManager()
        
        let date = Date()
        let calendaer = Calendar.current
        let year = calendaer.component(.year, from: date)
        let month = calendaer.component(.month, from: date)
        let day = calendaer.component(.day, from: date)
        
        let weeklySmoked = provider.getWeeklySmokedStats(year: year, month: month, day: day)
        let weeklyInterval = provider.getWeeklyIntervalStats(year: year, month: month, day: day)
        
        var data: [StatData]? = []
        
        if weeklySmoked != nil {
            data?.append(weeklySmoked!)
        }
        
        if weeklyInterval != nil {
            data?.append(weeklyInterval!)
        }

        statsTableViewDataSource.stats = data
        statsTableView?.reloadData()
    }
    
    func presentMonthlyStats() {
        let provider = StatsProvider()
        provider.dataManager = CoreDataManager()
        
        let date = Date()
        let calendaer = Calendar.current
        let year = calendaer.component(.year, from: date)
        let month = calendaer.component(.month, from: date)
        let day = calendaer.component(.day, from: date)
        
        let monthlySmoked = provider.getMonthlySmokedStats(year: year, month: month, day: day)
        let monthlyInterval = provider.getMonthlyIntervalStats(year: year, month: month, day: day)
        
        var data: [StatData]? = []
        
        if monthlySmoked != nil {
            data?.append(monthlySmoked!)
        }
        
        if monthlyInterval != nil {
            data?.append(monthlyInterval!)
        }

        statsTableViewDataSource.stats = data
        statsTableView?.reloadData()
    }
    
    func updateData() {
        if let segment = selectedSegment {
            switch segment {
            case 1:
                presentTodayStats()
            case 2:
                presentWeeklyStats()
            case 3:
                presentMonthlyStats()
            default:
                break
            }
        }
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        view.backgroundColor = colorForMode(bgColors, isDarkMode: isDarkMode)
    }

}
