Shader "Unlit/Mirror" {
	Properties {
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" "Queue"="Geometry-1" }
 		    Stencil {
 		        Ref 0
 		        Comp always
 		        Pass IncrSat
				Fail keep
				Zfail keep
				}
		Pass {

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata {
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f {
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			v2f vert (appdata v) {
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target {
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
				return fixed4(0.2f,0.2f,0.2f,1.0f);
			}
			ENDCG
		}
	}
}