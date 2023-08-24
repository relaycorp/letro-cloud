# Server-side components for Relaycorp's Letro implementation

This repository manages the cloud resources for the server-side components used by Relaycorp's Letro implementation.

## Manually-managed resources

- OAuth2 client on GCP (used by VeraId Authority API), since [there's currently no Google API that supports managing this resource](https://issuetracker.google.com/issues/116182848).
- DNS records for `letro.app`, which are managed by Cloudflare.
