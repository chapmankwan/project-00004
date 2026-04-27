terraform {
  required_version = ">= 1.6.0"

  required_providers {
    vercel = {
      source  = "vercel/vercel"
      version = "~> 1.4"
    }
    supabase = {
      source  = "supabase/supabase"
      version = "~> 1.3"
    }
  }

  # Store state remotely — swap for S3/GCS if preferred
  backend "local" {
    path = "terraform.tfstate"
  }
}

# ---------------------------------------------------------------------------
# Providers
# ---------------------------------------------------------------------------

provider "vercel" {
  api_token = var.vercel_api_token
  team      = var.vercel_team_id # optional, remove if personal account
}

provider "supabase" {
  access_token = var.supabase_access_token
}

# ---------------------------------------------------------------------------
# Supabase — database, auth, storage
# ---------------------------------------------------------------------------

resource "supabase_project" "main" {
  name            = var.project_name
  organization_id = var.supabase_org_id
  region          = var.supabase_region
  database_password = var.supabase_db_password

  lifecycle {
    # Prevent accidental DB destruction in production
    prevent_destroy = true
  }
}

# ---------------------------------------------------------------------------
# Vercel — Next.js hosting
# ---------------------------------------------------------------------------

resource "vercel_project" "app" {
  name      = var.project_name
  framework = "nextjs"

  git_repository = {
    type = "github"
    repo = var.github_repo # e.g. "your-org/your-repo"
  }

  # Build config
  build_command    = "pnpm build"
  install_command  = "pnpm install"
  output_directory = ".next"

  environment = [
    # Supabase
    {
      key    = "NEXT_PUBLIC_SUPABASE_URL"
      value  = "https://${supabase_project.main.id}.supabase.co"
      target = ["production", "preview", "development"]
    },
    {
      key    = "NEXT_PUBLIC_SUPABASE_ANON_KEY"
      value  = supabase_project.main.anon_key
      target = ["production", "preview", "development"]
    },
    {
      key    = "SUPABASE_SERVICE_ROLE_KEY"
      value  = supabase_project.main.service_role_key
      target = ["production"]
      sensitive = true
    },

    # Clerk
    {
      key    = "NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY"
      value  = var.clerk_publishable_key
      target = ["production", "preview"]
    },
    {
      key    = "CLERK_SECRET_KEY"
      value  = var.clerk_secret_key
      target = ["production", "preview"]
      sensitive = true
    },

    # Stripe
    {
      key    = "STRIPE_SECRET_KEY"
      value  = var.stripe_secret_key
      target = ["production"]
      sensitive = true
    },
    {
      key    = "STRIPE_WEBHOOK_SECRET"
      value  = var.stripe_webhook_secret
      target = ["production"]
      sensitive = true
    },
    {
      key    = "NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY"
      value  = var.stripe_publishable_key
      target = ["production", "preview"]
    },

    # Resend
    {
      key    = "RESEND_API_KEY"
      value  = var.resend_api_key
      target = ["production"]
      sensitive = true
    },

    # Upstash Redis (optional — remove if not using)
    {
      key    = "UPSTASH_REDIS_REST_URL"
      value  = var.upstash_redis_url
      target = ["production"]
    },
    {
      key    = "UPSTASH_REDIS_REST_TOKEN"
      value  = var.upstash_redis_token
      target = ["production"]
      sensitive = true
    },

    # Inngest
    {
      key    = "INNGEST_EVENT_KEY"
      value  = var.inngest_event_key
      target = ["production"]
      sensitive = true
    },
    {
      key    = "INNGEST_SIGNING_KEY"
      value  = var.inngest_signing_key
      target = ["production"]
      sensitive = true
    },

    # Sentry
    {
      key    = "NEXT_PUBLIC_SENTRY_DSN"
      value  = var.sentry_dsn
      target = ["production", "preview"]
    },
  ]
}

# Production domain
resource "vercel_project_domain" "production" {
  project_id = vercel_project.app.id
  domain     = var.production_domain
}

# ---------------------------------------------------------------------------
# Outputs
# ---------------------------------------------------------------------------

output "app_url" {
  value = "https://${var.production_domain}"
}

output "supabase_url" {
  value = "https://${supabase_project.main.id}.supabase.co"
}

output "supabase_project_id" {
  value = supabase_project.main.id
}
