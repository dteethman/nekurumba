import UIKit

class NMProgressViewWithButton: UIView {
    typealias ButtonFunction = () -> Void
    
    public var buttonTouchDown: ButtonFunction?
    public var buttonTouchDownRepeat: ButtonFunction?
    public var buttonTouchDragInside: ButtonFunction?
    public var buttonTouchDragOutside: ButtonFunction?
    public var buttonTouchDragEnter: ButtonFunction?
    public var buttonTouchDragExit: ButtonFunction?
    public var buttonTouchUpInside: ButtonFunction?
    public var buttonTouchUpOutside: ButtonFunction?
    public var buttonTouchCancel: ButtonFunction?
    
    public var progressBar: ProgressBarView!
    private var circleBackgroundView: NMViev!
    private var timerBackgroundView: NMViev!
    private var buttonBackgroundView: NMViev!
    private var button: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    public var cornerRadius: CGFloat = 0 {
        didSet {
            circleBackgroundView?.cornerRadius = cornerRadius
            timerBackgroundView?.cornerRadius = cornerRadius - 10
            buttonBackgroundView?.cornerRadius = cornerRadius - 40
            button?.layer.cornerRadius = cornerRadius - 40
        }
    }
    
    private func setupView() {
        circleBackgroundView = NMViev()
        circleBackgroundView.isConvex = true
        circleBackgroundView.bgColors = bgColors
        circleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(circleBackgroundView)
        
        timerBackgroundView = NMViev()
        timerBackgroundView.isConvex = false
        timerBackgroundView.bgColors = bgColors
        timerBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(timerBackgroundView)
        
        buttonBackgroundView = NMViev()
        buttonBackgroundView.isConvex = true
        buttonBackgroundView.bgColors = bgColors
        buttonBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonBackgroundView)
        
        progressBar = ProgressBarView()
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
        self.addSubview(button)
        
        NSLayoutConstraint.activate([
            circleBackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            circleBackgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            circleBackgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            circleBackgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            timerBackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            timerBackgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            timerBackgroundView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            timerBackgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            
            buttonBackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            buttonBackgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            buttonBackgroundView.topAnchor.constraint(equalTo: self.topAnchor, constant: 40),
            buttonBackgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -40),
            
            progressBar.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            progressBar.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            progressBar.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            progressBar.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            
            button.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            button.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            button.topAnchor.constraint(equalTo: self.topAnchor, constant: 40),
            button.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -40),
        ])
    }
    
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
        button?.setTitleColor(isDarkMode() ? .white : .black, for: .normal)
    }
    
}
