---
name: product-analyst
description: Market analysis of a consumer product ending in a concrete buy recommendation. Use when the user asks to analyze, research, or evaluate a product ("what should I buy", "analyze the market for X", "is X worth it", "compare X to alternatives"). Covers product identification, variants, competitor mapping, OEM/white-label discovery, and a final verdict. For pure price/deal hunting across sellers, also load the comparison-shopping skill.
---

# Product Analyst

Produce a market analysis that ends with "buy exactly this, here, at this price" — not a neutral survey. The user wants a decision, with the reasoning available underneath.

## Workflow

### 1. Identify the product precisely
- The user's phrasing may be garbled ("hello bath goliath xxl" → HelloBath® Goliath XXL). Search the literal phrase first; the brand's own site usually resolves it.
- Pin down: brand, exact model name, dimensions, materials, weight/capacity, what category it competes in.
- Find ALL variants before comparing anything (Basic vs Comfort trims, sizes, colors, bundle contents). The variant choice is often the real buying decision, and price differences between sellers frequently turn out to be different variants.

### 2. Map the market in three rings
Work outward; do not stop at ring 1:
1. **Direct branded competitors** — other brands reviewed alongside it in buying guides for the category (search local-language guides: "beste X 2026", "X Test Vergleich").
2. **White-label siblings / same-OEM products** — see "OEM check" below. For most commodity consumer goods this ring exists and changes the price picture drastically.
3. **Adjacent form factors** — cheaper or smaller products that solve the same need differently (e.g., sit bath vs full-length foldable vs inflatable). Name when an adjacent product is the better answer.

### 3. OEM / white-label check (do not skip)
Users legitimately push back if this is missing. For any commodity physical product:
- Search Alibaba / Made-in-China for the category + materials (e.g., "folding bathtub PP TPE OEM"). Note wholesale unit price, MOQ, "OEM/ODM acceptable" — this reveals the brand premium.
- Search the **exact dimensions in quotes** ("157x60x48") — clone listings reuse spec sheets verbatim, so identical dimensions are the strongest same-mold signal.
- Search local marketplaces (Amazon .de/.nl, bol, Kaufland, eBay, ManoMano) for same-size same-structure products under other brand names.
- **Calibrate the claim**: identical construction/materials/accessories = shared OEM design (safe to state). Slightly different dimensions = possibly different molds — say so explicitly rather than claiming "identical hardware".
- Then price the siblings *currently*. A historical price advantage may have evaporated; never recommend a clone on remembered/stale pricing (see comparison-shopping skill for verification tactics).

### 4. Price and evidence discipline
- Quote prices with seller and date; mark anything you could not verify this session as approximate.
- Many retail and coupon sites (Amazon, bol, eBay, aggregators) return 403 to direct fetches. Fall back to search snippets, price aggregators (PicClick, preissuchmaschine.de, meubelo.nl, testsieger.de), and cached comparison pages — and say which prices come from aggregators.
- Marketplace deep links rot: ASINs get delisted and reused. Before presenting a link as a buying option, confirm it still shows the claimed product via a fresh search; alongside any direct link, give a search-query fallback ("search 'UISEBRT faltbare Badewanne XXL' on Amazon.de").
- Localize: infer the user's market from context (retailers found, language, TLD) and search in the local language — local buying guides and shops beat English results.

### 5. The verdict
Structure the final answer as:
1. **Lead with the recommendation**: exact variant + color/config, exact seller, exact price, any discount code — first paragraph, not last.
2. Variant table (what each trim adds vs its price delta — call out which delta is worth it and why).
3. Price-by-seller table.
4. Alternatives table with the one-line reason each loses (or wins for a different user profile: "if you're under 1.85 m…", "if bubbles matter more…").
5. **Practical pre-purchase checks** the user might not think of (floor space, water heater capacity, weight limits, power outlet, ongoing costs).
   - **Inner/usable dimensions, not just outer footprint**: compare the product's usable interior (floor width, inner length, seat width) against the user's body, not only the outer size against the room. Form factors trade these off differently (e.g., foldable tubs' sloped walls shrink a 60 cm outer width to a ~36 cm floor; inflatables keep a wide floor but lose inner length to fat walls). A product that fits the space but not the person is the wrong product.
6. Brand-premium verdict: what the extra money actually buys (warranty, returns, support, QC) and whether it's worth it for this product's failure modes (e.g., 200 L of water on the floor makes warranty non-trivial).
7. Sources as markdown links.

## Failure modes observed in practice
- Stopping at branded competitors and missing the white-label market entirely.
- Recommending via a marketplace link that no longer shows the product.
- Quoting stale prices for the "cheaper alternative" that is no longer cheaper.
- Presenting a survey instead of a decision; the user asked what to buy.
- Overclaiming "same OEM/same factory" without dimension-level evidence.
