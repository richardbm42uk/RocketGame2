//
//  RocketView.swift
//  Rocket Game 2
//
//  Created by Richard Brown-Martin on 14/07/2020.
//  Copyright © 2020 Richard Brown-Martin. All rights reserved.
//

import SwiftUI



struct RocketView: View, Identifiable, CustomStringConvertible {
    
    
    
    var colourNumber: Int
    var direction: Int
    var angleOfDirection: Angle {
        return Angle(degrees: Double(-360*direction*7/8))
    }
    var rocketColour: UIColor {
        return colourpallette[colourNumber]
    }
    var isVisible: Bool = true
    var id: Int = 0
    
    var opacity: Double {
        if self.isVisible {
            return 1.0
        }
        return 0.0
    }

    
    init(id: Int, colourNumber: Int, direction: Int) {
        self.id = id
        self.colourNumber = colourNumber
        self.direction = direction
    }
    
    init(invisible: Bool) {
        isVisible = false
        self.colourNumber = 1
        self.direction = 0
    }
    
    init(Rocket: RocketStruct) {
        self.id = Rocket.id
        self.colourNumber = Rocket.colourNumber
        self.direction = Rocket.direction
    }
    
    private var colourpallette = [UIColor.red, UIColor.blue, UIColor.yellow, UIColor.green, UIColor.purple, UIColor.brown, UIColor.gray]
    private let directions = ["⬆️","↗️","➡️","↘️","⬇️","↙️","⬅️","↖️"]
    private let colourList = ["🔴","🔵","🟡","🟢","🟠","🟣","🟤","⚫️"]
    internal var description: String {
        if self.isVisible {
        return "\(id),\(directions[direction]), \(colourList[colourNumber])"
        }
        return "⚪️"
    }
    
    var body: some View {
        ZStack {
            Group {
                Image("rocketshape")
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                Image("rocketdetail")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipped()
            }
            .rotationEffect(angleOfDirection)
            .scaleEffect(rocketImageScaleFactor)
            .shadow(color: Color(UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)), radius: rocketShadowSize, x: rocketShadowSize, y: rocketShadowSize)
        }
        .foregroundColor(Color(rocketColour))
        .opacity(opacity)
    }
    
    
    var rocketImageScaleFactor: CGFloat = 0.7
    var rocketShadowSize: CGFloat = 5
    
}

struct RocketStackView: View {
    init(rocketStack: [RocketView]) {
        self.rocketStack = rocketStack
    }
    var rocketStack: [RocketView]
    var body: some View {
    ZStack {
        ForEach(rocketStack){ rocket in
            rocket
        }
        }
    }
}
