import UIKit

struct SliderItem {
    var sliderValue: Box<CGFloat>
    var minValue: CGFloat = 0
    var maxValue: CGFloat = 1
    var minSliderValue: CGFloat = 0
    var maxSliderValue: CGFloat = 1
    var numberOfDivisions: Int = 0
}
