Includes = {
	"constants.fxh"
	"standardfuncsgfx.fxh"
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

DepthStencilState DepthStencilState
{
	DepthEnable = no
}

VertexStruct VS_INPUT
{
	float3 vPosition  		: POSITION;
	float4 vPrimaryColor		: TEXCOORD0;
	float4 vSecondaryColor 	: TEXCOORD1;
};

VertexStruct VS_OUTPUT
{
	float4  vPosition 		: PDX_POSITION;
	float2  vPos 			: TEXCOORD0;
	float3  vPrimaryColor	: TEXCOORD1;
	float3  vSecondaryColor	: TEXCOORD2;
	float	vPrimaryColorFactor		: TEXCOORD3;
	float   vSecondaryColorFactor	: TEXCOORD4;
};

VertexShader =
{
	MainCode VertexShader
		ConstantBuffers = { Common }
	[[
		VS_OUTPUT main(const VS_INPUT v )
		{ 
			VS_OUTPUT Out;
			Out.vPos = v.vPosition.xz;
			Out.vPosition  	= mul( ViewProjectionMatrix, float4( v.vPosition, 1.0 ) );
			Out.vPrimaryColor = v.vPrimaryColor.rgb;
			Out.vSecondaryColor = v.vSecondaryColor.rgb;
			Out.vPrimaryColorFactor = v.vPrimaryColor.a;
			Out.vSecondaryColorFactor = v.vSecondaryColor.a;
			return Out;
		}
		
	]]
}

PixelShader =
{	
	MainCode PixelShader
	[[
		float4 main( VS_OUTPUT v ) : PDX_COLOR
		{
			float fMinAlpha = 0.01f;
			float fAlpha = saturate(0.125 - ( abs(distance(0, v.vPos)) * 0.000275f)) + fMinAlpha;

			float4 vPrimColor = float4( v.vPrimaryColor, fAlpha );
			float4 vSecColor = float4( v.vSecondaryColor, fAlpha );
			float4 vColor = lerp( vSecColor, vPrimColor, saturate( pow( v.vPrimaryColorFactor, 15 ) ) );
			vColor = ApplyTerraIncognita( vColor, v.vPos, 5.f, TerraIncognitaTexture );
			vColor.a = lerp( fMinAlpha * saturate( pow( v.vSecondaryColorFactor, 8 ) ), fAlpha, CalcTerraIncognitaValue( v.vPos, TerraIncognitaTexture ) );
			return vColor;
		}
		
	]]
}

Effect Hyperlane
{
	VertexShader = "VertexShader"
	PixelShader = "PixelShader"
}
