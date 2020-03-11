//
//  ReorderCell.swift
//  CellReorder
//
//  Created by Plamen Atanasov on 11.03.20.
//  Copyright © 2020 Plamen Atanasov. All rights reserved.
//

import UIKit

struct ReorderCell {
    // View of the cell that we are moving
    static var snapshot : UIView?
    
    // Current position of the moving cell
    static var currentIndexPath : IndexPath? {
         didSet {
              print("GONNA DROP IN: \(currentIndexPath?.row)")
         }
    }
    
    var startIndexPath: IndexPath
}
