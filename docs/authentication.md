# Keycloak configuration

1. Create a new client in your Keycloak realm
2. Set `Access Type` to `confidential`
3. Add `https://< yourcomain >/oauth2/callback` as a `Valid Redirect URIs`
4. Save the configuration
5. In the `Credentials` tab for the new created client, copy the generated secret

# OAuth2 Proxy configuration

OAuth2 proxy is configured via the variables exposed in the `.env` file. These are all the variables that must be configured for the proxy to work.

| Env variable                   | Description                                                                                                                 |
| ------------------------------ | --------------------------------------------------------------------------------------------------------------------------- |
| `KEYCLOAK_REALM`               | URL of the Keycloak realm. Constructed using the following schema: `https://< keycloak endpoint >/auth/realms/< realm >`.   |
| `KEYCLOAK_CLIENT_ID`           | Client ID configured in previous step.                                                                                      |
| `KEYCLOAK_CLIENT_SECRET`       | Client secret copied from previous step.                                                                                    |
| `OAUTH2_ALLOWED_EMAIL_DOMAINS` | Authenticate only users with specified email domains (eg. noi.bz.it). Use `*` to authenticate any user regardless of email. |
| `OAUTH2_COOKIE_SECRET`         | Key used to encrypt session cookies. Must be 16, 32 or 64 random bytes. Can be base64 encoded.                              |
