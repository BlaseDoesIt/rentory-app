# Rentory

Equipment rental management for **phone and desktop**: Android, iPhone, Windows and Mac, from one Flutter codebase. It runs **standalone on its own backend (Supabase)**, or connects to **Odoo 19** when a company already uses it.

Built for a camera and media equipment rental house. Orders, equipment, pickups, returns, late fees and payments, in English and Arabic.

Project page: [blasedoesit.com/projects/rentory-app](https://blasedoesit.com/projects/rentory-app/)

## What it does

- **Orders**: quotations, bookings, pickups and returns. Lines can be grouped under sections, dragged into order, and booked, picked up or returned one by one. Search by customer, order number, item, internal note or date.
- **Availability per unit**: each serial is offered only when its own bookings leave it free. Booking is confirmed by the server, so two people can't book the same camera.
- **Pickup**: what goes out, a checklist (rental contract, receipt, loan contract, items captured), the documents the customer leaves with you, and a signature.
- **Return**: condition and a note per unit, return photos, documents handed back.
- **Late fees**: late days counted automatically, with the option to set them by hand or waive them.
- **Payments**: lines, late fee, total, paid, due, and deposit held apart.
- **Scan**: camera scanning on phones, USB scanner or keyboard on desktop.
- **Assets**: equipment with units, photos, price per day and what's out right now.
- **English and Arabic** (right to left), with English digits in both.
- **Light and dark** themes. Bottom tabs on phones, a side rail on desktop.

## Two backends, one app

All screens talk to one repository layer. The backend behind it is picked at sign-in:

| Mode | Source of truth |
|---|---|
| **Supabase** (standalone) | Supabase Postgres shared by the team, with row-level security. A local SQLite copy (drift) is only a cache. Schema in `supabase/migrations/`. |
| **Odoo 19** | Odoo over the JSON-2 API (`/json/2/<model>/<method>`), signed in with each person's own API key. Every change goes through the Odoo module's own actions, plus invoices, payments and printed documents. Printing needs the small add-on in `odoo_addons/rentory_app_api/`. |

The app is online only. Until the first sync finishes, or when the server can't be reached, a "No connection" screen covers it.

## Tech

Flutter, Dart, drift (SQLite), Supabase (Postgres, Auth, Storage), Odoo JSON-2 API, flutter_localizations.

```
lib/
  app/        app shell, theme, navigation, sign-in and backend choice
  data/       repository, local database, Supabase sync, Odoo client
  domain/     business rules: availability, late fees, money, order states
  features/   one folder per screen area: orders, scan, assets, settings
  l10n/       English and Arabic strings
test/         unit and widget tests
supabase/     database migrations
odoo_addons/  rentory_app_api, the Odoo add-on used for printing
```

## Run

```bash
flutter pub get
flutter run -d windows
flutter test
```

Supabase URL and publishable key, and Odoo credentials, are entered in the app and kept in the OS keychain. No keys are stored in this repository. Release builds can carry the server address with `--dart-define-from-file=<file>` (a JSON file kept outside the repo with `SUPABASE_URL` and `SUPABASE_ANON_KEY`).

Settings has a **Load demo data** option that fills an empty database with made-up equipment, customers and orders.

## Author

Built by **Kosai Alhafez**, business systems developer.
[blasedoesit.com](https://blasedoesit.com) · kosai@blasedoesit.com

## License

MIT. See [LICENSE](LICENSE).
