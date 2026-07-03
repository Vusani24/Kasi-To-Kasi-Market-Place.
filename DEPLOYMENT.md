# Kasi to Kasi Market Place deployment

## Supabase

1. Open Supabase SQL Editor.
2. Run all SQL in `supabase-schema.sql`.
3. Confirm `public.app_state` appears in Table Editor.
4. Keep the Supabase secret key private. Never commit it to GitHub.

## Render environment variables

Add these under the Render web service's Environment page:

```text
SUPABASE_URL=https://YOUR_PROJECT_REFERENCE.supabase.co
SUPABASE_SECRET_KEY=YOUR_SB_SECRET_KEY
SUPABASE_APP_STATE_ID=mzansi-market-hub
ADMIN_PASSWORD=YOUR_PRIVATE_ADMIN_PASSWORD
```

`SUPABASE_SERVICE_ROLE_KEY` is also supported for compatibility, but
`SUPABASE_SECRET_KEY` is preferred for Supabase's current `sb_secret_...` key.

Keep `SUPABASE_APP_STATE_ID=mzansi-market-hub` so existing Supabase data remains
connected after the Kasi to Kasi rebrand.

## Render service

- Runtime: Node
- Build command: leave empty or use `npm install`
- Start command: `npm start`
- Health check path: `/api/health`

After deployment, open `/api/health`. A working Supabase deployment reports:

```json
{
  "ok": true,
  "database": "supabase",
  "supabaseConfigured": true,
  "adminPasswordConfigured": true
}
```

If `database` reports `supabase-error`, read the safe `supabaseError` message in
the same response. Confirm that `public.app_state` exists, that `SUPABASE_URL`
belongs to the same project, and that `SUPABASE_SECRET_KEY` contains the
server-side `sb_secret_...` key rather than the publishable key.

## Storage

- `listing-media`: public item and service media
- `verification-files`: keep private because it contains IDs and selfies
- `receipt-files`: keep private because receipts contain customer information

The current application stores listing data and uploaded media inside the private
`app_state` database record. Moving large images and videos into Storage is a
recommended follow-up before accepting many public uploads.
