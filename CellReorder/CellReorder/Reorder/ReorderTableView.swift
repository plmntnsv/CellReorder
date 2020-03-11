//
//  ReorderTableView.swift
//  CellReorder
//
//  Created by Plamen Atanasov on 6.03.20.
//  Copyright © 2020 Plamen Atanasov. All rights reserved.
//

// different section support
// extract magic numbers

import UIKit

protocol ReorderTableViewDelegate {
     func rowChanged(at: IndexPath, to: IndexPath)
}

class ReorderTableView: UITableView {
     // Private
     private var firstVisibleCellIndexPath: IndexPath? {
          get {
               guard let firstVisibleCell = self.visibleCells.first,
                    let indexPathOfFirst = self.indexPath(for: firstVisibleCell) else {
                         return nil
               }
               
               return indexPathOfFirst
          }
     }
     
     private var lastVisibleCellIndexPath: IndexPath? {
          get {
               guard let lastVisibleCell = self.visibleCells.last,
                    let indexPathOfLast = self.indexPath(for: lastVisibleCell) else {
                         return nil
               }
               
               return indexPathOfLast
          }
     }
     
     // Delegate
     var reorderDelegate: ReorderTableViewDelegate?
     
     func enableReorder() {
          let longpress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureRecognized(gestureRecognizer:)))
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
          let longPress = gestureRecognizer as! UILongPressGestureRecognizer
          let state = longPress.state
          let locationInView = longPress.location(in: self)
          print()
          print("DRAG LOC: \(locationInView)")
          
          var indexPath: IndexPath?
          
          if !self.frame.contains(locationInView) {
               if locationInView.y < self.frame.minY {
                    indexPath = firstVisibleCellIndexPath
               } else if locationInView.y > self.frame.maxY {
                    indexPath = lastVisibleCellIndexPath
               }
          } else {
               indexPath = self.indexPathForRow(at: locationInView)
          }
          
          print("INDEXPATH: \(indexPath)")
          print("FRAME: \(frame.maxY)")
          print("BOUNDS: \(bounds.maxY)")
          
          // Cell that we are moving
          struct Cell {
               static var snapshot : UIView?
          }
          
          // Current position of the moving cell
          struct Path {
               static var initialIndexPath : IndexPath? {
                    didSet {
                         print("GONNA DROP IN: \(initialIndexPath?.row)")
                    }
               }
          }
          
          switch state {
          case .began:
               if indexPath != nil {
                    Path.initialIndexPath = indexPath
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
          case .changed:
               var center = Cell.snapshot!.center
               center.y = locationInView.y
               Cell.snapshot!.center = center
               if let indexPath = indexPath {
                    if indexPath != Path.initialIndexPath {
                         // Delegate updating the dataSource
                         reorderDelegate?.rowChanged(at: Path.initialIndexPath!, to: indexPath)
                         
                         // Update UI
                         self.moveRow(at: Path.initialIndexPath!, to: indexPath)
                         Path.initialIndexPath = indexPath
                    }
                    
                    let currentOffset = self.contentOffset
                    
                    // Managing auto scrolling down/up
//                    if let indexPathOfLast = lastVisibleCellIndexPath,
//                         indexPath.row >= indexPathOfLast.row - 2 &&
//                              self.numberOfRows(inSection: 0) - 1 > indexPathOfLast.row {
//                         self.contentOffset = CGPoint(x: currentOffset.x, y: currentOffset.y + 10)
//
//                    } else if let indexPathOfFirst = firstVisibleCellIndexPath,
//                         indexPath.row <= indexPathOfFirst.row + 2 &&
//                              0 > indexPathOfFirst.row && indexPathOfFirst.row > 1 {
//                         self.contentOffset = CGPoint(x: currentOffset.x, y: currentOffset.y - 10)
//                    }
               }
               
               
               //case .ended:
               
          default:
               print()
               print("DROPPING CELL IN: \(indexPath)")
               print("PATH.INITIAL: \(Path.initialIndexPath)")

               let cell = self.cellForRow(at: Path.initialIndexPath!)
               cell?.isHidden = false
               cell?.alpha = 0.0
               UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    Cell.snapshot!.center = cell!.center
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
               
               //                if let cell = self.cellForRow(at: Path.initialIndexPath!) {
               //
               //                }
          }
     }
}
