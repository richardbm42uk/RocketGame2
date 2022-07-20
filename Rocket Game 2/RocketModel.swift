//
//  RocketModel.swift
//  Rocket Game 2
//
//  Created by Richard Brown-Martin on 12/07/2020.
//  Copyright © 2020 Richard Brown-Martin. All rights reserved.
//

import Foundation

struct RocketModel {
    // Main Variables
    var RocketGrid = [[RocketStruct]()]
    var gridSize = 6
    private var rocketID = 0
    var numberofSpaces: Int {
        return ((gridSize + 2) * (gridSize + 2))-1
    }
    private var unusableSpaceList = [Int]()
    var numberOfColours = 3
    var rocketsDestroyedThisRound: [Int] = []
    var allRocketsDestroyedThisGame: [Int] = []
    var gameScore = 0
    private var gameScoreMultiplier = 10
    
    var inProgress: Bool {
        !rocketsInMotion.isEmpty
    }

    
    var needsReset: Bool = false
    
    // Game variables
    var rocketsInMotion: [Int] = []
    var rocketsOutOfBounds: [(Int)] {
        var outOfBounds =  [(Int)]()
        for cell in unusableSpaceList {
            let thiscell = RocketGrid[cell]
            if !thiscell.isEmpty {
                outOfBounds.append((cell))
            }
        }
        return outOfBounds
    }
    
    // Initialiser
    init(gridSize: Int, numberOfColours: Int) {
        self.numberOfColours = numberOfColours
        self.gridSize = gridSize
        self.unusableSpaces()
        self.createGrid()
        self.populateGrid()
        
    }
    
    // Setup Functions
    mutating func unusableSpaces() -> Void { // this function works out the unusable grid spaces around the edge
        for anumber in 0...(gridSize+1) { // go through the top row
            unusableSpaceList.append(anumber) // mark the top row as unusable
            unusableSpaceList.append(numberofSpaces - anumber) // mark the bottom row as unusable
        }
        for anumber in 1...gridSize { // go down the sides
            unusableSpaceList.append((gridSize+2)*anumber) // mark the left edge as unusable
            unusableSpaceList.append(((gridSize+2)*(anumber+1))-1) // mark the right edge as unusable
        }
        unusableSpaceList.sort()
    }
    
    mutating func createGrid() -> Void {
        for _ in 0..<numberofSpaces { // for the number of spaces
            RocketGrid.append([RocketStruct]()) // create an empty array
        }
    }
    
    
    mutating func populateGrid() -> Void { // fill in empty gaps in the grid
        for cell in 0..<numberofSpaces { // go through all the cells
            if !unusableSpaceList.contains(cell) { // if it's not on the edge
                var thiscell = RocketGrid[cell] // get the array in the cell
                if thiscell.isEmpty { // and if it's empty
                    rocketID = rocketID + 1 // incrememt the rocket id tracker
                    thiscell.append(RocketStruct(id: rocketID, colourNumber: Int.random(in: 0..<numberOfColours), direction: Int.random(in: 0...7))) // create a new random rocket in an array
                    RocketGrid[cell] = thiscell // and assign that to the cell in the grid
                }
            }
        }
    }
    
    // Game Functions
    
    mutating func go() -> Void {  // Go!
        if !rocketsInMotion.isEmpty {
            // print("Out of Bounds \(rocketsOutOfBounds)")
            removeOutOfBounds() // remove any rockets that have fallen off the grid
            // print("Rockets in Motion \(rocketsInMotion)")
            checkForHits() // check if any rockets have hit and need to start moving
            for rocket in rocketsInMotion { // go through rockets that need to move
                moveOneRocket(id: rocket) // and move them!
            }
        } else {
            needsReset = true
        }
        
    }
    
    mutating func start(id: Int) -> Void {
        rocketsDestroyedThisRound = [] //reset the score of rockets set off last round
        rocketsInMotion.append(id) // add the rocket to the list of those that need to be in motion
        //self.go() // start the round
    }
    
    mutating func scoring() -> Void {
           gameScore = gameScore+(rocketsDestroyedThisRound.count*rocketsDestroyedThisRound.count*gameScoreMultiplier)
//        print(gameScore)
       }
       
       mutating func resetGame() -> Void {
        needsReset = false
           scoring()
           populateGrid()
       }
    
    mutating func removeOutOfBounds() -> Void {
        if !rocketsOutOfBounds.isEmpty { //if there are any rockets out of bounds
            for cell in rocketsOutOfBounds { // go through all the cells
                if !RocketGrid[cell].isEmpty { // if one isn't empty
                    for rocket in RocketGrid[cell] { // go through any rockets in it
                        rocketsInMotion = rocketsInMotion.filter {$0 != rocket.id } // remove rockets from the list of rockets in motion
                    }
                    RocketGrid[cell] = [] // then erase that grid space
                }
            }
        }
    }
    
    mutating func moveOneRocket(id: Int) -> Void {
        let start = findARocket(id: id)
        if !unusableSpaceList.contains(start.1!){
            var end = 0
            switch start.0?.direction {
            case 0:
                end = start.1! - (gridSize+2)
            case 1:
                end = start.1! - (gridSize+1)
            case 2:
                end = start.1!+1
            case 3:
                end = start.1! + (gridSize+3)
            case 4:
                end = start.1! + (gridSize+2)
            case 5:
                end = start.1! + (gridSize+1)
            case 6:
                end = start.1!-1
            case 7:
                end = start.1! - (gridSize+3)
            default:
                end = start.1!
            }
            var startCell = RocketGrid[start.1!]
            startCell = startCell.filter {$0 != start.0! }
            RocketGrid[start.1!] = startCell
            RocketGrid[end].append(start.0!)
        }
    }
    
    func findARocket(id: Int) -> (RocketStruct?,Int?) { // takes an rocket id number and returns the rocket's struct and grid location
        for cell in 0..<numberofSpaces { // go through all the cells in the grid
            let thisCell = RocketGrid[cell] // grab out the array of rockets
            if !thisCell.isEmpty { // if the array isn't empty
            for rocket in thisCell { // go through those rockets
                if rocket.id == id { // check if it's the rocket we are looking for
                    return (rocket,cell) // return it
                }
            }
            }
        }
        return (nil, nil) // else return nil - the rocket doesn't exist in the grid
    }
    
    func findAGrid(cell: Int) -> (Int?) {
        let thisCell = RocketGrid[cell]
        return thisCell[thisCell.count-1].id
    }
        
    
    mutating func checkForHits() -> Void {
        for rocket in rocketsInMotion { // go through all the moving rockets
            let rocketA = findARocket(id: rocket) // get the rocket and its position
            let celltoCheck = RocketGrid[rocketA.1!] // grab the cell it was in
            if celltoCheck.count > 1 { // check if there's any other rockets in that cell
                for rocketB in celltoCheck { // go through the rockets in the cell
                    if rocketB.id != rocketA.0!.id { // if it's not the one we're already checking
                        if !rocketsInMotion.contains(rocketB.id) { // and if it's not already moving
                            if rocketB.colourNumber == rocketA.0!.colourNumber { // and if it's got the same colour
                                rocketsInMotion.append(rocketB.id) // add it to the moving rockets
                            }
                        }
                    }
                }
            }
        }
        for id in rocketsInMotion { // once moving which rockets is set, add them to the records for scoring
            if !rocketsDestroyedThisRound.contains(id) {
                rocketsDestroyedThisRound.append(id)
                allRocketsDestroyedThisGame.append(id)
            }
        }
    }
    
} //End of Model




// Rocket Struct

struct RocketStruct: Identifiable, Equatable, Hashable, CustomStringConvertible {
    
    var colourNumber: Int
    var direction: Int
    var id: Int
    var isVisible: Bool = true
    init(id: Int, colourNumber: Int, direction: Int) {
        self.id = id
        self.colourNumber = colourNumber
        self.direction = direction
    }
    private let directions = ["⬆️","↗️","➡️","↘️","⬇️","↙️","⬅️","↖️"]
    private let colourList = ["🔴","🔵","🟡","🟢","🟣","🟠","🟤","⚫️"]
    var description: String {
        
        
        return "R\(self.id), \(self.directions[direction]), \(self.colourList[colourNumber])"
    }
}

