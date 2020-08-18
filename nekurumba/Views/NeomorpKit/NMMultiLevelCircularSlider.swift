import UIKit
import DTBunchOfExt

//MARK: - SliderItem Struct
struct SliderItem {
    var sliderValue: Box<CGFloat>
    var minValue: CGFloat = 0
    var maxValue: CGFloat = 1
    var minSliderValue: CGFloat = 0
    var maxSliderValue: CGFloat = 1
    var numberOfDivisions: Int = 0
}

class NMMultiLevelCircularSlider: UIView {
    //MARK: - Variables
    public var sliderItems: [SliderItem] = []
    private var activeItem: Int!
    
    public var progressBar: ProgressBarView!
    private var circleBackgroundView: NMView!
    private var timerBackgroundView: NMView!
    private var innerCircleView: NMView!
    private var divisionsView: UIView!
    private var panGRView: UIView!
    
    private var minValue: CGFloat = 0
    private var maxValue: CGFloat = 1
    private var minSliderValue: CGFloat = 0
    private var maxSliderValue: CGFloat = 1
    
    private var panGR: UIPanGestureRecognizer!
    private var touchBeganAndValid: Bool = false
    private var prevPosition: CGFloat? = nil
    
    private var divisionLines: [CAShapeLayer] = []
    
    public var numberOfDivisions: Int = 0 {
        didSet {
            divisionLines = []
            createDivisions(numberOfDivisions: numberOfDivisions)
        }
    }
    
    public var cornerRadius: CGFloat = 0 {
        didSet {
            circleBackgroundView?.cornerRadius = cornerRadius
            timerBackgroundView?.cornerRadius = cornerRadius - 10
            innerCircleView.cornerRadius = cornerRadius - sliderWidth - 10
        }
    }
    
    public var sliderWidth: CGFloat = 40 {
        didSet {
            progressBar.lineWidth = sliderWidth
            innerCircleView.cornerRadius = cornerRadius - sliderWidth - 10
        }
    }
    
    //MARK: - Initialisers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        innerCircleView = NMView()
        innerCircleView.isConvex = true
        innerCircleView.bgColors = bgColors
        innerCircleView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(innerCircleView)
        
        progressBar = ProgressBarView()
        progressBar.backgroundColor = .clear
        progressBar.progress = 0.375
        progressBar.lineWidth = sliderWidth
        progressBar.transparentBackgroundLayer = true
        progressBar.disableText = true
        progressBar.endCapPickerColor = colorForMode(bgColors, isDarkMode: isDarkMode)
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(progressBar)
        
        divisionsView = UIView()
        divisionsView.backgroundColor = .clear
        divisionsView.clipsToBounds = true
        divisionsView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(divisionsView)
        
        panGR = UIPanGestureRecognizer(target: self, action: #selector(panGRAction(_:)))
        
        panGRView = UIView()
        panGRView.backgroundColor = .clear
        panGRView.translatesAutoresizingMaskIntoConstraints = false
        panGRView.addGestureRecognizer(panGR)
        self.addSubview(panGRView)
        
        NSLayoutConstraint.activate([
            circleBackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            circleBackgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            circleBackgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            circleBackgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            timerBackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            timerBackgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            timerBackgroundView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            timerBackgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            
            innerCircleView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50),
            innerCircleView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50),
            innerCircleView.topAnchor.constraint(equalTo: self.topAnchor, constant: 50),
            innerCircleView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -50),
            
            progressBar.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            progressBar.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            progressBar.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            progressBar.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            
            divisionsView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            divisionsView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            divisionsView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            divisionsView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            
            panGRView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            panGRView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            panGRView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            panGRView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
        ])
    }
    
    private func createDivisions(numberOfDivisions: Int) {
        if numberOfDivisions == 0 {
            return
        }
        
        if self.bounds.width == 0 || self.bounds.height == 0 {
            return
        }
        
        divisionsView?.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        let center = CGPoint(x: min(self.bounds.width, self.bounds.height) / 2, y: min(self.bounds.width, self.bounds.height) / 2)
        let circleRadius = min(self.bounds.width, self.bounds.height) / 2
        let outerRadius = circleRadius - sliderWidth - 20
        
        var quarterNumber: Int = numberOfDivisions
        if numberOfDivisions % 2 == 0 {
            quarterNumber /= 4
        }
        
        let step = 1 / CGFloat(numberOfDivisions)
        
        for i in 0 ..< numberOfDivisions {
            
            let angle = -CGFloat.pi / 2 + (2 * CGFloat.pi * step * CGFloat(i))
            let innerRadius = i % quarterNumber == 0 ? outerRadius - 15 : outerRadius - 10
            
            let layer = CAShapeLayer()
            let path = UIBezierPath()
            path.move(to: CGPoint(center: center, radius: outerRadius, angle: angle))
            path.addLine(to: CGPoint(center: center, radius: innerRadius, angle: angle))
            
            layer.path = path.cgPath
            layer.strokeColor = inactiveColor.cgColor
            
            layer.lineWidth = 2
            layer.strokeEnd = 0
            divisionLines.append(layer)
            divisionsView?.layer.addSublayer(divisionLines[i])
            
            let strokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
            strokeAnimation.fromValue = 0
            strokeAnimation.toValue = 1.0
            strokeAnimation.duration = 0.2
            strokeAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            
            divisionLines[i].add(strokeAnimation, forKey: "line")
            if divisionLines.indices.contains(i) {
                divisionLines[i].strokeEnd = 1
            }

        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        progressBar?.endCapPickerColor = colorForMode(bgColors, isDarkMode: isDarkMode)
        divisionsView?.frame = self.bounds
        
        createDivisions(numberOfDivisions: numberOfDivisions)
    }
    
    //MARK: - Slider Setup
    public func switchSliderForItem(_ itemIndex: Int) {
        if sliderItems.indices.contains(itemIndex) {
            self.numberOfDivisions = sliderItems[itemIndex].numberOfDivisions
            self.progressBar.progress = sliderItems[itemIndex].sliderValue.value
            self.minValue = sliderItems[itemIndex].minValue
            self.maxValue = sliderItems[itemIndex].maxValue
            self.minSliderValue = sliderItems[itemIndex].minSliderValue
            self.maxSliderValue = sliderItems[itemIndex].maxSliderValue
            self.activeItem = itemIndex
        }
    }
        
    
    //MARK: - PanGestureRecognizer action
    @objc private func panGRAction(_ gesture: UIPanGestureRecognizer) {
        let point = gesture.location(in: panGRView)
        let center = CGPoint(x: self.bounds.width / 2, y: self.bounds.width / 2 )
        let circleRadius = min(self.bounds.width, self.bounds.height) / 2
        let sliderRadius = circleRadius - sliderWidth / 2
        
        let sliderPosition = angleOfTouchPoint(center: center, touchPoint: point) / (CGFloat.pi * 2)
        let step: CGFloat = 0.1
        
        if gesture.state == .began {
            let validAngle = (-CGFloat.pi / 2) + (2 * CGFloat.pi * progressBar.progress)
            let pointOnCircle = CGPoint(center: center, radius: sliderRadius, angle: validAngle)
            if (point.x >= (pointOnCircle.x - (sliderWidth / 2 + 10))) && (point.x <= (pointOnCircle.x + (sliderWidth / 2 + 10)))
                && (point.y >= (pointOnCircle.y - (sliderWidth / 2 + 10))) && (point.y <= (pointOnCircle.y + (sliderWidth / 2 + 10))) {
                touchBeganAndValid = true
                prevPosition = progressBar.progress
            } else {
                touchBeganAndValid = false
            }
        }
        
        if gesture.state == .changed {
            if touchBeganAndValid && prevPosition != nil {
                let positionDelta = abs(prevPosition! - sliderPosition)
                if positionDelta <= step {
                    if sliderPosition >= minSliderValue && sliderPosition <= maxSliderValue {
                        sliderItems[activeItem].sliderValue.value = sliderPosition
                    }
                    progressBar.progress = sliderPosition
                    prevPosition = sliderPosition
                }
            }
        }
        
        if gesture.state == .ended {
            if touchBeganAndValid && prevPosition != nil {
                let div = CGFloat(numberOfDivisions)
                let positionDelta = abs(prevPosition! - sliderPosition)
                
                var finalPosition = positionDelta <= step ? round(sliderPosition * div) / div : round(prevPosition! * div) / div
                finalPosition = min(finalPosition, maxSliderValue)
                finalPosition = max(finalPosition, minSliderValue)
                
                sliderItems[activeItem].sliderValue.value = finalPosition
                progressBar.progress = finalPosition
                prevPosition = nil
            }
                
            touchBeganAndValid = false
        }
        
    }
    
    //MARK: - Helpers
    private func angleOfTouchPoint(center: CGPoint, touchPoint: CGPoint) -> CGFloat {
            let firstAngle = atan2(touchPoint.y - center.y, touchPoint.x - center.x)
            let secondAnlge = atan2(0 - center.y, 0)
            var angleDiff = firstAngle - secondAnlge
            
            if angleDiff < 0 {
                angleDiff += CGFloat.pi * 2
            }
            
            return angleDiff
        }
    
    
}
