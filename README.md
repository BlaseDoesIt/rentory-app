# Rentory

Equipment rental management for PC (Windows, macOS) and mobile (Android, iOS),
built with Flutter. Works on its own, or connected to Odoo.

## Backends

All screens talk to one repository layer. The backend behind it is swappable:

| Mode | Source of truth | Status |
|---|---|---|
| Standalone | Supabase (shared by all devices), local SQLite cache for offline use | in progress |
| Odoo | Odoo 19 over the JSON-2 API (`/json/2/<model>/<method>`), local cache + offline queue | later |

The data model mirrors the Rentory Odoo module (`rentory.order`, `rentory.order.line`,
`rentory.asset`, `rentory.asset.serial`, `rentory.return.check`, `rentory.asset.photo`,
`rentory.location`) so the Odoo mapping stays close to one-to-one.

## Layout

```
lib/
  app/        app shell, theme, navigation (bottom tabs on phone, rail on PC)
  features/   one folder per screen area: orders, scan, assets, settings
```

## Secrets

No keys in git. Supabase URL/anon key and Odoo credentials are entered in Settings
and kept in the OS keychain. Development builds may read them from env vars
(`ODOO_URL`, `ODOO_DB`, `ODOO_API_KEY`).

## Run

```
flutter run -d windows
flutter test
```

Private and closed-source. © Kosai Alhafez, blasedoesit.com
