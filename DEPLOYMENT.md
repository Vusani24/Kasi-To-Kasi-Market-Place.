# Kasi to Kasi Market Place Railway deployment

This setup uses only GitHub and Railway. Supabase is not required.

The website stores listings, approvals, appointments, receipts, and admin data in
`db.json`. On Railway, that file must live inside a Railway Volume so posts do
not disappear when the service restarts.

## 1. Upload to GitHub

Upload these files and folders to the root of your GitHub repository:

```text
index.html
admin.html
basket.html
services.html
terms.html
seller-terms.html
server.js
package.json
railway.json
DEPLOYMENT.md
database/db.json
```

Do not upload `node_modules`.

## 2. Create Railway service

1. Open Railway.
2. Click New Project.
3. Choose Deploy from GitHub repo.
4. Select your Kasi to Kasi Market Place repository.
5. Railway should detect Node.js automatically.

This project includes `railway.json`, so Railway uses:

```text
Start command: npm start
Health check path: /
```

## 3. Add Railway Volume for database

This is the most important step if you do not want Supabase.

1. Open your Railway project.
2. Open your web service.
3. Add a Volume.
4. Set the mount path to:

```text
/data
```

The server automatically saves the live database here:

```text
/data/db.json
```

Without the `/data` volume, posts may be lost when Railway restarts or redeploys.

## 4. Add Railway variables

In Railway, open your service, then open Variables. Add:

```text
ADMIN_PASSWORD=Khanya0901@2
DATA_DIR=/data
```

The server also has `Khanya0901@2` as the default admin password, but adding the
variable is still recommended so Railway shows the setting clearly.

Do not add Supabase variables if you do not want Supabase.

Leave these out:

```text
SUPABASE_URL
SUPABASE_SECRET_KEY
SUPABASE_SERVICE_ROLE_KEY
SUPABASE_APP_STATE_ID
```

## 5. Deploy

After adding the Volume and Variables, deploy the service.

Then open your Railway website and check:

```text
/api/health
```

A correct GitHub + Railway only setup should show:

```json
{
  "ok": true,
  "database": "local-file",
  "dataFile": "/data/db.json",
  "supabaseConfigured": false,
  "adminPasswordConfigured": true
}
```

## 6. Test the marketplace

1. Open the public website.
2. Submit an item.
3. Open `admin.html`.
4. Log in with `Khanya0901@2`.
5. Check Pending.
6. Approve the item.
7. Open the public page again and confirm the item appears.

If the health page does not show `/data/db.json`, check that the Railway Volume
is mounted at `/data` and that `DATA_DIR=/data` exists in Variables.
