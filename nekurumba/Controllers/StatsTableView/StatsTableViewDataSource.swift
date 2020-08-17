import UIKit

class StatsTableViewDataSource: NSObject, UITableViewDataSource {
    var stats: [StatData]?
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if stats != nil {
            return stats!.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "statsCell", for: indexPath) as! StatsTableViewCell
        
        if stats != nil {
            cell.statsDataEntry = stats![indexPath.row].statsDataEntry
            cell.labelText = stats![indexPath.row].labelText
            cell.xAxisLabels = stats![indexPath.row].xAxisLabels
            cell.granularity = stats![indexPath.row].granularity
            cell.bgColors = bgColors
            return cell
        }

        return cell
    }
    
}
