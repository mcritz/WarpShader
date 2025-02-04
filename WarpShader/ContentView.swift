//
//  ContentView.swift
//  WarpShader
//
//  Created by Michael Critz on 1/31/25.
//

import SwiftUI

struct ContentView: View {
    @State private var speed: Double = 1.0
    @State private var fov: Double = 0.5
    @State private var tails: Double = 3.0
    
    let startTime = Date.now
    var body: some View {
        ZStack(alignment: .topTrailing) {
            GeometryReader { geometryProxy in
                TimelineView(.animation) { timelineContext in
                    let time = startTime.distance(to: timelineContext.date) * speed
                    Rectangle()
                        .colorEffect(ShaderLibrary.starWarp(
                            .float(time), // clock time. Idea: could accelerate by
                            .float2(geometryProxy.size),
                            .float(fov), // fov
                            .float(tails)
                        ))
                }
            }
            VStack {
                HStack {
                    Text("Speed")
                    Spacer()
                    Text(speed.formatted())
                }
                Slider(value: $speed, in: 0...5)
                
                Divider()
                
                HStack {
                    Text("FOV")
                    Spacer()
                    Text(fov.formatted())
                }
                Slider(value: $fov, in: 0.3...2.0)
                
                Divider()
                
                HStack {
                    Text("Tails")
                    Spacer()
                    Text(tails.formatted())
                }
                Slider(value: $tails, in: 0.1...8.0)
            }
            .padding()
            .frame(maxWidth: 240)
            .background(RoundedRectangle(cornerSize: .init(width: 8, height: 8)).foregroundStyle(.ultraThickMaterial))
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
