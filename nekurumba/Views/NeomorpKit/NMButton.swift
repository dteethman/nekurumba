import UIKit

enum NMButtonState {
    case touchDown
    case touchDownRepeat
    case touchDragInside
    case touchDragOutside
    case touchDragEnter
    case touchDragExit
    case touchUpInside
    case touchUpOutside
    case touchCancel
}

class NMButton: UIView {
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
    
    public var bgColors: ColorSet = ColorSet(light: UIColor.white, dark: UIColor.black) {
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
