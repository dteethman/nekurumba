import UIKit

class OnboardingView: UIView {
    private var titleTextView: UITextView!
    private var emojiLabel: UILabel!
    private var shortDescTextView: UITextView!
    private var fullDescTextView: UITextView!
    
    public var data: (titleText: String, emoji: String, shortDesc: String, fullDesc: String)? = nil
    
    public var bgColors: (light: UIColor, dark: UIColor) = (UIColor.white, UIColor.black) {
        didSet {
            self.backgroundColor = .clear

            layoutSubviews()
        }
    }
    
    init(frame: CGRect, data: (titleText: String, emoji: String, shortDesc: String, fullDesc: String)) {
        super.init(frame: frame)
        self.data = data
        setupViews()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
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
        titleTextView.textColor = isDarkMode() ? .white : .black
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
        let shortDescHeight = calculateTextFieldHeight(width: screenWidth - 40,
                                                       string: NSAttributedString(string: shortDescText,
                                                                                  attributes: [NSAttributedString.Key.font : shortDescFont]))
        shortDescTextView = UITextView()
        shortDescTextView.translatesAutoresizingMaskIntoConstraints = false
        shortDescTextView.text = shortDescText
        shortDescTextView.font = shortDescFont
        shortDescTextView.textColor = isDarkMode() ? .white : .black
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
        let fullDescHeight = calculateTextFieldHeight(width: screenWidth - 40,
                                                       string: NSAttributedString(string: fullDescText,
                                                                                  attributes: [NSAttributedString.Key.font : fullDescFont]))
        fullDescTextView = UITextView()
        fullDescTextView.translatesAutoresizingMaskIntoConstraints = false
        fullDescTextView.text = fullDescText
        fullDescTextView.font = fullDescFont
        fullDescTextView.textColor = isDarkMode() ? .white : .black
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
        titleTextView?.textColor = isDarkMode() ? .white : .black
        shortDescTextView?.textColor = isDarkMode() ? .white : .black
        fullDescTextView?.textColor = isDarkMode() ? .white : .black
    }
    
    
    func calculateTextFieldHeight(width: CGFloat, string: NSAttributedString) -> CGFloat {
        let maxSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let stringSize = string.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).size

        let range = CFRangeMake(0, string.length)
        let framesetter = CTFramesetterCreateWithAttributedString(string)
        let framesetterSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, range, nil, maxSize, nil)
        
        return max(stringSize.height.rounded(.up), framesetterSize.height.rounded(.up))
    }
}

