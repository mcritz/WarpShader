//
//  Warp.swift
//  WarpShader
//
//  Created by Michael Critz on 2/8/25.
//
import SwiftUI
import Metal

struct Warp: ViewModifier {
    // Warp Effect
    var starScale: Double = 0.0
    var speed: Double = 0.0
    var fov: Double = 0.92
    var bifrost: Double = 1.1
    var tails: Double = 0.52
    var starFieldOffset = CGPoint(x: 0.5, y: 0.5)
    
    let starWarp = ShaderFunction.starWarp
    
    let startTime = Date.now
    
    init(
        starScale: Double,
        speed: Double,
        fov: Double,
        bifrost: Double,
        tails: Double,
        starFieldOffset: CGPoint = CGPoint(x: 0.5, y: 0.5)
    ) {
        self.starScale = starScale
        self.speed = speed
        self.fov = fov
        self.bifrost = bifrost
        self.tails = tails
        self.starFieldOffset = starFieldOffset
    }


    func body(content: Content) -> some View {
        GeometryReader { geometryProxy in
            TimelineView(.animation) { timelineContext in
                let time = startTime.distance(to: timelineContext.date)
                content
                    .colorEffect(starWarp(
                        .float(time),
                        .float2(geometryProxy.size),
                        .float(starScale), // relative size of the stars
                        .float(speed), // zippity-zoom!
                        .float(fov), // More like “Z-space depth modifier”
                        .float(bifrost), // “bifrost” rainbow separation
                        .float(tails), // star streak length
                        .float2(starFieldOffset) // change heading
                    ))
            }
        }
    }
}

extension View {
    public func warp(starScale: Double = 0, speed: Double = 0.5, fov: Double = 0.9, bifrost: Double = 1.1, tails: Double = 0.5, starFieldOffset: CGPoint = .init(x: 0.5, y: 0.5)) -> some View {
        return modifier(Warp(starScale: starScale, speed: speed, fov: fov, bifrost: bifrost, tails: tails, starFieldOffset: starFieldOffset))
    }
}
