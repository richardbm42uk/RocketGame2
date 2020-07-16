//
//  ContentView.swift
//  Rocket Game 2
//
//  Created by Richard Brown-Martin on 11/07/2020.
//  Copyright © 2020 Richard Brown-Martin. All rights reserved.
//

import SwiftUI

struct RocketGameView: View {
    
    
    @ObservedObject var game: RocketGameViewModel
    @State private var animate = false
    
    var scaleFactor: CGFloat {
        1.0 + (2.0 / CGFloat(game.realGridSize-1))
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.yellow) // background
            VStack {
                Group {
                    ZStack {
                        Image("stars")
                            .resizable()
                        ZStack {
                            ForEach(game.rocketLayers) { rocket in
                                rocket
                                    .onTapGesture {
                                        if !self.game.inProgress {
                                            self.animate = true
                                            self.game.start(rocketID: rocket.id)
                                        }
                                }
                            }
                }
                .scaleEffect(self.scaleFactor)
                .clipped()
            }.aspectRatio(1.0, contentMode: .fit)
            Spacer()
            Text("Score: \(game.score)")
                .font(.largeTitle)
                .foregroundColor(Color.black)
            
            Text("Turns remaining: \(game.turns)")
                .font(.largeTitle)
                .foregroundColor(Color.black)
            Spacer()
        }
    }
    if game.over {
    RoundedRectangle(cornerRadius: 10.0)
    .padding()
    .foregroundColor(Color.white)
    .opacity(0.8)
    .transition(.scale)
    
    Text("Game Over")
    }
}.edgesIgnoringSafeArea(.bottom)
}
}














struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RocketGameView(game: RocketGameViewModel(gridSize: 3, numberOfColours: 3))
        
    }
}
