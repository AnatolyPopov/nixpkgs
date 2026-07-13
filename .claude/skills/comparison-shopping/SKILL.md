---
name: comparison-shopping
description: Find the best real price for a specific product - seller comparison, live-listing verification, discount codes, and discount programs. Use when the user asks where to buy, for the cheapest option, for coupon/discount codes, or about member/loyalty/referral discounts. For full market analysis and what-to-buy decisions, pair with the product-analyst skill.
---

# Comparison Shopping

Goal: the lowest *achievable* price from a seller the user can actually trust, with every claim dated and every unverified number flagged.

## Seller comparison
- Cover: brand's own store, dominant local marketplace (bol for NL/BE, Amazon .de/.nl/.fr, Kaufland, ManoMano), eBay, and price aggregators (PicClick, preissuchmaschine.de, meubelo.nl, testsieger.de, LionsHome).
- Same-product check: confirm listings are the same variant/trim/size before comparing prices — "cheaper" often means the Basic trim or a shorter size.
- Direct fetches to Amazon/bol/eBay/coupon sites usually 403; use search snippets and aggregators instead, and label those prices as aggregator-sourced with their date.
- **Link rot**: marketplace deep links (especially Amazon ASINs) get delisted and reused by unrelated products. Re-verify any link found in an article or older search before handing it to the user; always provide a search-string fallback next to direct links.
- Factor the total package into "cheapest": shipping, return rights (Amazon/bol returns vs eBay seller), warranty length (a small brand's 365-day warranty has real value for flood/failure-prone products), and delivery time.
- Cross-border: check the neighbor-country versions of the same shop (bol.nl vs bol.be, amazon.de vs .nl) — prices differ for identical items.

## Discount codes
Priority order (most → least reliable):
1. **Brand's own social media** (TikTok/Instagram): small D2C shops run rolling influencer codes, typically `<firstname>10` for €10 or 10%. Codes the brand posts from its own account tend to stay active long-term; recent/pinned posts have the freshest ones.
2. **Newsletter signup popup** — the standard first-order code source for small shops.
3. **Seasonal sales** — Black Friday is usually the deepest real discount of the year for D2C brands; if the user can wait, say so.
4. **Coupon aggregator sites** — treat as leads only. They inflate claims for SEO (a real 15% code advertised as "50% off", contradictory numbers on the same page). Sanity-check every aggregator claim against the brand's observed real discount range and say codes must be tried at checkout.
- When multiple codes exist, rank by expected value on the user's actual cart (10% beats €10 above a €100 cart) and give a try-order.
- State plainly that codes can't be verified without checkout access; they cost nothing to try.

## Discount programs (member / loyalty / referral / student)
- Search explicitly for: loyalty, member, referral / refer-a-friend, student discount, newsletter discount, trade/pro program — in English and the shop's language.
- Small D2C shops usually have **none** — their rolling influencer codes are the de facto program. If nothing is found, say "no formal program exists" plainly rather than hedging, and point to what substitutes for it (codes, seasonal sales, free-shipping threshold).
- Report standing non-code benefits: free-shipping thresholds, extended warranty/returns, financing (Klarna) — these are automatic and stack with codes.

## Output
- Lead with the single best buy: seller + price after best code, and the runner-up.
- Codes as a table: code, claimed value, source, confidence (brand-posted = high; aggregator-only = medium/low; seasonal = dead off-season).
- Date every price. Flag every unverified claim. Sources as markdown links.
