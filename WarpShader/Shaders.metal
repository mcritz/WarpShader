//
//  Shaders.metal
//  WarpShader
//
//  Created by Michael Critz on 1/31/25.
//

#include <metal_stdlib>
using namespace metal;

struct FS_INPUT
{
    float2 v_texcoord;
};

struct FS_UNIFORM
{
    float2 position;
    float time;
    float2 resolution;
    float warp;
    float speed;
    float fov;
    float tail_length;
};

constant float GAMMA = 2.2;

float hash12(float2 p) {
    float3 p3 = fract(float3(p.x, p.y, p.x) * 0.1031);
    p3 += dot(p3, p3.yzx + 33.33);
    return fract((p3.x + p3.y) * p3.z);
}

float4 Noise(int2 x) {
    float2 p = float2(x);
    return float4(hash12(p),
                 hash12(p + 1.0),
                 hash12(p + 2.0),
                 hash12(p + 3.0));
}

float3 ToGamma(float3 col) {
    return pow(col, float3(1.0/GAMMA));
}

float4 interstellarFragment(FS_UNIFORM uniforms) {
    float3 ray;
    ray.xy = 2.0 * (uniforms.position - uniforms.resolution * 0.5) / uniforms.resolution.x;
    ray.z = uniforms.warp;
    
    float offset = uniforms.time * uniforms.speed;
    float speed2 = 1.89 * uniforms.speed;
    float speed = uniforms.tail_length + 0.1;
    offset *= 1.5;
    
    float3 col = float3(0);
    float3 stp = ray/max(abs(ray.x), abs(ray.y));
    float3 pos = 2.0 * stp + 0.5;
    
    for (int i = 0; i < 20; i++) {
        float z;
        if (i % 2 == 0) {
            z = Noise(int2(pos.xy)).y * 11.0;
            offset += 5.0;
        } else if (i % 3 == 0) {
            z = Noise(int2(pos.yx)).y * 5.0;
            offset += 2.0;
        } else if (i % 5 == 0) {
            z = Noise(int2(pos.yx)).x * 21.0;
            offset += 1.0;
        } else {
            z = Noise(int2(pos.xy)).x * 7.32;
        }
        
        float offsetBravo = (i % 2 == 0 ? offset * 0.7 : offset);
        z = fract(z - offsetBravo);
        float d = 50.0 * z - pos.z;
        float w = pow(max(0.0, 1.0 - 8.0 * length(fract(pos.xy) - 0.5)), 2.0);
        float3 c = max(float3(0),
                      float3(1.0 - abs(d + speed2 * 0.5) / speed,
                            1.0 - abs(d) / speed,
                            1.0 - abs(d - speed2 * 0.5) / speed));
        
        col += 1.5 * (1.0 - z) * c * w;
        pos += stp;
    }
    
    return float4(ToGamma(col), 1.0);
}

[[ stitchable ]] half4 starWarp(float2 position,
                                half4 color,
                                float time,
                                float2 size,
                                float speed,
                                float fov,
                                float tail_length) {
    FS_UNIFORM uniforms;
    uniforms.time = time;
    uniforms.position = position;
    uniforms.resolution = size;
    uniforms.speed = speed;
    uniforms.warp = fov;
    uniforms.tail_length = tail_length;
    float4 outColor = interstellarFragment(uniforms);
    return half4(outColor);
}
