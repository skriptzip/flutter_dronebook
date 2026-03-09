import "@supabase/functions-js/edge-runtime.d.ts"

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
}

function parseTilePart(value: string | null, maxInclusive: number): number | null {
  if (!value || !/^\d+$/.test(value)) {
    return null
  }

  const parsed = Number(value)
  if (!Number.isInteger(parsed) || parsed < 0 || parsed > maxInclusive) {
    return null
  }

  return parsed
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders })
  }

  const requestUrl = new URL(req.url)
  const z = parseTilePart(requestUrl.searchParams.get("z"), 22)
  const x = parseTilePart(requestUrl.searchParams.get("x"), 1 << 22)
  const y = parseTilePart(requestUrl.searchParams.get("y"), 1 << 22)

  if (z === null || x === null || y === null) {
    return new Response("Invalid tile coordinates", {
      status: 400,
      headers: { ...corsHeaders, "Content-Type": "text/plain" },
    })
  }

  const upstreamUrl = `https://tile.openstreetmap.org/${z}/${x}/${y}.png`
  const upstreamResponse = await fetch(upstreamUrl, {
    headers: {
      "User-Agent": "dronebook-nofly-tiles/1.0",
      "Accept": "image/png,image/*;q=0.8,*/*;q=0.5",
    },
  })

  if (!upstreamResponse.ok) {
    return new Response("Tile not found", {
      status: upstreamResponse.status,
      headers: { ...corsHeaders, "Content-Type": "text/plain" },
    })
  }

  // Buffer entire tile into memory to avoid stream disconnection errors
  const tileData = await upstreamResponse.arrayBuffer()

  return new Response(tileData, {
    status: 200,
    headers: {
      ...corsHeaders,
      "Content-Type": "image/png",
      "Cache-Control": "public, max-age=3600",
    },
  })
})
