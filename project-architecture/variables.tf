variable "project_name" {
  type        = string
  description = "Name of your SaaS project (used for Vercel and Supabase)"
}

variable "production_domain" {
  type        = string
  description = "Your production domain e.g. app.yoursaas.com"
}

variable "github_repo" {
  type        = string
  description = "GitHub repo in org/repo format e.g. acme/my-saas"
}

# ---------------------------------------------------------------------------
# Vercel
# ---------------------------------------------------------------------------

variable "vercel_api_token" {
  type      = string
  sensitive = true
  description = "Vercel API token from vercel.com/account/tokens"
}

variable "vercel_team_id" {
  type        = string
  default     = ""
  description = "Vercel team ID — leave empty for personal accounts"
}

# ---------------------------------------------------------------------------
# Supabase
# ---------------------------------------------------------------------------

variable "supabase_access_token" {
  type      = string
  sensitive = true
  description = "Supabase access token from app.supabase.com/account/tokens"
}

variable "supabase_org_id" {
  type        = string
  description = "Supabase organization ID from your org settings"
}

variable "supabase_region" {
  type        = string
  default     = "us-east-1"
  description = "Supabase project region"
}

variable "supabase_db_password" {
  type      = string
  sensitive = true
  description = "Master password for the Supabase Postgres database"
}

# ---------------------------------------------------------------------------
# Clerk
# ---------------------------------------------------------------------------

variable "clerk_publishable_key" {
  type        = string
  description = "Clerk publishable key (pk_live_...)"
}

variable "clerk_secret_key" {
  type      = string
  sensitive = true
  description = "Clerk secret key (sk_live_...)"
}

# ---------------------------------------------------------------------------
# Stripe
# ---------------------------------------------------------------------------

variable "stripe_secret_key" {
  type      = string
  sensitive = true
  description = "Stripe secret key (sk_live_...)"
}

variable "stripe_publishable_key" {
  type        = string
  description = "Stripe publishable key (pk_live_...)"
}

variable "stripe_webhook_secret" {
  type      = string
  sensitive = true
  description = "Stripe webhook signing secret (whsec_...)"
}

# ---------------------------------------------------------------------------
# Resend
# ---------------------------------------------------------------------------

variable "resend_api_key" {
  type      = string
  sensitive = true
  description = "Resend API key from resend.com/api-keys"
}

# ---------------------------------------------------------------------------
# Upstash Redis (optional)
# ---------------------------------------------------------------------------

variable "upstash_redis_url" {
  type        = string
  default     = ""
  description = "Upstash Redis REST URL (optional)"
}

variable "upstash_redis_token" {
  type      = string
  sensitive = true
  default   = ""
  description = "Upstash Redis REST token (optional)"
}

# ---------------------------------------------------------------------------
# Inngest
# ---------------------------------------------------------------------------

variable "inngest_event_key" {
  type      = string
  sensitive = true
  description = "Inngest event key from app.inngest.com"
}

variable "inngest_signing_key" {
  type      = string
  sensitive = true
  description = "Inngest signing key from app.inngest.com"
}

# ---------------------------------------------------------------------------
# Sentry
# ---------------------------------------------------------------------------

variable "sentry_dsn" {
  type        = string
  description = "Sentry DSN from your Sentry project settings"
}
