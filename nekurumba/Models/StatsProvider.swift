import Charts
import UIKit

class StatsProvider {
    var dataManager: CoreDataManager!
    var statsData: [SmokeTracker]?
    
    private func loadStats() {
        statsData = dataManager?.loadAllData()
    }
    
    func getDailySmokedStats(year: Int, month: Int, day: Int) -> StatData? {
        if let tracks = dataManager.loadForDate(year: year, month: month, day: day) {
            var statsDataEntry: [ChartDataEntry] = []
            var smokedCount: [Int] = Array(repeating: 0, count: 24)
            var labels: [String] = []
            
            for track in tracks {
                let ind = Int(track.hour)
                if ind < 24 {
                    smokedCount[ind] += 1
                } else {
                    if !smokedCount.indices.contains(24) {
                        smokedCount.append(0)
                    }
                    smokedCount[24] += 1
                }  
            }
            
            for i in 0 ..< smokedCount.count {
                if i > 0 {
                    smokedCount[i] += smokedCount[i - 1]
                }
                let chartData = ChartDataEntry(x: Double(i), y: Double(smokedCount[i]))
                statsDataEntry.append(chartData)
                
                switch i {
                case 4, 8 , 12, 16, 20:
                    labels.append("\(i)")
                case 24:
                    labels.append("🌙")
                default:
                    labels.append("")
                }
            }
            
            return StatData(statsDataEntry: statsDataEntry, labelText: "Выкурено сигарет", xAxisLabels: labels, granularity: 1)
        } else {
            return nil
        }
    }
    
    func getDailyIntervalsStats(year: Int, month: Int, day: Int) -> StatData? {
        if let tracks = dataManager.loadForDate(year: year, month: month, day: day) {
            var statsDataEntry: [ChartDataEntry] = []
            var labels: [String] = []
            var isMoreThanHundred = false
            
            if tracks.count <= 2 {
                return nil
            }
            
            for i in 0 ..< tracks.count - 1 {
                let interval = ((tracks[i + 1].hour) * 60 + (tracks[i + 1].minute)) - ((tracks[i].hour) * 60 + (tracks[i].minute))
                let dataEntry = ChartDataEntry(x: Double(i), y: Double(interval))
                statsDataEntry.append(dataEntry)
                labels.append("\(i + 1)")
                if interval > 100 {
                    isMoreThanHundred = true
                }
            }
            
            if isMoreThanHundred {
                statsDataEntry = statsDataEntry.map(minutesToHours(_:))
            }
            
            return StatData(statsDataEntry: statsDataEntry, labelText: "Длина перерыва", xAxisLabels: labels, granularity: 1)
        } else {
            return nil
        }
    }
    
    func getWeeklySmokedStats(year: Int, month: Int, day: Int) -> StatData? {
        if dataManager != nil {
            var dateComponents = DateComponents()
            dateComponents.year = year
            dateComponents.month = month
            dateComponents.day = day
            dateComponents.timeZone = Calendar.current.timeZone
            dateComponents.hour = 03
            dateComponents.minute = 01
            
            let userCalendar = Calendar.current
            let fromDate = userCalendar.date(from: dateComponents)
            
            var curDate = fromDate?.addingTimeInterval(-6 * 24 * 60 * 60)
            
            var statsDataEntry: [ChartDataEntry] = []
            var labels: [String] = []
            
            statsDataEntry.append(ChartDataEntry(x: 0, y: 0))
            labels.append("")
            
            for i in 0 ... 6 {
                if let date = curDate {
                    if let tracks = dataManager.loadForDate(year: userCalendar.component(.year, from: date),
                                                            month: userCalendar.component(.month, from: date),
                                                            day: userCalendar.component(.day, from: date)) {
                        
                        statsDataEntry.append(ChartDataEntry(x: Double(i + 1), y: Double(tracks.count)))
                        
                        switch userCalendar.component(.weekday, from: date) {
                        case 1:
                            labels.append("ВС")
                        case 2:
                            labels.append("ПН")
                        case 3:
                            labels.append("ВТ")
                        case 4:
                            labels.append("СР")
                        case 5:
                            labels.append("ЧТ")
                        case 6:
                            labels.append("ПТ")
                        case 7:
                            labels.append("СБ")
                        default:
                            return nil
                        }
                        
                        curDate = date.addingTimeInterval(24 * 60 * 60)
                    } else {
                        return nil
                    }
                } else {
                    return nil
                }
            }
            statsDataEntry.append(ChartDataEntry(x: 8, y: 0))
            labels.append("")
            return StatData(statsDataEntry: statsDataEntry, labelText: "Выкурено сигарет", xAxisLabels: labels, granularity: 1)
        } else {
            return nil
        }
    }
    
    func getWeeklyIntervalStats(year: Int, month: Int, day: Int) -> StatData? {
        if dataManager != nil {
            var dateComponents = DateComponents()
            dateComponents.year = year
            dateComponents.month = month
            dateComponents.day = day
            dateComponents.timeZone = Calendar.current.timeZone
            dateComponents.hour = 03
            dateComponents.minute = 01
            
            let userCalendar = Calendar.current
            let fromDate = userCalendar.date(from: dateComponents)
            
            var curDate = fromDate?.addingTimeInterval(-6 * 24 * 60 * 60)
            var statsDataEntry: [ChartDataEntry] = []
            var labels: [String] = []
            var isMoreThanHundred = false
            
            statsDataEntry.append(ChartDataEntry(x: 0, y: 0))
            labels.append("")
            
            for i in 0 ... 6 {
                if let date = curDate {
                    if let tracks = dataManager.loadForDate(year: userCalendar.component(.year, from: date),
                                                            month: userCalendar.component(.month, from: date),
                                                            day: userCalendar.component(.day, from: date)) {
                        
                        if tracks.count <= 1 {
                            statsDataEntry.append(ChartDataEntry(x: Double(i + 1), y: Double(0)))
                        } else {
                            var avgInterval: Int = 0
                            for i in 0 ..< tracks.count - 1 {
                                let interval = Int(((tracks[i + 1].hour) * 60 + (tracks[i + 1].minute)) - ((tracks[i].hour) * 60 + (tracks[i].minute)))
                                avgInterval += interval
                            }
                            avgInterval /= tracks.count - 1
                            
                            if avgInterval > 100 {
                                isMoreThanHundred = true
                            }
                            
                            let dataEntry = ChartDataEntry(x: Double(i + 1), y: Double(avgInterval))
                            statsDataEntry.append(dataEntry)
                        }
                        
                        switch userCalendar.component(.weekday, from: date) {
                        case 1:
                            labels.append("ВС")
                        case 2:
                            labels.append("ПН")
                        case 3:
                            labels.append("ВТ")
                        case 4:
                            labels.append("СР")
                        case 5:
                            labels.append("ЧТ")
                        case 6:
                            labels.append("ПТ")
                        case 7:
                            labels.append("СБ")
                        default:
                            return nil
                        }
                        
                        
                        curDate = date.addingTimeInterval(24 * 60 * 60)
                    } else {
                        return nil
                    }
                } else {
                    return nil
                }
            }
            statsDataEntry.append(ChartDataEntry(x: 8, y: 0))
            labels.append("")
            
            if isMoreThanHundred {
                statsDataEntry = statsDataEntry.map(minutesToHours(_:))
            }
            
            return StatData(statsDataEntry: statsDataEntry, labelText: "Средняя длина перерыва", xAxisLabels: labels, granularity: 1)
        } else {
            return nil
        }
    }
    
    func getMonthlySmokedStats(year: Int, month: Int, day: Int) -> StatData? {
        if dataManager != nil {
            var dateComponents = DateComponents()
            dateComponents.year = year
            dateComponents.month = month
            dateComponents.day = day
            dateComponents.timeZone = Calendar.current.timeZone
            dateComponents.hour = 03
            dateComponents.minute = 01
            
            let userCalendar = Calendar.current
            let fromDate = userCalendar.date(from: dateComponents)
            
            var curDate = fromDate?.addingTimeInterval(-30 * 24 * 60 * 60)
            
            var statsDataEntry: [ChartDataEntry] = []
            var labels: [String] = []
            
            for i in 0 ... 30 {
                if let date = curDate {
                    if let tracks = dataManager.loadForDate(year: userCalendar.component(.year, from: date),
                                                            month: userCalendar.component(.month, from: date),
                                                            day: userCalendar.component(.day, from: date)) {
                        
                        statsDataEntry.append(ChartDataEntry(x: Double(i), y: Double(tracks.count)))
                        
                        let dayStr = userCalendar.component(.day, from: date)
                        let month = userCalendar.component(.month, from: date)
                        let monthStr = month / 10 == 0 ? "0\(month)" : "\(month)"
                        labels.append("\(dayStr).\(monthStr)")
                        
                        curDate = date.addingTimeInterval(24 * 60 * 60)
                    } else {
                        return nil
                    }
                } else {
                    return nil
                }
            }
            return StatData(statsDataEntry: statsDataEntry, labelText: "Выкурено сигарет", xAxisLabels: labels, granularity: 10)
        } else {
            return nil
        }
    }
    
    func getMonthlyIntervalStats(year: Int, month: Int, day: Int) -> StatData? {
        if dataManager != nil {
            var dateComponents = DateComponents()
            dateComponents.year = year
            dateComponents.month = month
            dateComponents.day = day
            dateComponents.timeZone = Calendar.current.timeZone
            dateComponents.hour = 03
            dateComponents.minute = 01
            
            let userCalendar = Calendar.current
            let fromDate = userCalendar.date(from: dateComponents)
            
            var curDate = fromDate?.addingTimeInterval(-30 * 24 * 60 * 60)
            
            var statsDataEntry: [ChartDataEntry] = []
            var labels: [String] = []
            var isMoreThanHundred = false
            
            for i in 0 ... 30 {
                if let date = curDate {
                    if let tracks = dataManager.loadForDate(year: userCalendar.component(.year, from: date),
                                                            month: userCalendar.component(.month, from: date),
                                                            day: userCalendar.component(.day, from: date)) {
                        
                        if tracks.count <= 1 {
                            statsDataEntry.append(ChartDataEntry(x: Double(i), y: Double(0)))
                        } else {
                            var avgInterval: Int = 0
                            for i in 0 ..< tracks.count - 1 {
                                let interval = Int(((tracks[i + 1].hour) * 60 + (tracks[i + 1].minute)) - ((tracks[i].hour) * 60 + (tracks[i].minute)))
                                avgInterval += interval
                            }
                            avgInterval /= tracks.count - 1
                            
                            if avgInterval > 100 {
                                isMoreThanHundred = true
                            }
                            
                            let dataEntry = ChartDataEntry(x: Double(i), y: Double(avgInterval))
                            statsDataEntry.append(dataEntry)
                        }
                        
                        let dayStr = userCalendar.component(.day, from: date)
                        let month = userCalendar.component(.month, from: date)
                        let monthStr = month / 10 == 0 ? "0\(month)" : "\(month)"
                        labels.append("\(dayStr).\(monthStr)")
                        
                        curDate = date.addingTimeInterval(24 * 60 * 60)
                    } else {
                        return nil
                    }
                } else {
                    return nil
                }
            }
            
            if isMoreThanHundred {
                statsDataEntry = statsDataEntry.map(minutesToHours(_:))
            }
            
            return StatData(statsDataEntry: statsDataEntry, labelText: "Средняя длина перерыва", xAxisLabels: labels, granularity: 10)
        } else {
            return nil
        }
    }
    
    private func minutesToHours(_ data: ChartDataEntry) -> ChartDataEntry {
        let minutses = data.y / 60
        return ChartDataEntry(x: data.x, y: minutses)
    }
    
}
