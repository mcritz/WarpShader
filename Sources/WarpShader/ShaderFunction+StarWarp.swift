import SwiftUI
import Metal

extension ShaderFunction {
    static let starWarp: ShaderFunction = {
        let url = Bundle.module.url(forResource: "default", withExtension: "metallib")!
        let shaderLibrary = ShaderLibrary(url: url)
        let shaderFunction = ShaderFunction(library: shaderLibrary, name: "starWarp")
        return shaderFunction
    }()
}
