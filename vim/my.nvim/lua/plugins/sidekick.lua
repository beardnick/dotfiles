if not require('plug').loaded('sidekick.nvim') then
    return
end

require("sidekick").setup({
    copilot = {
        status = {
            enabled = false,
        },
    },
    cli = {
        tools = {
            codex = {
                cmd = { "codex" },
            },
            codex_resume = {
                cmd = { "codex", "resume" },
            },
        },
    },
})

local map = vim.keymap.set

local function map_opts(desc)
    return { silent = true, desc = desc }
end

map({ "n", "t", "i", "x" }, "<C-.>", function()
    require("sidekick.cli").toggle()
end, map_opts("Sidekick toggle"))

map("n", "<leader>ks", function()
    require("sidekick.cli").toggle()
end, map_opts("Sidekick toggle CLI"))

map("n", "<leader>kc", function()
    require("sidekick.cli").select()
end, map_opts("Sidekick select CLI"))

map("n", "<leader>kc", function()
    require("sidekick.cli").toggle({ name = "codex", focus = true })
end, map_opts("Sidekick resume Codex"))

map("n", "<leader>kr", function()
    require("sidekick.cli").toggle({ name = "codex_resume", focus = true })
end, map_opts("Sidekick resume Codex"))

map("n", "<leader>kp", function()
    require("sidekick.cli").prompt()
end, map_opts("Sidekick prompt"))

map("n", "<leader>kf", function()
    require("sidekick.cli").send({ msg = "{file}" })
end, map_opts("Sidekick send file"))

map({ "n", "x" }, "<leader>kt", function()
    require("sidekick.cli").send({ msg = "{this}" })
end, map_opts("Sidekick send this"))

map("x", "<leader>kv", function()
    require("sidekick.cli").send({ msg = "{selection}" })
end, map_opts("Sidekick send selection"))

map("n", "<leader>kn", function()
    require("sidekick").nes_jump_or_apply()
end, map_opts("Sidekick next edit"))
