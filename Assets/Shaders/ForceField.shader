Shader "Custom/ForceField" {
	Properties
    {
        _LowAngleColor("Low Angle Color", Color) = (0.1, 0.4, 0.8, 0.2)
        _HighAngleColor("High Angle Color", Color) = (1, 1, 1, 0.5)
        _HighlightColor("Intersect Color", Color) = (1, 1, 1, 0.5) //Color when intersecting
        _HighlightThresholdMax("Highlight Threshold Max", Float) = 1 //Max difference for intersections
    }
    SubShader
    {	
		Tags { "Queue" = "Transparent" "RenderType"="Transparent"  }
		ZWrite Off
		Cull Off
		
		CGPROGRAM
		#pragma surface surf BlinnPhong alpha
		#pragma target 3.0

		float4 _LowAngleColor;
		float4 _HighAngleColor;

		struct Input {
			float3 viewDir;
			float3 worldNormal; INTERNAL_DATA
			float3 worldPos;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			float vDotn = dot(normalize(IN.viewDir), normalize(IN.worldNormal));
			float4 colorBlend = (_LowAngleColor*vDotn)+(_HighAngleColor*(1.0-vDotn));
			o.Albedo = colorBlend.rgb;
			o.Alpha = colorBlend.a;
		}
		ENDCG
		
			
		Blend srcAlpha oneMinusSrcAlpha

		CGPROGRAM
		#pragma target 3.0
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"

		uniform sampler2D _CameraDepthTexture; //Depth Texture
		uniform float4 _HighlightColor;
		uniform float _HighlightThresholdMax;

		struct v2f
		{
			float4 pos : SV_POSITION;
			float4 projPos : TEXCOORD1; //Screen position of pos
		};

		v2f vert(appdata_base v)
		{
			v2f o;
			o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
			o.projPos = ComputeScreenPos(o.pos);

			return o;
		}

		float4 frag(v2f i) : COLOR
		{
			float4 finalColor = float4(0,0,0,0);

			//Get the distance to the camera from the depth buffer for this point
			float sceneZ = LinearEyeDepth (tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos)).r);
			//Actual distance to the camera
			float partZ = i.projPos.z;

			//If the two are similar, then there is an object intersecting with our object
			float diff = (abs(sceneZ - partZ)) / _HighlightThresholdMax;

			if(diff <= 1)
			{
			    finalColor = lerp(_HighlightColor,
			                      finalColor,
			                      float4(diff, diff, diff, diff));
			}
			return finalColor;
		}

		ENDCG
		
    }
	FallBack "Diffuse"
	
}
