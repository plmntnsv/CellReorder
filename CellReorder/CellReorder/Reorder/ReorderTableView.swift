//
//  ReorderTableView.swift
//  CellReorder
//
//  Created by Plamen Atanasov on 6.03.20.
//  Copyright © 2020 Plamen Atanasov. All rights reserved.
//

import UIKit

protocol TableViewReorderDelegate {
    
}

fileprivate class MyLongGestureRecognizer<T>: UILongPressGestureRecognizer {
    var data: [T]?
}

extension UITableView {
    func enableReorder<T>(data: [T]) {
        let longpress = MyLongGestureRecognizer<T>(target: self, action: #selector(longPressGestureRecognized(gestureRecognizer:)))
        self.addGestureRecognizer(longpress)
    }
    
    private func snapshopOfCell(inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        let cellSnapshot : UIView = UIImageView(image: image)
        cellSnapshot.layer.masksToBounds = false
        cellSnapshot.layer.cornerRadius = 0.0
        cellSnapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
        cellSnapshot.layer.shadowRadius = 5.0
        cellSnapshot.layer.shadowOpacity = 0.4
        return cellSnapshot
    }
    
    @objc private func longPressGestureRecognized(gestureRecognizer: UIGestureRecognizer) {
        let longPress = gestureRecognizer as! MyLongGestureRecognizer<T>
        let state = longPress.state
        let locationInView = longPress.location(in: self)
        var indexPath = self.indexPathForRow(at: locationInView)
        let dataSource = self.dataSource
            
        struct Cell {
            static var snapshot : UIView? = nil
        }
        struct Path {
            static var initialIndexPath : IndexPath? = nil
        }
            
        switch state {
            case UIGestureRecognizerState.began:
                if indexPath != nil {
                    Path.initialIndexPath = indexPath as IndexPath?
                    let cell = self.cellForRow(at: indexPath!)
                    Cell.snapshot = snapshopOfCell(inputView: cell!)
                    var center = cell?.center
                    Cell.snapshot!.center = center!
                    Cell.snapshot!.alpha = 0.0
                    self.addSubview(Cell.snapshot!)
                        
                    UIView.animate(withDuration: 0.25,
                        animations: { () -> Void in
                            center?.y = locationInView.y
                            Cell.snapshot!.center = center!
                            Cell.snapshot!.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                            Cell.snapshot!.alpha = 0.98
                            cell?.alpha = 0.0
                            
                        }, completion: { (finished) -> Void in
                            if finished {
                                cell?.isHidden = true
                            }
                        }
                    )
                }
            case UIGestureRecognizerState.changed:
                var center = Cell.snapshot!.center
                center.y = locationInView.y
                Cell.snapshot!.center = center
                if ((indexPath != nil) && (indexPath != Path.initialIndexPath)) {
                    // Update data source
                    let data = self.cell
                    swap(&dataSource![indexPath!.row], &dataSource![Path.initialIndexPath!.row])
                    
                    // Update UI
                    self.moveRow(at: Path.initialIndexPath!, to: indexPath!)
                    Path.initialIndexPath = indexPath
                }
            default:
                let cell = self.cellForRow(at: Path.initialIndexPath!)
                cell?.isHidden = false
                cell?.alpha = 0.0
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    Cell.snapshot!.center = (cell?.center)!
                    Cell.snapshot!.transform = CGAffineTransform.identity
                    Cell.snapshot!.alpha = 0.0
                    cell?.alpha = 1.0
                    }, completion: { (finished) -> Void in
                        if finished {
                            Path.initialIndexPath = nil
                            Cell.snapshot!.removeFromSuperview()
                            Cell.snapshot = nil
                        }
                })
        }
    }
}
