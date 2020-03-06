//
//  Animal.swift
//  SwiftUITest
//
//  Created by Plamen Atanasov on 20.11.19.
//  Copyright © 2019 Plamen Atanasov. All rights reserved.
//

import Foundation

enum AnimalType: String, CaseIterable {
    case cat, dog, lion, horse, hippo, elephant, parrot, pig
}

struct Animal: Identifiable {
    var id = UUID()
    let type: AnimalType
    
    var imageName: String {
        return type.rawValue
    }
    
    var name: String {
        return type.rawValue.capitalized
    }
}


