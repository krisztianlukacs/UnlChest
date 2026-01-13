-- UnlChest v2.3.5 – GUI moved to player.gui.screen (drag_target + ESC safe in Factorio 2.0)

local function ensure_storage()
  storage.chests = storage.chests or {}               -- [unit_number] = {item="iron-plate"|nil}
  storage.player_target = storage.player_target or {} -- [player_index] = unit_number|nil
end

script.on_init(ensure_storage)
script.on_configuration_changed(ensure_storage)

local function ensure_record(entity)
  if not (entity and entity.valid and entity.name == "unl-chest" and entity.unit_number) then return nil end
  ensure_storage()
  local u = entity.unit_number
  storage.chests[u] = storage.chests[u] or { item = nil }
  return u
end

script.on_event({defines.events.on_built_entity, defines.events.on_robot_built_entity}, function(e)
  ensure_record(e.entity)
end)

local function unregister(entity)
  if not (entity and entity.valid and entity.name == "unl-chest" and entity.unit_number) then return end
  ensure_storage()
  local u = entity.unit_number
  storage.chests[u] = nil
  for p, tu in pairs(storage.player_target) do
    if tu == u then storage.player_target[p] = nil end
  end
end
script.on_event(defines.events.on_pre_player_mined_item, function(e) unregister(e.entity) end)
script.on_event(defines.events.on_robot_pre_mined, function(e) unregister(e.entity) end)
script.on_event(defines.events.on_entity_died, function(e) unregister(e.entity) end)

local function get_gui(player)
  return player.gui.screen.unl_gui
end

local function destroy_gui(player)
  local gui = get_gui(player)
  if gui and gui.valid then gui.destroy() end
  if player.opened and player.opened.valid and player.opened.name == "unl_gui" then
    player.opened = nil
  end
end

local function open_gui(player, unit_number)
  ensure_storage()
  destroy_gui(player)

  local record = storage.chests[unit_number]
  if not record then return end

  -- Must be in player.gui.screen for draggable titlebar / drag_target in Factorio 2.0
  local frame = player.gui.screen.add{
    type = "frame",
    name = "unl_gui",
    direction = "vertical"
  }
  frame.auto_center = true

  -- Titlebar
  local titlebar = frame.add{type="flow", name="unl_titlebar", direction="horizontal"}
  titlebar.drag_target = frame

  local title = titlebar.add{type="label", caption="UnlChest"}
  title.style = "frame_title"

  local drag = titlebar.add{type="empty-widget", style="draggable_space_header"}
  drag.style.horizontally_stretchable = true
  drag.style.height = 24
  drag.drag_target = frame

  titlebar.add{
    type = "sprite-button",
    name = "unl_close",
    sprite = "utility/close",
    style = "frame_action_button",
    tooltip = "Close"
  }

  frame.add{
    type = "choose-elem-button",
    name = "unl_item_select",
    elem_type = "item",
    item = record.item
  }

  storage.player_target[player.index] = unit_number

  -- Allow ESC to close
  player.opened = frame
end

-- Replace vanilla chest GUI with our selector GUI
script.on_event(defines.events.on_gui_opened, function(e)
  if e.gui_type ~= defines.gui_type.entity then return end
  if not (e.entity and e.entity.valid and e.entity.name == "unl-chest") then return end

  local player = game.players[e.player_index]
  local u = ensure_record(e.entity)
  if not u then return end

  player.opened = nil
  open_gui(player, u)
end)

-- Close button
script.on_event(defines.events.on_gui_click, function(e)
  if not (e.element and e.element.valid) then return end
  if e.element.name ~= "unl_close" then return end
  local player = game.players[e.player_index]
  destroy_gui(player)
  ensure_storage()
  storage.player_target[e.player_index] = nil
end)

-- ESC / normal close
script.on_event(defines.events.on_gui_closed, function(e)
  local player = game.players[e.player_index]
  local gui = get_gui(player)
  if gui and gui.valid then
    destroy_gui(player)
    ensure_storage()
    storage.player_target[e.player_index] = nil
  end
end)

-- Handle item selection
script.on_event(defines.events.on_gui_elem_changed, function(e)
  if not (e.element and e.element.valid and e.element.name == "unl_item_select") then return end
  ensure_storage()
  local unit = storage.player_target[e.player_index]
  if not unit or not storage.chests[unit] then return end
  storage.chests[unit].item = e.element.elem_value
end)

-- Infinite refill
script.on_nth_tick(10, function()
  ensure_storage()
  for unit, record in pairs(storage.chests) do
    local item = record.item
    if item then
      local entity = game.get_entity_by_unit_number(unit)
      if entity and entity.valid then
        local inv = entity.get_inventory(defines.inventory.chest)
        if inv then
          inv.clear()
          inv.insert{ name = item, count = prototypes.item[item].stack_size }
        end
      else
        storage.chests[unit] = nil
      end
    end
  end
end)
