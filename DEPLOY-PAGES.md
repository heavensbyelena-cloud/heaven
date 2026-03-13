# Déployer Heaven by Elena sur Cloudflare

**Avantage principal :** Le build s'exécute sur les serveurs Cloudflare (Linux) — **plus de problèmes Windows** (EPERM, etc.).

---

## Option A : Pages (recommandé si tu veux *.pages.dev)

**Limitation :** Cloudflare Pages utilise `next-on-pages` qui supporte uniquement **Next.js 14 ou 15**. Ton projet utilise Next.js 16.

Pour déployer sur Pages, il faut **downgrader** vers Next.js 14 :

```powershell
npm install next@14
```

Puis connecte ton dépôt GitHub à Cloudflare Pages :

1. **[dash.cloudflare.com](https://dash.cloudflare.com)** → **Workers & Pages** → **Create** → **Pages**
2. **Connect to Git** → sélectionne ton dépôt
3. **Framework preset :** Next.js (pas "Static HTML Export")
4. Cloudflare configure automatiquement :
   - Build command : `npx @cloudflare/next-on-pages@1`
   - Build output : `.vercel/output/static`
5. Ajoute tes variables d'environnement dans **Settings** → **Environment variables**
6. **Save and Deploy**

---

## Option B : Workers via GitHub (sans modifier Next.js)

Garde Next.js 16. Le build se fait sur Cloudflare.

1. Pousse ton code sur GitHub
2. **[dash.cloudflare.com](https://dash.cloudflare.com)** → **Workers & Pages** → **Create** → **Workers**
3. **Connect to Git** → sélectionne ton dépôt
4. Cloudflare détecte automatiquement le projet Next.js (wrangler.toml présent)
5. **Build command :** `npm run build && npx opennextjs-cloudflare build --dangerouslyUseUnsupportedNextVersion`
6. **Deploy command :** `npx wrangler deploy`
7. Ajoute tes variables dans **Build Variables and secrets**
8. **Save and Deploy**

Ton site sera sur `https://heavens-by-elena.TON_COMPTE.workers.dev`

---

## Variables d'environnement à configurer

Dans les paramètres du projet Cloudflare :

| Variable | Description |
|----------|-------------|
| `NEXT_PUBLIC_SUPABASE_URL` | URL Supabase |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | Clé anonyme Supabase |
| `SUPABASE_SERVICE_ROLE_KEY` | Clé service Supabase |
| `AUTH_SECRET` ou `JWT_SECRET` | Secret pour les JWT |
| `STRIPE_SECRET_KEY` | Clé secrète Stripe |
| `STRIPE_WEBHOOK_SECRET` | Secret webhook Stripe |
| `NEXT_PUBLIC_STRIPE_PUBLIC_KEY` | Clé publique Stripe |
| `NEXT_PUBLIC_SITE_URL` | URL de ton site (ex: `https://heavens-by-elena.workers.dev`) |
| `CLOUDINARY_*` | Variables Cloudinary |

---

## Mises à jour

Après chaque modification :

```powershell
git add .
git commit -m "Description des changements"
git push
```

Cloudflare redéploiera automatiquement.
