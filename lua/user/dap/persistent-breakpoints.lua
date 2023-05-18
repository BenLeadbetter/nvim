local has_persistent_breakpoints, persistent_breakpoints = pcall(require, "persistent-breakpoints")
if not has_persistent_breakpoints then
    return
end

persistent_breakpoints.setup{
    load_breakpoints_event = { "BufReadPost" }
}
