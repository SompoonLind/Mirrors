Shader "Unlit/TwoPassReflection" {
	Properties {
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" "Queue"="Geometry" }

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
				return col;
			}
			ENDCG
		}

 		Pass {

 		    ZTest Always
 		    CGPROGRAM
 		    #pragma vertex vert
 		    #pragma fragment frag
 		    
 		    #include "UnityCG.cginc"

 		    struct appdata {
 		        float4 vertex : POSITION;
 		        float2 uv : TEXCOORD0;
 		        float4 normal: NORMAL;
 		    };

 		    struct v2f {
 		        float2 uv : TEXCOORD0;
 		        float4 vertex : SV_POSITION;
 		    };

 		    sampler2D _MainTex;
 		    float4 _MainTex_ST;
 		    
 		    v2f vert (appdata v) {
 		        v2f o;
 		        v.vertex.xyz=reflect(v.vertex.xyz,float3(-1.0f,0.0f,0.0f));
 		        v.vertex.xyz=reflect(v.vertex.xyz,float3(0.0f,1.0f,0.0f));
 		        v.vertex.z+=1.5f;
 		        o.vertex = UnityObjectToClipPos(v.vertex);
 		        o.uv = TRANSFORM_TEX(v.uv, _MainTex);
 		        return o;
 		    }
 		    
 		    fixed4 frag (v2f i) : SV_Target {
 		        fixed4 col = tex2D(_MainTex, i.uv);
 		        return col;
 		    }
 		    ENDCG
 		}
	}
}