//
//  RocketGrid.swift
//  Rocket Game 2
//
//  Created by Richard Brown-Martin on 16/07/2020.
//  Copyright © 2020 Richard Brown-Martin. All rights reserved.
//

import SwiftUI
//
//struct rocketLayer: View, Identifiable {
//    
//    var rocket: RocketView
//    let gridPosition: Int
//    let gridSize: Int
//    let id: Int
//    
//    func setSize(size: CGSize) -> CGSize{
//            return CGSize(
//                width: size.width / CGFloat(gridSize),
//                height: size.height / CGFloat(gridSize)
//            )
//        }
//
//    func setPosition(size: CGSize) -> CGPoint {
//    return CGPoint(
//        x: (CGFloat(self.gridPosition % self.gridSize) + 0.5) * self.setSize(size: size).width,
//        y: (CGFloat(self.gridPosition / self.gridSize) + 0.5) * self.setSize(size: size).height
//    )
//    
//}
//    
//    init(rocket: RocketView, gridPosition: Int, gridSize: Int ) {
//        self.rocket = rocket
//        self.gridPosition = gridPosition
//        self.gridSize = gridSize
//        self.id = self.rocket.id
//    }
//    
//var body: some View {
//    GeometryReader { geometry in
//        self.rocket
//            .frame(width: self.setSize(size: geometry.size).width, height: self.setSize(size: geometry.size).height)
//            .position(self.setPosition(size: geometry.size))
//        }
//    }
//}
//
