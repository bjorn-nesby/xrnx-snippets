--[[============================================================================
main.lua
============================================================================]]--

local vb = renoise.ViewBuilder()
local dialog = nil
local dialog_content = nil


--------------------------------------------------------------------------------
-- functions
--------------------------------------------------------------------------------

function show()

  attach_to_song()

  if not dialog or not dialog.visible then
    
    if not dialog_content then
      dialog_content = build()
    end

    local function keyhandler(dialog, key)
      if (key.modifiers == "" and key.name == "return") then
        --perform_slicing()
      elseif (key.modifiers == "" and key.name == "esc") then
        dialog:close()
      end
    end
      
    dialog = renoise.app():show_custom_dialog("ToolTemplate", 
      dialog_content, keyhandler)

  else
    dialog:show()
  end

  --update_on_sample_focus()


end

--------------------------------------------------------------------------------

function build()

  local content = vb:column{
    style = "group",
    vb:text{
      text = "Hello World",
      font = "big",
    },
  }

  return content

end

--------------------------------------------------------------------------------
-- notifiers/observables
--------------------------------------------------------------------------------

function attach_to_song()

  -- attach notifiers to song elements

end

--------------------------------------------------------------------------------
-- tool stuff
--------------------------------------------------------------------------------

renoise.tool().app_new_document_observable:add_notifier(function()
  if dialog then
    attach_to_song()
    -- update GUI
  end
end)

renoise.tool().app_became_active_observable:add_notifier(function()
  if dialog then
    -- update GUI
  end
end)

renoise.tool():add_menu_entry{
  name = "Main Menu:Tools:ToolTemplate",
  invoke = function() show() end
}

renoise.tool():add_keybinding{
  name = "Main Menu:Tools:ToolTemplate",
  invoke = function() show() end
}



--------------------------------------------------------------------------------
-- debug
--------------------------------------------------------------------------------

_AUTO_RELOAD_DEBUG = function()
  show()
end

