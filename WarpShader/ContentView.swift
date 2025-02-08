//
//  ContentView.swift
//  WarpShader
//
//  Created by Michael Critz on 1/31/25.
//

import SwiftUI

struct ContentView: View {
    // Warp Effect
    @State private var speed: Double = 0.0
    @State private var fov: Double = 0.92
    @State private var bifrost: Double = 1.1
    @State private var tails: Double = 0.52
    
    // App UI
    @State private var isWarpSpeed = false
    @State private var showControls = false
    @State private var starFieldOffset = CGPoint(x: 0.5, y: 0.5)
    
    func toggleWarpSpeed() {
        if isWarpSpeed {
            withAnimation(.easeInOut(duration: 2.3)) {
                fov = 0.92
                tails = 0.52
            }
            withAnimation(.easeOut(duration: 0.7)) {
                speed   = 0.0
                bifrost = 1.1
            }
        } else {
            withAnimation(.easeInOut(duration: 2.3)) {
                fov = 0.46
                tails = 3.5
            }
            withAnimation(.easeOut(duration: 0.7)) {
                speed   = 1.75
                bifrost = 0.74
            }
        }
        isWarpSpeed.toggle()
    }
    
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
                            .float(bifrost), // “bifrost” rainbow separation
                            .float(tails), // star streak length
                            .float2(starFieldOffset) // change heading
                        ))
                }
            }
            if showControls {
                VStack {
                    HStack {
                        Text("Speed")
                        Spacer()
                        Text(speed.formatted())
                            .textSelection(.enabled)
                    }
                    Slider(value: $speed, in: 0...5)
                    
                    Divider()
                    
                    HStack {
                        Text("FOV")
                        Spacer()
                        Text(fov.formatted())
                            .textSelection(.enabled)
                    }
                    Slider(value: $fov, in: 0.3...2.0)
                    
                    Divider()
                    
                    HStack {
                        Text("Bifröst")
                        Spacer()
                        Text(bifrost.formatted())
                            .textSelection(.enabled)
                    }
                    Slider(value: $bifrost, in: 0.0...2.0)
                    
                    Divider()
                    
                    HStack {
                        Text("Tails")
                        Spacer()
                        Text(tails.formatted())
                            .textSelection(.enabled)
                    }
                    Slider(value: $tails, in: 0.1...8.0)
                    
                    Divider()
                    
                    Button {
                        toggleWarpSpeed()
                    } label: {
                        Text(isWarpSpeed ? "Stop" : "Engage")
                    }
                    
                    Divider()
                    
                    Text("Offset")
                        .onTapGesture {
                            withAnimation {
                                starFieldOffset.x = 0.5
                                starFieldOffset.y = 0.5
                            }
                        }
                    Slider(value: $starFieldOffset.x, in: 0...1.0) {
                        Text(String(format: "x: %.2f", starFieldOffset.x))
                            .textSelection(.enabled)
                    }
                    Slider(value: $starFieldOffset.y, in: 0...1.0) {
                        Text(String(format: "y: %.2f", starFieldOffset.y))
                            .textSelection(.enabled)
                    }
                }
                .padding()
                .frame(maxWidth: 240)
                .background(RoundedRectangle(cornerSize: .init(width: 8, height: 8)).foregroundStyle(.ultraThickMaterial))
                .padding()
                .transition(.opacity)
            }
        }
        .toolbar {
            Button {
                toggleWarpSpeed()
            } label: {
                Text(isWarpSpeed ? "Stop" : "Engage")
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
