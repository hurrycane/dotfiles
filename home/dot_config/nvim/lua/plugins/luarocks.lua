-- luarocks support, provisioned eagerly.
--
-- lazy.nvim only pulls hererocks into the spec when some plugin declares
-- `build = "rockspec"` (see lazy/core/plugin.lua). Nothing here does yet, so
-- with a bare `rocks.enabled = true` the sandbox never gets built and
-- :checkhealth keeps reporting luarocks as missing -- enabled in name only.
--
-- Naming it explicitly forces the build now, so luarocks genuinely works the
-- first time a rockspec plugin shows up instead of bootstrapping mid-install.
-- hererocks compiles its own Lua 5.1 via python3, which is the only route
-- available here: Homebrew ships lua 5.5 and carries no lua@5.1 formula, so
-- `rocks.hererocks = false` could never satisfy lazy's 5.1 check.
return {
  { "luarocks/hererocks", build = "rockspec", lazy = true },
}
