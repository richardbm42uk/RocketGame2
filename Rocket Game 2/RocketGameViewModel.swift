//
//  RocketGameViewModel.swift
//  Rocket Game 2
//
//  Created by Richard Brown-Martin on 11/07/2020.
//  Copyright © 2020 Richard Brown-Martin. All rights reserved.
//

import SwiftUI

class RocketGameViewModel: ObservableObject {
    
    var landscape = false // annoyingly needed but not wanted.
    
    // Important game variables
    
    private var game: RocketModel
    private var gameGridSize: Int
    var numberOfColours: Int
    var realGridSize: Int {
        gameGridSize+2
    }
    @Published var gameInMotion = false
    
    @Published var gameGrid: [RocketView] = []
    
    @Published var score = 0
    
    
    func update() {
        gameInMotion = true
        var graphicalGrid = [RocketView]()
        for cell in game.RocketGrid{
            if !cell.isEmpty {
                let topRocket = cell[cell.count-1]
                graphicalGrid.append(RocketView(Rocket: topRocket))
        }
    }
    gameGrid = graphicalGrid
    score = game.gameScore
    gameInMotion = false
}

init(gridSize: Int, numberOfColours: Int) {
    self.numberOfColours = numberOfColours
    self.gameGridSize = gridSize
    self.game = RocketModel(gridSize: self.gameGridSize, numberOfColours: self.numberOfColours)
    update()
}


// MARK: - Intents

func start(rocketID: Int) {
    game.start(id: rocketID)
    update()
    
}

func go() {
    game.go()
    print(gameGrid)
    update()
}

func reset() {
    game.resetGame()
    print(gameGrid)
    update()
}

} // End of GameView

