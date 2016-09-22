--[[
Format filenames for export to Kontakt sampler
Removes dash and convert velocity to decimal

Input: e.g. VST: Rhode (Default)_0x2A_C-5
Output e.g. VST: Rhode (Default)_42_C5

]]

local output_folder = "c:/temp/" -- folder needs to exist
local instr = renoise.song().selected_instrument
for _,sample in ipairs(instr.samples) do
  local filename = output_folder .. sample.name
  filename = string.gsub(filename,"(.*)_(0x%x%x)_([A-Z])-?(#?%d)",function(a,b,c,d)
    return a.."_"..("%d"):format(tonumber(b)).."_"..c..d
  end)
  print(filename)
  --renoise.app():save_instrument_sample(filename)
end

