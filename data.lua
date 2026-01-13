local util = require("__core__/lualib/util")

local chest_entity = util.table.deepcopy(data.raw["container"]["steel-chest"])
chest_entity.name = "unl-chest"
chest_entity.minable = {mining_time = 0.1, result = "unl-chest"}
chest_entity.inventory_size = 1

-- Needed for game.get_entity_by_unit_number(unit_number)
chest_entity.flags = chest_entity.flags or {}
local has_flag = false
for _, f in pairs(chest_entity.flags) do
  if f == "get-by-unit-number" then has_flag = true break end
end
if not has_flag then
  table.insert(chest_entity.flags, "get-by-unit-number")
end

local chest_item = util.table.deepcopy(data.raw["item"]["steel-chest"])
chest_item.name = "unl-chest"
chest_item.place_result = "unl-chest"
chest_item.order = "z[unl-chest]"

local chest_recipe = util.table.deepcopy(data.raw["recipe"]["steel-chest"])
chest_recipe.name = "unl-chest"
chest_recipe.enabled = true
chest_recipe.ingredients = {{type="item", name="iron-plate", amount=1}}
chest_recipe.results = {{type="item", name="unl-chest", amount=1}}

data:extend({chest_entity, chest_item, chest_recipe})
