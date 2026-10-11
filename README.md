# Spacelift golden paths: Postgres for services

Companion code for the blog post *How to Build Golden Paths in Platform Engineering*.

| Path | What it is |
|---|---|
| `modules/rds-postgres/` | Opinionated RDS Postgres module, published to the Spacelift module registry |
| `postgres/` | Root configuration that stacks created from the template run |
| `templates/postgres.yaml` | Spacelift template body (inputs, per-environment maps, stack definition) |
| `policies/` | Plan policy (RDS guardrails) and approval policy (one review for `env/prod`) |

Context IDs (`aws-network-<env>`), space IDs, and the AWS integration ID in the template are specific to the demo account; replace them with your own.

Drift detection is left out of the demo template because it requires a private worker pool. To enable it, add `worker_pool: <pool-id>` and a `schedules.drift` block to the stack.
