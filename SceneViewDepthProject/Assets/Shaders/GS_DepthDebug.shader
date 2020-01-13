Shader "Unlit/GS_DepthDebug"
{
	Properties
	{
		_Color("", Color) = (1, 1, 1, 1)
	}
		SubShader
	{
	Tags{"Queue" = "Transparent+1" "IgnoreProjector" = "True" }

	Pass
	{
	Name "Unselected Verts 0"
	ColorMask RGBA
		ZTest  Always
		ZWrite Off
		//Blend SrcAlpha OneMinusSrcAlpha

		CGPROGRAM
		#pragma target 5.0
		#pragma vertex vert
		#pragma fragment frag
		#pragma geometry GS_Main
		#include "UnityCG.cginc"

		struct GS_input
		{
			float4 pos : POSITION;
		};

		struct FS_input
		{
			float4 pos : SV_POSITION;
			float2 uv  : TEXCOORD0;
		};

		fixed4 _Color;
		UNITY_DECLARE_DEPTH_TEXTURE(_CameraDepthTexture);

		// Vertex Shader -------------------------------------------------------
		GS_input vert()
		{
			GS_input o;
			o.pos = float4(0.0, 0.0, 0.0, 1.0);
			return o;
		}

		// Geometry Shader -----------------------------------------------------
		[maxvertexcount(4)]
		void GS_Main(point GS_input p[1], inout TriangleStream<FS_input> triStream)
			{
				float3 up    = float3(0.0, 1.0, 0.0);
				float3 right = float3(1.0, 0.0, 0.0);
				float  size  = 1.0;
				
				float4 v[4];
				v[0] = float4(p[0].pos + size * right - size * up, 1.0f);
				v[1] = float4(p[0].pos + size * right + size * up, 1.0f);
				v[2] = float4(p[0].pos - size * right - size * up, 1.0f);
				v[3] = float4(p[0].pos - size * right + size * up, 1.0f);

				FS_input pIn;

				pIn.pos = v[0];
				pIn.uv  = float2(1, 1);
				triStream.Append(pIn);

				pIn.pos = v[1];
				pIn.uv  = float2(1, 0);
				triStream.Append(pIn);

				pIn.pos = v[2];
				pIn.uv  = float2(0, 1);
				triStream.Append(pIn);

				pIn.pos = v[3];
				pIn.uv  = float2(0, 0);
				triStream.Append(pIn);
			}

		// Fragment Shader -----------------------------------------------
		float4 frag(FS_input i) : SV_Target
		{
			float depth = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, i.uv);  // sample from depth texture
			depth = Linear01Depth(depth);
			return depth;
		}

		ENDCG
		}
	}
}
