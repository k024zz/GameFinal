cbuffer cbPerObject
{
	float4x4 gWorld;
};

cbuffer cbSkin
{
	float4x4 gBoneTransforms[22];
};

cbuffer cbPerFrame
{
	float4x4 gViewProj;
};

Texture2D gTexture;
SamplerState gSampleState;

struct VertexIn
{
	float3 PosL : POSITION;
	float3 NormalL : NORMAL;
	float2 Tex : TEXCOORD;
};

struct SkeletonVertexIn
{
	float3 PosL : POSITION;
	float3 NormalL : NORMAL;
	float2 Tex : TEXCOORD;
	float3 Weights : WEIGHTS;
	uint4  BoneIndices : BONEINDICES;
};

struct VertexOut
{
	float4 PosH : SV_POSITION;
	float2 Tex : TEXCOORD;
};

VertexOut vs_main(VertexIn vin)
{
	VertexOut vout;
	float4 PosW = mul(float4(vin.PosL, 1.0f), gWorld);
	vout.PosH = mul(PosW, gViewProj);
	vout.Tex = vin.Tex;
	return vout;
}

VertexOut skeleton_vs_main(SkeletonVertexIn vin)
{
	VertexOut vout;

	float weights[4];
	weights[0] = vin.Weights.x;
	weights[1] = vin.Weights.y;
	weights[2] = vin.Weights.z;
	weights[3] = 1.0f - vin.Weights.x - vin.Weights.y - vin.Weights.z;

	float4x4 BoneMatrix = 0.0f;
	
	[unroll]
	for(int i = 0; i < 4; i++)
	{
		BoneMatrix += gBoneTransforms[vin.BoneIndices[i]] * weights[i];
	}
	
	float4 Pos = mul(float4(vin.PosL, 1.0f), BoneMatrix);
	float4 PosW = mul(Pos, gWorld);
	vout.PosH = mul(PosW, gViewProj);
	vout.Tex = vin.Tex;
	return vout;

}

float4 ps_main(VertexOut pin) : SV_TARGET
{
	return gTexture.Sample(gSampleState, pin.Tex);
	//return float4(1.0f, 1.0f, 1.0f, 1.0f);
}

