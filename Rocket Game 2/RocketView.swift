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
    
    private var colourpallette = [UIColor.systemRed, UIColor.systemBlue, UIColor.systemYellow, UIColor.systemGreen, UIColor.systemPink, UIColor.systemTeal, UIColor.systemOrange, UIColor.systemGray]
    private let directions = ["⬆️","↗️","➡️","↘️","⬇️","↙️","⬅️","↖️"]
    private let colourList = ["🔴","🔵","🟡","🟢","🟠","🟣","🟤","⚫️"]
    internal var description: String {
        if self.isVisible {
        return "\(id),\(directions[direction]), \(colourList[colourNumber])"
        }
        return "⚪️"
    }
    
    var body: some View {
        GeometryReader { geo in
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
            .rotationEffect(self.angleOfDirection)
//            .scaleEffect(self.rocketImageScaleFactor)
                .shadow(color: self.rocketShadowColour, radius: self.rocketShadowSize*geo.size.width, x: self.rocketShadowSize*geo.size.width, y: self.rocketShadowSize*geo.size.width)
        }
        .foregroundColor(Color(self.rocketColour))
        .opacity(self.opacity)
    }
    }
    
//    var rocketImageScaleFactor: CGFloat = 0.7
    var rocketShadowSize: CGFloat = (2 / 100)
    var rocketShadowColour: Color = Color((UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)))
    
}

struct RocketView_Previews: PreviewProvider {
    static var previews: some View {
        RocketView(id: 0, colourNumber: 7, direction: 1)
    }
}

struct RocketGameView_Previews_2: PreviewProvider {
    static var previews: some View {
        RocketGameView(game: RocketGameViewModel(gridSize: 7, numberOfColours: 8))
    }
}
