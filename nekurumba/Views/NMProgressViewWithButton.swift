import UIKit

class NMProgressViewWithButton: UIView {
    //MARK: - Variables
    typealias ButtonFunction = () -> Void
    
    private var buttonTouchDown: ButtonFunction?
    private var buttonTouchDownRepeat: ButtonFunction?
    private var buttonTouchDragInside: ButtonFunction?
    private var buttonTouchDragOutside: ButtonFunction?
    private var buttonTouchDragEnter: ButtonFunction?
    private var buttonTouchDragExit: ButtonFunction?
    private var buttonTouchUpInside: ButtonFunction?
    private var buttonTouchUpOutside: ButtonFunction?
    private var buttonTouchCancel: ButtonFunction?
    
    public var progressBar: ProgressBarView!
    private var circleBackgroundView: NMView!
    private var timerBackgroundView: NMView!
    private var buttonBackgroundView: NMView!
    private var button: UIButton!
    
    public var lineWidth: CGFloat = 30 {
        didSet {
            buttonBackgroundView?.cornerRadius = cornerRadius - progressBarOffset - lineWidth
            button?.layer.cornerRadius = cornerRadius - progressBarOffset - lineWidth
            progressBar?.lineWidth = lineWidth
            
            updateLayout()
            
            self.layoutSubviews()
        }
    }
    
    public var progressBarOffset: CGFloat = 10 {
        didSet {
            timerBackgroundView?.cornerRadius = cornerRadius - progressBarOffset
            buttonBackgroundView?.cornerRadius = cornerRadius - progressBarOffset - lineWidth
            button?.layer.cornerRadius = cornerRadius - progressBarOffset - lineWidth

            updateLayout()
            
            self.layoutSubviews()
        }
    }
    
    public var bgColors: ColorSet = ColorSet(light: UIColor.white, dark: UIColor.black) {
        didSet {
            self.backgroundColor = .clear
            circleBackgroundView?.bgColors = bgColors
            timerBackgroundView?.bgColors = bgColors
            buttonBackgroundView?.bgColors = bgColors
            layoutSubviews()
        }
    }
    
    public var cornerRadius: CGFloat = 0 {
        didSet {
            circleBackgroundView?.cornerRadius = cornerRadius
            timerBackgroundView?.cornerRadius = cornerRadius - progressBarOffset
            buttonBackgroundView?.cornerRadius = cornerRadius - progressBarOffset - lineWidth
            button?.layer.cornerRadius = cornerRadius - progressBarOffset - lineWidth
        }
    }
    
    //MARK: - Initialisers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - Layout
    private func setupView() {
        circleBackgroundView = NMView()
        circleBackgroundView.isConvex = true
        circleBackgroundView.bgColors = bgColors
        circleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(circleBackgroundView)
        
        timerBackgroundView = NMView()
        timerBackgroundView.isConvex = false
        timerBackgroundView.bgColors = bgColors
        timerBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(timerBackgroundView)
        
        buttonBackgroundView = NMView()
        buttonBackgroundView.isConvex = true
        buttonBackgroundView.bgColors = bgColors
        buttonBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonBackgroundView)
        
        progressBar = ProgressBarView()
        progressBar.lineWidth = lineWidth
        progressBar.backgroundColor = .clear
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(progressBar)
        
        button = UIButton()
        button.addTarget(self, action: #selector(touchDownAction(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(touchDownRepeatAction(_:)), for: .touchDownRepeat)
        button.addTarget(self, action: #selector(touchDragInsideAction(_:)), for: .touchDragInside)
        button.addTarget(self, action: #selector(touchDragOutsideAction(_:)), for: .touchDragOutside)
        button.addTarget(self, action: #selector(touchDragEnterAction(_:)), for: .touchDragEnter)
        button.addTarget(self, action: #selector(touchDragExitAction(_:)), for: .touchDragExit)
        button.addTarget(self, action: #selector(touchUpInsideAction(_:)), for: .touchUpInside)
        button.addTarget(self, action: #selector(touchUpOutsideAction(_:)), for: .touchUpOutside)
        button.addTarget(self, action: #selector(touchCancelAction(_:)), for: .touchCancel)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.setTitleColor(colorForMode(primaryLabelColors, isDarkMode: isDarkMode), for: .normal)
        self.addSubview(button)
        
        NSLayoutConstraint.activate([
            circleBackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            circleBackgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            circleBackgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            circleBackgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            timerBackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: progressBarOffset),
            timerBackgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -progressBarOffset),
            timerBackgroundView.topAnchor.constraint(equalTo: self.topAnchor, constant: progressBarOffset),
            timerBackgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -progressBarOffset),
            
            buttonBackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: progressBarOffset + lineWidth),
            buttonBackgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -(progressBarOffset + lineWidth)),
            buttonBackgroundView.topAnchor.constraint(equalTo: self.topAnchor, constant: progressBarOffset + lineWidth),
            buttonBackgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -(progressBarOffset + lineWidth)),
            
            progressBar.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: progressBarOffset),
            progressBar.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -progressBarOffset),
            progressBar.topAnchor.constraint(equalTo: self.topAnchor, constant: progressBarOffset),
            progressBar.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -progressBarOffset),
            
            button.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: progressBarOffset + lineWidth),
            button.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -(progressBarOffset + lineWidth)),
            button.topAnchor.constraint(equalTo: self.topAnchor, constant: progressBarOffset + lineWidth),
            button.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -(progressBarOffset + lineWidth)),
        ])
    }
    
    private func updateLayout() {
        if timerBackgroundView != nil {
            timerBackgroundView.removeFromSuperview()
            timerBackgroundView.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(timerBackgroundView)
            NSLayoutConstraint.activate([
                timerBackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: progressBarOffset),
                timerBackgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -progressBarOffset),
                timerBackgroundView.topAnchor.constraint(equalTo: self.topAnchor, constant: progressBarOffset),
                timerBackgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -progressBarOffset),
            ])
        }
        
        if buttonBackgroundView != nil {
            buttonBackgroundView.removeFromSuperview()
            buttonBackgroundView.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(buttonBackgroundView)
            NSLayoutConstraint.activate([
                buttonBackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: progressBarOffset + lineWidth),
                buttonBackgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -(progressBarOffset + lineWidth)),
                buttonBackgroundView.topAnchor.constraint(equalTo: self.topAnchor, constant: progressBarOffset + lineWidth),
                buttonBackgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -(progressBarOffset + lineWidth)),
            ])
        }

        if progressBar != nil {
            progressBar.removeFromSuperview()
            progressBar.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(progressBar)
            NSLayoutConstraint.activate([
                progressBar.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: progressBarOffset),
                progressBar.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -progressBarOffset),
                progressBar.topAnchor.constraint(equalTo: self.topAnchor, constant: progressBarOffset),
                progressBar.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -progressBarOffset),
            ])
        }

        if button != nil {
            button.removeFromSuperview()
            button.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(button)
            NSLayoutConstraint.activate([
                button.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: progressBarOffset + lineWidth),
                button.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -(progressBarOffset + lineWidth)),
                button.topAnchor.constraint(equalTo: self.topAnchor, constant: progressBarOffset + lineWidth),
                button.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -(progressBarOffset + lineWidth)),
            ])
        }
    }
    
    //MARK: - Button Action binding
    public func addAction(for state: NMButtonState, action: @escaping () -> Void) {
        switch state {
        case .touchDown:
            buttonTouchDown = action
        case .touchDownRepeat:
            buttonTouchDownRepeat = action
        case .touchDragInside:
            buttonTouchDragInside = action
        case .touchDragOutside:
            buttonTouchDragOutside = action
        case .touchDragEnter:
            buttonTouchDragEnter = action
        case .touchDragExit:
            buttonTouchDragExit = action
        case .touchUpInside:
            buttonTouchUpInside = action
        case .touchUpOutside:
            buttonTouchUpOutside = action
        case .touchCancel:
            buttonTouchCancel = action
        }
    }
    
    //MARK: - Button public methods
    public func changeButtonTitle(_ text: String, font: UIFont? = nil) {
        button?.setTitle(text, for: .normal)
        if let f = font {
            button?.titleLabel?.font = f
        }
    }
    
    public func activateButton() {
        if !(button.isEnabled) {
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: { [self] in
                button.backgroundColor = .clear
            }, completion: nil)
            button.isEnabled = true
        }
        
    }
    
    public func deactivateButton() {
        if button.isEnabled {
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut], animations: { [self] in
                button.backgroundColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 0.2)
            }, completion: nil)
            button.isEnabled = false
        }
    }
    
    //MARK: - Button Actions
    @objc private func touchDownAction(_ sender: UIButton!) {
        buttonTouchDown?()
        buttonBackgroundView.isConvex = false
    }
    
    @objc private func touchDownRepeatAction(_ sender: UIButton!) {
        buttonTouchDownRepeat?()
    }
    
    @objc private func touchDragInsideAction(_ sender: UIButton!) {
        buttonTouchDragInside?()
        buttonBackgroundView.isConvex = false
    }
    
    @objc private func touchDragOutsideAction(_ sender: UIButton!) {
        buttonTouchDragOutside?()
        buttonBackgroundView.isConvex = true
    }
    
    @objc private func touchDragEnterAction(_ sender: UIButton!) {
        buttonTouchDragEnter?()
        buttonBackgroundView.isConvex = false
    }
    
    @objc private func touchDragExitAction(_ sender: UIButton!) {
        buttonTouchDragExit?()
        buttonBackgroundView.isConvex = true
    }
    
    @objc private func touchUpInsideAction(_ sender: UIButton!) {
        buttonTouchUpInside?()
        buttonBackgroundView.isConvex = true
    }
    
    @objc private func touchUpOutsideAction(_ sender: UIButton!) {
        buttonTouchUpOutside?()
        buttonBackgroundView.isConvex = true
    }
    
    @objc private func touchCancelAction(_ sender: UIButton!) {
        buttonTouchCancel?()
        buttonBackgroundView.isConvex = true
    }
    
    override func layoutSubviews() {
        button?.setTitleColor(colorForMode(primaryLabelColors, isDarkMode: isDarkMode), for: .normal)
    }
    
}
