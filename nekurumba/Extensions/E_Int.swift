extension Int {
    func getNoun(_ root: String, singleEnd: String, dualEnd: String, multipleEnd: String) -> String {
        var resStr = root
        switch self % 10 {
        case 1:
            resStr += singleEnd
        case 2, 3, 4:
            resStr += dualEnd
        default:
            resStr += multipleEnd
        }
        
        if self % 100 >= 11 &&  self % 100 <= 14 {
            resStr = root + multipleEnd
        }
        
        return resStr
    }
}
