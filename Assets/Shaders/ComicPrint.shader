Shader "Toon/ComicPrint" {
	Properties{
		_MainTex("Texture", 2D) = "white" { }
		_Threshold1("Light Threshold", Range(0,1)) = 0.8
		_ShadowTexLight("Shadow Light", 2D) = "white" { }
		_Threshold2("Light Threshold", Range(0,1)) = 0.3
		_ShadowTexMed("Shadow Med", 2D) = "grey" { }
		_ShadowTexDark("Shadow Dark", 2D) = "black" { }
	}
		SubShader{
		Pass{

		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag

		#include "UnityCG.cginc"

		sampler2D _MainTex;
		sampler2D _ShadowTexLight;
		sampler2D _ShadowTexMed;
		sampler2D _ShadowTexDark;

		float _Threshold1;
		float _Threshold2;

		struct v2f {
			float4  pos : SV_POSITION;
			float4  screenPos : TEXCOORD0;
			fixed4  diff : COLOR0;
			float2  uv : TEXCOORD1;
		};

		float4 _MainTex_ST;
		float4 _ShadowTexLight_ST;
		float4 _ShadowTexMed_ST;
		float4 _ShadowTexDark_ST;

		v2f vert(appdata_base v)
		{
			v2f o;
			o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
			o.screenPos = mul(UNITY_MATRIX_MVP, v.vertex);
			o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
			half3 worldNormal = UnityObjectToWorldNormal(v.normal);
			// dot product between normal and light direction for
			// standard diffuse (Lambert) lighting
			o.diff = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz));
			return o;
		}

		half4 frag(v2f i) : COLOR
		{
			half4 texcol = tex2D(_MainTex, i.uv);
			texcol.rgb = dot(texcol.rgb, float3(0.3, 0.59, 0.11));
			texcol *= i.diff;
			if (texcol.r > _Threshold1)
			{
				texcol = tex2D(_ShadowTexLight, float2(i.screenPos.x * _ShadowTexLight_ST.x, i.screenPos.y * _ShadowTexLight_ST.y) / i.screenPos.w);
			}
			else if (texcol.r > _Threshold2)
			{
				texcol = tex2D(_ShadowTexMed, float2(i.screenPos.x * _ShadowTexMed_ST.x, i.screenPos.y * _ShadowTexMed_ST.y) / i.screenPos.w);
			}
			else
			{
				texcol = tex2D(_ShadowTexDark, float2(i.screenPos.x * _ShadowTexDark_ST.x, i.screenPos.y * _ShadowTexDark_ST.y) / i.screenPos.w);
			}
			return texcol;
		}
		ENDCG

	}

	} // end subshader
		Fallback "VertexLit"
}