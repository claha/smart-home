# Agent Instructions

## Critical Rules

### 1. ALWAYS Format Nix Files After Changes

After making ANY changes to Nix configuration files, you MUST run the formatter:

```bash
nix-shell -p nixfmt-tree --run treefmt
```

This is not optional. Format the code every single time you modify it.

### 2. ALWAYS Use NixOS MCP for Configuration

Before writing or modifying ANY NixOS or home-manager configuration:

- Use the NixOS MCP tool to look up correct option names
- Use it to find available services in nixpkgs
- Use it to verify syntax and available parameters
- Do NOT guess or rely on memory for option names

The MCP tool is your source of truth for:

- NixOS system configuration options
- home-manager configuration options
- Available services and packages
- Correct attribute paths and syntax

## Workflow

1. **Look up** the option/service using NixOS MCP
2. **Write/modify** the configuration
3. **Format** the code with nixfmt-tree
4. **Verify** the changes are properly formatted
