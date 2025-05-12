# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [1.0.2] - 2025-05-12
### Added
- Increased CPU and memory.

## [1.0.2] - 2024-07-03
### Added
- Updated configuration to enable irsa authentication method.

## [1.0.1] - 2024-05-02
### Added
- Springboot upgrade

## [1.0.0] - 2023-05-02
### Added
- Updated the liveness_probe pathway to the correct endpoint in order to stop Kubernetes restarting drone-fly. Changed as part of a Springboot upgrade.

## [0.0.2] - 2021-12-16
### Added
- Set env var `LOG4J_FORMAT_MSG_NO_LOOKUPS=”true”` for K8S container to resolve log4j vulnerability.

## [0.0.1] - 2020-08-04
### Added
- First version of Drone Fly terraform module.
