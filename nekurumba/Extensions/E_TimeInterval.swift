import UIKit

extension TimeInterval {
    var timeString: String {
        var timeStr: String = ""
        let hours = (Int(self) / 3600)
        timeStr.append("\(hours):")
        let minutes = ((Int(self) - hours * 3600 ) / 60)
        minutes < 10 ? timeStr.append("0\(minutes):") : timeStr.append("\(minutes):")
        let seconds = (Int(self) - hours * 3600 - minutes * 60)
        seconds < 10 ? timeStr.append("0\(seconds)") : timeStr.append("\(seconds)")
        return timeStr
    }
}
