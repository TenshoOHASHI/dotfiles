-- ~/.config/nvim/lua/obsidian_setup.lua
-- Obsidian vault を Neovim で扱う基本設定

local ok, obsidian = pcall(require, "obsidian")
if not ok then
  return
end

obsidian.setup({
  workspaces = {
    {
      name = "personal",
      path = vim.fn.expand("~/vaults/personal"),
      overrides = {
        notes_subdir = "notes",
      },
    },
    {
      name = "work",
      path = vim.fn.expand("~/vaults/work"),
      overrides = {
        notes_subdir = "notes",
      },
    },
  },

  -- 新規ノートは notes_subdir 配下へ
  notes_subdir = "notes",
  new_notes_location = "notes_subdir",

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

  -- ここは obsidian.nvim が markdown バッファに対して設定する “内部マッピング”
  -- Enter は "cr" ではなく "<cr>" と書く必要があります（空文字も不可）
  mappings = {
    ["gf"] = {
      action = function()
        return require("obsidian").util.gf_passthrough()
      end,
      opts = { noremap = false, expr = true, buffer = true },
    },
    ["<cr>"] = {
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
    -- コマンド: :ObsidianPasteImg で貼り付け可能 :contentReference[oaicite:0]{index=0}
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
        print("Obsidian workspace ready: " .. workspace.name)
      end)
    end,
  },
})

