{ ... }:

{
  # Shared restic secrets for all backup jobs (one S3 key pair + one
  # repository password, reused by every service's restic backup).
  # Each service's `services.restic.backups.<name>` block references these
  # via `config.age.secrets.restic-s3.path` and
  # `config.age.secrets.restic-password.path`.
  age.secrets = {
    restic-s3.file = ../secrets/restic-s3.age;
    restic-password.file = ../secrets/restic-password.age;
  };
}
