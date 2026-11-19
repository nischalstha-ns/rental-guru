// Edge Function: Face Verification via AWS Rekognition
// Run with: supabase functions deploy face-verify --no-emit-diagnostics
// Requires env vars: AWS_REGION, AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, FACE_COLLECTION_ID

import { serve } from "https://deno.land/std@0.177.1/http/server.ts"

const FACE_COLLECTION_ID = Deno.env.get("FACE_COLLECTION_ID") ?? "rent-guru-faces"
const REKOGNITION_REGION = Deno.env.get("AWS_REGION") ?? "us-east-1"

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response(null, {
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "POST, OPTIONS",
        "Access-Control-Allow-Headers": "Content-Type, Authorization",
      },
    })
  }

  try {
    const body = await req.json()
    const { faceImageBase64, collectionId = FACE_COLLECTION_ID, userId } = body as {
      faceImageBase64: string
      collectionId?: string
      userId?: string
    }

    if (!faceImageBase64) {
      return new Response(JSON.stringify({ error: "Missing faceImageBase64" }), {
        status: 400,
        headers: { "Content-Type": "application/json", "Access-Control-Allow-Origin": "*" },
      })
    }

    // Decode base64 image
    const binaryString = atob(faceImageBase64)
    const imgBytes = new Uint8Array(binaryString.length)
    for (let i = 0; i < binaryString.length; i++) {
      imgBytes[i] = binaryString.charCodeAt(i)
    }

    // Determine operation: search existing face or index new face
    const opType = userId ? "SearchFacesByImage" : "IndexFace"
    const payload: Record<string, unknown> = {
      CollectionId: collectionId,
      Image: { Bytes: Array.from(imgBytes) },
      ExternalImageId: userId ?? crypto.randomUUID(),
      MaxFaces: 1,
      MinConfidence: 90,
    }
    if (userId) {
      payload["FaceMatchThreshold"] = 85
    }

    // Call AWS Rekognition
    const resp = await fetch(`https://rekognition.${REKOGNITION_REGION}.amazonaws.com/`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-Amz-Target": `AmazonRekognition.${opType}`,
      },
      body: JSON.stringify(payload),
    })

    const data = await resp.json()

    return new Response(JSON.stringify({
      success: true,
      operation: opType,
      facesDetected: data.FaceDetails?.length ?? 0,
      confidence: data.FaceDetails?.[0]?.Confidence ?? 0,
      faceId: data.Face?.FaceId,
      matches: data.FaceMatches,
    }), {
      status: 200,
      headers: { "Content-Type": "application/json", "Access-Control-Allow-Origin": "*" },
    })
  } catch (err) {
    console.error("Face verify error:", err)
    return new Response(JSON.stringify({ error: err instanceof Error ? err.message : "Unknown error" }), {
      status: 500,
      headers: { "Content-Type": "application/json", "Access-Control-Allow-Origin": "*" },
    })
  }
})
