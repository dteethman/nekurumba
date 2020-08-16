import UIKit
import AEConicalGradient

class ProgressBarView: UIView {
    
    private var backgroundLayer: CAShapeLayer!
    private var foregroundLayer: CAShapeLayer!
    private var textLayer: CATextLayer!
    private var gradientLayer: CAGradientLayer!
    private var conGradientLayer: ConicalGradientLayer!
    private var startCapLayer: CAShapeLayer!
    private var endCapLayer: CAShapeLayer!
    private var endCapShadowLayer: CAGradientLayer!
    private var endCapPickerLayer: CAShapeLayer!
    
    public var startGradienttColor: UIColor = .red
    public var endGradientColor: UIColor = .orange
    public var backgroundLayerColor: UIColor = .lightGray
    public var endCapPickerColor: UIColor? = nil {
        didSet {
            if let color = endCapPickerColor {
                endCapLayer?.strokeColor = color.cgColor
            }
        }
    }
    
    public var coloredBackgroundLayer = false
    public var transparentBackgroundLayer = false
    public var disableText = false
    
    public var lineWidth: CGFloat = 0 {
        didSet {
            if backgroundLayer != nil {
                self.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
                setupViews(self.layer.bounds)
            }
        }
    }
    
    public var animationDuration: CFTimeInterval = 0.30
    
    public var progress: CGFloat = 0 {
        didSet {
            didProgressUpdated()
        }
    }
    private var prevProgress: CGFloat = 0
    
    override func draw(_ rect: CGRect) {
        guard layer.sublayers == nil else {
          return
        }
        
        setupViews(rect)
    }
    
    private func setupViews(_ rect: CGRect) {
        self.backgroundColor = .clear
        self.layer.backgroundColor = UIColor.clear.cgColor
        
        let width = rect.width
        let height = rect.height
        
        if lineWidth <= 0 { lineWidth = 0.1 * min(width, height) }
        
        backgroundLayer = createCircularLayer(rect: rect, strokeColor: backgroundLayerColor.cgColor,
                                              fillColor: UIColor.clear.cgColor, lineWidth: lineWidth)
        
        foregroundLayer = createCircularLayer(rect: rect, strokeColor: UIColor.red.cgColor,
                                              fillColor: UIColor.clear.cgColor, lineWidth: lineWidth)
        
        textLayer = createTextLayer(rect: rect, textColor: UIColor.black.cgColor)
        
        textLayer?.foregroundColor = colorForMode(primaryLabelColors, isDarkMode: isDarkMode).cgColor
        
        gradientLayer = CAGradientLayer()
        conGradientLayer = ConicalGradientLayer()
        if #available(iOS 12.0, *) {
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
            gradientLayer.colors = [startGradienttColor.cgColor, endGradientColor.cgColor]
            gradientLayer.type = .conic
            gradientLayer.frame = rect
            gradientLayer.mask = foregroundLayer
        } else {
            conGradientLayer.startAngle = -Double.pi / 2
            conGradientLayer.endAngle = Double.pi * (3 / 2)
            conGradientLayer.colors = [startGradienttColor, endGradientColor]
            conGradientLayer.frame = rect
            conGradientLayer.mask = foregroundLayer
        }
        
        
        startCapLayer = createLineCapLayer(rect: rect, lineWidth: lineWidth,
                                           strokeColor: UIColor.clear.cgColor, fillColor: startGradienttColor.cgColor)
        
        endCapLayer = createLineCapLayer(rect: rect, lineWidth: lineWidth,
                                         strokeColor: UIColor.clear.cgColor, fillColor: endGradientColor.cgColor)
        
        endCapShadowLayer = createLineCapShadowLayer(rect: rect, lineWidth: lineWidth)
        
        endCapPickerLayer = createLineCapPickerLayer(rect: rect, lineWidth: lineWidth,
                                                     strokeColor: UIColor.clear.cgColor, fillColor: UIColor.clear.cgColor)
        
        foregroundLayer.strokeEnd = progress
        
        layer.addSublayer(backgroundLayer)
        if #available(iOS 12.0, *) {
            layer.addSublayer(gradientLayer)
        } else {
            layer.addSublayer(conGradientLayer)
        }
        if !disableText {
            layer.addSublayer(textLayer)
        }
        layer.addSublayer(startCapLayer)
        layer.addSublayer(endCapShadowLayer)
        layer.addSublayer(endCapLayer)
        layer.addSublayer(endCapPickerLayer)
        
        endCapLayer.fillColor = getGradientColor(startColor: startGradienttColor, endColor: endGradientColor, percent: progress).cgColor
        
        if let color = endCapPickerColor {
            endCapPickerLayer.strokeColor = color.cgColor
        }
        
        endCapLayer.frame.origin = getEndCapPoint(rect: rect, lineWidth: lineWidth, progress: progress)
        endCapShadowLayer.frame.origin = getEndCapPoint(rect: rect, lineWidth: lineWidth, progress: progress + 0.007)
        endCapPickerLayer.frame.origin = getEndCapPoint(rect: rect, lineWidth: lineWidth, progress: progress)
    }
    
    private func createCircularLayer(rect: CGRect, strokeColor: CGColor, fillColor: CGColor,
                                     lineWidth: CGFloat) -> CAShapeLayer {
        let width = rect.width
        let height = rect.height
        
        let center = CGPoint(x: width / 2, y: height / 2)
        let radius = (min(width, height) - lineWidth) / 2
        
        let startAndle = -CGFloat.pi / 2
        let endAngle = startAndle + (CGFloat.pi * 2)
        
        let circularPath = UIBezierPath(arcCenter: center, radius: radius,
                                        startAngle: startAndle, endAngle: endAngle,
                                        clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circularPath.cgPath
        
        shapeLayer.strokeColor = strokeColor
        shapeLayer.fillColor = fillColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineCap = .round
        
        return shapeLayer
    }
    
    private func createTextLayer(rect: CGRect, textColor: CGColor) -> CATextLayer {
        let width = rect.width
        let height = rect.height
        
        let fontSize = min(width, height) / 4
        let offset = min(width, height) * 0.1
        
        let layer = CATextLayer()
        layer.string = "\(Int(progress * 100))"
        layer.backgroundColor = UIColor.clear.cgColor
        layer.foregroundColor = textColor
        layer.fontSize = fontSize
        layer.frame = CGRect(x: 0, y: (height - fontSize - offset) / 2, width: width, height: fontSize + offset)
        layer.alignmentMode = .center
        
        return layer
    }
    
    private func createLineCapLayer(rect: CGRect, lineWidth: CGFloat,
                                    strokeColor: CGColor, fillColor: CGColor) -> CAShapeLayer {
        let width = rect.width
        
        let center = CGPoint(x: lineWidth / 2, y: lineWidth / 2)
        let radius = lineWidth / 2
        
        let startAndle = -CGFloat.pi / 2
        let endAngle = startAndle + (CGFloat.pi * 2)
        
        let circularPath = UIBezierPath(arcCenter: center, radius: radius,
                                        startAngle: startAndle, endAngle: endAngle,
                                        clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circularPath.cgPath
        
        shapeLayer.strokeColor = strokeColor
        shapeLayer.fillColor = fillColor
        shapeLayer.lineWidth = 0
        shapeLayer.frame = CGRect(x: width / 2 - lineWidth / 2, y: 0, width: lineWidth, height: lineWidth)
        shapeLayer.lineCap = .round
        
        return shapeLayer
    }
    
    private func createLineCapPickerLayer(rect: CGRect, lineWidth: CGFloat,
                                    strokeColor: CGColor, fillColor: CGColor) -> CAShapeLayer {
        let width = rect.width
        
        let center = CGPoint(x: lineWidth / 2, y: lineWidth / 2)
        let radius = lineWidth / 4
        
        let startAndle = -CGFloat.pi / 2
        let endAngle = startAndle + (CGFloat.pi * 2)
        
        let circularPath = UIBezierPath(arcCenter: center, radius: radius,
                                        startAngle: startAndle, endAngle: endAngle,
                                        clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circularPath.cgPath
        
        shapeLayer.fillColor = fillColor
        shapeLayer.strokeColor = strokeColor
        shapeLayer.lineWidth = lineWidth / 2 - 8
        shapeLayer.frame = CGRect(x: width / 2 - lineWidth / 2, y: 0, width: lineWidth, height: lineWidth)
        shapeLayer.lineCap = .round
        
        return shapeLayer
    }
    
    private func createLineCapShadowLayer(rect: CGRect, lineWidth: CGFloat) -> CAGradientLayer {
        let width = rect.width
        
        let startColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        let endColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        
        let layer = CAGradientLayer()
        layer.frame = CGRect(x: width / 2 - lineWidth / 2, y: 0, width: lineWidth, height: lineWidth)
        layer.cornerRadius = lineWidth / 2
        layer.startPoint = CGPoint(x: 0.5, y: 0.5)
        layer.endPoint = CGPoint(x: 1, y: 1)
        layer.colors = [startColor, endColor]
        layer.type = .radial
        
        
        return layer
    }
    
    private func getEndCapPoint(rect: CGRect, lineWidth: CGFloat, progress: CGFloat) -> CGPoint {
        let width = rect.width
        let height = rect.height
        
        let center = CGPoint(x: width / 2, y: height / 2)
        let radius = (min(width, height) - lineWidth) / 2
        
        let startAndle = -CGFloat.pi / 2
        let angle = startAndle + (CGFloat.pi * 2) * progress
        
        let X = center.x + radius * CGFloat(cos(angle)) - lineWidth / 2
        let Y = center.y + radius * CGFloat(sin(angle)) - lineWidth / 2
        let point = CGPoint(x: X, y: Y)
        return point
    }
    
    private func didProgressUpdated() {
        if endCapLayer != nil {
            animateEndCapColor(startPosition: prevProgress, endPosition: progress, layer: endCapLayer)
            animateEndCap(startPosition: prevProgress, endPosition: progress, layer: endCapLayer)
            animateEndCap(startPosition: prevProgress + 0.007, endPosition: progress + 0.007, layer: endCapShadowLayer)
            animateEndCap(startPosition: prevProgress, endPosition: progress, layer: endCapPickerLayer)
            animateStrokeEnd(startPosition: prevProgress, endPosition: progress, layer: foregroundLayer)
        }
        
        textLayer?.string = "\(Int(progress * 100))"
        prevProgress = progress
    }
    
    private func animateEndCap(startPosition: CGFloat, endPosition: CGFloat, layer: CALayer) {
        let positionAnimation = CAKeyframeAnimation(keyPath: "position")

        var positions: [CGPoint] = []
        var position: CGFloat = startPosition
        var rawP = getEndCapPoint(rect: self.layer.bounds, lineWidth: lineWidth, progress: position)
        var frameP = CGPoint(x: rawP.x + lineWidth / 2, y: rawP.y + lineWidth / 2)
        positions.append(frameP)
        
        while position != endPosition {
            if startPosition < endPosition {
                position = min(endPosition, position + 0.005)
            } else {
                position = max(endPosition, position - 0.005)
            }
            
            rawP = getEndCapPoint(rect: self.layer.bounds, lineWidth: lineWidth, progress: position)
            frameP = CGPoint(x: rawP.x + lineWidth / 2, y: rawP.y + lineWidth / 2)
            positions.append(frameP)

        }
        positionAnimation.values = positions
        positionAnimation.duration = animationDuration
        positionAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        layer.frame.origin = getEndCapPoint(rect: self.layer.bounds, lineWidth: lineWidth, progress: position)
        layer.add(positionAnimation, forKey: "position")
        
    }
    
    private func animateStrokeEnd(startPosition: CGFloat, endPosition: CGFloat, layer: CAShapeLayer) {
        let anim = CABasicAnimation(keyPath: "strokeEnd")
        anim.fromValue = startPosition
        anim.toValue = endPosition
        anim.duration = animationDuration
        anim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        layer.strokeEnd = endPosition
        layer.add(anim, forKey: "strokeEnd")
    }
    
    private func animateEndCapColor(startPosition: CGFloat, endPosition: CGFloat, layer: CAShapeLayer) {
        let colorAnimation = CABasicAnimation(keyPath: "fillColor")
        colorAnimation.fromValue = getGradientColor(startColor: startGradienttColor, endColor: endGradientColor, percent: startPosition).cgColor
        colorAnimation.toValue = getGradientColor(startColor: startGradienttColor, endColor: endGradientColor, percent: endPosition).cgColor
        colorAnimation.duration = animationDuration
        colorAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        layer.fillColor = getGradientColor(startColor: startGradienttColor, endColor: endGradientColor, percent: endPosition).cgColor
        layer.add(colorAnimation, forKey: "fillColor")
        
    }
    
    private func getGradientColor(startColor: UIColor, endColor: UIColor, percent: CGFloat) -> UIColor{
        let red = startColor.rgba.red + percent * (endColor.rgba.red - startColor.rgba.red)
        let green = startColor.rgba.green + percent * (endColor.rgba.green - startColor.rgba.green)
        let blue = startColor.rgba.blue + percent * (endColor.rgba.blue - startColor.rgba.blue)
        let alpha = startColor.rgba.alpha + percent * (endColor.rgba.alpha - startColor.rgba.alpha)
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if isDarkMode {
            if coloredBackgroundLayer {
                backgroundLayerColor = getGradientColor(startColor: startGradienttColor, endColor: endGradientColor, percent: 0.5)
                backgroundLayerColor = getGradientColor(startColor: backgroundLayerColor, endColor: .black, percent: 0.7)
                backgroundLayer?.strokeColor = backgroundLayerColor.cgColor
            } else {
                backgroundLayerColor = .darkGray
                backgroundLayer?.strokeColor = backgroundLayerColor.cgColor
            }
            
        } else {
            if coloredBackgroundLayer {
                backgroundLayerColor = getGradientColor(startColor: startGradienttColor, endColor: endGradientColor, percent: 0.5)
                backgroundLayerColor = getGradientColor(startColor: backgroundLayerColor, endColor: .white, percent: 0.5)
                backgroundLayer?.strokeColor = backgroundLayerColor.cgColor
            } else {
                backgroundLayerColor = .lightGray
                backgroundLayer?.strokeColor = backgroundLayerColor.cgColor
            }
        }
        
        if let color = endCapPickerColor {
            endCapPickerLayer?.strokeColor = color.cgColor
        }
        
        if transparentBackgroundLayer {
            backgroundLayer?.strokeColor = UIColor.clear.cgColor
        }
        
        textLayer?.foregroundColor = colorForMode(primaryLabelColors, isDarkMode: isDarkMode).cgColor
    }
}

