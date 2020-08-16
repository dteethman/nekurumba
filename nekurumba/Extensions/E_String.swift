import UIKit

extension String {
    func calculateTextFieldHeight(width: CGFloat, font: UIFont) -> CGFloat {
        let string = NSAttributedString(string: self, attributes: [NSAttributedString.Key.font : font])
        
        let maxSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let stringSize = string.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).size

        let range = CFRangeMake(0, string.length)
        let framesetter = CTFramesetterCreateWithAttributedString(string)
        let framesetterSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, range, nil, maxSize, nil)
        
        return max(stringSize.height.rounded(.up), framesetterSize.height.rounded(.up))
    }
}
