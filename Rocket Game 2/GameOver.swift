//
//  GaveOver.swift
//  Rocket Game 2
//
//  Created by Richard Brown-Martin on 16/07/2020.
//  Copyright © 2020 Richard Brown-Martin. All rights reserved.
//

import SwiftUI

struct GameOver: View {
    @ObservedObject var game: RocketGameViewModel

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10.0)
                .foregroundColor(.white)
                .opacity(0.9)
                .transition(.scale)

            VStack(alignment: .center) {
                RocketView(id: 0, colourNumber: 0, direction: 7)
                    .aspectRatio(1.0, contentMode: .fit)
                    .padding()

                VStack {
                    Spacer()
                    Text("Game Over")
                        .font(.largeTitle)
                    Spacer()
                    Text("Score: \(game.score)")
                        .font(.title)
                    Text("Total Destroyed: \(game.total)")
                        .font(.title)
                    Spacer()
                    Button(action: {
                        self.game.newGame()
                    }) {
                        Text("Restart")
                    }
                    Spacer()
                }
            }
            .padding()
        }
        .padding()
    }
}

struct TestingSpace_Previews: PreviewProvider {
    static var previews: some View {
        GameOver(game: RocketGameViewModel(gridSize: 4, numberOfColours: 5))
    }
}
