-- Redefine globals
globals = {
    "vim",
}

-- Ignore unused self warnings (methods)
self = false

-- Ignore warnings about unused arguments
unused_args = false

-- Increase max line length
max_line_length = 120

-- Ignore some common warnings
ignore = {
    "212", -- Unused argument
    "213", -- Unused loop variable
    "421", -- Shadowing a local variable
    "431", -- Shadowing an upvalue
    "432", -- Shadowing an upvalue argument
}

-- Exclude some directories
exclude_files = {
    "tests/*",
}
