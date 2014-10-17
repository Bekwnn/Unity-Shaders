Shader "Custom/Toon/ScreenCordTex" {
        Properties {
            _MainTex ("Texture", 2D) = "white" { }
        }
        SubShader {
            Pass {
            //Cull Front

        CGPROGRAM
// Upgrade NOTE: excluded shader from DX11 and Xbox360; has structs without semantics (struct v2f members uvproj)
#pragma exclude_renderers d3d11 xbox360

        #pragma vertex vert
        #pragma fragment frag

        #include "UnityCG.cginc"

        float4 _Color;
        sampler2D _MainTex;

        struct v2f {
            float4 pos : SV_POSITION;
            float4 screenPos;
        };

        float4 _MainTex_ST;

        v2f vert (appdata_base v)
        {
            v2f o;
            o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
            o.screenPos = o.pos;
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