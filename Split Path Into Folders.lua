local path = "Home/Users/Bjørn/Docum\\ents/Renoise//User Library/FX/"
local matches = string.gmatch(path,"(.-)([^\\/])")
local part = ""
local parts = {}
for k,v in matches do
  if (k=="") then
    part = part..v
  else
    table.insert(parts,part)
    part = v
  end
end
table.insert(parts,part)
rprint(parts)

