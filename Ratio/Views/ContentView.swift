//
//  ContentView.swift
//  Ratio
//
//  Created by Philip Müller on 07/11/2020.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @ObservedObject var vm = ParentViewModel()
    
    var body: some View {
        Text("Will be back soon...")
    }
}

class ParentViewModel: ObservableObject {
    @Published var proposition: Proposition?
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}



