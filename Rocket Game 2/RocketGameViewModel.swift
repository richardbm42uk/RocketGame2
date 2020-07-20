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
    @Published var over : Bool = false
    
    @Published var rocketLayers: [rocketLayer] = []
    
    var startturns = 0
    var needsReset: Bool = false
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
//    animationCount = animationCount + 0.5
    update()
}

func reset() {
//    print("Reset")
//    print(over)
    needsReset = false
    game.resetGame()
    score = game.gameScore
    thisTurn = game.rocketsDestroyedThisRound.count
    total = game.allRocketsDestroyedThisGame.count
    update()
//    animationCount = 0
}
    
    func newGame() {
        self.game = RocketModel(gridSize: self.gameGridSize, numberOfColours: self.numberOfColours)
        reset()
        turns = startturns
        over = false
        print(game)
    }
    

} // End of GameView

struct rocketLayer: View, Identifiable {
    
    var rocket: RocketView
    let gridPosition: Int
    let gridSize: Int
    let id: Int
    
    func setSize(size: CGSize) -> CGSize{
            return CGSize(
                width: size.width / CGFloat(gridSize),
                height: size.height / CGFloat(gridSize)
            )
        }

    func setPosition(size: CGSize) -> CGPoint {
    return CGPoint(
        x: (CGFloat(self.gridPosition % self.gridSize) + 0.5) * self.setSize(size: size).width,
        y: (CGFloat(self.gridPosition / self.gridSize) + 0.5) * self.setSize(size: size).height
    )
    
}
    
    init(rocket: RocketView, gridPosition: Int, gridSize: Int ) {
        self.rocket = rocket
        self.gridPosition = gridPosition
        self.gridSize = gridSize
        self.id = self.rocket.id
    }
    
var body: some View {
    GeometryReader { geometry in
        self.rocket
            .frame(width: self.setSize(size: geometry.size).width, height: self.setSize(size: geometry.size).height)
            .position(self.setPosition(size: geometry.size))
        }
    }
}


struct RocketGameViewModel_Previews: PreviewProvider {
    static var previews: some View {
        RocketGameView(game: RocketGameViewModel(gridSize: 7, numberOfColours: 6))
    }
}
