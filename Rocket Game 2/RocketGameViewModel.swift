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
    var inProgress: Bool {
        game.inProgress
    }
    
//    @Published var graphics: Bool = true
     
//    @Published var gameGrid: [RocketView] = []
    var gameGrid: [RocketView] = []
    
    var needsReset: Bool = false
    
    var score = 0
    
    var turns = 10
    
    func update() {
        var tempgrid: [RocketView] = []
        for cell in game.RocketGrid {
            if cell.isEmpty {
                tempgrid.append(RocketView(invisible: true))
            } else {
            tempgrid.append(RocketView(Rocket: cell[cell.count-1]))
        }
            gameGrid = tempgrid
            score = game.gameScore
            
            }
        controller()
    }
    
 

init(gridSize: Int, numberOfColours: Int) {
    self.numberOfColours = numberOfColours
    self.gameGridSize = gridSize
    self.game = RocketModel(gridSize: self.gameGridSize, numberOfColours: self.numberOfColours)
    update()
}
    
    func staus()
        {
        print ("Model \(game.RocketGrid)")
        print ("Graphics \(gameGrid)")
        print ("Game In Progress \(inProgress) Game Needs Reset \(needsReset)")
    }


// MARK: - Intents

func start(rocketID: Int) {
    if turns > 0 {
    game.start(id: rocketID)
    needsReset = true
    withAnimation(.linear){
        controller()
    }
    turns = turns-1
}
    }

    func controller() {
        if game.inProgress {
                go()
        } else {
        if needsReset {
            reset()
        }
    }
        objectWillChange.send()
//        updateGraphics()
        }
    
func go() {
    game.go()
    update()
}
//    func updateGraphics(){
//        graphics = !graphics
//    }

func reset() {
    print("Reset")
    needsReset = false
    game.resetGame()
    score = game.gameScore
    update()
    
    
}

} // End of GameView

