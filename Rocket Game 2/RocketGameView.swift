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
//    @State private var animate = false
    
    var scaleFactor: CGFloat {
        1.0 + (2.0 / CGFloat(game.realGridSize-1))
    }
    
    var body: some View {
        GeometryReader { geometry in
        ZStack {
                        Rectangle()
                            .fill(Color.black) // background
            if geometry.size.width < geometry.size.height {
            VStack {
                Group {
                    ZStack {
                        Image("stars")
                            .resizable()
                        ZStack {
                            ForEach(self.game.rocketLayers) { rocket in
                                rocket
                                    .onTapGesture {
                                        if !self.game.inProgress {
                                            self.game.start(rocketID: rocket.id)
                                        }
                                }
                            }
                        }
                        .scaleEffect(self.scaleFactor)
                        .clipped()
                    }.aspectRatio(1.0, contentMode: .fit)
                    Group {
                        Spacer()
                        VStack {
                        Text("Score: \(self.game.score)")
                        Text("Rockets this turn: \(self.game.thisTurn)")
                        Text("Rockets total: \(self.game.total)")
                        Text("Turns remaining: \(self.game.turns)")
                        }.foregroundColor(Color.white)
                        Spacer()
                    }
                    .font(.largeTitle)
                    .foregroundColor(Color.white)
                    .animation(.none)
                }
                }
            } else {
                HStack {
                    Group {
                        ZStack {
                            Image("stars")
                                .resizable()
                            ZStack {
                                ForEach(self.game.rocketLayers) { rocket in
                                    rocket
                                        .onTapGesture {
                                            if !self.game.inProgress {
                                                self.game.start(rocketID: rocket.id)
                                            }
                                    }
                                }
                            }
                            .scaleEffect(self.scaleFactor)
                            .scaledToFit()
                            .clipped()
                        }.aspectRatio(1.0, contentMode: .fit)
                        Group {
                            Spacer()
                            VStack {
                            Text("Score: \(self.game.score)")
                            Text("Rockets this turn: \(self.game.thisTurn)")
                            Text("Rockets total: \(self.game.total)")
                            Text("Turns remaining: \(self.game.turns)")
                            }.foregroundColor(Color.white)
                            Spacer()
                        }
                        .font(.largeTitle)
                        .foregroundColor(Color.white)
                        .animation(.none)
                    }
                    }
                
            }
            
            
            if self.game.over {
                GameOver(game: self.game)
            }
        }.edgesIgnoringSafeArea(.bottom)
    }.navigationBarTitle("Rocket Game", displayMode: .inline)
}

    mutating func reset() {
        game = RocketGameViewModel(gridSize: 6, numberOfColours: 5)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RocketGameView(game: RocketGameViewModel(gridSize: 5, numberOfColours: 6))
            .previewDevice("iPhone 11")
        
    }
}

