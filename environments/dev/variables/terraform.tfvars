# =============================================================================
# Azure Configuration
# =============================================================================
azure_location        = "eastus2"
azure_subscription_id = "db86071b-e936-4caf-8cf4-455b661615a2"
azure_tenant_id       = "bdbb7f5b-efd1-4e5a-8b55-af6ce35e39c5"

# =============================================================================
# GCP Configuration
# =============================================================================
gcp_project_id        = "decent-terra-470507-j1"
gcp_region           = "us-central1"
gcp_credentials_file = "~/.gcp/credentials.json"

# =============================================================================
# GCP Service Account Credentials (SECURE - Use Azure Key Vault)
# =============================================================================
# NOTE: These credentials should be stored in Azure Key Vault for security
# The values below are placeholders - replace with actual values from Key Vault
gcp_service_account_email = "adf-ga4-integration@decent-terra-470507-j1.iam.gserviceaccount.com"
gcp_client_id            = "116356125553772475880"
gcp_private_key_id       = "0d83feb98a97ccc822c69448cef1c171fbf067ca"
gcp_private_key          = "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDXAhKAlvcrDN51\nrmoXeCrsdZUpG6MxUQaD4vGXOXWyiy+KyIzz17192ekvrnxXUtKK0qvHQ+sr+QiQ\n+g/hrtNAPPab4b2gHJuPgggvYSE1o88j2GpUzk1cU3IinKFcyoHiWgweLZcBzCE+\n7FH7tgVlGDhXBswVYtKAaEoV6l6m9VvjScSinpENLphwPhR5gdrPNPJgvlRdmLfM\nfujWB7PvJwka0Tokw1WLSy4qCJUkbmBcRoyU6I7lakEXciXkAAtKCAw/8+n3Rj2P\ntEGeXZ98nqoes7YS00vHe4ekbSMRR9hEjhio15EGPLpb7+jlDcKSOx1oO8za0eC0\nlWEPGSQPAgMBAAECggEAZRGlTusoPwVqoVkep++mBcd0GYHTYcBb1q1csaCiEg7Z\nh1yk3Y8hlUJVGkPkUUwuinFjrGTh7KbA/x19T7JVvZGqvzYLZHNuMLSIUnVPHh7l\npUz7FuhvdyIGufx04eCT06pOnfUCUib5zdFa7H7w5EfRXB9m2fq9Rv0/LjQg0EwS\nxUG11FBW9AXfTaNOYnL7H0QGNdtQ93flZ+d/1vPBRlEeG7H6SUhkQussC3x7gHqH\nmxdS8R24lpQpGZOw7Q9T4OhZuWhzHr+SOiiwtGr2QGBNktoZGMtipDBU4QCgg/2b\noOmd2p7/oM2txMXYAyGVgarwJXT4pI/sXGJtc8Gn2QKBgQD/tSFdv/KsHqU+B0uw\nGULIWe9zvfMz8Y2yATY+ZX8pGxCPpT6UGgd3g7090MV3x5gAGNss/oD+PaT8ywQE\n1ArstGKuz6tNpYh2FqUFbYwsaqxbrb6jb3JWQkufcGe6OXW4AfXn1icN+Q1OgYjW\nIO8DhWT4RY/hGbtzl3PpKtpbUwKBgQDXQQZ/SGYMVXaR/46Q9+fOX7TRLZqy165Y\nL/l3mtNHXFC9Pm2lLPCOIvLA75DA1VZpqBW9mdbcVIiMvL0mss1y8ZVr6pG3Qg4T\ntZBYefJ5stHS5e3E1747ojJmQHTqGMtKS4rH1+SFWL5i+5p/An8vPRibvwk9OBZp\nBdcScas41QKBgQDbldkUX9xuMFbogG1fySGPWaQGea0bAykSHnZNeO2NCB/dqyKl\nHgEhgfEF331j0fPWyYGWDuwI6DkBmPlXiBvljzZbNhy+LhOUjPejRKKmFejzRa27\nPd4q8v1r6qQ4yFUt8gkQ0Ndy6Vei/hva/icil+/QQDRBMs7Fgd7Y8aLX3wKBgB2n\nysJcchq+54ADylt0nA4Vp26uLsL27gEeUutEfFk3gbQg1rBL+bRLYlBscO/wNGCI\nFL6zZCOkzc897X1YYu+0Etb0UTEDO7dBa2qVGm/jz/6TSOe2pXHHzdPCi5j444EP\n2UXhG423hTtT2Jwo9ubGLw6+CgLSKFw9vry+xk0lAoGAAg9PecrPrQm1ISOeOM0j\nIRPDV8cPTY8XwuqFF9TSQxItGmgwjouNUVXF9Tb76ttN7ejQmq3hK0u5DYOy485Q\nUIbtcF1uP31zJ4Zn+dW3fOr8nreRV3enIxAedlv6J9rxzsflWG+q8lv75nbNEROU\nRD9TJ6kOOGVK0KqduxkNErY=\n-----END PRIVATE KEY-----\n"

# =============================================================================
# GCP Service Account Key (Base64 encoded - Store in Key Vault)
# =============================================================================
gcp_service_account_key = "ewogICJ0eXBlIjogInNlcnZpY2VfYWNjb3VudCIsCiAgInByb2plY3RfaWQiOiAiZGVjZW50LXRlcnJhLTQ3MDUwNy1qMSIsCiAgInByaXZhdGVfa2V5X2lkIjogIjBkODNmZWI5OGE5N2NjYzgyMmM2OTQ0OGNlZjFjMTcxZmJmMDY3Y2EiLAogICJwcml2YXRlX2tleSI6ICItLS0tLUJFR0lOIFBSSVZBVEUgS0VZLS0tLS1cbk1JSUV2UUlCQURBTkJna3Foa2lHOXcwQkFRRUZBQVNDQktjd2dnU2pBZ0VBQW9JQkFRRFhBaEtBbHZjckRONTFcbnJtb1hlQ3JzZFpVcEc2TXhVUWFENHZHWE9YV3lpeStLeUl6ejE3MTkyZWt2cm54WFV0S0swcXZIUStzcitRaVFcbitnL2hydE5BUFBhYjRiMmdISnVQZ2dndllTRTFvODhqMkdwVXprMWNVM0lpbktGY3lvSGlXZ3dlTFpjQnpDRStcbjdGSDd0Z1ZsR0RoWEJzd1ZZdEtBYUVvVjZsNm05VnZqU2NTaW5wRU5McGh3UGhSNWdkclBOUEpndmxSZG1MZk1cbmZ1aldCN1B2SndrYTBUb2t3MVdMU3k0cUNKVWtibUJjUm95VTZJN2xha0VYY2lYa0FBdEtDQXcvOCtuM1JqMlBcbnRFR2VYWjk4bnFvZXM3WVMwMHZIZTRla2JTTVJSOWhFamhpbzE1RUdQTHBiNytqbERjS1NPeDFvTzh6YTBlQzBcbmxXRVBHU1FQQWdNQkFBRUNnZ0VBWlJHbFR1c29Qd1Zxb1ZrZXArK21CY2QwR1lIVFljQmIxcTFjc2FDaUVnN1pcbmgxeWszWThobFVKVkdrUGtVVXd1aW5GanJHVGg3S2JBL3gxOVQ3SlZ2WkdxdnpZTFpITnVNTFNJVW5WUEhoN2xcbnBVejdGdWh2ZHlJR3VmeDA0ZUNUMDZwT25mVUNVaWI1emRGYTdIN3c1RWZSWEI5bTJmcTlSdjAvTGpRZzBFd1NcbnhVRzExRkJXOUFYZlRhTk9Zbkw3SDBRR05kdFE5M2ZsWitkLzF2UEJSbEVlRzdINlNVaGtRdXNzQzN4N2dIcUhcbm14ZFM4UjI0bHBRcEdaT3c3UTlUNE9oWnVXaHpIcitTT2lpd3RHcjJRR0JOa3RvWkdNdGlwREJVNFFDZ2cvMmJcbm9PbWQycDcvb00ydHhNWFlBeUdWZ2Fyd0pYVDRwSS9zWEdKdGM4R24yUUtCZ1FEL3RTRmR2L0tzSHFVK0IwdXdcbkdVTElXZTl6dmZNejhZMnlBVFkrWlg4cEd4Q1BwVDZVR2dkM2c3MDkwTVYzeDVnQUdOc3Mvb0QrUGFUOHl3UUVcbjFBcnN0R0t1ejZ0TnBZaDJGcVVGYll3c2FxeGJyYjZqYjNKV1FrdWZjR2U2T1hXNEFmWG4xaWNOK1ExT2dZaldcbklPOERoV1Q0UlkvaEdidHpsM1BwS3RwYlV3S0JnUURYUVFaL1NHWU1WWGFSLzQ2UTkrZk9YN1RSTFpxeTE2NVlcbkwvbDNtdE5IWEZDOVBtMmxMUENPSXZMQTc1REExVlpwcUJXOW1kYmNWSWlNdkwwbXNzMXk4WlZyNnBHM1FnNFRcbnRaQlllZko1c3RIUzVlM0UxNzQ3b2pKbVFIVHFHTXRLUzRySDErU0ZXTDVpKzVwL0FuOHZQUmli\ndndrOU9CWnBcbkJkY1NjYXM0MVFLQmdRRGJsZGtVWDl4dU1GYm9nRzFmeVNHUFdhUUdlYTBiQXlrU0huWk5lTzJOQ0IvZHF5S2xcbkhnRWhnZkVGMzMxajBmUFd5WUdXRHV3STZEa0JtUGxYaUJ2bGp6WmJOaHkrTGhPVWpQZWpSS0ttRmVqelJhMjdcblBkNHE4djFyNnFRNHlGVXQ4Z2tRME5keTZWZWkvaHZhL2ljaWwrL1FRRFJCTXM3RmdkN1k4YUxYM3dLQmdCMm5cbnlzSmNjaHErNTRBRHlsdDBuQTRWcDI2dUxzTDI3Z0VlVXV0RWZGazNnYlFnMXJCTCtiUkxZbEJzY08vd05HQ0lcbkZMNnpaQ09remM4OTdYMVlZdSswRXRiMFVURURPN2RCYTJxVkdtL2p6LzZUU09lMnBYSEh6ZFBDaTVqNDQ0RVBcbjJVWGhHNDIzaFR0VDJKd285dWJHTHc2K0NnTFNLRnc5dnJ5K3hrMGxBb0dBQWc5UGVjclByUW0xSVNPZU9NMGpcbklSUERWOGNQVFk4WHd1cUZGOVRTUXhJdEdtZ3dqb3VOVVZYRjlUYjc2dHRON2VqUW1xM2hLMHU1RFlPeTQ4NVFcblVJYnRjRjF1UDMxeko0Wm4rZFczZk9yOG5yZVJWM2VuSXhBZWRsdjZKOXJ4enNmbFdHK3E4bHY3NW5iTkVST1VcblJEOVRKNmtPT0dWSzBLcWR1eGtORXJZPVxuLS0tLS1FTkQgUFJJVkFURSBLRVktLS0tLVxuIiwKICAiY2xpZW50X2VtYWlsIjogImFkZi1nYTQtaW50ZWdyYXRpb25AZGVjZW50LXRlcnJhLTQ3MDUwNy1qMS5pYW0uZ3NlcnZpY2VhY2NvdW50LmNvbSIsCiAgImNsaWVudF9pZCI6ICIxMTYzNTYxMjU1NTM3NzI0NzU4ODAiLAogICJhdXRoX3VyaSI6ICJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20vby9vYXV0aDIvYXV0aCIsCiAgInRva2VuX3VyaSI6ICJodHRwczovL29hdXRoMi5nb29nbGVhcGlzLmNvbS90b2tlbiIsCiAgImF1dGhfcHJvdmlkZXJfeDUwOV9jZXJ0X3VybCI6ICJodHRwczovL3d3dy5nb29nbGVhcGlzLmNvbS9vYXV0aDIvdjEvY2VydHMiLAogICJjbGllbnRfeDUwOV9jZXJ0X3VybCI6ICJodHRwczovL3d3dy5nb29nbGVhcGlzLmNvbS9yb2JvdC92MS9tZXRhZGF0YS94NTA5L2FkZi1nYTQtaW50ZWdyYXRpb24lNDBkZWNlbnQtdGVycmEtNDcwNTA3LWoxLmlhbS5nc2VydmljZWFjY291bnQuY29tIiwKICAidW5pdmVyc2VfZG9tYWluIjogImdvb2dsZWFwaXMuY29tIgp9Cg=="

# =============================================================================
# BigQuery Configuration
# =============================================================================
bigquery_dataset     = "gfs_global_forecast_system"
bigquery_table       = "weather"

# =============================================================================
# GA4 Configuration
# =============================================================================
ga4_dataset_id       = "ga4_data"
ga4_property_id      = "213025502"
ga4_data_stream_id   = "1600198309"
