#version 430
out vec4 frag_colour;


in vec4 fColour;
in vec3 fNormal;
in vec3 pos;
in vec2 fuv;

uniform sampler2D tex;
void main() {
  vec4 col = texture(tex, fuv);
  if(col.a - 0.01 < 0){
    discard;
  }
  frag_colour.rgb = col.rgb * (1 - dot(fNormal, normalize(vec3(-1, -1, 0))));
}