import Foundation

class StatsProvider {
    var dataManager: CoreDataManager!
    var statsData: [SmokeTracker]?
    
   private  func loadStats() {
        statsData = dataManager?.loadData()
    }
    
    func dataForDay(year: Int, month: Int, day: Int) -> [SmokeTracker]? {
        loadStats()
        if let data = statsData {
            var dailyData: [SmokeTracker] = []
            for d in data {
                if d.day == day && d.month == month && d.year == year {
                    dailyData.append(d)
                }
            }
            
            dailyData.sort {
                $0.minute < $1.minute
            }
            
            dailyData.sort {
                $0.hour < $1.hour
            }
            
            dailyData.sort {
                $0.day < $1.day
            }
            
            dailyData.sort {
                $0.month < $1.month
            }

            dailyData.sort {
                $0.year < $1.year
            }

    
            return dailyData
        } else {
            return nil
        }
    }
}
