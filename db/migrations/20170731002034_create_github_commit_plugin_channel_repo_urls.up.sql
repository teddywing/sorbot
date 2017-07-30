CREATE TABLE IF NOT EXISTS plugin_github_commit_channel_repo_urls (
    id       INTEGER PRIMARY KEY,
    channel  TEXT    NOT NULL,
    repo_url TEXT    NOT NULL
);
