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
    var RocketGrid: [[RocketStruct]] = []
    var gridSize = 6
    private var rocketID = 0

    var numberofSpaces: Int {
        (gridSize + 2) * (gridSize + 2)
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

    var rocketDirection = Int.random(in: 0...7)
    var rocketColour = 1

    var needsReset: Bool = false

    // Game variables
    var rocketsInMotion: [Int] = []

    var rocketsOutOfBounds: [Int] {
        var outOfBounds = [Int]()
        for cell in unusableSpaceList where cell < RocketGrid.count {
            if !RocketGrid[cell].isEmpty {
                outOfBounds.append(cell)
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
    mutating func unusableSpaces() {
        unusableSpaceList.removeAll()
        let fullWidth = gridSize + 2

        // top and bottom rows
        for number in 0..<fullWidth {
            unusableSpaceList.append(number)
            unusableSpaceList.append(numberofSpaces - fullWidth + number)
        }

        // left and right columns
        for row in 1...gridSize {
            unusableSpaceList.append(fullWidth * row)
            unusableSpaceList.append((fullWidth * (row + 1)) - 1)
        }

        unusableSpaceList = Array(Set(unusableSpaceList)).sorted()
    }

    mutating func createGrid() {
        RocketGrid = Array(repeating: [], count: numberofSpaces)
    }

    mutating func populateGrid() {
        for cell in 0..<numberofSpaces where !unusableSpaceList.contains(cell) {
            if RocketGrid[cell].isEmpty {
                rocketID += 1

                let newRocketDirection = Int.random(in: 0...7)
                let newRocketColour = Int.random(in: 0..<numberOfColours)

                if rocketColour == newRocketColour {
                    rocketColour = Int.random(in: 0..<numberOfColours)
                } else {
                    rocketColour = newRocketColour
                }

                if rocketDirection == newRocketDirection {
                    rocketDirection = Int.random(in: 0...7)
                } else {
                    rocketDirection = newRocketDirection
                }

                RocketGrid[cell].append(
                    RocketStruct(
                        id: rocketID,
                        colourNumber: rocketColour,
                        direction: rocketDirection
                    )
                )
            }
        }
    }

    // Game Functions

    mutating func go() {
        if !rocketsInMotion.isEmpty {
            removeOutOfBounds()
            checkForHits()

            let movingRockets = rocketsInMotion
            for rocket in movingRockets {
                moveOneRocket(id: rocket)
            }
        } else {
            needsReset = true
        }
    }

    mutating func start(id: Int) {
        guard findARocket(id: id).0 != nil else { return }
        rocketsDestroyedThisRound = []

        if !rocketsInMotion.contains(id) {
            rocketsInMotion.append(id)
        }
    }

    mutating func scoring() {
        gameScore += rocketsDestroyedThisRound.count * rocketsDestroyedThisRound.count * gameScoreMultiplier
    }

    mutating func resetGame() {
        needsReset = false
        scoring()
        populateGrid()
    }

    mutating func removeOutOfBounds() {
        guard !rocketsOutOfBounds.isEmpty else { return }

        for cell in rocketsOutOfBounds {
            guard !RocketGrid[cell].isEmpty else { continue }

            for rocket in RocketGrid[cell] {
                rocketsInMotion.removeAll { $0 == rocket.id }
            }

            RocketGrid[cell] = []
        }
    }

    mutating func moveOneRocket(id: Int) {
        let foundRocket = findARocket(id: id)
        guard let rocket = foundRocket.0, let startCellIndex = foundRocket.1 else { return }
        guard !unusableSpaceList.contains(startCellIndex) else { return }

        let end: Int
        switch rocket.direction {
        case 0:
            end = startCellIndex - (gridSize + 2)
        case 1:
            end = startCellIndex - (gridSize + 1)
        case 2:
            end = startCellIndex + 1
        case 3:
            end = startCellIndex + (gridSize + 3)
        case 4:
            end = startCellIndex + (gridSize + 2)
        case 5:
            end = startCellIndex + (gridSize + 1)
        case 6:
            end = startCellIndex - 1
        case 7:
            end = startCellIndex - (gridSize + 3)
        default:
            end = startCellIndex
        }

        guard RocketGrid.indices.contains(end) else { return }

        RocketGrid[startCellIndex].removeAll { $0.id == rocket.id }
        RocketGrid[end].append(rocket)
    }

    func findARocket(id: Int) -> (RocketStruct?, Int?) {
        for cell in 0..<numberofSpaces {
            let thisCell = RocketGrid[cell]
            if !thisCell.isEmpty {
                for rocket in thisCell where rocket.id == id {
                    return (rocket, cell)
                }
            }
        }
        return (nil, nil)
    }

    func findAGrid(cell: Int) -> Int? {
        guard RocketGrid.indices.contains(cell), !RocketGrid[cell].isEmpty else { return nil }
        return RocketGrid[cell][RocketGrid[cell].count - 1].id
    }

    mutating func checkForHits() {
        let currentMovingRockets = rocketsInMotion

        for rocketID in currentMovingRockets {
            let foundRocket = findARocket(id: rocketID)
            guard let rocketA = foundRocket.0, let cellIndex = foundRocket.1 else { continue }

            let cellToCheck = RocketGrid[cellIndex]
            if cellToCheck.count > 1 {
                for rocketB in cellToCheck where rocketB.id != rocketA.id {
                    if !rocketsInMotion.contains(rocketB.id) && rocketB.colourNumber == rocketA.colourNumber {
                        rocketsInMotion.append(rocketB.id)
                    }
                }
            }
        }

        for id in rocketsInMotion {
            if !rocketsDestroyedThisRound.contains(id) {
                rocketsDestroyedThisRound.append(id)
                if !allRocketsDestroyedThisGame.contains(id) {
                    allRocketsDestroyedThisGame.append(id)
                }
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
        "R\(self.id), \(self.directions[direction]), \(self.colourList[colourNumber])"
    }
}
