<div align="center">
   
   # 🩸 VeinX

  ### AI-powered emergency blood donation — Uber for blood, built for Bangladesh

  [![Next.js](https://img.shields.io/badge/Next.js-16-black?style=for-the-badge&logo=next.js)](https://nextjs.org)
  [![React](https://img.shields.io/badge/React-19-149ECA?style=for-the-badge&logo=react)](https://react.dev)
  [![TypeScript](https://img.shields.io/badge/TypeScript-5-3178C6?style=for-the-badge&logo=typescript)](https://typescriptlang.org)
  [![Tailwind](https://img.shields.io/badge/Tailwind-v4-38BDF8?style=for-the-badge&logo=tailwindcss)](https://tailwindcss.com)

  **People still search Facebook during blood emergencies.**
  **VeinX replaces chaos with instant, intelligent donor matching.**
</div>

---

## The problem

In Bangladesh, a blood emergency still means posting in scattered Facebook
groups, calling random contacts, and losing critical minutes. There is no
unified, real-time system to find a verified, compatible donor nearby.

## The solution

VeinX is an AI-native, mobile-first platform that turns a blood emergency into
a single tap:

- 🗺️ **Live donor map** — Uber/Pathao-style, with glowing, pulsing donors
- ⚡ **AI Emergency Score** — every request triaged 0–100
- 🧠 **Smart Match** — donors ranked by compatibility, proximity, availability & reliability
- 🤰 **Maternal Priority Routing** — maternal cases get boosted routing
- 📈 **Predictive Availability** — who's most likely to respond *now*
- 🏥 **Hospital command center** — live emergencies, supply, demand heatmap
- 🧑‍🤝‍🧑 **Donor mode** — register as a donor, availability toggle, incoming
  requests, donate to open requests, history
- 🎥 **Presentation studio** (`/present`) — the app inside a resizable phone
  frame with a scene picker, made for screen recording
- 🌐 **Full Bangla + English** — complete UI translation, persisted
- 📴 **Offline + SMS fallback** — dispatch over SMS when there's no internet

> **Note:** This is a hackathon **demo product**. The backend is fully
> simulated (mock data + a client-side "Mock Engine"); there are no real
> servers, accounts, or messages sent.

---

---

## 🏗️ Architecture

Frontend-only. A client-side **Mock Engine** simulates real-time movement and
events so the product *feels* live without any backend.

```
┌──────────────────────── Next.js 16 App Router (RSC) ────────────────────────┐
│                                                                              │
│   Marketing (Server)         App shell (Client)        Mock Engine           │
│   ┌──────────────┐           ┌──────────────┐          ┌──────────────────┐  │
│   │  /  landing  │           │  /map        │          │ lib/matching  AI │  │
│   └──────────────┘           │  /request/*  │◄────────►│ lib/eta  haversine│ │
│                              │  /donor      │          │ hooks/use-sim tick│ │
│                              │  /hospital   │          └────────┬─────────┘  │
│                              └──────┬───────┘                   │            │
│            ┌────────────────────────┼─────────────────┐         │            │
│            ▼                        ▼                  ▼         ▼            │
│   ┌────────────────┐      ┌──────────────────┐   ┌──────────────────────┐    │
│   │ Zustand stores │      │  React Query      │   │ Custom map renderer  │    │
│   │ user/map/      │      │  (mock fetches)   │   │ (projection + SVG,   │    │
│   │ emergency/lang │      └──────────────────┘   │  no token required)  │    │
│   └────────────────┘                             └──────────────────────┘    │
└──────────────────────────────────────────────────────────────────────────────┘
```

### Project structure

```
src/
├── app/
│   ├── page.tsx                  landing
│   ├── demo/                     scenario launcher
│   └── (app)/                    app shell (top bar + bottom nav + offline)
│       ├── map/                  live donor map
│       ├── request/              wizard → matching → [id] tracking
│       ├── donor/                donor dashboard
│       └── hospital/             hospital command center
├── components/
│   ├── ui/                       design-system primitives (hand-rolled)
│   ├── map/                      MapCanvas, markers, radius, route line
│   ├── emergency/                wizard inputs, matching overlay, triage
│   ├── donor/ landing/ hospital/ shared/
├── lib/                          matching (AI), eta, constants, i18n, motion
├── data/                         Dhaka-realistic mock donors/hospitals/etc.
├── store/                        Zustand stores
├── hooks/                        sim tick + network sync
└── types/                        domain model
```

### The AI matching model

`lib/matching.ts` scores every compatible, eligible donor against a request:

```
Smart Match = 30·compatibility + 28·proximity + 20·availability
            + 12·reliability   + 10·maternal     (clamped 0–99)
```

Each score ships with **explainable reasons** (shown in the triage panel), and
the request gets an overall **AI Emergency Score** from urgency, units, supply
scarcity, and the maternal flag.

---

## 🚀 Getting started

```bash
# 1. Install
npm install

# 2. (Optional) configure environment
cp .env.example .env.local

# 3. Run
npm run dev          # http://localhost:3000
```

Open [`/demo`](http://localhost:3000/demo) to drive the pitch scenarios.

### Environment

All variables are optional — the app runs fully without them.

| Variable | Purpose |
|----------|---------|
| `NEXT_PUBLIC_MAPBOX_TOKEN` | Enables real Mapbox tiles. **Without it, VeinX uses its built-in stylized map** (no token needed for the demo). |
| `NEXT_PUBLIC_APP_NAME` | App name. |
| `NEXT_PUBLIC_DEMO_MODE` | Demo affordances. |

> ⚠️ `NEXT_PUBLIC_MAPBOX_TOKEN` ships to the browser. If you enable real tiles,
> **restrict the token to your domain** (URL restrictions) in the Mapbox
> dashboard before deploying publicly.

### Scripts

```bash
npm run dev        # dev server
npm run build      # production build
npm run start      # serve the production build
npm run lint       # eslint
npm run export     # static export → ./out (shareable, no server needed)
npm run serve:out  # preview the static export at http://localhost:8000
```

---

## 📦 Share the demo with teammates (no setup)

Produce a fully static copy anyone can run on their laptop:

```bash
npm run export        # builds ./out
```

Zip the `out/` folder and send it. To run it, your teammate just:

- **Windows** — double-clicks `serve.cmd`
- **Mac/Linux** — runs `./serve.sh`

…then opens `http://localhost:8000` (or `/present` for the phone-framed view).
`out/START-HERE.txt` has the same instructions. A local server is required
because the assets use absolute paths — opening `index.html` directly won't
style correctly.

> Alternatively, just deploy to Vercel (below) and share the URL.

---

## ☁️ Deploy to Vercel

1. Push this repo to GitHub.
2. Import it at [vercel.com/new](https://vercel.com/new) — the framework is
   auto-detected (Next.js 16).
3. (Optional) add `NEXT_PUBLIC_MAPBOX_TOKEN` under **Project → Settings →
   Environment Variables** for real tiles.
4. Deploy. No other configuration required.

```bash
# or from the CLI
npm i -g vercel && vercel
```

---

## 🧰 Tech stack

Next.js 16 (App Router) · React 19 · TypeScript · Tailwind v4 ·
Motion (Framer Motion) · Zustand · TanStack Query · Recharts ·
Lucide · Sonner · custom token-free map renderer.

## 📸 Screenshots

> _Add captures here: landing · live map · AI matching · triage · tracking · hospital._

| Landing | Live map | AI matching |
|---|---|---|
| _todo_ | _todo_ | _todo_ |

---

<div align="center">
  Built for Bangladesh. Designed for the world. · Demo product · MIT
</div>
