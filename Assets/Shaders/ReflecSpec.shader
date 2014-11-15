Shader "Custom/Toon/ToonGlitterReflect" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_SpecColor ("Specular Color", Color) = (0.5, 0.5, 0.5, 1)
	_SpecPower ("Specular Power", float) = 1
	_Reflec ("Reflectiveness", Range(0.0, 1.0)) = 0.6
	_MainTex ("Texture", 2D) = "white" {}
	_SpecMap ("Specular Map (RGB)", 2D) = "black" {}
	_Ramp ("Toon Ramp (RGB)", 2D) = "grey" {}
	_Cube ("Cubemap", CUBE) = "" {}
}
SubShader { 
	Tags { "RenderType"="Opaque" }
	LOD 400
	
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
	c.a = 0;
	return c;
}


sampler2D _MainTex;
float4 _Color;
float _Reflec;
samplerCUBE _Cube;

struct Input {
	float2 uv_MainTex : TEXCOORD0;
	float3 worldRefl;
    INTERNAL_DATA
};

void surf (Input IN, inout SurfaceOutput o) {
	half4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
	o.Albedo = c.rgb;
	o.Alpha = c.a;
	o.Emission = texCUBE (_Cube, WorldReflectionVector (IN, o.Normal)).rgb;
	o.Emission *= _Reflec;
}
ENDCG

Blend SrcColor One

CGPROGRAM
#pragma surface surf BlinnPhong

sampler2D _SpecMap;
fixed4 _Color;
half _Gloss;
float _SpecPower;

struct Input {
	float3 viewDir;
	float2 uv_SpecMap;
	float3 worldRefl;
};

void surf (Input IN, inout SurfaceOutput o) {
	fixed4 specTex = tex2D(_SpecMap, IN.uv_SpecMap);
	o.Albedo = _Color.rgb;
	o.Gloss = specTex.g;
	o.Specular = pow((1.0-specTex.g), _SpecPower);
}
ENDCG
}
FallBack "Specular"
}