# Server-side components for Relaycorp's Letro implementation

This repository manages the cloud resources for [Letro server](https://docs.relaycorp.tech/letro-server/) and its backing services in production.

## Manually-managed resources

- OAuth2 client on GCP (used by VeraId Authority API), since [there's currently no Google API that supports managing this resource](https://issuetracker.google.com/issues/116182848).
- DNS records for `letro.app`, which are managed by Cloudflare.

## Generate superadmin token for the VeraId Authority API

1. [Get token](https://accounts.google.com/o/oauth2/v2/auth?client_id=1053273447752-rtiji7vtdj0b2rd6lpu3dhmglp27qbjf.apps.googleusercontent.com&redirect_uri=https://jwt.io&response_type=id_token&scope=https://www.googleapis.com/auth/userinfo.profile%20https://www.googleapis.com/auth/userinfo.email&nonce=RANDOM_STRING).
2. Use token as `Bearer` token in the `Authorization` header of all requests to the VeraId Authority API.
