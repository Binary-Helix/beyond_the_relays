Includes = {
	"constants.fxh"
	"standardfuncsgfx.fxh"
	"shadow.fxh"
	"tiled_pointlights.fxh"
}

VertexShader =
{
	MainCode VertexPdxMeshStandardRS
		ConstantBuffers = { Common, ShipConstants, Shadow }
	[[
		VS_OUTPUT_PDXMESHSTANDARD main( const VS_INPUT_PDXMESHSTANDARD v )
		{
		  	VS_OUTPUT_PDXMESHSTANDARD Out;

			float4 vPosition = float4( v.vPosition.xyz, 1.0f );
			Out.vSphere = float4( v.vPosition, 1.0f );
			Out.vNormal = normalize( mul( CastTo3x3( WorldMatrix ), v.vNormal ) );

			#ifdef IS_STAR
				Out.vTangent = normalize( v.vPosition.xyz ); //Use tangent for position
			#else
				Out.vTangent = normalize( mul( CastTo3x3( WorldMatrix ), v.vTangent.xyz ) );
			#endif
			Out.vBitangent = normalize( cross( Out.vNormal, Out.vTangent ) * v.vTangent.w );

			Out.vPosition = mul( WorldMatrix, vPosition );

			Out.vPos = Out.vPosition;
			Out.vPosition = mul( ViewProjectionMatrix, Out.vPosition );

			Out.vUV0 = v.vUV0;
#ifdef PDX_MESH_UV1
			Out.vUV1 = v.vUV1;
#else
			Out.vUV1 = v.vUV0;
#endif

			return Out;
		}

	]]
}

PixelShader =
{
	MainCode PixelPdxMeshAdditiveRS
		ConstantBuffers = { Common, ShipConstants, Shadow }
	[[
		float4 main( VS_OUTPUT_PDXMESHSTANDARD In ) : PDX_COLOR
		{
			float2 vUV = In.vUV0;
			vUV += vUVAnimationDir * vUVAnimationTime;

			float4 vDiffuse = tex2D( DiffuseMap, vUV );

		#ifdef ANIMATE_UV
			#ifndef ANIMATE_UV_ALPHA
				vDiffuse.a = tex2D( DiffuseMap, In.vUV0 ).a;
			#endif
		#endif

		#ifdef ALPHA_TEST
			clip(vDiffuse.a - 1.0);
		#endif

			#ifdef ADD_COLOR
				vDiffuse.rgb *= PrimaryColor.rgb;
			#endif

			#ifdef ALPHA_OVERRIDE
				vDiffuse *= vAlphaOverrideMult;
			#endif

			vDiffuse.rgb *= vDiffuse.a;
			vDiffuse.a *= vBloomFactor;
			#ifdef GUI_ICON
				float vLen = length( vDiffuse.rgb );
				vDiffuse.rgb /= vLen;
				vDiffuse.a = saturate( vLen * 1.5f );
			#endif

			#ifdef BLACK_HOLE
				vDiffuse.rgb *= pow( 1.f - abs( dot( vCamLookAtDir, float3( 0.f, 1.f, 0.f ) ) ), 1.5f );
			#endif

			#ifdef DISSOLVE
			vDiffuse.rgb = ApplyDissolve( PrimaryColor.rgb, vDamage, vDiffuse.rgb, vDiffuse.rgb, In.vUV0 );
			#endif

			return vDiffuse;
		}

	]]
}

BlendState BlendStateAdditiveBlendRS
{
	BlendEnable = yes
	SourceBlend = "SRC_ALPHA"
	DestBlend = "ONE"
	WriteMask = "RED|GREEN|BLUE|ALPHA"
}

DepthStencilState DepthStencilNoZWriteRS
{
	DepthEnable = yes
	DepthWriteMask = "DEPTH_WRITE_ZERO"
}

RasterizerState RasterizerStateNoCullingRS
{
	CullMode = "CULL_NONE"
}



Effect PdxMeshPlanetRingsRS
{
	VertexShader = "VertexPdxMeshStandardRS"
	PixelShader = "PixelPdxMeshAdditiveRS"
	RasterizerState = "RasterizerStateNoCullingRS"
	BlendState = "BlendStateAdditiveBlendRS"
	DepthStencilState = "DepthStencilNoZWriteRS"
	Defines = { "IS_PLANET" "IS_RING" }
}