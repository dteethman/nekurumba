import UIKit

class NMGradient: UIView {
    //MARK: - Variables
    private var gradientLayer: CAGradientLayer!
    public var instantColorChange = true
    
    public var bgColors: ColorSet = ColorSet(light: UIColor.white, dark: UIColor.black) {
        didSet {
            layoutSubviews()
        }
    }
    
    //MARK: - Layout
    override func draw(_ rect: CGRect) {
        guard layer.sublayers == nil else {
            return
        }
        
        setupGradient(rect)
    }
    
    fileprivate func setupGradient(_ rect: CGRect) {
        gradientLayer = CAGradientLayer()
        gradientLayer.colors = getGradienColors(isDarkMode: isDarkMode)
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.type = .axial
        gradientLayer.frame = rect
        layer.addSublayer(gradientLayer)
    }
    
    private func getGradienColors(isDarkMode: Bool) -> [CGColor] {
        if isDarkMode {
            return [bgColors.dark.getGradientColor(at: 0.08, with: bgColors.light).cgColor ,bgColors.dark.cgColor]
        } else {
            return [bgColors.light.cgColor, bgColors.light.getGradientColor(at: 0.08, with: bgColors.dark).cgColor]
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !instantColorChange {
            gradientLayer?.colors = getGradienColors(isDarkMode: isDarkMode)
        } else {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            gradientLayer?.colors = getGradienColors(isDarkMode: isDarkMode)
            CATransaction.commit()
        }
        
    }
}
