import UIKit
import DTBunchOfExt

class OnboardingView: UIView {
    private var titleTextView: UITextView!
    private var emojiLabel: UILabel!
    private var shortDescTextView: UITextView!
    private var fullDescTextView: UITextView!
    
    public var data: (titleText: String, emoji: String, shortDesc: String, fullDesc: String)? = nil
    
    public var bgColors: ColorSet = ColorSet(light: UIColor.white, dark: UIColor.black) {
        didSet {
            self.backgroundColor = .clear

            layoutSubviews()
        }
    }
    
    //MARK: - Initialisers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(frame: CGRect, data: (titleText: String, emoji: String, shortDesc: String, fullDesc: String)) {
        super.init(frame: frame)
        self.data = data
        setupViews()
    }
    
    //MARK: - Layout
    private func setupViews() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
        
        self.backgroundColor = .clear
        let screenWidth = UIScreen.main.bounds.width
        
        titleTextView = UITextView()
        titleTextView.translatesAutoresizingMaskIntoConstraints = false
        titleTextView.text = data?.titleText ?? "No data"
        titleTextView.font = .systemFont(ofSize: 34, weight: .bold)
        titleTextView.textColor = colorForMode(primaryLabelColors, isDarkMode: isDarkMode)
        titleTextView.backgroundColor = .clear
        titleTextView.textContainer.lineBreakMode = .byWordWrapping
        titleTextView.textAlignment = .left
        titleTextView.isScrollEnabled = false
        titleTextView.isEditable = false
        titleTextView.isSelectable = false
        titleTextView.textContainerInset = .zero
        titleTextView.textContainer.lineFragmentPadding = 0
        self.addSubview(titleTextView)
        
        var emojiHeight: CGFloat = 131
        var emojiFontSize: CGFloat = 100
        if UIScreen.main.bounds.height < 600 {
            emojiHeight = 79
            emojiFontSize = 60
        }
        emojiLabel = UILabel()
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.text = data?.emoji ?? "😮"
        emojiLabel.font = .systemFont(ofSize: emojiFontSize)
        emojiLabel.textAlignment = .center
        self.addSubview(emojiLabel)
        
        let shortDescText = data?.shortDesc ?? "No data"
        let shortDescFont = UIFont.systemFont(ofSize: 17, weight: .medium)
        let shortDescHeight = shortDescText.calculateTextFieldHeight(width: screenWidth - 40, font: shortDescFont)
 
        shortDescTextView = UITextView()
        shortDescTextView.translatesAutoresizingMaskIntoConstraints = false
        shortDescTextView.text = shortDescText
        shortDescTextView.font = shortDescFont
        shortDescTextView.textColor = colorForMode(primaryLabelColors, isDarkMode: isDarkMode)
        shortDescTextView.backgroundColor = .clear
        shortDescTextView.textContainer.lineBreakMode = .byWordWrapping
        shortDescTextView.textAlignment = .left
        shortDescTextView.isScrollEnabled = false
        shortDescTextView.isEditable = false
        shortDescTextView.isSelectable = false
        shortDescTextView.textContainerInset = .zero
        shortDescTextView.textContainer.lineFragmentPadding = 0
        self.addSubview(shortDescTextView)
        
        let fullDescText = data?.fullDesc ?? "No data"
        let fullDescFont = UIFont.systemFont(ofSize: 13, weight: .regular)
        let fullDescHeight = fullDescText.calculateTextFieldHeight(width: screenWidth - 40, font: fullDescFont)
        fullDescTextView = UITextView()
        fullDescTextView.translatesAutoresizingMaskIntoConstraints = false
        fullDescTextView.text = fullDescText
        fullDescTextView.font = fullDescFont
        fullDescTextView.textColor = colorForMode(primaryLabelColors, isDarkMode: isDarkMode)
        fullDescTextView.backgroundColor = .clear
        fullDescTextView.textContainer.lineBreakMode = .byWordWrapping
        fullDescTextView.textAlignment = .left
        fullDescTextView.isScrollEnabled = false
        fullDescTextView.isEditable = false
        fullDescTextView.isSelectable = false
        fullDescTextView.textContainerInset = .zero
        fullDescTextView.textContainer.lineFragmentPadding = 0
        self.addSubview(fullDescTextView)
        
        NSLayoutConstraint.activate([
            titleTextView.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            titleTextView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            titleTextView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            titleTextView.heightAnchor.constraint(equalToConstant: 82),
            
            emojiLabel.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant: 8),
            emojiLabel.leadingAnchor.constraint(equalTo: titleTextView.leadingAnchor),
            emojiLabel.trailingAnchor.constraint(equalTo: titleTextView.trailingAnchor),
            emojiLabel.heightAnchor.constraint(equalToConstant: emojiHeight),
            
            shortDescTextView.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 10),
            shortDescTextView.leadingAnchor.constraint(equalTo: titleTextView.leadingAnchor),
            shortDescTextView.trailingAnchor.constraint(equalTo: titleTextView.trailingAnchor),
            shortDescTextView.heightAnchor.constraint(equalToConstant: shortDescHeight),
            
            fullDescTextView.topAnchor.constraint(equalTo: shortDescTextView.bottomAnchor, constant: 5),
            fullDescTextView.leadingAnchor.constraint(equalTo: titleTextView.leadingAnchor),
            fullDescTextView.trailingAnchor.constraint(equalTo: titleTextView.trailingAnchor),
            fullDescTextView.heightAnchor.constraint(equalToConstant: fullDescHeight),

        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleTextView?.textColor = colorForMode(primaryLabelColors, isDarkMode: isDarkMode)
        shortDescTextView?.textColor = colorForMode(primaryLabelColors, isDarkMode: isDarkMode)
        fullDescTextView?.textColor = colorForMode(primaryLabelColors, isDarkMode: isDarkMode)
    }
    
}

