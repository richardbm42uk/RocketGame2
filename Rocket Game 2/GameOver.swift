//
//  GaveOver.swift
//  Rocket Game 2
//
//  Created by Richard Brown-Martin on 16/07/2020.
//  Copyright © 2020 Richard Brown-Martin. All rights reserved.
//

import SwiftUI

struct GameOver: View {
//    var repeatingAnimation: Animation {
//         Animation
//             .linear(duration: 2)
//             .repeatForever()
//     }
//    @State var size: CGFloat = 0.5
//
    var body: some View {
//
//        RocketView(id: 1, colourNumber: 1, direction: 0)
//            .padding()
//            .scaleEffect(size)
//            .onAppear() {
//                withAnimation(self.repeatingAnimation) { self.size = 1.3 }
//        }
        
            ZStack{
        RoundedRectangle(cornerRadius: 10.0)
            .foregroundColor(.white)
            .opacity(0.9)
            .transition(.scale)
            VStack {
                RocketView(id: 0, colourNumber: 0, direction: 0)
                    .transition(.move(edge: .bottom))
                    
                VStack {
                Spacer()
        Text("Game Over")
            .font(.largeTitle)
                Spacer()
                Text("Score: 100")
                .font(.title)
                Text("Total Destroyed: 5")
                .font(.title)
                Spacer()
                }
                            }.padding()
        }.padding()
    }
}

struct TestingSpace_Previews: PreviewProvider {
    static var previews: some View {
        GameOver()
    }
}
