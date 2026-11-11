# ExpiryTracker API

Backend for an expiry and loss tracking app built for medium-sized Egyptian supermarkets.

Staff register each **batch** of a product with its expiry date. The app shows what is about to expire, lets staff act on it (sell, discount, or throw away with a reason), and reports how much money was lost to waste each month, by category.

The Flutter client (web and Android, with barcode scanning) lives in the [`app/`](app/) folder of this repository.

## Tech stack

| | |
|---|---|
| Framework | ASP.NET Core Minimal APIs (.NET 11) |
| Database | SQLite through Entity Framework Core |
| API docs | OpenAPI + Scalar UI |
| Hosting | Runs locally on the supermarket's own PC |

## Getting started

### Prerequisites

- [.NET 11 SDK](https://dotnet.microsoft.com/download)
- EF Core CLI tool:
  ```bash
  dotnet tool install --global dotnet-ef
  ```

### Run

```bash
git clone https://github.com/salma-elmaghawry/expiry-tracker-api.git
cd expiry-tracker-api

dotnet ef database update   # creates expirytracker.db from the migrations
dotnet run                  # http://localhost:5291
```

Then open **http://localhost:5291/scalar** to browse and try every endpoint.

### Reach the API from a phone or Flutter Web

- The API listens on every network interface (`http://0.0.0.0:5291`), so a phone on the same Wi-Fi can call `http://<PC-IP>:5291`. Find the IP on macOS with `ipconfig getifaddr en0`. Allow incoming connections if the firewall asks.
- CORS allows browser pages served from the same computer (`localhost` or `127.0.0.1`, any port), which is where Flutter Web runs during development.
- There is no authentication yet, so only run it on a trusted network.

### Load demo data

```bash
curl -X POST http://localhost:5291/api/demo/seed
```

This **deletes all batches** and inserts 21 realistic demo batches. All dates are relative to today, so the dashboard and reports always have data in every state. The endpoint exists only in the `Development` environment.

## API

| Method | Route | Purpose |
|---|---|---|
| `GET` | `/api/batches?status=&bucket=` | List batches, closest expiry first. Both filters are optional. `bucket` returns exactly what a dashboard card counted |
| `POST` | `/api/batches` | Register a new batch |
| `PATCH` | `/api/batches/{id}/action` | Sell, discount, or waste a batch |
| `GET` | `/api/dashboard` | Batches at risk: expired, within 3 days, within 4 to 7 days |
| `GET` | `/api/reports/losses?month=` | Waste for one month, grouped by category |
| `POST` | `/api/demo/seed` | Reset the database with demo data (Development only) |

### Create a batch

`POST /api/batches`

```json
{
  "productName": "Juhayna Milk 1L",
  "category": "Dairy",
  "quantity": 24,
  "costPricePiasters": 3000,
  "unitPricePiasters": 3500,
  "expiryDate": "2026-11-15",
  "barcode": "6221007012345"
}
```

`barcode` is optional. Returns `201 Created` with the new batch. The server sets `id`, `status` (`Active`), and `createdAt`.

### Act on a batch

`PATCH /api/batches/{id}/action`

```json
{ "action": "Sell" }
{ "action": "Discount", "discountPricePiasters": 2800 }
{ "action": "Waste", "wasteReason": "Expired" }
```

| Response | When |
|---|---|
| `200 OK` | Done. Returns the updated batch |
| `400 Bad Request` | Missing discount price or waste reason, or discount is not lower than the selling price |
| `404 Not Found` | No batch with this id |
| `409 Conflict` | The batch is already `Sold` or `Wasted` |

### Dashboard

`GET /api/dashboard`

```json
{
  "today": "2026-11-11",
  "expired":        { "batchCount": 2, "valuePiasters": 26000 },
  "within3Days":    { "batchCount": 4, "valuePiasters": 271500 },
  "within4To7Days": { "batchCount": 3, "valuePiasters": 130000 }
}
```

### Losses report

`GET /api/reports/losses?month=2026-11` (omit `month` for the current month)

```json
{
  "month": "2026-11",
  "totalBatches": 4,
  "totalValuePiasters": 85500,
  "categories": [
    { "category": "MeatAndPoultry", "batchCount": 1, "valuePiasters": 45000 },
    { "category": "FruitsAndVegetables", "batchCount": 1, "valuePiasters": 22500 }
  ]
}
```

Categories are sorted by loss, biggest first. Categories with no waste are not returned.

## Business rules

### Batch lifecycle

```text
                 Discount
   Active ─────────────────► Discounted ◄──┐
     │  │                      │  │        │ Discount again
     │  │         Sell         │  │ ───────┘
     │  └────────► Sold ◄──────┘  │
     │                            │
     │  Waste                     │ Waste
     └────────► Wasted ◄──────────┘
```

`Sold` and `Wasted` are final. Batches are never deleted, because the losses report is built from wasted batches.

### Dashboard buckets

Only `Active` and `Discounted` batches are counted. The buckets never overlap, so every batch is counted once:

| Bucket | Expiry date |
|---|---|
| `expired` | before today |
| `within3Days` | today to today + 3 (a product expiring today can still be sold today) |
| `within4To7Days` | today + 4 to today + 7 |

### Money value

Dashboard value and losses are calculated at **cost price** (`quantity × costPricePiasters`), because that is the money the store actually paid and loses if the product is thrown away.

### Losses month

A batch belongs to the month in which it was **wasted** (`actionAt`), not the month it expired. Months follow Cairo time, so a batch thrown away at 00:30 on November 1st counts in November.

## API conventions

| Topic | Convention |
|---|---|
| Money | Integer **piasters** everywhere (`3550` = 35.50 EGP). Clients divide by 100 for display |
| Enums | Strings, case-sensitive: `"Dairy"`, `"Active"`, `"Expired"` |
| Dates | `expiryDate` is a calendar date: `"2026-11-15"` |
| Timestamps | `createdAt` and `actionAt` are UTC (`"2026-11-11T09:44:34Z"`) |
| Errors | `400` responses use the standard problem details format, with `errors` keyed by the JSON field name |

Validation error example:

```json
{
  "title": "One or more validation errors occurred.",
  "status": 400,
  "errors": {
    "quantity": ["Quantity must be greater than 0."]
  }
}
```

### Enum values

| Enum | Values |
|---|---|
| `category` | `Dairy`, `Bakery`, `MeatAndPoultry`, `FruitsAndVegetables`, `Frozen`, `Beverages`, `Snacks`, `Grocery`, `Other` |
| `status` | `Active`, `Discounted`, `Sold`, `Wasted` |
| `wasteReason` | `Expired`, `Damaged`, `Spoiled`, `Other` |
| `action` | `Sell`, `Discount`, `Waste` |
| `bucket` | `Expired`, `Within3Days`, `Within4To7Days` |

## Project structure

```text
ExpiryTracker.Api/
├── Models/       Entities and enums (Batch, BatchStatus, Category, WasteReason)
├── Data/         AppDbContext (EF Core)
├── Migrations/   Database schema history
├── Dtos/         Request and response shapes for the API
├── Services/     Business logic (batches, dashboard, reports, demo seed)
├── Endpoints/    Route groups that map HTTP to services
└── Program.cs    Service registration and app startup
```

## Design decisions

- **Money as `long` piasters.** SQLite has no decimal type, and EF Core cannot `SUM` or `ORDER BY` decimal values on SQLite. Integers also avoid floating point errors in the Dart client.
- **Enums stored as strings.** The database stays readable, and reordering an enum never corrupts existing rows.
- **DTOs separate from entities.** Clients cannot set server-owned fields such as `id`, `status`, or `createdAt`.
- **Aggregation in the database.** The dashboard and losses report each run one SQL query with `GROUP BY`, so the response size does not grow with the number of batches.

## Roadmap

- [ ] Flutter client (web and mobile) with barcode scanning
- [ ] Authentication and roles
- [ ] Partial actions (for example, sell 10 out of 24)
- [ ] Separate `Product` table (name, barcode, category) shared by batches
- [ ] Automated tests for services
