function CheckQuickfix()
    local function check_valid_filename(entry)
        local filename = vim.fn.bufname(entry.bufnr)
        return filename and #filename > 0 and entry.lnum ~= 0
    end

    local function filter(func, t)
        local result = {}
        for _, v in ipairs(t) do -- Using ipairs for array-like tables
            if func(v) then
                table.insert(result, v)
            end
        end
        return result
    end

    local qflist = vim.fn.getqflist()
    local filtered_qflist = filter(check_valid_filename, qflist)

    if #filtered_qflist > 0 then
        vim.cmd.copen()
    end
end

function ReloadConfig()
  for name,_ in pairs(package.loaded) do
    if name:match('^cnull') then
      package.loaded[name] = nil
    end
  end

  dofile(vim.env.MYVIMRC)
end
