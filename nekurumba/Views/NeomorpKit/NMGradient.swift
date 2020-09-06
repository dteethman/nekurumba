import UIKit

class NMGradient: UIView {
    //MARK: - Variables
    private var gradientLayer: CAGradientLayer!
    
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
        if isDarkMode {
            gradientLayer.colors = [bgColors.dark.getGradientColor(at: 0.08, with: bgColors.light).cgColor ,bgColors.dark.cgColor]
        } else {
            gradientLayer.colors = [bgColors.light.cgColor, bgColors.light.getGradientColor(at: 0.08, with: bgColors.dark).cgColor]
        }
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.type = .axial
        gradientLayer.frame = rect
        layer.addSublayer(gradientLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let layers = self.layer.sublayers {
            for layer in layers {
                    layer.removeFromSuperlayer()
             }
        }
        
        setupGradient(self.bounds)
    }
}
