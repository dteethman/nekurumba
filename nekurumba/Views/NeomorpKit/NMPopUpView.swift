import UIKit

class NMPopUpView: UIView {
    //MARK: - Variables
    private var backgroundView: NMView!
    private var titleLabel: UILabel!
    private var messageTextView: UITextView!
    public var dismissButton: NMButton!
    
    private var titleText: String?
    private var messageText: String?
    public private(set) var messageTextViewHeight: CGFloat = 0
    
    public var cornerRadius: CGFloat = 0 {
        didSet {
            
            layoutSubviews()
        }
    }
    
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
    
    init(titleText: String, messageText: String){
        super.init(frame: .zero)
        self.titleText = titleText
        self.messageText = messageText
        setupViews()
    }
    
    //MARK: - Layout
    func setupViews() {
        let screenWidth = UIScreen.main.bounds.width
        
        backgroundView = NMView()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.bgColors = bgColors
        backgroundView.cornerRadius = cornerRadius
        self.addSubview(backgroundView)
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = titleText ?? "Oops 😮"
        titleLabel.textAlignment = . left
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        self.addSubview(titleLabel)
        
        
        let msgText = messageText ?? ""
        let msgFont = UIFont.systemFont(ofSize: 17, weight: .regular)
        messageTextViewHeight = msgText.calculateTextFieldHeight(width: screenWidth - 70, font: msgFont)
        messageTextView = UITextView()
        messageTextView.translatesAutoresizingMaskIntoConstraints = false
        messageTextView.text = msgText
        messageTextView.font = msgFont
        messageTextView.textColor = colorForMode(primaryLabelColors, isDarkMode: isDarkMode)
        messageTextView.backgroundColor = .clear
        messageTextView.textContainer.lineBreakMode = .byWordWrapping
        messageTextView.textAlignment = .left
        messageTextView.isScrollEnabled = false
        messageTextView.isEditable = false
        messageTextView.isSelectable = false
        messageTextView.textContainerInset = .zero
        messageTextView.textContainer.lineFragmentPadding = 0
        self.addSubview(messageTextView)
        
        dismissButton = NMButton()
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.bgColors = bgColors
        dismissButton.cornerRadius = 15
        dismissButton.titleLabel.textColor = activeColor
        dismissButton.titleLabel.textAlignment = .center
        dismissButton.titleLabel.font = .systemFont(ofSize: 17)
        self.addSubview(dismissButton)
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            titleLabel.heightAnchor.constraint(equalToConstant: 24),
            
            messageTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            messageTextView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            messageTextView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            messageTextView.heightAnchor.constraint(equalToConstant: messageTextViewHeight),
            
            dismissButton.topAnchor.constraint(equalTo: messageTextView.bottomAnchor, constant: 15),
            dismissButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: 0),
            dismissButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 0),
            dismissButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundView?.cornerRadius = cornerRadius
        backgroundView?.bgColors = bgColors
        dismissButton?.bgColors = bgColors
        messageTextView?.textColor = colorForMode(primaryLabelColors, isDarkMode: isDarkMode)
        
    }
    
}
