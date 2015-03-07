Shader "Custom/Diffuse-Clipsafe" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
		_FadeDistance("Fade Distance", float) = 1.0
	}
	SubShader {
		Tags { "RenderType"="Transparent" "Queue"="Transparent" }
		LOD 200
		Cull off
		Blend SrcAlpha OneMinusSrcAlpha
		ZWrite off
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard alpha:fade fullforwardshadows vertex:vert

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
			float4 color;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;
		float _FadeDistance;

		void vert(inout appdata_full v, out Input o) {
			float4 viewPos = mul(UNITY_MATRIX_MV, v.vertex);
			float alpha =  (-viewPos.z - _ProjectionParams.y) / _FadeDistance;
			alpha = min(alpha, 1);

			UNITY_INITIALIZE_OUTPUT(Input, o);
			o.color = float4(_Color.rgb, _Color.a * alpha);
		}

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * IN.color;
			o.Albedo = c.rgb * c.a;
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic * c.a;
			o.Smoothness = _Glossiness * c.a;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"

}
