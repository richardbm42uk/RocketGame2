//
//  Testing Space.swift
//  Rocket Game 2
//
//  Created by Richard Brown-Martin on 16/07/2020.
//  Copyright © 2020 Richard Brown-Martin. All rights reserved.
//

import SwiftUI
import Combine

struct Testing_Space: View {
    @State private var showSettings = false
    
    var body: some View {
        NavigationView() {
            ZStack {
                //            Rectangle()
                //                .foregroundColor(.black)
                NavigationLink(destination: RocketGameView(game: RocketGameViewModel(gridSize: 6, numberOfColours: 4))){
                    Text("Start").font(.largeTitle)
                }
                .navigationBarItems(trailing:
                    NavigationLink(destination:
                         SettingsView())
                    {
                        Image(systemName: "gear").font(.body)
                        }
                )
                
            }
                
                
            .navigationBarTitle("Rocket Game", displayMode: .large)
        }.accentColor(.red)
    }
}

struct Testing_Space_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

struct SettingsView: View {
    var body: some View {
        List {
            Section(header: Text("Game Settings")) {
                Text("Test")
            }
            Section(header: Text("Theme")) {
                ThemeChooser(name: "Classic")
                ThemeChooser(name: "Classic")
                ThemeChooser(name: "Classic")
                ThemeChooser(name: "Classic")
                ThemeChooser(name: "Classic")
            
        }
    }.navigationBarTitle("Settings", displayMode: .inline)
}
}

struct ThemeChooser: View {
    var name: String
    init(name: String) {
        self.name = name
    }
    var body: some View {
        VStack {
            HStack {
                Text(name).font(.caption)
                Spacer()
            }
        HStack {
            RocketView(id: 0, colourNumber: 0, direction: 1)
            RocketView(id: 1, colourNumber: 1, direction: 1)
            RocketView(id: 2, colourNumber: 2, direction: 1)
            RocketView(id: 3, colourNumber: 3, direction: 1)
            RocketView(id: 4, colourNumber: 4, direction: 1)
            RocketView(id: 5, colourNumber: 5, direction: 1)
            RocketView(id: 6, colourNumber: 6, direction: 1)
            Spacer()
        
    }
}
}
}
