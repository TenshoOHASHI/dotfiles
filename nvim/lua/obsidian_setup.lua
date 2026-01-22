-- ~/.config/nvim/lua/obsidian_setup.lua
-- Obsidian vault を Neovim で扱う基本設定（vault を動的に自動検出）

local ok, obsidian = pcall(require, "obsidian")
if not ok then
  return
end

-- ====== Vault の自動検出（おすすめ：cwd ベース） ======
-- ルール:
--   - cwd が ~/vaults/<name> または ~/vaults/<name>/... の場合、その <name> を workspace にする
--   - それ以外はデフォルト vault（M4）へフォールバック
local home = vim.fn.expand("~")
local vaults_root = home .. "/vaults"

local cwd = vim.fn.getcwd()
local vault_name = cwd:match("^" .. vim.pesc(vaults_root) .. "/([^/]+)")
local vault_path = vault_name and (vaults_root .. "/" .. vault_name) or (vaults_root .. "/M4")

-- vault が実在しない場合は安全にデフォルトへ
if vim.fn.isdirectory(vault_path) == 0 then
  vault_name = "M4"
  vault_path = vaults_root .. "/M4"
end

-- ====== Obsidian.nvim setup ======
obsidian.setup({
  workspaces = {
    {
      name = vault_name or "M4",
      path = vault_path,
      -- overrides を削除（notes_subdir を固定しない）
    },
  },

  -- 新規ノートは現在のバッファのディレクトリに保存
  notes_subdir = nil,  -- nil で固定サブディレクトリを使用しない
  new_notes_location = "current_dir",

  daily_notes = {
    folder = "notes/dailies",
    date_format = "%Y-%m-%d",
    alias_format = "%B %-d, %Y",
    default_tags = { "daily-notes" },
  },

  templates = {
    folder = "templates",
    date_format = "%Y-%m-%d",
    time_format = "%H:%M:%S",
    substitutions = {
      yesterday = function()
        return os.date("%Y-%m-%d", os.time() - 86400)
      end,
      tomorrow = function()
        return os.date("%Y-%m-%d", os.time() + 86400)
      end,
      week = function()
        return os.date("%Y-W%V")
      end,
    },
  },

  completion = {
    nvim_cmp = false, -- nvim-cmp を入れたら true に
    min_chars = 2,
  },

  picker = {
    name = "telescope.nvim",
    -- 絶対に空文字を入れない（Invalid (empty) LHS の原因）
    -- note_mappings を “書かない” ＝デフォルトに任せるのが安全
  },

  -- ここは obsidian.nvim が markdown バッファに対して設定する "内部マッピング"
  mappings = {
    ["gf"] = {
      action = function()
        return require("obsidian").util.gf_passthrough()
      end,
      opts = { noremap = false, expr = true, buffer = true },
    },
    -- Ctrl+i (Tab) と競合しないよう、Ctrl+g に変更
    -- Ctrl+g でリンクをジャンプ、チェックボックスをトグル
    ["<C-g>"] = {
      action = function()
        return require("obsidian").util.smart_action()
      end,
      opts = { buffer = true, expr = true },
    },
  },

  ui = {
    enable = true,
    checkboxes = {
      [" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
      ["x"] = { char = "", hl_group = "ObsidianDone" },
      [">"] = { char = "➤", hl_group = "ObsidianRightArrow" },
      ["~"] = { char = "◯", hl_group = "ObsidianTilde" },
      ["!"] = { char = "⚠", hl_group = "ObsidianImportant" },
      ["-"] = { char = "⊖", hl_group = "ObsidianTilde" },
    },
  },

  attachments = {
    -- 画像は vault 直下からの相対パスで保存される（デフォルト先をここで指定）
    -- コマンド: :ObsidianPasteImg で貼り付け可能
    img_folder = "notes/assets",
  },

  wiki_link_func = function(opts)
    return require("obsidian.util").wiki_link_id_prefix(opts)
  end,

  note_id_func = function(title)
    local suffix = ""
    if title ~= nil and title ~= "" then
      suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
    else
      for _ = 1, 4 do
        suffix = suffix .. string.char(math.random(65, 90))
      end
    end
    return tostring(os.time()) .. "-" .. suffix
  end,

  disable_frontmatter = false,

  callbacks = {
    post_setup_workspace = function(_, workspace)
      vim.schedule(function()
        print("Obsidian workspace ready: " .. workspace.name .. " (" .. workspace.path .. ")")
      end)
    end,
  },
})
