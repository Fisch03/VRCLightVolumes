// Made with Amplify Shader Editor v1.9.9.1
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Light Volume Samples/Light Volume PBR Cutout"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_MainTex( "Albedo", 2D ) = "white" {}
		_Color( "Color", Color ) = ( 1, 1, 1, 1 )
		[NoScaleOffset] _MetallicGlossMap( "Metal AO Smoothness", 2D ) = "white" {}
		_Metallic( "Metallic", Range( 0, 1 ) ) = 0
		_Glossiness( "Smoothness", Range( 0, 1 ) ) = 1
		_OcclusionStrength( "AO", Range( 0, 1 ) ) = 1
		[NoScaleOffset] _BumpMap( "Normal", 2D ) = "bump" {}
		_BumpScale( "Normal Power", Float ) = 1
		[HDR][NoScaleOffset] _EmissionMap( "Emission Map", 2D ) = "white" {}
		[HDR] _EmissionColor( "Emission Color", Color ) = ( 0, 0, 0, 1 )
		[Toggle( _LIGHTVOLUMES_ON )] _LightVolumes( "Enable Light Volumes", Float ) = 1
		_LightVolumesBias( "Light Volumes Bias", Float ) = 0
		[Toggle( _SPECULARS_ON )] _Speculars( "Speculars", Float ) = 1
		[Toggle( _DOMINANTDIRSPECULARS_ON )] _DominantDirSpeculars( "Dominant Dir Speculars", Float ) = 0
		[Enum(UnityEngine.Rendering.CullMode)] _Culling( "Culling", Float ) = 2
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" "IsEmissive" = "true"  }
		Cull [_Culling]
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "Packages/red.sim.lightvolumes/Shaders/LightVolumes.cginc"
		#include "UnityStandardBRDF.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 5.0
		#pragma shader_feature_local _SPECULARS_ON
		#pragma shader_feature_local _LIGHTVOLUMES_ON
		#pragma shader_feature_local _DOMINANTDIRSPECULARS_ON
		#define ASE_VERSION 19901
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldNormal;
			INTERNAL_DATA
			float3 worldPos;
		};

		uniform float _Culling;
		uniform sampler2D _BumpMap;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float _BumpScale;
		uniform float4 _Color;
		uniform float4 _EmissionColor;
		uniform sampler2D _EmissionMap;
		uniform float _LightVolumesBias;
		uniform sampler2D _MetallicGlossMap;
		uniform float _Metallic;
		uniform float _Glossiness;
		uniform float _OcclusionStrength;
		uniform float _Cutoff = 0.5;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float3 tex2DNode5 = UnpackScaleNormal( tex2D( _BumpMap, uv_MainTex ), _BumpScale );
			float3 Normal437 = tex2DNode5;
			o.Normal = Normal437;
			float4 tex2DNode3 = tex2D( _MainTex, uv_MainTex );
			float3 Albedo337 = ( _Color.rgb * tex2DNode3.rgb );
			o.Albedo = Albedo337;
			float3 normalizeResult349 = normalize( (WorldNormalVector( i , tex2DNode5 )) );
			float3 World_Normal112 = normalizeResult349;
			float3 worldNormal2_g222 = World_Normal112;
			float3 appendResult427 = (float3(unity_SHAr.w , unity_SHAg.w , unity_SHAb.w));
			float localLightVolumeSH1_g3 = ( 0.0 );
			float3 ase_positionWS = i.worldPos;
			float3 temp_output_6_0_g3 = ase_positionWS;
			float3 worldPos1_g3 = temp_output_6_0_g3;
			float3 L01_g3 = float3( 0,0,0 );
			float3 L1r1_g3 = float3( 0,0,0 );
			float3 L1g1_g3 = float3( 0,0,0 );
			float3 L1b1_g3 = float3( 0,0,0 );
			float3 temp_output_470_0 = ( _LightVolumesBias * World_Normal112 );
			float3 temp_output_17_0_g3 = temp_output_470_0;
			float3 worldPosOffset1_g3 = temp_output_17_0_g3;
			LightVolumeSH( worldPos1_g3 , L01_g3 , L1r1_g3 , L1g1_g3 , L1b1_g3 , worldPosOffset1_g3 );
			float localLightVolumeAdditiveSH9_g4 = ( 0.0 );
			float3 temp_output_6_0_g4 = ase_positionWS;
			float3 worldPos9_g4 = temp_output_6_0_g4;
			float3 L09_g4 = float3( 0,0,0 );
			float3 L1r9_g4 = float3( 0,0,0 );
			float3 L1g9_g4 = float3( 0,0,0 );
			float3 L1b9_g4 = float3( 0,0,0 );
			float3 temp_output_17_0_g4 = temp_output_470_0;
			float3 worldPosOffset9_g4 = temp_output_17_0_g4;
			LightVolumeAdditiveSH( worldPos9_g4 , L09_g4 , L1r9_g4 , L1g9_g4 , L1b9_g4 , worldPosOffset9_g4 );
			#ifdef LIGHTMAP_ON
				float3 staticSwitch467 = L09_g4;
			#else
				float3 staticSwitch467 = L01_g3;
			#endif
			#ifdef _LIGHTVOLUMES_ON
				float3 staticSwitch431 = staticSwitch467;
			#else
				float3 staticSwitch431 = appendResult427;
			#endif
			float3 L098 = staticSwitch431;
			float3 L02_g222 = L098;
			#ifdef LIGHTMAP_ON
				float3 staticSwitch93 = L1r9_g4;
			#else
				float3 staticSwitch93 = L1r1_g3;
			#endif
			#ifdef _LIGHTVOLUMES_ON
				float3 staticSwitch461 = staticSwitch93;
			#else
				float3 staticSwitch461 = (unity_SHAr).xyz;
			#endif
			float3 L1r99 = staticSwitch461;
			float3 L1r2_g222 = L1r99;
			#ifdef LIGHTMAP_ON
				float3 staticSwitch94 = L1g9_g4;
			#else
				float3 staticSwitch94 = L1g1_g3;
			#endif
			#ifdef _LIGHTVOLUMES_ON
				float3 staticSwitch462 = staticSwitch94;
			#else
				float3 staticSwitch462 = (unity_SHAg).xyz;
			#endif
			float3 L1g100 = staticSwitch462;
			float3 L1g2_g222 = L1g100;
			#ifdef LIGHTMAP_ON
				float3 staticSwitch95 = L1b9_g4;
			#else
				float3 staticSwitch95 = L1b1_g3;
			#endif
			#ifdef _LIGHTVOLUMES_ON
				float3 staticSwitch463 = staticSwitch95;
			#else
				float3 staticSwitch463 = (unity_SHAb).xyz;
			#endif
			float3 L1b101 = staticSwitch463;
			float3 L1b2_g222 = L1b101;
			float3 localLightVolumeEvaluate2_g222 = LightVolumeEvaluate( worldNormal2_g222 , L02_g222 , L1r2_g222 , L1g2_g222 , L1b2_g222 );
			float4 tex2DNode50 = tex2D( _MetallicGlossMap, uv_MainTex );
			float temp_output_54_0 = ( tex2DNode50.r * _Metallic );
			float Metallic334 = ( temp_output_54_0 * temp_output_54_0 );
			float3 temp_output_406_0 = ( localLightVolumeEvaluate2_g222 * Albedo337 * ( 1.0 - Metallic334 ) );
			float3 temp_output_138_0_g220 = Albedo337;
			float3 albedo157_g220 = temp_output_138_0_g220;
			float Smoothness109 = ( tex2DNode50.a * _Glossiness );
			float temp_output_3_0_g220 = Smoothness109;
			float smoothness157_g220 = temp_output_3_0_g220;
			float temp_output_137_0_g220 = Metallic334;
			float metallic157_g220 = temp_output_137_0_g220;
			float3 temp_output_2_0_g220 = World_Normal112;
			float3 worldNormal157_g220 = temp_output_2_0_g220;
			float3 ase_viewVectorWS = ( _WorldSpaceCameraPos.xyz - ase_positionWS );
			float3 ase_viewDirSafeWS = Unity_SafeNormalize( ase_viewVectorWS );
			float3 temp_output_9_0_g220 = ase_viewDirSafeWS;
			float3 viewDir157_g220 = temp_output_9_0_g220;
			float3 temp_output_65_0_g220 = L098;
			float3 L0157_g220 = temp_output_65_0_g220;
			float3 temp_output_1_0_g220 = L1r99;
			float3 L1r157_g220 = temp_output_1_0_g220;
			float3 temp_output_36_0_g220 = L1g100;
			float3 L1g157_g220 = temp_output_36_0_g220;
			float3 temp_output_37_0_g220 = L1b101;
			float3 L1b157_g220 = temp_output_37_0_g220;
			float3 localLightVolumeSpecular157_g220 = LightVolumeSpecular( albedo157_g220 , smoothness157_g220 , metallic157_g220 , worldNormal157_g220 , viewDir157_g220 , L0157_g220 , L1r157_g220 , L1g157_g220 , L1b157_g220 );
			float3 temp_output_138_0_g221 = Albedo337;
			float3 albedo158_g221 = temp_output_138_0_g221;
			float temp_output_3_0_g221 = Smoothness109;
			float smoothness158_g221 = temp_output_3_0_g221;
			float temp_output_137_0_g221 = Metallic334;
			float metallic158_g221 = temp_output_137_0_g221;
			float3 temp_output_2_0_g221 = World_Normal112;
			float3 worldNormal158_g221 = temp_output_2_0_g221;
			float3 temp_output_9_0_g221 = ase_viewDirSafeWS;
			float3 viewDir158_g221 = temp_output_9_0_g221;
			float3 temp_output_65_0_g221 = L098;
			float3 L0158_g221 = temp_output_65_0_g221;
			float3 temp_output_1_0_g221 = L1r99;
			float3 L1r158_g221 = temp_output_1_0_g221;
			float3 temp_output_36_0_g221 = L1g100;
			float3 L1g158_g221 = temp_output_36_0_g221;
			float3 temp_output_37_0_g221 = L1b101;
			float3 L1b158_g221 = temp_output_37_0_g221;
			float3 localLightVolumeSpecularDominant158_g221 = LightVolumeSpecularDominant( albedo158_g221 , smoothness158_g221 , metallic158_g221 , worldNormal158_g221 , viewDir158_g221 , L0158_g221 , L1r158_g221 , L1g158_g221 , L1b158_g221 );
			#ifdef _DOMINANTDIRSPECULARS_ON
				float3 staticSwitch410 = localLightVolumeSpecularDominant158_g221;
			#else
				float3 staticSwitch410 = localLightVolumeSpecular157_g220;
			#endif
			float lerpResult57 = lerp( 1.0 , tex2DNode50.g , _OcclusionStrength);
			float AO357 = lerpResult57;
			float3 Speculars412 = ( staticSwitch410 * AO357 );
			#ifdef _SPECULARS_ON
				float3 staticSwitch361 = ( temp_output_406_0 + Speculars412 );
			#else
				float3 staticSwitch361 = temp_output_406_0;
			#endif
			float3 IndirectAndSpeculars444 = ( staticSwitch361 * AO357 );
			float3 Emission452 = ( ( _EmissionColor.rgb * tex2D( _EmissionMap, uv_MainTex ).rgb ) + IndirectAndSpeculars444 );
			o.Emission = Emission452;
			o.Metallic = Metallic334;
			o.Smoothness = Smoothness109;
			o.Occlusion = AO357;
			o.Alpha = 1;
			float Opacity455 = ( _Color.a * tex2DNode3.a );
			clip( Opacity455 - _Cutoff );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows exclude_path:deferred noambient 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 5.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "AmplifyShaderEditor.MaterialInspector"
}
/*ASEBEGIN
Version=19901
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;439;-2016,-880;Inherit;False;1266.988;354.1402;Normal;7;437;112;349;14;5;6;471;;0.5792453,0.6214049,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;6;-1856,-624;Inherit;False;Property;_BumpScale;Normal Power;8;0;Create;False;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;471;-1920,-768;Inherit;False;0;3;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;5;-1664,-736;Inherit;True;Property;_BumpMap;Normal;7;1;[NoScaleOffset];Create;False;0;0;0;False;0;False;3;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.WorldNormalVector, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;14;-1344,-736;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalizeNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;349;-1168,-736;Inherit;False;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;436;-2551.2,800;Inherit;False;1115.2;487.8;Light Volumes;9;470;469;468;467;95;94;93;79;78;;0.9834821,1,0.7150943,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;112;-1024,-736;Inherit;False;World Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;469;-2480,1056;Inherit;False;112;World Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;468;-2480,976;Inherit;False;Property;_LightVolumesBias;Light Volumes Bias;12;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;443;-2016,-512;Inherit;False;1254.472;527.7868;Metallic Smoothness AO;12;357;57;334;56;109;466;51;54;52;53;50;472;;1,0.8500044,0.4735848,1;0;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;435;-2016,32;Inherit;False;579.2;735.9199;Defaul Unity Light Probes;7;427;426;425;424;430;429;428;;0.8294254,1,0.6396227,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;470;-2240,1008;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TextureCoordinatesNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;472;-1932.5,-432.8092;Inherit;False;0;3;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;457;-2016,-1392;Inherit;False;756;475;Albedo;6;3;87;88;337;419;455;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector4Node, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;424;-1952,224;Inherit;False;Global;unity_SHAr;unity_SHAr;17;0;Fetch;True;0;0;0;False;0;False;0,0,0,0;-0.01133499,0.00130087,0.007937171,0.1727012;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;425;-1952,400;Inherit;False;Global;unity_SHAg;unity_SHAg;17;0;Fetch;True;0;0;0;False;0;False;0,0,0,0;-0.01783318,0.04936448,0.01248796,0.2148392;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;426;-1952,576;Inherit;False;Global;unity_SHAb;unity_SHAb;17;0;Fetch;True;0;0;0;False;0;False;0,0,0,0;-0.03078351,0.1389579,0.0215575,0.2960468;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;78;-2032,880;Inherit;False;LightVolume;-1;;3;78706f2b7f33b1c44b4f381a7904a7e1;4,8,0,10,0,11,0,12,0;2;6;FLOAT3;0,0,0;False;17;FLOAT3;0,0,0;False;4;FLOAT3;13;FLOAT3;14;FLOAT3;15;FLOAT3;16
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;79;-2032,1040;Inherit;False;LightVolume;-1;;4;78706f2b7f33b1c44b4f381a7904a7e1;4,8,1,10,1,11,1,12,1;2;6;FLOAT3;0,0,0;False;17;FLOAT3;0,0,0;False;4;FLOAT3;13;FLOAT3;14;FLOAT3;15;FLOAT3;16
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;50;-1696,-448;Inherit;True;Property;_MetallicGlossMap;Metal AO Smoothness;3;1;[NoScaleOffset];Create;False;0;0;0;False;0;False;3;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;53;-1696,-176;Inherit;False;Property;_Metallic;Metallic;4;0;Create;False;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;3;-1968,-1152;Inherit;True;Property;_MainTex;Albedo;1;0;Create;False;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;87;-1904,-1344;Inherit;False;Property;_Color;Color;2;0;Create;True;0;0;0;False;0;False;1,1,1,1;1,1,1,1;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ComponentMaskNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;428;-1696,224;Inherit;False;True;True;True;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ComponentMaskNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;429;-1696,400;Inherit;False;True;True;True;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ComponentMaskNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;430;-1696,576;Inherit;False;True;True;True;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;427;-1632,96;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;93;-1712,944;Inherit;False;Property;_AdditiveOnly;Additive Only;15;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;467;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;94;-1712,1040;Inherit;False;Property;_AdditiveOnly;Additive Only;15;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;467;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;95;-1712,1136;Inherit;False;Property;_AdditiveOnly;Additive Only;15;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;467;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;467;-1712,848;Inherit;False;Property;LIGHTMAP_ON;LIGHTMAP_ON;15;0;Create;False;0;0;0;False;0;False;0;0;0;False;LIGHTMAP_ON;Toggle;2;Key0;Key1;Fetch;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;52;-1696,-256;Inherit;False;Property;_Glossiness;Smoothness;5;0;Create;False;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;54;-1376,-400;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;88;-1648,-1152;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;461;-1344,672;Inherit;False;Property;_Keyword0;Keyword 0;11;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;431;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;462;-1344,768;Inherit;False;Property;_Keyword1;Keyword 1;11;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;431;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;463;-1344,864;Inherit;False;Property;_Keyword2;Keyword 2;11;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;431;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;431;-1344,576;Inherit;False;Property;_LightVolumes;Enable Light Volumes;11;0;Create;False;0;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;51;-1376,-304;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;466;-1216,-416;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;459;-656,-880;Inherit;False;1380;643;Speculars;14;359;410;360;111;114;339;340;362;411;123;108;115;122;412;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;337;-1504,-1152;Inherit;False;Albedo;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;99;-1088,672;Inherit;False;L1r;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;100;-1088,768;Inherit;False;L1g;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;101;-1088,864;Inherit;False;L1b;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;98;-1088,576;Inherit;False;L0;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;109;-1216,-304;Inherit;False;Smoothness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;56;-1696,-96;Inherit;False;Property;_OcclusionStrength;AO;6;0;Create;False;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;334;-1056,-416;Inherit;False;Metallic;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;111;-576,-752;Inherit;False;109;Smoothness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;114;-608,-368;Inherit;False;112;World Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;339;-576,-816;Inherit;False;337;Albedo;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;340;-576,-688;Inherit;False;334;Metallic;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;123;-576,-432;Inherit;False;101;L1b;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;108;-576,-560;Inherit;False;99;L1r;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;115;-576,-624;Inherit;False;98;L0;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;122;-576,-496;Inherit;False;100;L1g;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;57;-1376,-208;Inherit;False;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;362;-304,-832;Inherit;False;LightVolumeSpecular;-1;;220;a5ec4a1f240e00f47a5deb132f113431;1,159,0;9;138;FLOAT3;1,1,1;False;3;FLOAT;0;False;137;FLOAT;0;False;65;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;36;FLOAT3;0,0,0;False;37;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;9;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;411;-304,-544;Inherit;False;LightVolumeSpecular;-1;;221;a5ec4a1f240e00f47a5deb132f113431;1,159,1;9;138;FLOAT3;1,1,1;False;3;FLOAT;0;False;137;FLOAT;0;False;65;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;36;FLOAT3;0,0,0;False;37;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;9;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;357;-1216,-208;Inherit;False;AO;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;458;-656,-176;Inherit;False;1685;417;Indirect and Speculars;16;464;361;124;444;413;406;80;338;350;336;451;450;449;448;113;465;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;359;80,-576;Inherit;False;357;AO;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;410;-16,-688;Inherit;False;Property;_DominantDirSpeculars;Dominant Dir Speculars;14;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;113;-608,-128;Inherit;False;112;World Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;448;-576,-64;Inherit;False;98;L0;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;449;-576,0;Inherit;False;99;L1r;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;450;-576,64;Inherit;False;100;L1g;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;451;-576,128;Inherit;False;101;L1b;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;336;-368,128;Inherit;False;334;Metallic;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;360;320,-688;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.FunctionNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;350;-288,-128;Inherit;False;LightVolumeEvaluate;-1;;222;4919cc1d83093f24f802ce655e9f3303;0;5;5;FLOAT3;0,0,0;False;13;FLOAT3;1,1,1;False;14;FLOAT3;0,0,0;False;15;FLOAT3;0,0,0;False;16;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;338;-224,48;Inherit;False;337;Albedo;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;80;-192,128;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;412;480,-688;Inherit;False;Speculars;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;406;0,-128;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;413;0,32;Inherit;False;412;Speculars;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;124;192,-48;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;361;320,-128;Inherit;False;Property;_Speculars;Speculars;13;0;Create;True;0;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;464;384,-16;Inherit;False;357;AO;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;460;-656,288;Inherit;False;1387.253;488.9682;Emission Plus Indirect and Speculars;7;452;417;447;416;415;414;473;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;465;592,-128;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TextureCoordinatesNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;473;-577.2529,473.1902;Inherit;False;0;3;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;444;768,-128;Inherit;False;IndirectAndSpeculars;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;414;-272,560;Inherit;True;Property;_EmissionMap;Emission Map;9;2;[HDR];[NoScaleOffset];Create;False;0;0;0;False;0;False;3;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.ColorNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;415;-208,352;Inherit;False;Property;_EmissionColor;Emission Color;10;1;[HDR];Create;False;0;0;0;False;0;False;0,0,0,1;1,1,1,1;True;True;0;6;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT3;5
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;416;48,480;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;447;48,592;Inherit;False;444;IndirectAndSpeculars;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;419;-1648,-1056;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;417;304,480;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;455;-1504,-1056;Inherit;False;Opacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;437;-1344,-816;Inherit;False;Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;452;464,480;Inherit;False;Emission;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;440;1088,-16;Inherit;False;334;Metallic;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;441;1056,64;Inherit;False;109;Smoothness;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;442;1088,144;Inherit;False;357;AO;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;456;1088,224;Inherit;False;455;Opacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;438;1088,-176;Inherit;False;437;Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;454;1088,-256;Inherit;False;337;Albedo;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;453;1088,-96;Inherit;False;452;Emission;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;418;1504,240;Inherit;False;Property;_Culling;Culling;15;1;[Enum];Create;False;0;0;1;UnityEngine.Rendering.CullMode;True;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode, AmplifyShaderEditor, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null;72;1504,-224;Float;False;True;-1;7;AmplifyShaderEditor.MaterialInspector;0;0;Standard;Light Volume Samples/Light Volume PBR Cutout;False;False;False;False;True;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;_ZWrite;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;True;0;True;TransparentCutout;;AlphaTest;ForwardOnly;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;True;_Culling;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;17;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;16;FLOAT4;0,0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;5;1;471;0
WireConnection;5;5;6;0
WireConnection;14;0;5;0
WireConnection;349;0;14;0
WireConnection;112;0;349;0
WireConnection;470;0;468;0
WireConnection;470;1;469;0
WireConnection;78;17;470;0
WireConnection;79;17;470;0
WireConnection;50;1;472;0
WireConnection;428;0;424;0
WireConnection;429;0;425;0
WireConnection;430;0;426;0
WireConnection;427;0;424;4
WireConnection;427;1;425;4
WireConnection;427;2;426;4
WireConnection;93;1;78;14
WireConnection;93;0;79;14
WireConnection;94;1;78;15
WireConnection;94;0;79;15
WireConnection;95;1;78;16
WireConnection;95;0;79;16
WireConnection;467;1;78;13
WireConnection;467;0;79;13
WireConnection;54;0;50;1
WireConnection;54;1;53;0
WireConnection;88;0;87;5
WireConnection;88;1;3;5
WireConnection;461;1;428;0
WireConnection;461;0;93;0
WireConnection;462;1;429;0
WireConnection;462;0;94;0
WireConnection;463;1;430;0
WireConnection;463;0;95;0
WireConnection;431;1;427;0
WireConnection;431;0;467;0
WireConnection;51;0;50;4
WireConnection;51;1;52;0
WireConnection;466;0;54;0
WireConnection;466;1;54;0
WireConnection;337;0;88;0
WireConnection;99;0;461;0
WireConnection;100;0;462;0
WireConnection;101;0;463;0
WireConnection;98;0;431;0
WireConnection;109;0;51;0
WireConnection;334;0;466;0
WireConnection;57;1;50;2
WireConnection;57;2;56;0
WireConnection;362;138;339;0
WireConnection;362;3;111;0
WireConnection;362;137;340;0
WireConnection;362;65;115;0
WireConnection;362;1;108;0
WireConnection;362;36;122;0
WireConnection;362;37;123;0
WireConnection;362;2;114;0
WireConnection;411;138;339;0
WireConnection;411;3;111;0
WireConnection;411;137;340;0
WireConnection;411;65;115;0
WireConnection;411;1;108;0
WireConnection;411;36;122;0
WireConnection;411;37;123;0
WireConnection;411;2;114;0
WireConnection;357;0;57;0
WireConnection;410;1;362;0
WireConnection;410;0;411;0
WireConnection;360;0;410;0
WireConnection;360;1;359;0
WireConnection;350;5;113;0
WireConnection;350;13;448;0
WireConnection;350;14;449;0
WireConnection;350;15;450;0
WireConnection;350;16;451;0
WireConnection;80;0;336;0
WireConnection;412;0;360;0
WireConnection;406;0;350;0
WireConnection;406;1;338;0
WireConnection;406;2;80;0
WireConnection;124;0;406;0
WireConnection;124;1;413;0
WireConnection;361;1;406;0
WireConnection;361;0;124;0
WireConnection;465;0;361;0
WireConnection;465;1;464;0
WireConnection;444;0;465;0
WireConnection;414;1;473;0
WireConnection;416;0;415;5
WireConnection;416;1;414;5
WireConnection;419;0;87;4
WireConnection;419;1;3;4
WireConnection;417;0;416;0
WireConnection;417;1;447;0
WireConnection;455;0;419;0
WireConnection;437;0;5;0
WireConnection;452;0;417;0
WireConnection;72;0;454;0
WireConnection;72;1;438;0
WireConnection;72;2;453;0
WireConnection;72;3;440;0
WireConnection;72;4;441;0
WireConnection;72;5;442;0
WireConnection;72;10;456;0
ASEEND*/
//CHKSM=EF2E78CE511A3BD35187805CDF94F3CF89AD8562