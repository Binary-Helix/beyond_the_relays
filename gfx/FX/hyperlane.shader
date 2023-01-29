Includes = {
	"constants.fxh"
	"terra_incognita.fxh"
}

PixelShader =
{
	Samplers = 
	{		
		TerraIncognitaTexture = 
		{
			Index = 0;
			MagFilter = "Linear";
			MinFilter = "Linear";
			AddressU = "Clamp"
			AddressV = "Clamp"
		}
	}
}

BlendState BlendState
{
	BlendEnable = yes
	AlphaTest = no
	SourceBlend = "SRC_ALPHA"
	DestBlend = "INV_SRC_ALPHA"
	WriteMask = "RED|GREEN|BLUE"
} 

BlendState BlendStateAlphaClear
{
	BlendEnable = yes
	AlphaTest = no
	SourceAlpha = "ONE"
	DestAlpha = "ONE"
	WriteMask = "ALPHA"
	BlendOpAlpha = blend_op_max
}

BlendState BlendStateAlphaWrite
{
	BlendEnable = yes
	AlphaTest = no
	SourceAlpha = "ONE"
	DestAlpha = "ONE"
	WriteMask = "ALPHA"
	BlendOpAlpha = blend_op_min
}

BlendState BlendStateColorOnly
{
	BlendEnable = yes
	AlphaTest = no
	SourceBlend = "INV_DEST_ALPHA"
	DestBlend = "ONE"
	SourceAlpha = "ONE"
	DestAlpha = "ONE"
	WriteMask = "RED|GREEN|BLUE|ALPHA"
	BlendOp = blend_op_add
	BlendOpAlpha = blend_op_max
}

DepthStencilState DepthStencilState
{
	DepthEnable = yes
	DepthWriteMask = "depth_write_zero"
}

VertexStruct VS_INPUT
{
	float3 Position			: POSITION;
	float4 PrimaryColor		: TEXCOORD0;
	float4 SecondaryColor	: TEXCOORD1;
	float Access			: TEXCOORD2;
	float Visibility		: TEXCOORD3;
	float4 UV				: TEXCOORD4; // U, V, WidthScale, HeightScale
	float4 ControlPoint		: TEXCOORD5;
};

VertexStruct VS_LINE_OUTPUT
{
	float4 Position 		: PDX_POSITION;
	float4 PrimaryColor		: TEXCOORD1;
	float4 SecondaryColor	: TEXCOORD2;
	float2 IncognitaLookup 	: TEXCOORD3; 
	float Access			: TEXCOORD4;
	float Visibility		: TEXCOORD5;
}; 

VertexStruct VS_QUAD_OUTPUT
{
	float4 Position 		: PDX_POSITION;
	float4 PrimaryColor		: TEXCOORD1;
	float4 SecondaryColor	: TEXCOORD2;
	float3 UV				: TEXCOORD3; // U, V, W
	float2 IncognitaLookup 	: TEXCOORD4; // U, V,
	float Access			: TEXCOORD5;
	float Visibility		: TEXCOORD6;
};

ConstantBuffer( HyperLaneConstants, 0, 0 )
{
	float4x4 	ViewProjectionMatrix;
	float		GlobalAlpha;
};

ConstantBuffer( QuadExpansionConstants, 1, 16 )
{
	float AspectRatio;
	float Thickness;
	float MinThickness;
	float MaxThickness;
}

RasterizerState RasterizerState
{
	FillMode = "FILL_SOLID"
	CullMode = "CULL_NONE"
	FrontCCW = no
}

VertexShader =
{
	MainCode VertexQuadLineRenderer
		ConstantBuffers = { HyperLaneConstants QuadExpansionConstants }
	[[
		VS_QUAD_OUTPUT main( const VS_INPUT v )
		{
			// takes a list of quads of width 0, expanding them along UV coords.
			VS_QUAD_OUTPUT Out;
			Out.IncognitaLookup = v.Position.xz;
			Out.PrimaryColor = v.PrimaryColor;
			Out.SecondaryColor = v.SecondaryColor;
			Out.Access = v.Access;
			Out.Visibility = v.Visibility;
			Out.Position = mul( ViewProjectionMatrix, float4( v.Position, 1.0 ) );
			float4 Next = mul( ViewProjectionMatrix, v.ControlPoint );
 
#ifdef UNIFORM_WIDTH 
			float SrcWidth = clamp( Thickness * Out.Position.w * 0.1, MinThickness, MaxThickness ) * v.UV.z;
			float DstWidth = clamp( Thickness * Next.w * 0.1, MinThickness, MaxThickness ) * v.UV.w;
#else 
			float SrcWidth = clamp( Thickness * 0.1, MinThickness, MaxThickness ) * v.UV.z;
			float DstWidth = clamp( Thickness * 0.1, MinThickness, MaxThickness ) * v.UV.w;
#endif 
			// expand to either a line or a billboard.
			float2 Perpendicular = ( Next.xy / Next.w ) - ( Out.Position.xy / Out.Position.w );
			float SelectPerpendicular = step( .001, length( Perpendicular ) );

			// make it actually perpendicular.
			Perpendicular = normalize( Perpendicular ).yx;
			Perpendicular.y = -Perpendicular.y;
			Perpendicular.xy *= (2 * ( v.UV.x - 0.5 ) ) * ( 2 * ( v.UV.y - 0.5 ) );
			float2 Billboard = 2 * ( v.UV.xy - 0.5 );
			Out.Position.x += lerp(Billboard.x, Perpendicular.x, SelectPerpendicular) * SrcWidth;
			Out.Position.y += lerp(Billboard.y, Perpendicular.y, SelectPerpendicular) * SrcWidth * AspectRatio;

			// keep size ratio in z for unpacking.
			float SizeRatio = ( SrcWidth + DstWidth ) / DstWidth; 
			Out.UV.x = v.UV.x * SizeRatio;
			Out.UV.y = lerp( v.UV.y, 0.5, SelectPerpendicular ) * SizeRatio;
			Out.UV.z = SizeRatio;

			return Out;
		}
	]] 

	MainCode VertexLineLegacy
		ConstantBuffers = { HyperLaneConstants }
	[[
		VS_LINE_OUTPUT main(const VS_INPUT v )
		{ 
			VS_LINE_OUTPUT Out;
			Out.IncognitaLookup = v.Position.xz;
			Out.PrimaryColor = v.PrimaryColor;
			Out.SecondaryColor = v.SecondaryColor;
			Out.Access = v.Access;
			Out.Visibility = v.Visibility;
			Out.Position = mul( ViewProjectionMatrix, float4( v.Position, 1.0 ) );
			return Out;
		}
	]]
}

PixelShader =
{	
	Code 
		ConstantBuffers = { HyperLaneConstants }
	[[
		static const float INCOGNITA_HYPERLANE_ALPHA = 0.05f;

		float GetBaseAlpha( const VS_QUAD_OUTPUT In )
		{
			float RegularAlpha = lerp( In.SecondaryColor.a, In.PrimaryColor.a, In.Access ) * GlobalAlpha; 
			float IncognitaAlpha = INCOGNITA_HYPERLANE_ALPHA * saturate( pow( In.Visibility, 4 ) ) * GlobalAlpha;
			float IncognitaValue = CalcTerraIncognitaValue( In.IncognitaLookup, TerraIncognitaTexture );
			return lerp( IncognitaAlpha, RegularAlpha, IncognitaValue );
		}

		float3 GetBaseRGB( const VS_QUAD_OUTPUT In )
		{
			float4 Primary = float4( 0.692, 1.329, 1.4, 1.0 );
			float4 Secondary = float4( In.SecondaryColor.rgb, 1.0 );
			float4 Color = lerp( Secondary, Primary, saturate( pow( In.Access, 15 ) ) );
			
			// We want same color on Incognita lines regardless of Access, so use IgnoreSaturation version.
			Color = ApplyTerraIncognitaIgnoreSaturation( Color, In.IncognitaLookup, 5.f, TerraIncognitaTexture );
			return Color.rgb;
		}

		float4 GetBaseRGBA( const VS_QUAD_OUTPUT In )
		{
			float4 Out;
			Out.rgb = GetBaseRGB( In );
			Out.a = GetBaseAlpha( In );
			return Out;
		}

		float2 UnpackLineRendererUV( float3 Packed )
		{
			// Undo perspective correction.
			return Packed.xy / Packed.z;
		}

		float ApplyAlpha( float DistanceFromCenter )
		{
			// this can be replaced with a proper texture lookup
			// for now, just get a custom value to apply from distance to center.

			// default
			return saturate( pow( DistanceFromCenter, 0.8 ) * 2.0 );
		}
	]]

	# default shader, has some issues with self-transparency
	MainCode PixelLineDefault
		ConstantBuffers = { HyperLaneConstants }
	[[
		float4 main( VS_QUAD_OUTPUT v ) : PDX_COLOR 
		{
			float4 BaseColor = GetBaseRGBA( v );
			float2 UV = UnpackLineRendererUV( v.UV );
			float LineDistance = 1 - saturate( length( UV * 2.0 - float2( 1.0, 1.0 ) ) );
			return ApplyAlpha( LineDistance * BaseColor.a ) * BaseColor;
		} 
	]] 

	MainCode PixelLineAlphaMask
		ConstantBuffers = { HyperLaneConstants }
	[[
		float4 main( VS_QUAD_OUTPUT v ) : PDX_COLOR 
		{ 
			float2 UV = UnpackLineRendererUV( v.UV );
			float LineDistance = 1 - saturate( length( UV * 2.0 - float2( 1.0, 1.0 ) ) );
			float OutputAlpha = GetBaseAlpha( v );
			float LineAlpha = ApplyAlpha( LineDistance );
			return float4( 0.0, 0.0, 0.0, lerp( 1.0, 1 - LineAlpha, OutputAlpha ) );
		} 
	]] 

	MainCode PixelLineColor 
		ConstantBuffers = { HyperLaneConstants }
	[[
		float4 main( VS_QUAD_OUTPUT v ) : PDX_COLOR 
		{
			return float4( GetBaseRGB( v ), 1.0 );
		} 
	]] 

	MainCode PixelFlatColor
		ConstantBuffers = { HyperLaneConstants }
	[[
		float4 main( VS_QUAD_OUTPUT v ) : PDX_COLOR 
		{
			return float4( 0.0, 0.0, 0.0, 1.0 );
		} 
	]] 
}

Effect HyperlaneLegacy
{
	VertexShader = "VertexLineLegacy"
	PixelShader = "PixelLineLegacy"
}

Effect HyperlaneQuadLine
{
	VertexShader = "VertexQuadLineRenderer"
	PixelShader = "PixelLineDefault" 
	Defines = { "UNIFORM_WIDTH" }
}

Effect HyperlaneQuadLineAlphaPass1
{
	VertexShader = "VertexQuadLineRenderer"
	PixelShader = "PixelFlatColor" 
	BlendState = "BlendStateAlphaClear"
	Defines = { "UNIFORM_WIDTH" }
} 

Effect HyperlaneQuadLineAlphaPass2 
{
	VertexShader = "VertexQuadLineRenderer"
	PixelShader = "PixelLineAlphaMask" 
	BlendState = "BlendStateAlphaWrite"
	Defines = { "UNIFORM_WIDTH" }
} 

Effect HyperlaneQuadLineFlatColorPass 
{
	VertexShader = "VertexQuadLineRenderer"
	PixelShader = "PixelLineColor" 
	BlendState = "BlendStateColorOnly"
	Defines = { "UNIFORM_WIDTH" }
}