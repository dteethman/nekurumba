import UIKit

class NightModeChangerViewController: UIViewController {
    private var sliderView: NMMultiLevelCircularSlider!
    private var sliderLabel: UILabel!
    private var backButton: NMButton!

    private var hours: Int!
    private var hoursSliderValue: CGFloat = 0

    private var sliderItems: [SliderItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        loadTimeFromDefaults()

        sliderItems = [
            SliderItem(sliderValue: Box(hoursSliderValue), minValue: 0, maxValue: 5, minSliderValue: 0, maxSliderValue: 1, numberOfDivisions: 5),
        ]

        sliderItems[0].sliderValue.bind { [unowned self] (value) in
            if sliderView != nil {
                hours = Int(round(value * sliderView!.sliderItems[0].maxValue))
                sliderLabel.text = "\(hours!)"
                saveToDefaults(hours!, forKey: nightModeHoursKey)
            }
        }

        setupViews()
        sliderView.switchSliderForItem(0)
        sliderView.layoutSubviews()
    }

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
        sliderView.numberOfDivisions = sliderItems[0].numberOfDivisions
        sliderView.cornerRadius = (UIScreen.main.bounds.width - 40 ) / 2
        sliderView.sliderItems = sliderItems
        sliderView.progressBar.startGradienttColor = .systemPink
        sliderView.progressBar.endGradientColor = .systemPink
        view.addSubview(sliderView)

        sliderLabel = UILabel()
        sliderLabel.translatesAutoresizingMaskIntoConstraints = false
        sliderLabel.textColor = colorForMode(primaryLabelColors, isDarkMode: isDarkMode)
        sliderLabel.text = "\(hours!)"
        sliderLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 54, weight: .bold)
        sliderLabel.textAlignment = .center
        self.view.addSubview(sliderLabel)

        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: safeGuide.topAnchor, constant: 14),
            backButton.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            backButton.heightAnchor.constraint(equalToConstant: 40),

            sliderView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 20),
            sliderView.leadingAnchor.constraint(equalTo: safeGuide.leadingAnchor, constant: 20),
            sliderView.trailingAnchor.constraint(equalTo: safeGuide.trailingAnchor, constant: -20),
            sliderView.heightAnchor.constraint(equalTo: sliderView.widthAnchor),

            sliderLabel.topAnchor.constraint(equalTo: sliderView.topAnchor, constant: 50),
            sliderLabel.leadingAnchor.constraint(equalTo: sliderView.leadingAnchor, constant: 50),
            sliderLabel.trailingAnchor.constraint(equalTo: sliderView.trailingAnchor, constant: -50),
            sliderLabel.bottomAnchor.constraint(equalTo: sliderView.bottomAnchor, constant: -50),

        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    private func loadTimeFromDefaults() {
        let defaults = UserDefaults.standard

        hours = defaults.integer(forKey: nightModeHoursKey)

        hoursSliderValue = CGFloat(hours) / 5
    }

    private func saveToDefaults(_ value: Any, forKey: String) {
        let defaults = UserDefaults.standard
        defaults.setValue(value, forKey: forKey)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super .traitCollectionDidChange(previousTraitCollection)
        view.backgroundColor = colorForMode(bgColors, isDarkMode: isDarkMode)
        sliderLabel?.textColor = colorForMode(primaryLabelColors, isDarkMode: isDarkMode)
    }


}




