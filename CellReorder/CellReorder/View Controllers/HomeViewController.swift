//
//  HomeViewController.swift
//  SwiftUITest
//
//  Created by Plamen Atanasov on 6.01.20.
//  Copyright © 2020 Plamen Atanasov. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    private let cells: [String] = ["Cell 1", "Cell 2", "Cell 3", "Cell 4"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
