Shader "Custom/Toon/ScreenCordTex" {
    Properties {
        _MainTex ("Texture", 2D) = "white" { }
    }
    SubShader {
        Pass {
        //Cull Front

    CGPROGRAM

#pragma target 3.0

    #pragma vertex vert
    #pragma fragment frag

    #include "UnityCG.cginc"

    sampler2D _MainTex;

	struct appdata {
		float4 vertex : POSITION;
	};

    struct v2f {
		float4 pos : SV_POSITION;
		float4 screenPos : TEXCOORD0;
    };

    v2f vert (appdata v)
    {
        v2f o;
		o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
        o.screenPos = mul(UNITY_MATRIX_MVP, v.vertex);
        return o;
    }

    half4 frag (v2f i) : COLOR
    {
        return tex2D(_MainTex, i.screenPos.xy);
    }
    ENDCG

        }
    }
    Fallback "VertexLit"
}