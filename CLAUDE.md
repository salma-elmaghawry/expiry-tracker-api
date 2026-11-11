# ExpiryTracker API

## Project
Standalone expiry & loss tracking app for medium Egyptian supermarkets.
Backend: ASP.NET Core Minimal APIs (.NET 11) + EF Core + SQLite. Runs locally only.
Frontend (later): Flutter + Cubit.

## Structure
Models/ (entities), Data/ (AppDbContext), Dtos/, Services/ (business logic), Endpoints/ (route groups)

## Rules
- Money stored as `long` piasters (SQLite has no native decimal; EF can't Sum/OrderBy decimal there).
- Enums stored as strings via HasConversion<string>().
- No real auth for now (future work).
- No HTTPS redirection (local dev with Flutter).

## MVP Endpoints
- GET /api/batches?status=
- POST /api/batches
- PATCH /api/batches/{id}/action  (sell / discount / waste with reason)
- GET /api/dashboard  (expired / ≤3 days / ≤7 days + value in EGP)
- GET /api/reports/losses?month=  (waste by category)
- POST /api/demo/seed

## How to work with me
I'm a Flutter developer learning .NET while building this. My manager may ask me about any part.
- Explain every new concept before writing code, with a Flutter/Dart comparison when possible.
- Go one step at a time and wait for me to run it.
- Never use em dashes in output.