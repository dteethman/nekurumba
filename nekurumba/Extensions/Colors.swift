import UIKit

struct ColorSet {
    var light: UIColor
    var dark: UIColor
}

let bgLightColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
let bgDarkColor = UIColor(red: 25/255, green: 25/255, blue: 25/255, alpha: 1)
let greenHighlightColor = UIColor(red: 212/255, green: 242/255, blue: 209/255, alpha: 1)
let redHighlightColor = UIColor(red: 253/255, green: 172/255, blue: 172/255, alpha: 1)
let inactiveColor = UIColor(red: 160/255, green: 160/255, blue: 160/255, alpha: 1)
let activeColor = UIColor.systemPink

let primaryLabelColors = ColorSet(light: .black, dark: .white)
let secondaryLabelColors = ColorSet(light: UIColor(red: 60/255, green: 60/255, blue: 67/255, alpha: 0.6),
                      dark: UIColor(red: 235/255, green: 235/255, blue: 245/255, alpha: 0.6))
let bgColors = ColorSet(light: bgLightColor, dark: bgDarkColor)


func colorForMode(_ colors: ColorSet, isDarkMode: Bool) -> UIColor {
    if isDarkMode { return colors.dark } else { return colors.light }
}
