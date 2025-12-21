---@alias alpha.Initalizer fun(_, alpha.Config):alpha.Config

---@class alpha.Config
---@field section alpha.Section
local config = {}

---@generic T
---@class alpha.Property<T>
---@field val T
local prop = {}

---@class alpha.Section
---@field header alpha.Property<string>
local section = {}