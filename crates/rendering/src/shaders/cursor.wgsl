struct Uniforms {
    position: vec2<f32>,
    padding1: vec2<f32>,
    size: vec2<f32>,
    padding2: vec2<f32>,
    output_size: vec2<f32>,
    padding3: vec2<f32>,
    screen_bounds: vec4<f32>,
};

@group(0) @binding(0) var<uniform> uniforms: Uniforms;
@group(0) @binding(1) var cursor_texture: texture_2d<f32>;
@group(0) @binding(2) var cursor_sampler: sampler;

struct VertexOutput {
    @builtin(position) position: vec4<f32>,
    @location(0) tex_coords: vec2<f32>,
};

@vertex
fn vs_main(@builtin(vertex_index) vertex_index: u32) -> VertexOutput {
    var out: VertexOutput;
    
    // Create a quad from two triangles using triangle strip
    let x = f32(vertex_index & 1u);
    let y = f32((vertex_index >> 1u) & 1u);
    
    // Calculate position in screen space
    let pos = uniforms.position + vec2<f32>(x * uniforms.size.x, y * uniforms.size.y);
    
    // Convert to clip space (-1 to 1)
    let clip_pos = vec2<f32>(
        (pos.x / uniforms.output_size.x) * 2.0 - 1.0,
        -((pos.y / uniforms.output_size.y) * 2.0 - 1.0)
    );
    
    out.position = vec4<f32>(clip_pos, 0.0, 1.0);
    out.tex_coords = vec2<f32>(x, y);
    
    return out;
}

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
    let color = textureSample(cursor_texture, cursor_sampler, in.tex_coords);
    return color;
}