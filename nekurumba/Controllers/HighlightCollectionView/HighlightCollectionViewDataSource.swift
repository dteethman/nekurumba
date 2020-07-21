import UIKit

class HighlightCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    var data: [HighlightData]?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let d = data {
            return d.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "highlightCell", for: indexPath) as! HighlightCollectionViewCell
        
        if let d = data {
            cell.data = d[indexPath.row]
        }
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
}
