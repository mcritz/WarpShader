# WarpShader

This is a Metal shader example for SwiftUI based on “Hazel Quantock” / “TekF” from this code: https://www.shadertoy.com/view/Xdl3D2

## Installation

Until I publish as a Package the easiest installation is to copy these files to your project:

- Shaders.metal
- Warp.swift

## Usage

Example usage for SwiftUI is in `ContentView.swift`.

Apply the `.warp()` view modifier to any view.

## Customization

The modifier has a good number of properties that can be customized.

```swift
SomeView()
    .warp(
        starScale: starScale, // relative star size. Things get chonky around 3.5 or so
        speed: speed, // zippy zoom!
        fov: fov, // lower values show a wider view
        bifrost: bifrost, // By Thor’s beard: higher values increase the red-blue separation of stars
        tails: tails, // higher values turn stars into longer lines
        starFieldOffset: starFieldOffset // changes the point of origin of stars
    )
```

I highly recommend building the included app, clicking the “Controls” button, and finding values you find most pleasing.

Animating between warp parameters leads to many interesting results that may seem familiar.

## TODO

- [ ] Publish as a Swift Package 
