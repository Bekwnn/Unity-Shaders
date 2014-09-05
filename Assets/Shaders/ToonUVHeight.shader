Shader "Custom/Toon/ToonUVHeight" {
	Properties {
		_MainTex ("Main Tex", 2D) = "white" {}
		_Color1 ("Gradiant Color A", Color) = (.5,.5,.5,1)
		_Color2 ("Gradiant Color B", Color) = (.5,.5,.5,1)
		_Center ("Gradiant Position", Range(0,1)) = 0.5
		_Softness ("Gradiant Softness", float) = 0.5
		_Ramp ("Toon Ramp (RGB)", 2D) = "grey" {}
	}
	
	SubShader {
		Tags { "Queue"="Transparent" "RenderType"="Transparent" }
		Pass {
CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 3.0

#include "UnityCG.cginc"
uniform float4 _Color1;
uniform float4 _Color2;
float _Center;
float _Softness;

struct vertexInput {
	float4 vertex : POSITION;
	float4 texcoord0 : TEXCOORD0;
};

struct fragmentInput{
	float4 position : SV_POSITION;
	float2 texcoord0 : TEXCOORD0;
};


fragmentInput vert(vertexInput i){
	fragmentInput o;
	o.position = mul (UNITY_MATRIX_MVP, i.vertex);
	o.texcoord0 = i.texcoord0;
	return o;
}

float4 frag(fragmentInput i) : COLOR {
	float4 color1 = _Color1*(atan((_Center - i.texcoord0.y)/_Softness)*0.636619+1)/2;
	float4 color2 = _Color2*(atan((i.texcoord0.y - _Center)/_Softness)*0.636619+1)/2;
	return color1 + color2;
}
ENDCG
		}//end pass
		Blend OneMinusSrcColor SrcColor
CGPROGRAM
#pragma surface surf ToonRamp

sampler2D _Ramp;

// custom lighting function that uses a texture ramp based
// on angle between light direction and normal
#pragma lighting ToonRamp exclude_path:prepass
inline half4 LightingToonRamp (SurfaceOutput s, half3 lightDir, half atten)
{
	#ifndef USING_DIRECTIONAL_LIGHT
	lightDir = normalize(lightDir);
	#endif
	
	half d = dot (s.Normal, lightDir)*0.5 + 0.5;
	half3 ramp = tex2D (_Ramp, float2(d,d)).rgb;
	
	half4 c;
	c.rgb = s.Albedo * _LightColor0.rgb * ramp * (atten * 2);
	c.a = s.Alpha;
	return c;
}


sampler2D _MainTex;

struct Input {
	float2 uv2_MainTex : TEXCOORD0;
};

void surf (Input IN, inout SurfaceOutput o) {
	half4 c = tex2D(_MainTex, IN.uv2_MainTex);
	o.Albedo = c.rgb;
	o.Alpha = c.a;
}
ENDCG
	}//end subshader
}