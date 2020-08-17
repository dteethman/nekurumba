import UIKit

extension UIColor {
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        return (red, green, blue, alpha)
    }
    
    func getGradientColor(at percent: CGFloat, with color: UIColor) -> UIColor {
        let red = self.rgba.red + percent * (color.rgba.red - self.rgba.red)
        let green = self.rgba.green + percent * (color.rgba.green - self.rgba.green)
        let blue = self.rgba.blue + percent * (color.rgba.blue - self.rgba.blue)
        let alpha = self.rgba.alpha + percent * (color.rgba.alpha - self.rgba.alpha)
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
