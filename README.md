# Rentory

Equipment rental management for PC (Windows, macOS) and mobile (Android, iOS),
built with Flutter. Online only: it needs the internet and a team account.

## Backends

All screens talk to one repository layer. The backend behind it is swappable:

| Mode | Source of truth | Status |
|---|---|---|
| Supabase | Supabase, shared by the whole team. A local SQLite copy is only a cache | 1.0 |
| Odoo | Odoo 19 over the JSON-2 API (`/json/2/<model>/<method>`) | later |

Rentory never works offline. Until the first sync finishes, and whenever the
server can't be reached, a "No connection" screen covers the app (open orders
included). Every edit is pushed within a moment.

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

Orders (new order, asset/service/section lines that can be dragged into
order, units picked while adding a line or with Autofill, search by customer,
number, item, internal note or date), pickup (checklist, documents left,
signature; admins may hand over without the contract), return (condition and
note per unit, documents handed back) and Scan (camera on phones, USB scanner
or keyboard on PC). Screens only call `RentoryRepository`.

Lines live on their own: each one is booked, picked up and returned by itself
from its menu, lines can be added to an order already under way, and a booked
line that changes is booked again through the server (`book_lines`). Orders
and assets with history are archived instead of deleted.

Asset photos, return photos and signatures are saved under the app documents
folder (`rentory_photos/`) and recorded in `photos` with a `localPath`; the
sync engine uploads them. Order photos (phones only) are different: they go to
the phone's gallery (album "Rentory") and the local `order_photos` table,
never to the server.

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

## Releases

Release builds carry the server address, since phones and team PCs have no
env vars. Make a JSON file outside the repo with `SUPABASE_URL` and
`SUPABASE_ANON_KEY` (the publishable key, safe to ship), then:

```
flutter build apk --release --dart-define-from-file=<file>
flutter build windows --release --dart-define-from-file=<file>
```

Android release signing reads `android/key.properties` (git-ignored), which
points at the keystore in `C:\Users\BlasePC\.rentory\`. Back both up: every
later update must be signed with the same key, or phones have to uninstall
first. The Windows zip needs the Visual C++ runtime DLLs copied next to
`rentory.exe` (msvcp140, vcruntime140, vcruntime140_1).

## Supabase

Project `rentory`. Schema lives in
`supabase/migrations/`, applied in filename order.

Postgres connections (ports 5432/6543) are filtered on the development
network, so `supabase db push` cannot connect from there. Apply new migrations
by pasting them into the dashboard's SQL Editor, which runs over HTTPS. The app
only uses HTTPS and is not affected.
