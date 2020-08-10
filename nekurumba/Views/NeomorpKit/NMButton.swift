import UIKit

class NMButton: UIView {
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
    
    private var backgroundView: NMView!
    private var button: UIButton!
    public var titleLabel: UILabel!
    
    public var isEnabled: Bool = true {
        didSet {
            button?.isEnabled = isEnabled
        }
    }
    
    public var cornerRadius: CGFloat = 0 {
        didSet {
            backgroundView?.cornerRadius = cornerRadius
            
        }
    }
    
    public var bgColors: (light: UIColor, dark: UIColor) = (UIColor.white, UIColor.black) {
        didSet {
            self.backgroundColor = .clear
            backgroundView?.bgColors = bgColors
            layoutSubviews()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        backgroundView = NMView()
        backgroundView.cornerRadius = cornerRadius
        backgroundView?.bgColors = bgColors
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(backgroundView)
        
        button = UIButton()
        button.isEnabled = isEnabled
        button.backgroundColor = .clear
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
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            
            button.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            button.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            button.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            button.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
        ])
        
        layoutSubviews()
    }
    
    
    @objc private func touchDownAction(_ sender: UIButton!) {
        if isEnabled {
            buttonTouchDown?()
            backgroundView.isConvex = false
        }
    }
    
    @objc private func touchDownRepeatAction(_ sender: UIButton!) {
        if isEnabled {
            buttonTouchDownRepeat?()
        }
    }
    
    @objc private func touchDragInsideAction(_ sender: UIButton!) {
        if isEnabled {
            buttonTouchDragInside?()
            backgroundView.isConvex = false
        }
    }
    
    @objc private func touchDragOutsideAction(_ sender: UIButton!) {
        if isEnabled {
            buttonTouchDragOutside?()
            backgroundView.isConvex = true
        }
    }
    
    @objc private func touchDragEnterAction(_ sender: UIButton!) {
        if isEnabled {
            buttonTouchDragEnter?()
            backgroundView.isConvex = false
        }
    }
    
    @objc private func touchDragExitAction(_ sender: UIButton!) {
        if isEnabled {
            buttonTouchDragExit?()
            backgroundView.isConvex = true
        }
    }
    
    @objc private func touchUpInsideAction(_ sender: UIButton!) {
        if isEnabled {
            buttonTouchUpInside?()
            backgroundView.isConvex = true
        }
    }
    
    @objc private func touchUpOutsideAction(_ sender: UIButton!) {
        if isEnabled {
            buttonTouchUpOutside?()
            backgroundView.isConvex = true
        }
    }
    
    @objc private func touchCancelAction(_ sender: UIButton!) {
        if isEnabled {
            buttonTouchCancel?()
            backgroundView.isConvex = true
        }
    }
}
