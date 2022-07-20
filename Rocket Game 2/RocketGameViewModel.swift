//
//  RocketGameViewModel.swift
//  Rocket Game 2
//
//  Created by Richard Brown-Martin on 11/07/2020.
//  Copyright © 2020 Richard Brown-Martin. All rights reserved.
//

import SwiftUI

class RocketGameViewModel: ObservableObject, CustomStringConvertible {
    
    
    var description: String {
        String("\(game)")
    }
    
    
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
    @Published var over : Bool = false
    
    @Published var rocketLayers: [rocketLayer] = []
    
    var startturns = 0
    var needsReset: Bool
    var score = 0
    var turns: Int
    var thisTurn = 0
    var total = 0
    
    func update() {
        var tempgrid: [rocketLayer] = [] // all the rockets in layers
        var foregrid: [rocketLayer] = [] // the ones in motion get made up separately and tacked on at the end to keep them in front
        for cellnum in 0..<game.RocketGrid.count{
            let cell = game.RocketGrid[cellnum]
            if cell.isEmpty {
                tempgrid.append(rocketLayer(rocket: RocketView(invisible: true), gridPosition: cellnum, gridSize: realGridSize))
            } else {
                for rocket in cell {
                    let layer = rocketLayer(rocket: RocketView(Rocket: rocket), gridPosition: cellnum, gridSize: realGridSize)
                    if game.rocketsInMotion.contains(rocket.id) {
                        foregrid.append(layer)
                    } else {
                        tempgrid.append(layer)
                    }
                }
            }
        }
        tempgrid.append(contentsOf: foregrid)
        rocketLayers = tempgrid
        controller()
    }
    
    private let rocketSpeedConstant = 0.3
    
    
    init(gridSize: Int, numberOfTurns: Int = 10, numberOfColours: Int) {
        needsReset = false
        self.startturns = numberOfTurns
        self.turns = numberOfTurns
        self.numberOfColours = numberOfColours
        self.gameGridSize = gridSize
        self.game = RocketModel(gridSize: self.gameGridSize, numberOfColours: self.numberOfColours)
        update()
    }
    
    func staus()
    {
        print ("Model \(game.RocketGrid)")
        print ("Graphics \(rocketLayers)")
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
        if game.inProgress {
            DispatchQueue.main.asyncAfter(deadline: .now() + rocketSpeedConstant) {
                withAnimation(.linear(duration: self.rocketSpeedConstant)){
                    self.go()
                }
            }
        } else {
            if needsReset {
                DispatchQueue.main.asyncAfter(deadline: .now() + rocketSpeedConstant) {
                    withAnimation(Animation.easeInOut(duration: 1.0)){
                        self.reset()
                        if self.turns < 1 {
                            self.over = true
                        }
                    }
                }
            }
        }
        
    }
    
    func go() {
        game.go()
        update()
    }
    
    func reset() {
        needsReset = false
        game.resetGame()
        score = game.gameScore
        thisTurn = game.rocketsDestroyedThisRound.count
        total = game.allRocketsDestroyedThisGame.count
        update()
    }
    
    func newGame() {
        self.game = RocketModel(gridSize: self.gameGridSize, numberOfColours: self.numberOfColours)
        reset()
        turns = startturns
        over = false
//        print(game)
    }
    
    
} // End of GameView

