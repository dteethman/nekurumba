import UIKit

class HomeViewController: UIViewController {
    let smokeTimer = UDLoadableTimer()
    
    var timerView: NMProgressViewWithButton!
    var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        timerView.buttonTouchUpInside = {
            self.smokeTimer.start()
            self.timerView.deactivateButton()
        }
        
        smokeTimer.interval = 15
        smokeTimer.currentTime.value = 2
        smokeTimer.defaultsKey = "firstTimer"
        smokeTimer.currentTime.bind { [unowned self] in
            timerView.progressBar.progress = CGFloat(1 - ($0 / smokeTimer.interval))
            let remainingTime = smokeTimer.interval - $0
            if $0 >= smokeTimer.interval {
                timerView.changeButtonTitle("🚬", font: UIFont.systemFont(ofSize: 60))
                timerView.activateButton()
            } else {
                timerView.changeButtonTitle(remainingTime.timeString, font: UIFont.monospacedDigitSystemFont(ofSize: 36, weight: .bold))
                timerView.deactivateButton()
            }
        }
        if #available(iOS 13.0, *) { } else {
            smokeTimer.loadFromDefaults()
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
    
    private func setupViews() {
        self.view.backgroundColor = isDarkMode ? bgColors.dark : bgColors.light
        
        let safeGuide = view.safeAreaLayoutGuide
        let safeAreaBoundsView = UIView()
        safeAreaBoundsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(safeAreaBoundsView)
        
        titleLabel = UILabel()
        titleLabel.text = "Некурюмба"
        titleLabel.font = .systemFont(ofSize: 34, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .left
        safeAreaBoundsView.addSubview(titleLabel)
        
        timerView = NMProgressViewWithButton(frame: .zero)
        timerView.cornerRadius = 150
        timerView.progressBar.progress = 1
        timerView.progressBar.startGradienttColor = .red
        timerView.progressBar.endGradientColor = .systemPink
        timerView.progressBar.transparentBackgroundLayer = true
        timerView.progressBar.disableText = true
        timerView.progressBar.animationDuration = 0.2
        timerView.progressBar.lineWidth = 30
        
        timerView.translatesAutoresizingMaskIntoConstraints = false
        safeAreaBoundsView.addSubview(timerView)
         
        NSLayoutConstraint.activate([
            safeAreaBoundsView.topAnchor.constraint(equalTo: safeGuide.topAnchor),
            safeAreaBoundsView.bottomAnchor.constraint(equalTo: safeGuide.bottomAnchor),
            safeAreaBoundsView.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor),
            safeAreaBoundsView.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: safeGuide.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor, constant: 20),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            
            timerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            timerView.centerXAnchor.constraint(equalTo: safeAreaBoundsView.centerXAnchor),
            timerView.heightAnchor.constraint(equalToConstant: 300),
            timerView.widthAnchor.constraint(equalTo: timerView.heightAnchor),
        ])
    }
    
    @objc func viewWillResignActive() {
        print("viewWillResignActive")
        smokeTimer.saveToDefaults()
    }
    
    @objc func viewWillEnterForeground() {
        print("viewWillEnterForeground")
        smokeTimer.loadFromDefaults()
    }
    
    @objc func viewWillTerminate() {
        print("viewWillTerminate")
        smokeTimer.saveToDefaults()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.view.backgroundColor = isDarkMode ? bgColors.dark : bgColors.light
        
    }

}






