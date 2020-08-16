import UIKit

struct HighlightData {
    var title: NSMutableAttributedString
    var text: String
    var mark: Bool
}

class HighlightsProvider {
    func makeCountHighlight(todayData: [SmokeTracker]?, yesterdayData: [SmokeTracker]?, isDarkMode: Bool = false) -> HighlightData? {
        if todayData != nil && yesterdayData != nil {
            let todayCount = todayData!.count
            let yesterdayCount = yesterdayData!.count
            
            var mark = todayCount < yesterdayCount ? true : false
            let difference = abs(todayCount - yesterdayCount)
            
            var smokedStr = "Сегодня " + todayCount.getNoun("выкурен", singleEnd: "а ", dualEnd: "о ", multipleEnd: "о ")
            var cigStr = "\(todayCount) " + todayCount.getNoun("выкурен", singleEnd: "а ", dualEnd: "о ", multipleEnd: "о ")
            
            let textColor = colorForMode(primaryLabelColors, isDarkMode: isDarkMode)
            
            if todayCount == 0 {
                smokedStr = "Сегодня не выкурено "
                cigStr = "ни одной сигареты"
                mark = true
            }
            
            let blackAtr = [NSMutableAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17), NSMutableAttributedString.Key.foregroundColor: textColor]
            let blackStr = NSMutableAttributedString(string:  smokedStr, attributes: blackAtr)
            let coloredAtr = [NSMutableAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17), NSMutableAttributedString.Key.foregroundColor: UIColor.systemPink]

            let coloredStr = NSMutableAttributedString(string: cigStr, attributes: coloredAtr)
            let titleStr = NSMutableAttributedString()
            titleStr.append(blackStr)
            titleStr.append(coloredStr)
            
            var textStr = "Это "
            if mark {
                textStr.append("на \(difference) меньше, чем вчера")
            } else {
                if difference != 0 {
                    textStr.append("на \(difference) больше, чем вчера")
                } else {
                    textStr.append("столько же, сколько и вчера")
                }
            }
            
            if todayCount == 0 {
                if difference == 0 {
                    textStr = "И вчера тоже!"
                } else {
                    textStr = "А вчера — \(yesterdayCount)!"
                }
            }
            
            return HighlightData(title: titleStr, text: textStr, mark: mark)
        } else {
            return nil
        }
    }
    
    func makeIntervalHighlight(todayData: [SmokeTracker]?, plannedInteval: Int, isDarkMode: Bool = false) -> HighlightData?{
        if todayData != nil {
            var mark: Bool
            let titleStr: NSMutableAttributedString = NSMutableAttributedString()
            var textStr = ""
            
            if todayData!.count <= 1 {
                return nil
            }
            
            var intervals: [Int] = []
            var avgInterval: Int = 0
            for i in 0 ..< todayData!.count - 1 {
                let interval = ((todayData![i + 1].hour) * 60 + (todayData![i + 1].minute)) - ((todayData![i].hour) * 60 + (todayData![i].minute))
                intervals.append(Int(interval))
                avgInterval += Int(interval)
            }
            
            avgInterval /= intervals.count
            mark = avgInterval >= plannedInteval
            
            let avgHours = avgInterval / 60
            let avgMinutes = avgInterval - avgHours * 60
            
            let difference = abs(plannedInteval - avgInterval)
            let diffHours = difference / 60
            let diffMinutes = difference - diffHours * 60
            
            let avgHoursNoun = avgHours.getNoun("час", singleEnd: "", dualEnd: "а", multipleEnd: "ов")
            let avgMinutesNoun = avgMinutes.getNoun("минут", singleEnd: "а", dualEnd: "ы", multipleEnd: "")
            let diffHoursNoun = diffHours.getNoun("час", singleEnd: "", dualEnd: "а", multipleEnd: "ов")
            let diffMinutesNoun = diffMinutes.getNoun("минут", singleEnd: "у", dualEnd: "ы", multipleEnd: "")
            
            var avgTimeStr = ""
            
            if avgHours != 0 {
                avgTimeStr.append("\(avgHours) \(avgHoursNoun) ")
            }
            
            if avgMinutes != 0 {
                avgTimeStr.append("\(avgMinutes) \(avgMinutesNoun)")
            }
            
            var diffTimeStr = ""
            
            if diffHours != 0 {
                diffTimeStr.append("\(diffHours) \(diffHoursNoun) ")
            }
            
            if diffMinutes != 0 {
                diffTimeStr.append("\(diffMinutes) \(diffMinutesNoun)")
            }
            
            
            let textColor = colorForMode(primaryLabelColors, isDarkMode: isDarkMode)
            let firstAtr = [NSMutableAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17), NSMutableAttributedString.Key.foregroundColor: textColor]
            let firstStr = NSMutableAttributedString(string: "Средний перерыв: ", attributes: firstAtr)
            let secondAtr = [NSMutableAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17), NSMutableAttributedString.Key.foregroundColor: UIColor.systemPink]

            let secondStr = NSMutableAttributedString(string: avgTimeStr, attributes: secondAtr)
            
            titleStr.append(firstStr)
            titleStr.append(secondStr)
            
            if mark {
                textStr.append("Это больше установленной цели на \(diffTimeStr)")
            } else {
                if difference != 0 {
                    textStr.append("Это меньше установленной цели на \(diffTimeStr)")
                } else {
                    textStr.append("Как и запланированный интервал")
                }
            }
            
            return HighlightData(title: titleStr, text: textStr, mark: mark)
        } else {
            return nil
        }
    }
}
