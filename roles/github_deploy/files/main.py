"""Script that listens for and processese events from a GitHub repository."""

from __future__ import annotations

import logging
import os
import subprocess
import time
from pathlib import Path

from github import Github, Repository, WorkflowRun

# Define the repository owner and repo name
OWNER: str = "claha"
REPO: str = "smart-home"

# Define the file path for storing processed run IDs
PROCESSED_RUNS_FILE: str = "processed_runs.txt"
RUNS_TO_CHECK = 100

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
)


def listen_for_events() -> None:
    """Listen for events and process workflow runs."""
    # Set up authentication
    token: str = os.getenv("GITHUB_ACCESS_TOKEN", "")
    github: Github = Github(token)

    # Get the repository
    repository: Repository.Repository = github.get_repo(f"{OWNER}/{REPO}")

    # Set up persistence
    processed_runs: set[int] = read_processed_runs()

    # Make the repo safe
    run_command(f"git config --global --add safe.directory /{REPO}")

    # Check events
    while True:
        try:
            # Get the latest workflow runs
            non_processed_runs: list[WorkflowRun.WorkflowRun] = get_non_processed_runs(
                repository,
                processed_runs,
            )

            for run in non_processed_runs:
                logging.info("Check run: %s", run.name)
                # Perform actions based on the workflow run
                if run.name.startswith("Deploy"):
                    deployment_name: str = run.name.split("Deploy")[1].strip()
                    deploy(deployment_name)

                # Add the processed run ID to the set
                processed_runs.add(run.id)

            # Save the processed run IDs
            write_processed_runs(processed_runs)

        except Exception:
            logging.exception("Failed to process")

        # Wait some time before checking next time
        time.sleep(60)


def run_command(command: str) -> None:
    """Run and log command output."""
    result = subprocess.run(
        command,
        cwd=f"/{REPO}",
        shell=True,
        capture_output=True,
        check=False,
    )
    logging.info(result.stderr.decode("UTF-8").strip())
    logging.info(result.stdout.decode("UTF-8").strip())


def deploy(name: str) -> None:
    """Perform deployment based on the name."""
    logging.info("Deploy: %s", name)
    for command in [
        "git fetch && git reset --hard origin/main",
        "ansible-galaxy install -r requirements.yaml",
        "ansible-playbook main.yaml --limit localhost --tags ssh_config",
        f"ansible-playbook main.yaml --limit all,!localhost --tags {name}",
    ]:
        run_command(command)


def get_non_processed_runs(
    repository: Repository.Repository,
    processed_runs: set[int],
) -> list[WorkflowRun.WorkflowRun]:
    """Retrieve non-processed workflow runs from the repository."""
    # Get the latest workflow runs
    runs: list[WorkflowRun.WorkflowRun] = repository.get_workflow_runs(
        branch="main",
        event="push",
        status="success",
    )

    # Filter and return non-processed runs
    non_processed_runs = []
    for i, run in enumerate(runs):
        if i > RUNS_TO_CHECK:
            break
        if run.id not in processed_runs:
            non_processed_runs.append(run)

    return non_processed_runs


def read_processed_runs() -> set[int]:
    """Read and return the set of processed run IDs from the file."""
    processed_runs: set[int] = set()
    if Path.exists(PROCESSED_RUNS_FILE):
        with Path.open(PROCESSED_RUNS_FILE, encoding="UTF-8") as file:
            processed_runs = {int(line.strip()) for line in file}
    return processed_runs


def write_processed_runs(processed_runs: set[int]) -> None:
    """Write the set of processed run IDs to the file."""
    with Path.open(PROCESSED_RUNS_FILE, "w", encoding="UTF-8") as file:
        file.writelines(f"{run_id}\n" for run_id in processed_runs)


if __name__ == "__main__":
    listen_for_events()
