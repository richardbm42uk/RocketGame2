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
    
//    @State private var isAnimating = true
    
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
    var animationCount = 0.0
    
//    @Published var graphics: Bool = true
     
    @Published var gameGrid: [RocketView] = []
//    var gameGrid: [RocketView] = []
    
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
    
    private let rocketSpeedConstant = 0.3
 

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
    controller()
    turns = turns-1
}
    }

    func controller() {
        print(animationCount)
        if game.inProgress {
            DispatchQueue.main.asyncAfter(deadline: .now() + rocketSpeedConstant) {
                withAnimation(.linear(duration: self.rocketSpeedConstant)){
                self.go()
//                isAnimating.toggle()
            }
            }
        } else {
        if needsReset {
            DispatchQueue.main.asyncAfter(deadline: .now() + rocketSpeedConstant) {
                withAnimation(Animation.easeInOut(duration: 1.0)){
                self.reset()
//                self.isAnimating.toggle()
            }
            }
        }
    }
        
//        objectWillChange.send()
//        updateGraphics()
        }
    
func go() {
    game.go()
    animationCount = animationCount + 0.5
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
    animationCount = 0
}
    

} // End of GameView

