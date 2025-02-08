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
    @State private var starFieldOffset = CGPoint(x: 0.5, y: 0.5)
    
    // App UI
    @State private var isWarpSpeed = false
    @State private var showControls = false
    
    func toggleWarpSpeed() {
        if isWarpSpeed {
            withAnimation(.easeInOut(duration: 2.3)) {
                fov = 0.92
                tails = 0.52
                bifrost = 1.1
            }
            withAnimation(.easeOut(duration: 0.7)) {
                speed   = 0.0
            }
        } else {
            withAnimation(.easeInOut(duration: 2.3)) {
                fov = 0.46
                tails = 3.5
                bifrost = 0.74
            }
            withAnimation(.easeOut(duration: 0.7)) {
                speed   = 1.75
            }
        }
        isWarpSpeed.toggle()
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Rectangle()
                .warp(speed: speed, fov: fov, bifrost: bifrost, tails: tails, starFieldOffset: starFieldOffset)
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
