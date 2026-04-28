import { z } from "zod";

// ---------------------------------------------------------------------------
// Schema
// Define every env var your app uses. This file is the single source of truth.
// ---------------------------------------------------------------------------

const server = z.object({
  NODE_ENV: z.enum(["development", "test", "production"]).default("development"),
  DATABASE_URL: z.string().url(),

  // Clerk
  CLERK_SECRET_KEY: z.string().min(1),

  // Stripe
  STRIPE_SECRET_KEY: z.string().min(1),
  STRIPE_WEBHOOK_SECRET: z.string().min(1),

  // Resend
  RESEND_API_KEY: z.string().min(1),

  // Supabase (server-side — service role)
  SUPABASE_SERVICE_ROLE_KEY: z.string().min(1),

  // Upstash Redis (optional)
  UPSTASH_REDIS_REST_URL: z.string().url().optional(),
  UPSTASH_REDIS_REST_TOKEN: z.string().optional(),

  // Inngest
  INNGEST_EVENT_KEY: z.string().min(1),
  INNGEST_SIGNING_KEY: z.string().min(1),
});

const client = z.object({
  // Clerk (public)
  NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY: z.string().min(1),

  // Stripe (public)
  NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY: z.string().min(1),

  // Supabase (public)
  NEXT_PUBLIC_SUPABASE_URL: z.string().url(),
  NEXT_PUBLIC_SUPABASE_ANON_KEY: z.string().min(1),

  // Sentry (public)
  NEXT_PUBLIC_SENTRY_DSN: z.string().url().optional(),
});

// ---------------------------------------------------------------------------
// Validation
// ---------------------------------------------------------------------------

const processEnv = {
  NODE_ENV: process.env.NODE_ENV,
  DATABASE_URL: process.env.DATABASE_URL,
  CLERK_SECRET_KEY: process.env.CLERK_SECRET_KEY,
  STRIPE_SECRET_KEY: process.env.STRIPE_SECRET_KEY,
  STRIPE_WEBHOOK_SECRET: process.env.STRIPE_WEBHOOK_SECRET,
  RESEND_API_KEY: process.env.RESEND_API_KEY,
  SUPABASE_SERVICE_ROLE_KEY: process.env.SUPABASE_SERVICE_ROLE_KEY,
  UPSTASH_REDIS_REST_URL: process.env.UPSTASH_REDIS_REST_URL,
  UPSTASH_REDIS_REST_TOKEN: process.env.UPSTASH_REDIS_REST_TOKEN,
  INNGEST_EVENT_KEY: process.env.INNGEST_EVENT_KEY,
  INNGEST_SIGNING_KEY: process.env.INNGEST_SIGNING_KEY,
  NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY: process.env.NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY,
  NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY: process.env.NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY,
  NEXT_PUBLIC_SUPABASE_URL: process.env.NEXT_PUBLIC_SUPABASE_URL,
  NEXT_PUBLIC_SUPABASE_ANON_KEY: process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY,
  NEXT_PUBLIC_SENTRY_DSN: process.env.NEXT_PUBLIC_SENTRY_DSN,
};

const merged = server.merge(client);

// Validate on module load — missing vars throw at startup, not at runtime
const _env = merged.safeParse(processEnv);

if (!_env.success) {
  console.error("❌  Invalid environment variables:");
  console.error(_env.error.flatten().fieldErrors);
  throw new Error("Invalid environment variables — check the output above.");
}

export const env = _env.data;
