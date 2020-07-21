import UIKit

struct SegmentItem {
    typealias SegmentFunction = () -> Void
    
    var displayTitle: String
    var action: SegmentFunction?
}
