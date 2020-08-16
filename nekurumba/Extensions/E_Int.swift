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
        
        switch self % 100 {
        case 11, 12:
            resStr += multipleEnd
        default:
            break
        }
        
        return resStr
    }
}
