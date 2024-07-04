require('ollama').setup({
    url = "http://192.168.0.58:11434",
    serve = {
        on_start = false,
        command = "virsh",
        args = { "start", "arch-llm" },
        stop_command = "virsh",
        stop_args = { "shutdown", "arch-llm" },
    },
})
