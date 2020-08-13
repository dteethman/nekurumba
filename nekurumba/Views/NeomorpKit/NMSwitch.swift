import UIKit

enum NMSwitchState {
    case on
    case off
}

class NMSwitch: UIView {
    typealias SwitcFhunction = () -> Void
    
    private var switchEnabled: SwitcFhunction?
    private var switchDisabled: SwitcFhunction?
    
    private var backgroundView: NMView!
    private var foregroundView: NMView!
    private var foregroundViewMask: UIView!
    private var pickerCapView: NMView!
    private var tapGRView: UIView!
    
    private var pickerLeadingConstraint: NSLayoutConstraint?
    private var pickerTrailingConstraint: NSLayoutConstraint?
    
    private var cornerRadius: CGFloat = 0 {
        didSet {
            backgroundView?.cornerRadius = cornerRadius
            foregroundView?.cornerRadius = cornerRadius - 5
            foregroundViewMask?.layer.cornerRadius = cornerRadius - 5
            pickerCapView?.cornerRadius = cornerRadius - 10
            layoutSubviews()
        }
    }
    
    private var dimmedbgColors: ColorSet = ColorSet(light: UIColor.lightGray, dark:UIColor.lightGray)
    
    public var bgColors: ColorSet = ColorSet(light: UIColor.white, dark: UIColor.black) {
        didSet {
            self.backgroundColor = .clear
            dimmedbgColors = ColorSet(light: getGradientColor(startColor: bgColors.light, endColor: .black, percent: 0.1),
                              dark: getGradientColor(startColor: bgColors.dark, endColor: .white, percent: 0.1))
            backgroundView?.bgColors = bgColors
            foregroundView?.bgColors = isActive ? accentColors : dimmedbgColors
            pickerCapView?.bgColors = bgColors
            layoutSubviews()
        }
    }
    
    public var accentColors: ColorSet = ColorSet(light: UIColor.systemGreen, dark:UIColor.systemGreen) {
        didSet {
            foregroundView?.bgColors = isActive ? accentColors : dimmedbgColors
        }
    }
    
    public var isActive: Bool = true {
        didSet {
            
            if isActive {
                pickerLeadingConstraint?.isActive = false
                pickerTrailingConstraint?.isActive = true
            } else {
                pickerTrailingConstraint?.isActive = false
                pickerLeadingConstraint?.isActive = true
            }
            
            UIView.animate(withDuration: 0.15, delay: 0, options: [.curveEaseIn, .allowUserInteraction], animations: { [self] in
                foregroundView?.bgColors = isActive ? accentColors : dimmedbgColors
                layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundView = NMView()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.cornerRadius = cornerRadius
        self.addSubview(backgroundView)
        
        foregroundView = NMView()
        foregroundView.translatesAutoresizingMaskIntoConstraints = false
        foregroundView.bgColors = isActive ? accentColors : bgColors
        foregroundView.cornerRadius = cornerRadius - 5
        foregroundView.isConvex = false
        self.addSubview(foregroundView)
        
        foregroundViewMask = UIView()
        foregroundViewMask.translatesAutoresizingMaskIntoConstraints = false
        foregroundViewMask.layer.cornerRadius = cornerRadius - 5
        foregroundViewMask.clipsToBounds = true
        foregroundViewMask.backgroundColor = .clear
        self.addSubview(foregroundViewMask)
        
        pickerCapView = NMView()
        pickerCapView.translatesAutoresizingMaskIntoConstraints = false
        pickerCapView.cornerRadius = cornerRadius - 10
        foregroundViewMask.addSubview(pickerCapView)
        
        pickerLeadingConstraint = pickerCapView.leadingAnchor.constraint(equalTo: foregroundView.leadingAnchor, constant: 5)
        pickerTrailingConstraint = pickerCapView.trailingAnchor.constraint(equalTo: foregroundView.trailingAnchor, constant: -5)
        
        tapGRView = UIView()
        tapGRView.translatesAutoresizingMaskIntoConstraints = false
        tapGRView.backgroundColor = .clear
        tapGRView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap)))
        self.addSubview(tapGRView)
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            foregroundView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 5),
            foregroundView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 5),
            foregroundView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -5),
            foregroundView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -5),
            
            foregroundViewMask.topAnchor.constraint(equalTo: foregroundView.topAnchor),
            foregroundViewMask.leadingAnchor.constraint(equalTo: foregroundView.leadingAnchor),
            foregroundViewMask.trailingAnchor.constraint(equalTo: foregroundView.trailingAnchor),
            foregroundViewMask.bottomAnchor.constraint(equalTo: foregroundView.bottomAnchor),
            
            pickerCapView.topAnchor.constraint(equalTo: foregroundView.topAnchor, constant: 5),
            pickerCapView.bottomAnchor.constraint(equalTo: foregroundView.bottomAnchor, constant: -5),
            pickerCapView.widthAnchor.constraint(equalTo: pickerCapView.heightAnchor),
            
            tapGRView.topAnchor.constraint(equalTo: self.topAnchor),
            tapGRView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tapGRView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tapGRView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
        ])
        
        if isActive {
            pickerTrailingConstraint?.isActive = true
        } else {
            pickerLeadingConstraint?.isActive = true
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if cornerRadius != min(self.bounds.width, self.bounds.height) / 2 {
            cornerRadius = min(self.bounds.width, self.bounds.height) / 2
        }
    }
    
    public func addAction(for state: NMSwitchState, action: @escaping () -> Void) {
        switch state {
        case .off:
            switchDisabled = action
        case .on:
            switchEnabled = action
        }
    }
    
    private func getGradientColor(startColor: UIColor, endColor: UIColor, percent: CGFloat) -> UIColor{
        let red = startColor.rgba.red + percent * (endColor.rgba.red - startColor.rgba.red)
        let green = startColor.rgba.green + percent * (endColor.rgba.green - startColor.rgba.green)
        let blue = startColor.rgba.blue + percent * (endColor.rgba.blue - startColor.rgba.blue)
        let alpha = startColor.rgba.alpha + percent * (endColor.rgba.alpha - startColor.rgba.alpha)
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    @objc func handleTap(_ sender: UIGestureRecognizer) {
        self.isActive = !isActive
        if isActive {
            switchEnabled?()
        } else {
            switchDisabled?()
        }
    }
}
