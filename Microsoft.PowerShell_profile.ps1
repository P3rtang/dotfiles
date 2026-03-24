Set-PSReadLineOption -EditMode Emacs
atuin init powershell | Out-String | Invoke-Expression

function ChangeFuzzyDir {
    Get-ChildItem . -Recurse -Attributes Directory | Invoke-Fzf | Set-Location
}

Set-Alias -Name cdf -Value ChangeFuzzyDir

function Avante {
    nvim -c "lua vim.defer_fn(function()require('avante.api').zen_mode()end, 100)"
}

Set-Alias -Name avante -Value Avante
