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

## Screens

Orders (new order, draft editing with asset/service/section lines, unit
picker with Autofill), pickup (checklist, documents left, signature, condition
photos; admins may hand over without the contract), return (condition and note
per unit, documents handed back) and Scan (camera on phones, USB scanner or
keyboard on PC). Screens only call `RentoryRepository`.

Photos and signatures are saved under the app documents folder
(`rentory_photos/`) and recorded in `photos` with a `localPath`; the sync
engine uploads them.

## Languages

English and Arabic (right to left), picked in Settings or following the
device. Numbers and dates use English digits in both. Strings live in
`lib/l10n/app_en.arb` and `app_ar.arb`; after editing them run
`flutter gen-l10n`. Messages from the business rules are still English.

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

## Supabase

Project `rentory`. Schema lives in
`supabase/migrations/`, applied in filename order.

Postgres connections (ports 5432/6543) are filtered on the development
network, so `supabase db push` cannot connect from there. Apply new migrations
by pasting them into the dashboard's SQL Editor, which runs over HTTPS. The app
only uses HTTPS and is not affected.
