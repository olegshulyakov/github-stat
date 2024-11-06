CREATE DATABASE IF NOT EXISTS dataset;
USE dataset;
CREATE TABLE IF NOT EXISTS repositories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    data JSON
);

CREATE TABLE IF NOT EXISTS repositoriesTest (
    id INT AUTO_INCREMENT PRIMARY KEY,
    data JSON
);

CREATE TABLE IF NOT EXISTS pulls (
    id BIGINT NOT NULL,
    repo VARCHAR(255) NOT NULL,
    data JSON,
    PRIMARY KEY (id, repo),
    INDEX idx_repo (repo)
);

CREATE TABLE IF NOT EXISTS pullsTest (
    id BIGINT NOT NULL,
    repo VARCHAR(255) NOT NULL,
    data JSON,
    PRIMARY KEY (id, repo),
    INDEX idx_repo (repo)
);

CREATE TABLE IF NOT EXISTS reports_runs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    data JSON
);

CREATE TABLE IF NOT EXISTS reports_databases (
    id INT AUTO_INCREMENT PRIMARY KEY,
    data JSON
);