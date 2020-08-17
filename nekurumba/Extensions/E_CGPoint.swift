import UIKit

extension CGPoint {
    init(center: CGPoint, radius: CGFloat, angle: CGFloat) {
        let X = center.x + radius * CGFloat(cos(angle))
        let Y = center.y + radius * CGFloat(sin(angle))
        
        self = CGPoint(x: X, y: Y)
    }

}
