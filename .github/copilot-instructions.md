# Copilot Instructions for MCP Connector Workspace

## Overview
This workspace contains three main MCP server components and a gateway:
- **mcp-ado/**: Azure DevOps integration (FastMCP v2, HTTP transport)
- **mcp-docupedia/**: Confluence/Docupedia integration (FastMCP v2, HTTP transport)
- **mcp-gateway/**: Aggregates MCP servers into a unified interface, loads servers as Python modules or proxies to external HTTP servers

## Architecture & Data Flow
- Each MCP server exposes a JSON-RPC API for its domain (ADO, Docupedia)
- The gateway routes requests to MCP servers either in-process (Python module) or via HTTP proxy
- Configuration files (e.g., `gateway_config.json`, `config.json`) define service endpoints and integration modes
- External services can be added via config with a `prefix` and `name`

## Developer Workflows
- **Start all services**: Use `start-all.ps1` (Windows PowerShell)
- **Stop all services**: Use `stop-all.ps1`
- **Run gateway**: `uv run gateway_server.py --config gateway_config.json`
- **Run individual MCP server**: `uv run mcp_server.py --config config.json` in the respective directory
- **Testing**:
  - Gateway: `uv run gateway_server.py --config test_config.json`
  - Health endpoint: See README for curl examples
  - MCP protocol: `uv run test_client.py` (see gateway README)
- **Debugging**: Check port usage (default: 8002 for gateway), verify external servers are running

## Project-Specific Patterns
- All MCP servers follow FastMCP v2 conventions (see README in each server directory)
- Configuration is always via JSON files, not environment variables
- External integrations (e.g., Azure DevOps, Confluence) require valid credentials in config
- Gateway supports both module loading and HTTP proxying for flexibility/performance

## Integration Points
- Gateway loads MCP servers as Python modules for performance, or proxies to external HTTP servers for isolation
- Each MCP server integrates with its respective external API (Azure DevOps REST, Confluence REST)
- Cross-component communication is via JSON-RPC over HTTP

## Key Files & Directories
- `mcp-ado/`, `mcp-docupedia/`, `mcp-gateway/`: Main service implementations
- `gateway_config.json`, `config.json`: Service and integration configuration
- `start-all.ps1`, `stop-all.ps1`: Service orchestration scripts
- `README.md` in each directory: Details on endpoints, testing, and integration

## Example Patterns
- To add a new external MCP server, update `gateway_config.json` with its endpoint and prefix
- To test a server, use the provided curl or uvicorn commands from the README
- To debug integration, check service logs and port assignments

---
**For AI agents:**
- Always follow the configuration and orchestration scripts for starting/stopping services
- Use JSON config files for all service settings
- Reference README files for endpoint details and integration examples
- Maintain FastMCP v2 conventions for new MCP server implementations
