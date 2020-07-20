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
    var game = RocketGameViewModel(gridSize: 6, numberOfColours: 4)
    
    var body: some View {
        NavigationView() {
            VStack {
                logoView()
                Spacer()
                NavigationLink(destination: RocketGameView(game: game)){
                    Text("Start").font(.largeTitle)
                }
                NavigationLink(destination: RocketGameView(game: game)){
                    Text("Resume").font(.largeTitle)
                }
                Spacer()
            }
            .navigationBarTitle("Rocket Game", displayMode: .large)
            .navigationBarItems(trailing:
                NavigationLink(destination:
                    SettingsView())
                {
                    Image(systemName: "gear").font(.body)
                }
            )
        }.accentColor(.red)
    }
}

struct Testing_Space_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

struct SettingsView: View {
    var names = ["Ocean", "Classic"
        ,"Classic G3", "Inferno", "Candy", "Bright", "UISystemColor", "Camo", "Forest"
    ]
    @State var value = 0
    
    var body: some View {
        List {
            
            Section(header: Text("Game Settings")) {
                numberOfPicker(what: "Rows", minmax: (3,12))
                numberOfPicker(what: "Colours", minmax: (2,8))
            }
            Section(header: Text("Colour Theme")) {
                ForEach((self.names.sorted()), id: \.self) { name in
                    ThemeChooser(name: name)
                }
            }
            Section(header: Text("Reset")) {
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                    HStack{
                        Text("Reset Saved Games")
                        Spacer()
                        Image(systemName: "exclamationmark.triangle")
                    }
                }
                .foregroundColor(.red)
            }
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                HStack{
                    Text("Reset Saved Games")
                    Spacer()
                    Image(systemName: "exclamationmark.octagon")
                }
                .foregroundColor(.red)
            }
            
        }.navigationBarTitle("Settings", displayMode: .inline)
    }
}




struct ThemeChooser: View {
    
    var currentPalleteName = "Classic"
    var name: String
    init(name: String) {
        self.name = name
    }
    var isSelected: Bool {
        self.name == currentPalleteName
    }
    var body: some View {
        HStack {
            VStack {
                HStack {
                    Text(name).font(.caption)
                    Spacer()
                }
                HStack {
                    ForEach(0 ..< 7) { number in
                        RocketView(id: number, colourNumber: number, direction: 1)
                            .aspectRatio(1.0, contentMode: .fit)
                    }
                    Spacer()
                    
                }
            }
            Group {
                if isSelected {
                    Image(systemName: "checkmark.square.fill")
                } else {
                    Image(systemName: "square")
                }
            }.padding(.leading)
        }
    }
}

struct numberOfPicker: View {
    
    var what: String
    var minmax: (Int, Int)
    @State var value = 0
    
    init(what: String, minmax: (Int, Int)) {
        self.what = what
        self.minmax = minmax
        self.value = minmax.0
    }
    
    var body: some View {
        HStack {
            Stepper(value: $value, in: minmax.0...minmax.1) {
                Text("Number of \(what)")
            }
            //            Spacer()
            Text("\(value)")
                .foregroundColor(.accentColor)
                .bold()
        }
        
    }
}


struct logoView: View {
    var body: some View {
        ZStack {
            Group {
                Image("stars")
                    .resizable()
                    .clipShape(Circle())
//                    .clipShape(RoundedRectangle(cornerRadius: 20))
                RocketView(id: 0, colourNumber: 0, direction: 1)
                    .scaleEffect(0.8)
            }
            .padding()
//            .clipped()
            .aspectRatio(1.0, contentMode: .fit)
        }
    }
}
