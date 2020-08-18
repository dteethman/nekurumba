import UIKit
import DTBunchOfExt

class OnboardingViewController: UIViewController, UIScrollViewDelegate {
    //MARK: - Variables
    private let defaults = UserDefaults.standard
    
    private var scrollView: UIScrollView!
    private var pageControl: UIPageControl!
    private var intervalButton: NMButton!
    
    private let onboardingDataArray: [(titleText: String, emoji: String, shortDesc: String, fullDesc: String)] = [
        (
            titleText: "Что такое Некурёмба?",
            emoji: "🤔",
            shortDesc: "Некуремба — это приложение, которое помогает дисциплинировать себя как курильщика.",
            fullDesc: """
Оно соберет статистику о курении, покажет насколько больше или меньше и как часто вы курите в сравнении с вчерашним днем, неделей и месяцем. А вы сделаете выводы.

Некуремба не будет говорить вам, сколько следует курить, и учить вас жить. Курить или нет — решать вам.
"""
        ),
        (
            titleText: "Считайте сигареты",
            emoji: "🚬",
            shortDesc: "Нажимайте на сигарету внутри круга каждый раз, когда курите.",
            fullDesc: """
Некурёмба соберет и покажет статистику.

Если вы будете нажимать кнопку при каждом перекуре, у вас будут полная статистика.

Нажать можно даже когда внутри круга идет время. Единственное ограничение — не чаще, чем раз в минуту.
"""
        ),
        (
            titleText: "Делайте перерыв",
            emoji: "⌛",
            shortDesc: "Поставьте цель и старайтесь ее выполнить.",
            fullDesc: """
Некурёмба не может заставить вас выдерживать время между перекурами, лишь показать, сколько прошло.

По умолчанию перерыв составляет 2 часа, но вы можете изменить его сейчас или в любой момент в настройках.
"""
        ),
        (
            titleText: "Все готово",
            emoji: "👌",
            shortDesc: "Начните держать курение под контролем прямо сейчас!",
            fullDesc: """
И помните, что Некурёмба — это приложение для честных с самим собой.

А вообще — курить плохо!
"""
        )
    ]
    
    private var onboardingViews: [OnboardingView] = []
    private var buttonsArray: [NMButton] = []
    
    private var screenWidth: CGFloat = 0

    //MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = colorForMode(bgColors, isDarkMode: isDarkMode)
        
        defaults.setValue(true, forKey: isCountdownKey)
        defaults.setValue(2, forKey: intervalHoursKey)
        
        setupViews()
        setupButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.view.backgroundColor = colorForMode(bgColors, isDarkMode: isDarkMode)
        pageControl?.pageIndicatorTintColor = colorForMode(secondaryLabelColors, isDarkMode: isDarkMode)
        pageControl?.currentPageIndicatorTintColor = colorForMode(bgColors, isDarkMode: isDarkMode)
        
    }
    
    //MARK: - Layout
    func setupViews() {
        let safeGuide = view.safeAreaLayoutGuide
        
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        self.view.addSubview(scrollView)
        
        pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = onboardingDataArray.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = colorForMode(secondaryLabelColors, isDarkMode: isDarkMode)
        pageControl.currentPageIndicatorTintColor = colorForMode(bgColors, isDarkMode: isDarkMode)
        pageControl.isUserInteractionEnabled = false
        self.view.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: safeGuide.bottomAnchor, constant: -19),
            pageControl.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor),
            pageControl.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 20),
            
            scrollView.topAnchor.constraint(equalTo: safeGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: pageControl.topAnchor),
            
        ])
        
        screenWidth = UIScreen.main.bounds.width
        
        for ind in 0 ..< onboardingDataArray.count {
            let v = OnboardingView(frame: .zero, data: onboardingDataArray[ind])
            v.translatesAutoresizingMaskIntoConstraints = false
            v.bgColors = bgColors
            v.backgroundColor = .red
            scrollView.addSubview(v)
            onboardingViews.append(v)
            
            
            if ind == 0 {
                NSLayoutConstraint.activate([
                    v.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
                    v.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0),
                    v.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0),
                    v.widthAnchor.constraint(equalToConstant: screenWidth)
                ])
            } else if ind == onboardingDataArray.count - 1 {
                NSLayoutConstraint.activate([
                    v.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
                    v.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0),
                    v.leadingAnchor.constraint(equalTo: onboardingViews[ind - 1].trailingAnchor),
                    v.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                    v.widthAnchor.constraint(equalToConstant: screenWidth)
                ])
            } else {
                NSLayoutConstraint.activate([
                    v.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
                    v.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0),
                    v.leadingAnchor.constraint(equalTo: onboardingViews[ind - 1].trailingAnchor),
                    v.widthAnchor.constraint(equalToConstant: screenWidth)
                ])
            }
            
        }
    }
    
    func setupButtons() {
        for view in  onboardingViews {
            let button = NMButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.bgColors = bgColors
            button.cornerRadius = 15
            button.titleLabel.textColor = activeColor
            button.titleLabel.textAlignment = .center
            button.titleLabel.font = .systemFont(ofSize: 17)
            self.scrollView.addSubview(button)
            buttonsArray.append(button)
            
            NSLayoutConstraint.activate([
                button.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -15),
                button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                button.widthAnchor.constraint(equalToConstant: 190),
                button.heightAnchor.constraint(equalToConstant: 40),
            ])
        }
        
        buttonsArray[0].titleLabel.text = "Продолжить"
        buttonsArray[1].titleLabel.text = "Продолжить"
        buttonsArray[2].titleLabel.text = "Продолжить"
        buttonsArray[3].titleLabel.text = "Начать"
        
        intervalButton = NMButton()
        intervalButton.translatesAutoresizingMaskIntoConstraints = false
        intervalButton.bgColors = bgColors
        intervalButton.cornerRadius = 15
        intervalButton.titleLabel.textColor = activeColor
        intervalButton.titleLabel.textAlignment = .center
        intervalButton.titleLabel.text = "Поменять"
        intervalButton.titleLabel.font = .systemFont(ofSize: 17)
        self.scrollView.addSubview(intervalButton)
        
        NSLayoutConstraint.activate([
            intervalButton.bottomAnchor.constraint(equalTo: buttonsArray[2].topAnchor, constant: -20),
            intervalButton.centerXAnchor.constraint(equalTo: buttonsArray[2].centerXAnchor),
            intervalButton.widthAnchor.constraint(equalToConstant: 190),
            intervalButton.heightAnchor.constraint(equalToConstant: 40),
        ])
        
        buttonsArray[0].addAction(for: .touchUpInside, action: {
            self.scrollToPage(page: 1, animated: true)
        })
        
        buttonsArray[1].addAction(for: .touchUpInside, action: {
            self.scrollToPage(page: 2, animated: true)
        })
        
        buttonsArray[2].addAction(for: .touchUpInside, action: {
            self.scrollToPage(page: 3, animated: true)
        })
        
        buttonsArray[3].addAction(for: .touchUpInside, action: {
            self.dismiss(animated: true) {
                self.defaults.setValue(true, forKey: userDidOnboardingKey)
            }
        })
        
        intervalButton.addAction(for: .touchUpInside, action: {
            let presentingController = IntervalChangerViewController()
            self.navigationController?.pushViewController(presentingController, animated: true)
        })
        
    }

    //MARK: - ScrollView methods
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        setIndiactorForCurrentPage()
    }

    func scrollToPage(page: Int, animated: Bool) {
        scrollView.setContentOffset(CGPoint(x: screenWidth * CGFloat(page), y: 0), animated: true)
    }
    
    //MARK: - PageControll methods
    func setIndiactorForCurrentPage()  {
        let page = (scrollView?.contentOffset.x)!/screenWidth
        pageControl?.currentPage = Int(page)
    }
    
    

}
