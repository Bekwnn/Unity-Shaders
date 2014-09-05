Shader "Custom/Toon/MagicAura" {
	Properties {
		_Color ("Main Color", Color) = (.5,.5,.5,0.6)
		_OutlineColor ("Outline Color", Color) = (.2,.2,.2,1)
		_Outline ("Outline Width", Range(0.002,0.02)) = 0.005
		_Offset ("Shader Offset", Float) = 0
		_NoiseFreq ("Noise Frequency", Range(0.0,20.0)) = 10.0
		_NoiseMag ("Noise Magnitude", Range(0.0,0.05)) = 0.01
	}
	Subshader {
		Tags { "Queue"="Transparent+1" }
		Pass {
			Name "MAGIC"
			Tags { "LightMode"="Always" }
			Blend SrcAlpha OneMinusSrcAlpha
			Cull Front
			Offset 0, [_Offset]
CGPROGRAM
#pragma fragmentoption ARB_precision_hint_fastest
#pragma vertex vert
#pragma fragment frag

#include "UnityCG.cginc"
uniform float4 _Color;
float _NoiseFreq;
float _NoiseMag;

struct vertexInput {
	float4 vertex : POSITION;
};

struct fragmentInput {
	float4 pos : SV_POSITION;
	float4 color : COLOR0;
};

fragmentInput vert (vertexInput i) {
	fragmentInput o;
	o.pos = mul(UNITY_MATRIX_MVP, i.vertex);
	
	o.pos.y += sin((o.pos.x+_Time[1])*_NoiseFreq)*_NoiseMag;
	o.pos.x += sin((o.pos.y+_Time[1])*_NoiseFreq)*_NoiseMag;
	
	o.color = _Color;			//return the color
	
	return o;
}

half4 frag (fragmentInput i) : COLOR{
	return i.color;
}

ENDCG

		}//end pass
		Pass {
			Name "MAGIC OUTLINE"
			Tags { "LightMode"="Always" }
			Blend SrcAlpha OneMinusSrcAlpha
			Cull Front
			Offset 0, [_Offset]
CGPROGRAM
#pragma fragmentoption ARB_precision_hint_fastest
#pragma vertex vert
#pragma fragment frag

#include "UnityCG.cginc"
uniform float4 _OutlineColor;
float _Outline;
float _NoiseFreq;
float _NoiseMag;

struct vertexInput {
	float4 vertex : POSITION;
	float3 normal : NORMAL;
};

struct fragmentInput {
	float4 pos : SV_POSITION;
	float4 color : COLOR0;
};


fragmentInput vert (vertexInput i) {
	fragmentInput o;
	o.pos = mul(UNITY_MATRIX_MVP, i.vertex);
	
	float3 norm = mul ((float3x3)UNITY_MATRIX_MV, i.normal);
	norm.x *= UNITY_MATRIX_P[0][0];
	norm.y *= UNITY_MATRIX_P[1][1];
	o.pos.xy += norm.xy * _Outline;
	
	o.pos.y += sin((o.pos.x+_Time[1])*_NoiseFreq)*_NoiseMag;
	o.pos.x += sin((o.pos.y+_Time[1])*_NoiseFreq)*_NoiseMag;
	o.color = _OutlineColor;			//return the color
	
	return o;
}

half4 frag (fragmentInput i) : COLOR{
	return i.color;
}

ENDCG
		}//end pass
	}//end subshader
	Fallback "Toon/Basic"
}