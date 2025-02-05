//
//  ContentView.swift
//  WarpShader
//
//  Created by Michael Critz on 1/31/25.
//

import SwiftUI

struct ContentView: View {
    // Warp Effect
    @State private var speed: Double = 0.1
    @State private var fov: Double = 2.0
    @State private var tails: Double = 0.1
    
    // App UI
    @State private var isWarpSpeed = false
    @State private var showControls = true
    
    let startTime = Date.now
    var body: some View {
        ZStack(alignment: .topTrailing) {
            GeometryReader { geometryProxy in
                TimelineView(.animation) { timelineContext in
                    let time = startTime.distance(to: timelineContext.date)
                    Rectangle()
                        .colorEffect(ShaderLibrary.starWarp(
                            .float(time),
                            .float2(geometryProxy.size),
                            .float(speed), // zippity-zoom!
                            .float(fov), // More like “Z-space depth modifier”
                            .float(tails) // rainbows
                        ))
                }
            }
            if showControls {
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
                    
                    Divider()
                    
                    Button {
                        withAnimation(.easeInOut(duration: 2.3)) {
                            fov     = isWarpSpeed ? 2.0 : 0.5
                            tails   = isWarpSpeed ? 0.1 : 3.0
                        }
                        withAnimation(.easeOut(duration: 0.7)) {
                            speed   = isWarpSpeed ? 0.1 : 1.25
                        }
                        isWarpSpeed.toggle()
                    } label: {
                        Text(isWarpSpeed ? "Impulse" : "Engage")
                    }
                }
                .padding()
                .frame(maxWidth: 240)
                .background(RoundedRectangle(cornerSize: .init(width: 8, height: 8)).foregroundStyle(.ultraThickMaterial))
                .padding()
                .transition( showControls ? .move(edge: .trailing) : .scale)
            }
        }
        .toolbar {
            Button {
                withAnimation(.bouncy(duration: 2.3)) {
                    fov     = isWarpSpeed ? 2.0 : 0.5
                    tails   = isWarpSpeed ? 0.1 : 3.0
                }
                withAnimation(.easeOut(duration: 0.7)) {
                    speed   = isWarpSpeed ? 0.1 : 1.25
                }
                isWarpSpeed.toggle()
            } label: {
                Text(isWarpSpeed ? "Impulse" : "Engage")
            }
            Button {
                withAnimation(.easeOut(duration: 0.2)) {
                    showControls.toggle()
                }
            } label: {
                Text("Controls")
            }
        }
    }
}

#Preview {
    ContentView()
}
