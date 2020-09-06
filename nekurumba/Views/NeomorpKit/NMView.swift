import UIKit
import DTBunchOfExt

class NMView: UIView {
    //MARK: - Variables
    private var topShadowLayer: CAShapeLayer!
    private var bottomShadowLayer: CAShapeLayer!
    private var backgroundViewMask: UIView!
    private var backgroundView: UIView!
    private var foregroundView: UIView!
    
    private var topShadowOffset = (convex: CGSize(width: -6, height: -6), concave: CGSize(width: 0, height: 0))
    private var bottomShadowOffset = (convex: CGSize(width: 6, height: 6), concave: CGSize(width: 0, height: 0))
    private var topShadowColor = (convex: UIColor.white.cgColor, concave: UIColor.black.cgColor)
    private var bottomShadowColor = (convex: UIColor.black.cgColor, concave: UIColor.white.cgColor)
    private var shadowRadius: CGFloat = 6
    
    public var cornerRadius: CGFloat = 0 {
        didSet {
            backgroundViewMask?.layer.cornerRadius = cornerRadius
            backgroundView?.layer.cornerRadius = cornerRadius
            foregroundView?.layer.cornerRadius = cornerRadius
            layoutSubviews()
        }
    }
    
    public var bgColors: ColorSet = ColorSet(light: UIColor.white, dark: UIColor.black) {
        didSet {
            self.backgroundColor = .clear
            layoutSubviews()
        }
    }
    
    public var isConvex: Bool = true {
        didSet {
            isConvex ? layoutForConvex() : layoutForConcave()
            
            if isConvex && foregroundView != nil {
                UIView.animate(withDuration: 0.25, delay: 0.0, options: [.curveEaseIn, .allowUserInteraction], animations: {
                    self.foregroundView?.alpha = 1
                    self.setNeedsLayout()
                    self.layoutIfNeeded()
                })
            } else if foregroundView != nil {
                UIView.animate(withDuration: 0.25, delay: 0.0, options: [.curveEaseIn, .allowUserInteraction], animations: {
                    self.foregroundView?.alpha = 0
                    self.setNeedsLayout()
                    self.layoutIfNeeded()
                })
            }
        }
    }
    
    //MARK: - Draw
    override func draw(_ rect: CGRect) {
        guard layer.sublayers == nil else {
            return
        }
        
        backgroundViewMask = UIView()
        backgroundViewMask.frame = rect
        backgroundViewMask.layer.cornerRadius = cornerRadius
        backgroundViewMask.backgroundColor = .clear
        self.addSubview(backgroundViewMask)
        
        backgroundView = UIView()
        backgroundView.frame = rect
        backgroundView.layer.cornerRadius = cornerRadius
        backgroundViewMask.addSubview(backgroundView)
        
        topShadowLayer = CAShapeLayer()
        bottomShadowLayer = CAShapeLayer()
        addShadowPaths(rect: rect)
        backgroundView.layer.addSublayer(topShadowLayer)
        backgroundView.layer.addSublayer(bottomShadowLayer)
        
        foregroundView = UIView()
        foregroundView.frame = rect
        foregroundView.layer.cornerRadius = cornerRadius
        foregroundView.layer.masksToBounds = true
        
        self.addSubview(foregroundView)
        
        isConvex ? layoutForConvex() : layoutForConcave()
        foregroundView.alpha = isConvex ? 1 : 0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        isConvex ? layoutForConvex() : layoutForConcave()
    }
    
    //MARK: - Layout
    private func addShadowPaths(rect: CGRect) {
        let cornerCenters = (topLeft: CGPoint(x: cornerRadius, y: cornerRadius),
                             topRight: CGPoint(x: rect.width - cornerRadius, y: cornerRadius),
                             bottomLeft: CGPoint(x: cornerRadius, y: rect.height - cornerRadius),
                             bottomRight: CGPoint(x: rect.width - cornerRadius, y: rect.height - cornerRadius))
        
        let angles = (d0: CGFloat.zero,
                      d45: CGFloat.pi / 4,
                      d90: CGFloat.pi / 2,
                      d135: CGFloat.pi * 3/4,
                      d180: CGFloat.pi,
                      d225: CGFloat.pi * 5/4,
                      d270: CGFloat.pi * 3/2,
                      d315: CGFloat.pi * 7/4,
                      d360: CGFloat.pi * 2)
        
        let topShadowLayerPath = UIBezierPath()
        topShadowLayerPath.addArc(withCenter: cornerCenters.bottomLeft,
                                  radius: cornerRadius,
                                  startAngle: angles.d135,
                                  endAngle: angles.d180,
                                  clockwise: true)
        topShadowLayerPath.addLine(to: CGPoint(x: 0, y: cornerRadius))
        topShadowLayerPath.addArc(withCenter: cornerCenters.topLeft,
                                  radius: cornerRadius,
                                  startAngle: -angles.d180,
                                  endAngle: -angles.d90,
                                  clockwise: true)
        topShadowLayerPath.addLine(to: CGPoint(x: rect.width - cornerRadius, y: 0))
        topShadowLayerPath.addArc(withCenter: cornerCenters.topRight,
                                  radius: cornerRadius,
                                  startAngle: -angles.d90,
                                  endAngle: -angles.d45,
                                  clockwise: true)
        topShadowLayerPath.addLine(to: CGPoint(center: cornerCenters.topRight,
                                               radius: cornerRadius - 6,
                                               angle: -angles.d45))
        topShadowLayerPath.addArc(withCenter: cornerCenters.topRight,
                                  radius: cornerRadius - 6,
                                  startAngle: -angles.d45,
                                  endAngle: -angles.d90,
                                  clockwise: false)
        topShadowLayerPath.addLine(to: CGPoint(center: cornerCenters.topLeft,
                                               radius: cornerRadius - 6,
                                               angle: -angles.d90))
        topShadowLayerPath.addArc(withCenter: cornerCenters.topLeft,
                                  radius: cornerRadius - 6,
                                  startAngle: -angles.d90,
                                  endAngle: -angles.d180,
                                  clockwise: false)
        topShadowLayerPath.addLine(to: CGPoint(center: cornerCenters.bottomLeft,
                                               radius: cornerRadius - 6,
                                               angle: -angles.d180))
        topShadowLayerPath.addArc(withCenter: cornerCenters.bottomLeft,
                                  radius: cornerRadius - 6,
                                  startAngle: angles.d180,
                                  endAngle: angles.d135,
                                  clockwise: false)
        topShadowLayerPath.addLine(to: CGPoint(center: cornerCenters.bottomLeft,
                                               radius: cornerRadius,
                                               angle: angles.d135))
        
        
        topShadowLayer?.path = topShadowLayerPath.cgPath
        topShadowLayer?.shadowPath = topShadowLayerPath.cgPath
        
        let bottomShadowLayerPath = UIBezierPath()
        bottomShadowLayerPath.addArc(withCenter: cornerCenters.topRight,
                                     radius: cornerRadius,
                                     startAngle: -angles.d45,
                                     endAngle: angles.d0,
                                     clockwise: true)
        bottomShadowLayerPath.addLine(to: CGPoint(x: rect.width, y: rect.height - cornerRadius))
        bottomShadowLayerPath.addArc(withCenter: cornerCenters.bottomRight,
                                     radius: cornerRadius,
                                     startAngle: 0,
                                     endAngle: angles.d90,
                                     clockwise: true)
        bottomShadowLayerPath.addLine(to: CGPoint(x: cornerRadius, y: rect.height))
        bottomShadowLayerPath.addArc(withCenter: cornerCenters.bottomLeft,
                                     radius: cornerRadius,
                                     startAngle: angles.d90,
                                     endAngle: angles.d135,
                                     clockwise: true)
        bottomShadowLayerPath.addLine(to: CGPoint(center: cornerCenters.bottomLeft,
                                                  radius: cornerRadius - 6,
                                                  angle: angles.d135))
        bottomShadowLayerPath.addArc(withCenter: cornerCenters.bottomLeft,
                                     radius: cornerRadius - 6,
                                     startAngle: angles.d135,
                                     endAngle: angles.d90,
                                     clockwise: false)
        bottomShadowLayerPath.addLine(to: CGPoint(center: cornerCenters.bottomRight,
                                                  radius: cornerRadius - 6,
                                                  angle: angles.d90))
        bottomShadowLayerPath.addArc(withCenter: cornerCenters.bottomRight,
                                     radius: cornerRadius - 6,
                                     startAngle: angles.d90,
                                     endAngle: angles.d0,
                                     clockwise: false)
        bottomShadowLayerPath.addLine(to: CGPoint(center: cornerCenters.topRight,
                                                  radius: cornerRadius - 6,
                                                  angle: angles.d0))
        bottomShadowLayerPath.addArc(withCenter: cornerCenters.topRight,
                                     radius: cornerRadius - 6,
                                     startAngle: angles.d0,
                                     endAngle: -angles.d45,
                                     clockwise: false)
        bottomShadowLayerPath.addLine(to: CGPoint(center: cornerCenters.topRight,
                                                  radius: cornerRadius,
                                                  angle: -angles.d45))
        
        bottomShadowLayer?.path = bottomShadowLayerPath.cgPath
        bottomShadowLayer?.shadowPath = bottomShadowLayerPath.cgPath
    }
    
    private func layoutForConvex() {
        backgroundViewMask?.layer.masksToBounds = false
        
        self.backgroundColor = .clear
        
        topShadowLayer?.fillColor = UIColor.clear.cgColor
        topShadowLayer?.shadowColor = topShadowColor.convex
        topShadowLayer?.shadowOffset = topShadowOffset.convex
        topShadowLayer?.shadowRadius = shadowRadius
        topShadowLayer?.shadowOpacity = isDarkMode ? 0.1 : 0.8
        
        bottomShadowLayer?.fillColor = UIColor.clear.cgColor
        bottomShadowLayer?.shadowColor = bottomShadowColor.convex
        bottomShadowLayer?.shadowOffset = bottomShadowOffset.convex
        bottomShadowLayer?.shadowRadius = shadowRadius
        bottomShadowLayer?.shadowOpacity = isDarkMode ? 0.5 : 0.2
        
        backgroundView?.backgroundColor = colorForMode(bgColors, isDarkMode: isDarkMode)
        foregroundView?.backgroundColor = colorForMode(bgColors, isDarkMode: isDarkMode)
    }
    
    private func layoutForConcave() {
        backgroundViewMask?.layer.masksToBounds = true
        
        self.backgroundColor = .clear
        
        topShadowLayer?.fillColor = UIColor.clear.cgColor
        topShadowLayer?.shadowColor = topShadowColor.concave
        topShadowLayer?.shadowOffset = topShadowOffset.concave
        topShadowLayer?.shadowRadius = shadowRadius
        topShadowLayer?.shadowOpacity = isDarkMode ? 0.5 : 0.2
        
        bottomShadowLayer?.fillColor = UIColor.clear.cgColor
        bottomShadowLayer?.shadowColor = bottomShadowColor.concave
        bottomShadowLayer?.shadowOffset = bottomShadowOffset.concave
        bottomShadowLayer?.shadowRadius = shadowRadius
        bottomShadowLayer?.shadowOpacity = isDarkMode ? 0.1 : 0.8
        
        backgroundView?.backgroundColor = colorForMode(bgColors, isDarkMode: isDarkMode)
        foregroundView?.backgroundColor = colorForMode(bgColors, isDarkMode: isDarkMode)
    }
    
}
