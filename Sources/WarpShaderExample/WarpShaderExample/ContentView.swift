//
//  ContentView.swift
//  WarpShader
//
//  Created by Michael Critz on 1/31/25.
//

import SwiftUI
import WarpShader

struct ContentView: View {
    // Warp Effect
    @State private var starScale: Double = 0.0
    @State private var speed: Double = 0.0
    @State private var fov: Double = 0.92
    @State private var bifrost: Double = 1.1
    @State private var tails: Double = 0.52
    @State private var starFieldOffset = CGPoint(x: 0.5, y: 0.5)
    
    // App UI
    @State private var warpEffect: WarpEffect = .stopped
    @State private var showControls = false
    
    private enum WarpEffect: String, CaseIterable, CustomStringConvertible, Identifiable {
        var id: String { description }
        case stopped
        case impulse
        case fasterThanLight
        case warpSpeed
        case tardis
        case plaid
        
        var description: String {
            switch self {
            case .stopped:
                "Stopped"
            case .impulse:
                "Impulse"
            case .fasterThanLight:
                "Faster Than Light"
            case .warpSpeed:
                "Warp Speed"
            case .tardis:
                "Tardis"
            case .plaid:
                "Plaid"
            }
        }
    }
    
    private func setWarp(_ effect: WarpEffect) {
        switch effect {
        case .stopped:
            withAnimation(.easeInOut(duration: 0.5)) {
                bifrost = 1.1
                tails = 0.0
                fov = 1.9
            }
            withAnimation {
                starScale = 0.001
                speed = 0.0
            }
        case .impulse:
            withAnimation(.easeInOut(duration: 2.3)) {
                fov = 1.9
                tails = 0.1
                bifrost = 0.25
            }
            withAnimation(.easeOut(duration: 0.7)) {
                speed = 0.03
                starScale = 0.0
            }
        case .fasterThanLight:
            withAnimation(.easeInOut(duration: 2.3)) {
                fov = 1.8
                tails = 2.0
                bifrost = 0.3
            }
            withAnimation(.easeOut(duration: 0.7)) {
                speed = 0.4
                starScale = 3.0
            }
        case .warpSpeed:
            withAnimation(.easeInOut(duration: 2.3)) {
                fov = 0.8
                tails = 2.0
                bifrost = 1.0
            }
            withAnimation(.easeOut(duration: 0.7)) {
                speed = 0.9
                starScale = 3.0
            }
        case .tardis:
            withAnimation(.easeInOut(duration: 2.3)) {
                fov = 1.8
                tails = 4.5
                bifrost = 1.5
            }
            withAnimation(.easeOut(duration: 0.7)) {
                speed = 0.7
                starScale = 4.2
            }
        case .plaid:
            withAnimation(.easeInOut(duration: 2.3)) {
                fov = 0.6
                tails = 1.0
                bifrost = 2.0
            }
            withAnimation(.easeOut(duration: 0.7)) {
                speed = 0.6
                starScale = 5.0
            }
        }
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Rectangle()
                .warp(
                    starScale: starScale,
                    speed: speed,
                    fov: fov,
                    bifrost: bifrost,
                    tails: tails,
                    starFieldOffset: starFieldOffset
                )
            if showControls {
                VStack {
                    HStack {
                        Text("Star Scale")
                        Spacer()
                        Text(starScale.formatted())
                            .textSelection(.enabled)
                    }
                    Slider(value: $starScale, in: 0...5)
                    
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
            Picker("Effect", selection: $warpEffect) {
                ForEach(WarpEffect.allCases) { effect in
                    Text(effect.description)
                        .tag(effect)
                }
            }
            .onChange(of: warpEffect) { oldValue, newValue in
                setWarp(warpEffect)
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
