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
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.yellow) // background
            VStack {
                Group {
                    ZStack {
                        Image("stars")
                            .resizable()
                        
                        HStack {
                            Grid(game.gameGrid) { rocket in
                                rocket
                                    .onTapGesture {
                                        if !self.game.inProgress {
                                            self.animate = true
                                            self.game.start(rocketID: rocket.id)
                                            
                                        }
                                        
                                        
                                }
                            }
                            
                        }
                        .scaleEffect(1.3)
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
            if game.turns < 1 {
                RoundedRectangle(cornerRadius: 10.0)
                    .padding()
                    .foregroundColor(Color.white)
                    .opacity(0.8)
                    .animation(.easeIn(duration: 0.1))
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
