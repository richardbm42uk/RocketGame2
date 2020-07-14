//
//  ContentView.swift
//  Rocket Game 2
//
//  Created by Richard Brown-Martin on 11/07/2020.
//  Copyright © 2020 Richard Brown-Martin. All rights reserved.
//

import SwiftUI

struct RocketGameView: View {
    
    var game: RocketGameViewModel
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.yellow) // background
            if game.landscape {
                HStack {
                    Group {
                        ZStack {
                            Image("stars")
                                .resizable()
                                .aspectRatio(1.0, contentMode: .fit)
                            HStack {
                                ForEach(game.gameGrid) { rocket in
                                    rocket
                                        .onTapGesture {
                                            withAnimation(.linear(duration: 1)){
                                                self.game.start(rocketID: rocket.id)
                                                print(self.game.gameGrid)
                                            }
                                    }
                                }
                            }
                        }
                        Spacer()
                        Text("Score: ")
                            .font(.largeTitle)
                            .foregroundColor(Color.black)
                        
                        Text("Turns remaining: ")
                            .font(.largeTitle)
                            .foregroundColor(Color.black)
                        Spacer()
                    }
                }
            } else {
                VStack {
                    Group {
                        ZStack {
                            Image("stars")
                                .resizable()
                            VStack {
                                ForEach(game.gameGrid) { rocket in
                                    rocket
                                        .onTapGesture {
                                            withAnimation(.linear(duration: 1)){
                                                self.game.start(rocketID: rocket.id)
                                                print(self.game.gameGrid)
                                            }
                                    }
                                }
                            }
                        }.aspectRatio(1.0, contentMode: .fit)
                        Spacer()
                        Text("Score: \(game.score)")
                            .font(.largeTitle)
                            .foregroundColor(Color.black)
                        
                        Text("Turns remaining: ")
                            .font(.largeTitle)
                            .foregroundColor(Color.black)
                        Spacer()
                    }
                }
            }
        }.edgesIgnoringSafeArea(.bottom)
    }
}


struct RocketView: View, Identifiable, CustomStringConvertible {
    
    var colourNumber: Int
    var direction: Int
    var angleOfDirection: Angle {
        return Angle(degrees: Double(-360*direction*7/8))
    }
    var rocketColour: UIColor {
        return colourpallette[colourNumber]
    }
    var id: Int
    
    
    init(id: Int, colourNumber: Int, direction: Int) {
        self.id = id
        self.colourNumber = colourNumber
        self.direction = direction
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
        return "R\(self.id), \(self.directions[direction]), \(self.colourList[colourNumber])"
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
    }
    
    
    var rocketImageScaleFactor: CGFloat = 0.7
    var rocketShadowSize: CGFloat = 5
    
}

//struct GameGrid: View {
//    var game: RocketGameViewModel
//    var body: some View {
//        ZStack {
//            Image("stars")
//            .resizable()
//                .aspectRatio(1.0, contentMode: .fit)
//            HStack {
//                ForEach(game.gameGrid) { rocket in
//                    rocket
//                        .onTapGesture {
//                           print("FUCK")
//                    }
//            }
//            }
//        }
//    }
//}
//
//struct ScreenLayout: View {
//    var game: RocketGameViewModel
//        var body: some View {
//            Group {
//            GameGrid()
//            Spacer()
//            Text("Score: ")
//                .font(.largeTitle)
//                .foregroundColor(Color.black)
//
//            Text("Turns remaining: ")
//                .font(.largeTitle)
//                .foregroundColor(Color.black)
//            Spacer()
//}
//}
//}
//












struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RocketGameView(game: RocketGameViewModel(gridSize: 3, numberOfColours: 3))
        
    }
}
