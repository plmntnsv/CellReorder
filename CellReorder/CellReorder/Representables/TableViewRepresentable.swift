//
//  TableViewRepresentable.swift
//  SwiftUITest
//
//  Created by Plamen Atanasov on 6.01.20.
//  Copyright © 2020 Plamen Atanasov. All rights reserved.
//

import SwiftUI

struct TableVCRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: UIViewControllerRepresentableContext<TableVCRepresentable>) -> UIViewController {
        let tableVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController()!
        
        return tableVC
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<TableVCRepresentable>) {
    }
}
