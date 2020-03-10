//
//  HomeViewController.swift
//  SwiftUITest
//
//  Created by Plamen Atanasov on 6.01.20.
//  Copyright © 2020 Plamen Atanasov. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet var tableView: ReorderTableView!
    
    private let numberOfCells = 40
    private var cellsContent: [String] {
        get {
            var cellArray: [String] = []
            for index in 0...numberOfCells-1 {
                cellArray.append("\(index)")
            }

            return cellArray
        }
    }
    
    private lazy var cells: [String] = cellsContent
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.reorderDelegate = self
        tableView.enableReorder()
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = cells[indexPath.row]
        return cell
    }
}

extension HomeViewController: ReorderTableViewDelegate {
    func rowChanged(at: IndexPath, to: IndexPath) {
        cells.swapAt(at.row, to.row)
        //print(cells)
    }
}
