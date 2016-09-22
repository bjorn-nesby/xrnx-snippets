local output_folder = "c:/temp2/"
local instr = renoise.song().selected_instrument
for _,sample in ipairs(instr.samples) do
  local filename = output_folder .. sample.name
  renoise.app():save_instrument_sample(filename)
end
