
Effect OmniMeshShip
{
	VertexShader = "VertexPdxMeshStandard"
    PixelShader = "PixelOmniMeshShip"
	Defines = {
		"PDX_IMPROVED_BLINN_PHONG"
		"RIM_LIGHT"
	}
}

Effect OmniMeshShipSkinned
{
	VertexShader = "VertexPdxMeshStandardSkinned"
    PixelShader = "PixelOmniMeshShip"
	Defines = {
		"PDX_IMPROVED_BLINN_PHONG"
		"RIM_LIGHT"
	}
}

Effect OmniMeshShipShadow
{
	VertexShader = "VertexPdxMeshStandardShadow"
	PixelShader = "PixelPdxMeshStandardShadow"
	Defines = { "IS_SHADOW" }
}

Effect OmniMeshShipSkinnedShadow
{
	VertexShader = "VertexPdxMeshStandardSkinnedShadow"
	PixelShader = "PixelPdxMeshStandardShadow"
	Defines = { "IS_SHADOW" }
}

Effect OmniMeshShipRecolor
{
    VertexShader = "VertexPdxMeshStandard"
    PixelShader = "PixelOmniMeshShip"
    Defines = {
		"ANIMATE_UV"
        "PDX_IMPROVED_BLINN_PHONG"
        "RIM_LIGHT"
        "RECOLOR_EMISSIVE"
    }
}

Effect OmniMeshShipRecolorShadow
{
    VertexShader = "VertexPdxMeshStandardShadow"
    PixelShader = "PixelPdxMeshStandardShadow"
    Defines = { "IS_SHADOW" }
}

Effect OmniMeshShipRecolorSkinned
{
	VertexShader = "VertexPdxMeshStandardSkinned"
    PixelShader = "PixelOmniMeshShip"
    Defines = {
        "PDX_IMPROVED_BLINN_PHONG"
        "RIM_LIGHT"
        "RECOLOR_EMISSIVE"
    }
}

Effect OmniMeshShipRecolorSkinnedShadow
{
	VertexShader = "VertexPdxMeshStandardSkinnedShadow"
    PixelShader = "PixelPdxMeshStandardShadow"
    Defines = { "IS_SHADOW" }
}

Effect OmniMeshShipAlpha
{
    VertexShader = "VertexPdxMeshStandard"
    PixelShader = "PixelOmniMeshShip"
	BlendState = "BlendStateAdditiveBlend"
	DepthStencilState = "DepthStencilNoZWrite"
	Defines = { "DISSOLVE" }
}

Effect OmniMeshShipAlphaShadow
{
    VertexShader = "VertexPdxMeshStandardShadow"
	PixelShader = "PixelPdxMeshNoShadow"
	Defines = { "IS_SHADOW" }
}

Effect OmniMeshShipAlphaSkinned
{
	VertexShader = "VertexPdxMeshStandardSkinned"
    PixelShader = "PixelOmniMeshShip"
	BlendState = "BlendStateAdditiveBlend"
	DepthStencilState = "DepthStencilNoZWrite"
	Defines = { "DISSOLVE" }
}

Effect OmniMeshShipAlphaSkinnedShadow
{
	VertexShader = "VertexPdxMeshStandardSkinnedShadow"
	PixelShader = "PixelPdxMeshNoShadow"
	Defines = { "IS_SHADOW" }
}

Effect OmniMeshMegaAlpha
{
    VertexShader = "VertexPdxMeshStandard"
    PixelShader = "PixelPdxMeshStandard"
	BlendState = "BlendStateAdditiveBlend"
	DepthStencilState = "DepthStencilNoZWrite"
	Defines = { "DISSOLVE" }
}

Effect OmniMeshMegaAlphaShadow
{
    VertexShader = "VertexPdxMeshStandardShadow"
	PixelShader = "PixelPdxMeshNoShadow"
	Defines = { "IS_SHADOW" }
}

Effect OmniMeshMegaAlphaSkinned
{
	VertexShader = "VertexPdxMeshStandardSkinned"
    PixelShader = "PixelPdxMeshStandard"
	BlendState = "BlendStateAdditiveBlend"
	DepthStencilState = "DepthStencilNoZWrite"
	Defines = { "DISSOLVE" }
}

Effect OmniMeshMegaAlphaSkinnedShadow
{
	VertexShader = "VertexPdxMeshStandardSkinnedShadow"
	PixelShader = "PixelPdxMeshNoShadow"
	Defines = { "IS_SHADOW" }
}

Effect OmniMeshED
{
	VertexShader = "VertexPdxMeshStandard"
	PixelShader = "PixelOmniMeshED"
	BlendState = "BlendStateAdditiveBlend"
	RasterizerState = "RasterizerStateNoCulling"
	DepthStencilState = "DepthStencilNoZWrite"
    Defines = {
        "PDX_IMPROVED_BLINN_PHONG"
        "RIM_LIGHT"
        "RECOLOR_EMISSIVE"
		"DISSOLVE"
    }
}

Effect OmniMeshEDSkinned
{
	VertexShader = "VertexPdxMeshStandardSkinned"
	PixelShader = "PixelOmniMeshED"
	BlendState = "BlendStateAdditiveBlend"
	RasterizerState = "RasterizerStateNoCulling"
	DepthStencilState = "DepthStencilNoZWrite"
    Defines = {
        "PDX_IMPROVED_BLINN_PHONG"
        "RIM_LIGHT"
        "RECOLOR_EMISSIVE"
		"DISSOLVE"
    }
}

Effect OmniMeshEDShadow
{
	VertexShader = "VertexPdxMeshStandardShadow"
	PixelShader = "PixelPdxMeshNoShadow"
	Defines = { "IS_SHADOW" }
}

Effect OmniMeshEDSkinnedShadow
{
	VertexShader = "VertexPdxMeshStandardSkinnedShadow"
	PixelShader = "PixelPdxMeshNoShadow"
	Defines = { "IS_SHADOW" }
}

Effect OmniMeshEDSphere
{
	VertexShader = "VertexPdxMeshStandard"
	PixelShader = "PixelOmniMeshEDSphere"
	BlendState = "BlendStateAdditiveBlend"
	RasterizerState = "RasterizerStateNoCulling"
	DepthStencilState = "DepthStencilNoZWrite"
    Defines = {
        "PDX_IMPROVED_BLINN_PHONG"
        "RIM_LIGHT"
        "RECOLOR_EMISSIVE"
		"DISSOLVE"
    }
}

Effect OmniMeshEDSphereSkinned
{
	VertexShader = "VertexPdxMeshStandardSkinned"
	PixelShader = "PixelOmniMeshEDSphere"
	BlendState = "BlendStateAdditiveBlend"
	RasterizerState = "RasterizerStateNoCulling"
	DepthStencilState = "DepthStencilNoZWrite"
    Defines = {
        "PDX_IMPROVED_BLINN_PHONG"
        "RIM_LIGHT"
        "RECOLOR_EMISSIVE"
		"DISSOLVE"
    }
}

Effect OmniMeshEDSphereShadow
{
	VertexShader = "VertexPdxMeshStandardShadow"
	PixelShader = "PixelPdxMeshNoShadow"
	Defines = { "IS_SHADOW" }
}

Effect OmniMeshEDSphereSkinnedShadow
{
	VertexShader = "VertexPdxMeshStandardSkinnedShadow"
	PixelShader = "PixelPdxMeshNoShadow"
	Defines = { "IS_SHADOW" }
}

Effect OmniMeshWhiteHole
{
	VertexShader = "VertexPdxMeshStandard"
	PixelShader = "PixelOmniMeshWhiteHole"
	#BlendState = "BlendStateAlphaBlend"
	#DepthStencilState = "DepthStencilNoZWrite"
	Defines = { "BLACK_HOLE" }
}

Effect OmniMeshWhiteHoleSkinned
{
	VertexShader = "VertexPdxMeshStandardSkinned"
	PixelShader = "PixelOmniMeshWhiteHole"
	#BlendState = "BlendStateAlphaBlend"
	#DepthStencilState = "DepthStencilNoZWrite"
	Defines = { "BLACK_HOLE" }
}
Effect OmniMeshWhiteHoleShadow
{
	VertexShader = "VertexPdxMeshStandardShadow"
	PixelShader = "PixelPdxMeshStandardShadow"
	Defines = { "ADD_COLOR"  "IGNORE_POINT_LIGHTS" }
}

Effect OmniMeshWhiteHoleSkinnedShadow
{
	VertexShader = "VertexPdxMeshStandardSkinnedShadow"
	PixelShader = "PixelPdxMeshStandardShadow"
	Defines = { "ADD_COLOR" "EMISSIVE"  "IGNORE_POINT_LIGHTS" }
}


Effect OmniMeshShipAnimateUV
{
	VertexShader = "VertexPdxMeshStandard"
    PixelShader = "PixelOmniMeshShip"
	Defines = {
		"PDX_IMPROVED_BLINN_PHONG"
		"RIM_LIGHT"
		"ANIMATE_NORMAL"
		"ANIMATE_SPECULAR"
	}
}

Effect OmniMeshShipAnimateUVSkinned
{
	VertexShader = "VertexPdxMeshStandardSkinned"
    PixelShader = "PixelOmniMeshShip"
	Defines = {
		"PDX_IMPROVED_BLINN_PHONG"
		"RIM_LIGHT"
		"ANIMATE_NORMAL"
		"ANIMATE_SPECULAR"
	}
}

Effect OmniMeshShipAnimateUVShadow
{
	VertexShader = "VertexPdxMeshStandardShadow"
	PixelShader = "PixelPdxMeshStandardShadow"
	Defines = { "IS_SHADOW" }
}

Effect OmniMeshShipAnimateUVSkinnedShadow
{
	VertexShader = "VertexPdxMeshStandardSkinnedShadow"
	PixelShader = "PixelPdxMeshStandardShadow"
	Defines = { "IS_SHADOW" }
}

Effect OmniMeshShipAnimateUVAlpha
{
	VertexShader = "VertexPdxMeshStandard"
    PixelShader = "PixelOmniMeshShip"
	BlendState = "BlendStateAdditiveBlend"
	DepthStencilState = "DepthStencilNoZWrite"
	Defines = {
		"RECOLOR_EMISSIVE"
		"DISSOLVE"
		"ANIMATE_NORMAL"
		"ANIMATE_SPECULAR"
	}
}

Effect OmniMeshShipAnimateUVAlphaSkinned
{
	VertexShader = "VertexPdxMeshStandardSkinned"
    PixelShader = "PixelOmniMeshShip"
	BlendState = "BlendStateAdditiveBlend"
	DepthStencilState = "DepthStencilNoZWrite"
	Defines = {
		"RECOLOR_EMISSIVE"
		"DISSOLVE"
		"ANIMATE_NORMAL"
		"ANIMATE_SPECULAR"
	}
}

Effect OmniMeshShipAnimateUVAlphaShadow
{
	VertexShader = "VertexPdxMeshStandardShadow"
	PixelShader = "PixelPdxMeshStandardShadow"
	Defines = { "IS_SHADOW" }
}

Effect OmniMeshShipAnimateUVAlphaSkinnedShadow
{
	VertexShader = "VertexPdxMeshStandardSkinnedShadow"
	PixelShader = "PixelPdxMeshStandardShadow"
	Defines = { "IS_SHADOW" }
}







Effect PdxMeshPlanetRingsRS
{
	VertexShader = "VertexPdxMeshStandard"
	PixelShader = "PixelPdxMeshAdditive"
	RasterizerState = "RasterizerStateNoCulling"
	BlendState = "BlendStateAdditiveBlend"
	DepthStencilState = "DepthStencilNoZWrite"
	Defines = { "IS_PLANET" "IS_RING" }
}

Effect PdxMeshPlanetRingsRSShadow
{
	VertexShader = "VertexPdxMeshStandardShadow"
	PixelShader = "PixelPdxMeshStandardShadow"
	Defines = { "IS_SHADOW" "IS_PLANET" "IS_RING" }
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








Effect PdxMeshShipHalo
{
    VertexShader = "VertexPdxMeshStandard"
    PixelShader = "PixelPdxMeshShip"
    Defines = {
        "PDX_IMPROVED_BLINN_PHONG"
        "RIM_LIGHT"
            "ALPHA_TEST"
    }
}
Effect PdxMeshPlanetHalo
{
    VertexShader = "VertexPdxMeshStandard"
    PixelShader = "PixelPdxMeshShip"
    Defines = { "ALPHA_TEST" "NO_PLANET_EMISSIVE" "EMISSIVE" "PDX_IMPROVED_BLINN_PHONG" }
}
Effect PdxMeshNavigationButtonGate
{
    VertexShader = "VertexPdxMeshStandard"
    PixelShader = "PixelPdxMeshShip"
    Defines = {
        "PDX_IMPROVED_BLINN_PHONG"
        #"RIM_LIGHT"
    }
    #DepthStencilState = "DepthStencilNoZWrite"
}