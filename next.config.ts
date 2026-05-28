import type { NextConfig } from "next";

// Set STATIC_EXPORT=1 to emit a fully static site in ./out that can be
// zipped and shared, or served from any static host (e.g. `npx serve out`).
const isStaticExport = process.env.STATIC_EXPORT === "1";

const nextConfig: NextConfig = {
  ...(isStaticExport
    ? {
        output: "export",
        images: { unoptimized: true },
        trailingSlash: true,
      }
    : {}),
};

export default nextConfig;
