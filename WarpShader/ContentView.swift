//
//  ContentView.swift
//  WarpShader
//
//  Created by Michael Critz on 1/31/25.
//

import SwiftUI

struct ContentView: View {
    @State private var speed: Double = 1.0
    
    let startTime = Date.now
    var body: some View {
        Slider(value: $speed, in: 0...5)
        GeometryReader { geometryProxy in
            TimelineView(.animation) { timelineContext in
                let time = startTime.distance(to: timelineContext.date) * speed
                Rectangle()
                    .colorEffect(ShaderLibrary.starWarp(
                        .float(time),
                        .float2(geometryProxy.size),
                        .float(speed)
                    ))
            }
        }
    }
}

#Preview {
    ContentView()
}
