Includes = {
	"constants.fxh"
	"terra_incognita.fxh"
}

PixelShader =
{
	Samplers =
	{
		Diffuse = {
			Index = 0;
			MagFilter = "Linear";
			MinFilter = "Linear";
			AddressU = "Wrap";
			AddressV = "Wrap";
		}
		BorderID = {
			Index = 1;
			MagFilter = "point";
			MinFilter = "point";
			MipFilter = "none";
			AddressU = "Clamp";
			AddressV = "Clamp";
		}
		BorderSDF = {
			Index = 2
			MagFilter = "linear"
			MinFilter = "linear"
			AddressU = "Clamp"
			AddressV = "Clamp"
		}
		TerraIncognitaTexture = 
		{
			Index = 3;
			MagFilter = "Linear";
			MinFilter = "Linear";
			AddressU = "Clamp"
			AddressV = "Clamp"
		}
	}
}

VertexStruct VS_INPUT
{
	float2  vPosition 	: POSITION;
	float2  vUV 		: TEXCOORD0;
};

VertexStruct VS_INPUT_STAR_PIN
{
	float2	vOffset		: POSITION;
	float	vGroundStarBlend : TEXCOORD0;
};

VertexStruct VS_OUTPUT_STAR_PIN
{
	float4 vPosition	: PDX_POSITION;
	float3 vPos			: TEXCOORD0;
};

VertexStruct VS_OUTPUT
{
    float4 vPosition 	: PDX_POSITION;
	float2 vUV			: TEXCOORD0;
	float2 vPos			: TEXCOORD2;
};

VertexStruct VS_INPUT_SECTOR
{
	float2	vPosition	: POSITION;
	float	vDistance	: TEXCOORD0;
};

VertexStruct VS_OUTPUT_SECTOR
{
	float4 	vPosition 	: PDX_POSITION;
	float2 	vUV			: TEXCOORD0;
	float 	vDistance	: TEXCOORD1;
};

ConstantBuffer( CountryBorders, 0, 0 )	#Country borders
{
	float4x4	ViewProjectionMatrix;
	float3		vCamPos;
	float3		vCamLookAtDir;
	float3		vCamUpDir;
	float3		vCamRightDir;
	float2		vCamFOV;
	float 		vFade;
	float		vTextureSize;
};

ConstantBuffer( StarPins, 0, 0 )	#Star pins
{
	float4x4	ViewProjectionMatrix;
	float3		StarPos;
	float3		GroundPos;
	float4		vStarPinColor;
};

ConstantBuffer( SectorBorders, 0, 0 )	#Sector borders
{
	float4x4	ViewProjectionMatrix;
	float3	vCamPos;
	float		vCamZoom;
	float2	vBoundsMin;
	float2	vBoundsMax;
}

ConstantBuffer( CountrySdfBorders, 0, 0 ) #SDF borders
{
	float4x4	ViewProjectionMatrix;
	float3		vCamPos;
	float4		PrimaryColor;
	float4		SecondaryColor;
	float		vSdfTime;
	float		vBorderHighLight;
}

VertexShader =
{
	MainCode VertexShader
		ConstantBuffers = { CountryBorders }
	[[
		VS_OUTPUT main(const VS_INPUT v )
		{
			VS_OUTPUT Out;
			Out.vPosition  	= mul( ViewProjectionMatrix, float4( v.vPosition.x, 0.0f, v.vPosition.y, 1.0f ) );
			Out.vUV			= v.vUV;
			Out.vPos 		= v.vPosition.xy;
			return Out;
		}
		
	]]
	MainCode VertexShaderStarPin
		ConstantBuffers = { StarPins }
	[[
		VS_OUTPUT_STAR_PIN main( const VS_INPUT_STAR_PIN v )
		{
			VS_OUTPUT_STAR_PIN Out;
			float3 vPos = lerp( GroundPos, StarPos, v.vGroundStarBlend );
			vPos.xz += v.vOffset;
			
			//float3 vPos = float3( v.vOffset.x, v.vGroundStarBlend * 100.f, v.vOffset.y );
			//vPos += StarPos;
			Out.vPosition  	= mul( ViewProjectionMatrix, float4( vPos, 1.0f ) );
			Out.vPos = vPos;
			return Out;
		}
	]]
	MainCode VertexShaderSectorSdf
		ConstantBuffers = { SectorBorders }
	[[
		VS_OUTPUT_SECTOR main(const VS_INPUT_SECTOR v )
		{
			VS_OUTPUT_SECTOR Out;
			Out.vPosition  	= mul( ViewProjectionMatrix, float4( v.vPosition.x, 0.0f, v.vPosition.y, 1.0f ) );
			Out.vUV 		= ( v.vPosition - vBoundsMin ) / ( vBoundsMax - vBoundsMin );
			Out.vDistance	= v.vDistance;
			return Out;
		}
		
	]]
}

PixelShader =
{
	MainCode PixelShaderSDF
		ConstantBuffers = { CountrySdfBorders }
	[[
		float4 main( VS_OUTPUT v ) : PDX_COLOR
		{
			float vDist = tex2D( BorderSDF, v.vUV ).a;
			
			const float vMaxMidDistance = 0.53f;	
			const float vMinMidDistance = 0.47f;
			clip( vMaxMidDistance - vDist );
			
			float vCameraDistance = length( vCamPos - float3(v.vPos.x, 0.f, v.vPos.y ) );
			float vCamDistFactor = saturate( vCameraDistance / 1600.0f );
			
			float vMid = lerp( vMinMidDistance, vMaxMidDistance, vCamDistFactor );
			
			float vEpsilon = 0.005f + vCamDistFactor * 0.05f;
			float vOffset = -0.000f;
			float vAlpha = smoothstep( vMid + vEpsilon, vMid - vEpsilon, vDist + vOffset );
					
			float vAlphaMin = 0.5f + 0.5f * vCamDistFactor;
			
			float vEdgeWidth = 0.025f + 0.35f * vCamDistFactor / 2;
			const float vEdgeSharpness = 100.0f;			
			float vBlackBorderWidth = vEdgeWidth * 0.25f;
			const float vBlackBorderSharpness = 25.0f;

			//vAlphaOuterEdge makes the outermost edge smoother
			float vAlphaOuterEdge = smoothstep( vMid + vEpsilon, vMid - vEpsilon, vDist + vOffset );
			//vAlphaEdge is the saturated part at the outer edge
			float vAlphaEdge = saturate( (vDist-vMid + vEdgeWidth)*vEdgeSharpness ) / 2;
			//vAlphaFill is the soft gradient inside the blobs
			float vAlphaFill = max( vAlphaMin, saturate( vMid + (vDist-0.25f + vEdgeWidth*1.0f)*2.0f ) * 0.75f ) / 2;

			float4 vColor = vAlphaEdge *  SecondaryColor + ( 1 - vAlphaEdge ) * PrimaryColor;

			//Add a black edge that becomes more visible the further away from the camera it is
			vColor *= 1.0f - ( 0.25f * saturate( (vDist-vMid + vBlackBorderWidth)*vBlackBorderSharpness ) );
			vColor[3] = saturate(vAlphaEdge + vAlphaFill) * vAlphaOuterEdge;

			// Fade out based on Terra Incognita
			float2 vTIUV = ( v.vPos.xy + GALAXY_SIZE * 0.5f ) / GALAXY_SIZE;
			vColor.a *= tex2D( TerraIncognitaTexture, vTIUV ).a;
			
			return vColor;
		}
		
	]]
		
	MainCode PixelShaderCentroid
		ConstantBuffers = { CountryBorders }
	[[
		float4 main( VS_OUTPUT v ) : PDX_COLOR
		{
			float4 vColor = tex2D( Diffuse, float2( -v.vUV.x, v.vUV.y ) );
			vColor.a *= vFade * 0.65f;
			return vColor;
		}
		
	]]
	MainCode PixelShaderStarPin
		ConstantBuffers = { StarPins }
	[[
		float4 main( VS_OUTPUT_STAR_PIN v ) : PDX_COLOR
		{
			float4 vColor = vStarPinColor;
			vColor.a *= 0.2f;
			
			vColor = ApplyTerraIncognita( vColor, v.vPos.xz, 4.f, TerraIncognitaTexture );
			
			return saturate( vColor );
		}
	]]
	MainCode PixelShaderSectorSdf
		ConstantBuffers = { SectorBorders }
	[[
		float4 main( VS_OUTPUT_SECTOR v ) : PDX_COLOR
		{
			float vDist = tex2D( BorderSDF, v.vUV ).a;
			float vDistance = min( v.vDistance/64.0f, 0.5f - vDist );
			clip( vDistance - 0.0001f );
					
			float vThickness = 0.005f + ( vCamZoom / 70000.f );
			float vInvThickness = 1.f / vThickness;
			
			//1 - ( (x - 0.25) * 4 ) ^ 2
			float vValue = 1.f - pow( ( vDistance - vThickness ) * vInvThickness, 2.f );
			
			if( v.vDistance > vThickness )
			{
				vValue = max( vValue, 0.1f );
			}
			vValue = saturate( vValue );
			
			float3 vColor = float3( 1.f, 1.f, 1.f );
			return float4( vColor * vValue, vValue * 0.75f  + 0.8f);
		}
	]]
}

BlendState BlendState
{
	BlendEnable = yes
	AlphaTest = no
	SourceBlend = "SRC_ALPHA"
	DestBlend = "INV_SRC_ALPHA"
	WriteMask = "RED|GREEN|BLUE|ALPHA"
}

BlendState BlendStateAdditiveBlend
{
	BlendEnable = yes
	SourceBlend = "SRC_ALPHA"
	DestBlend = "ONE"
	WriteMask = "RED|GREEN|BLUE|ALPHA"
}

DepthStencilState DepthStencilState
{
	DepthEnable = no
	DepthWriteMask = "depth_write_zero"
}

RasterizerState RasterizerState
{
	FillMode = "FILL_SOLID"
	CullMode = "CULL_NONE"
	FrontCCW = no
	
	#FillMode = "fill_wireframe"	
}

Effect BorderSDF
{
	VertexShader = "VertexShader"
	PixelShader = "PixelShaderSDF"
}

Effect BorderCentroid
{
	VertexShader = "VertexShader"
	PixelShader = "PixelShaderCentroid"
}

Effect StarPin
{
	VertexShader = "VertexShaderStarPin"
	PixelShader = "PixelShaderStarPin"
	
	BlendState = "BlendStateAdditiveBlend"
}

Effect SectorSdf
{
	VertexShader = "VertexShaderSectorSdf"
	PixelShader = "PixelShaderSectorSdf"
	
	BlendState = "BlendStateAdditiveBlend"
}
