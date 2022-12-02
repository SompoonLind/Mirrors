Shader "Unlit/TwoPassReflection" {
	Properties {
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" "Queue"="Geometry" } // set a queue for render time

		Pass {
			CGPROGRAM
			#pragma vertex vert //set "vert" as the vertex shader
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata { //vertex shader inputs
				float4 vertex : POSITION; //vertex POSITION
				float2 uv : TEXCOORD0; // texture coordinates
			};

			struct v2f { // this is the output of the vertex shader. Vertex to fragment
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION; // clip space position
			};

			sampler2D _MainTex; //sampled texture
			float4 _MainTex_ST;
			
			v2f vert (appdata v) { // vertex shader
				v2f o; 
				o.vertex = UnityObjectToClipPos(v.vertex); //tranforms position to clip space
				o.uv = TRANSFORM_TEX(v.uv, _MainTex); // transforms the texture in regaards to the vertex shader texture coordinates and the  sampled texture
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target {
				fixed4 col = tex2D(_MainTex, i.uv); //samples texture and returns
				return col;
			}
			ENDCG
		}

 		Pass {                  // A second Pass is run here to run a reflection of the first Pass in this SubShader
            Stencil {           // Stencil is put here to change the render state for this particular Pass
 		        Ref 1           //The GPU compares the content 
 		        Comp Equal      // when the stencil compares, the "objects is only shown when theyre equel kind of overlapping
 		        Pass keep       //Keeps the stencil whether is passes or fails
                Fail Keep       //Keeps the stencil whether is passes or fails
                Zfail keep      //Keeps the stencil whether is passes or fails
            }
 		    ZTest Always        //ZTest tests to see if some geometry is drawn to early in the pipieline. set to always, depth isnt tested and draws geometry regardless of distance
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
 		        v.vertex.xyz=reflect(v.vertex.xyz,float3(-1.0f,0.0f,0.0f)); //reflects the object
 		        v.vertex.xyz=reflect(v.vertex.xyz,float3(0.0f,1.0f,0.0f));  //reflects more of the texture so you cannot see inside the object
 		        v.vertex.z+=1.5f; //offsets the position of the reflected "object" by 1.5f in the z-direction
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