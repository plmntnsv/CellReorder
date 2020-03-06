//
//  AnimalCell.swift
//  SwiftUITest
//
//  Created by Plamen Atanasov on 27.11.19.
//  Copyright © 2019 Plamen Atanasov. All rights reserved.
//

import SwiftUI

struct AnimalCell: View {
    let animal: Animal
    @State private var presentInfo: Bool = false
    
    var body: some View {
        HStack {
            Image(animal.imageName)
                .resizable()
                .frame(width: 50.0, height: 50.0)
                .cornerRadius(/*@START_MENU_TOKEN@*/30.0/*@END_MENU_TOKEN@*/)
            VStack(alignment: .leading) {
                Text(animal.name)
                    .font(.headline)
                Text(animal.name)
                    .font(.subheadline)
                    .foregroundColor(Color.gray)
            }
            Spacer()
            Image(systemName: "arrow.up.circle")
                .foregroundColor(.gray)
                .padding(.trailing, 20)
            
        }
        .contentShape(Rectangle())
        .onTapGesture {
            self.presentInfo = true
        }
        .sheet(isPresented: self.$presentInfo, onDismiss: updateUI) {
            AnimalDetails(showModal: self.$presentInfo, animal: self.animal)
        }
        .background(presentInfo ? Color(#colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)) : Color.clear)
    }
    
    private func updateUI() {
        presentInfo = false
    }
}


struct AnimalCell_Previews: PreviewProvider {
    static var previews: some View {
        AnimalCell(animal: allAnimals[5])
    }
}
