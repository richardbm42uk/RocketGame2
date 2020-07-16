//
//  TestingSpace.swift
//  Rocket Game 2
//
//  Created by Richard Brown-Martin on 16/07/2020.
//  Copyright © 2020 Richard Brown-Martin. All rights reserved.
//

import SwiftUI



struct TestingSpace: View {
    var body: some View {
                        ZStack{
        RoundedRectangle(cornerRadius: 10.0)
            .foregroundColor(Color.white)
            .opacity(0.8)
            .transition(.scale)
            VStack {
                Spacer()
        Text("Game Over")
            .font(.largeTitle)
                Spacer()
                Text("Score: 100")
                .font(.title)
                Text("Total Rockets Destroyed: 5")
                .font(.title)
                Spacer()
            }
        }.padding()
    }
}

struct TestingSpace_Previews: PreviewProvider {
    static var previews: some View {
        TestingSpace()
    }
}
