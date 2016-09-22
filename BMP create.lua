--[[
  BMP Writer
]]

local BIT_COUNT = {1,4,8,16,24,32}

local BMP_COMPRESSION = {
  UNCOMPRESSED = 0,
  RLE_8 = 1,        -- Usable only with 8-bit images
  RLE_4 = 2,        -- Usable only with 4-bit images
  BITFIELDS = 3,    -- Used - and required - only with 16- and 32-bit images
}

local width = 1
local height = 1000
local bit_count = 24
--local compression = 0   -- uncompressed
--local size_image = 0    -- no need when uncompressed 
--local x_resolution = 0  -- preferred horizontal resolution of the image, in pixels per meter
--local y_resolution = 0  -- preferred vertical resolution of the image, in pixels per meter
--local clrs_used = 0     -- Number Color Map entries that are actually used
--local clrs_important = 0 -- Number of significant colors

local pixels = {}

-- 14 = file header 
-- 40 = image header
-- 
--local file_size = 14+40 

--[[
function writeHex(str,fh)
  for byte in str:gmatch'%x%x' do
    fh:write(string.char(tonumber(byte,16)))
  end
end
]]

-------------------------------------------------------------------------------
--- set all pixels to a particular color

function flood(color)

  pixels = {}
  
  for row = 1,height do
    for col = 1,width do  
      table.insert(pixels,color)
    end
  end
  
end

-------------------------------------------------------------------------------

function tohex(val)
  if (type(val) == "string") then
    return (val:gsub('.', function (c)
      return string.format('%02X', string.byte(c))
    end))
  elseif (type(val) == "number") then
    return string.format('%02X', val)
  end
end

-------------------------------------------------------------------------------
--- hexadecimal "pretty-print" 

function hex_print()

  local str_rslt = ""

  local items_per_line = 16
  local item_count = 0
  
  for k,v in ipairs(bmp) do
    str_rslt = str_rslt .. tohex(v)
    item_count = item_count+1
    if ((item_count%2)==0) then
      str_rslt = str_rslt .. " "
    end
    if (item_count == items_per_line) then
      item_count = 0
      str_rslt = str_rslt .. "\n"    
    end
  end
  
  return str_rslt

end
  

-------------------------------------------------------------------------------
--- given a value, return bytes in reverse (endian) order
-- @param number, treated as 32-bit 
-- @return table>number

function split_bits(num,endian)

  local str_hex = (bit.tohex(num))
  local rslt = {}
  local bytes = {
    tonumber(string.sub(str_hex,1,2),16),
    tonumber(string.sub(str_hex,3,4),16),
    tonumber(string.sub(str_hex,5,6),16),
    tonumber(string.sub(str_hex,7,8),16),
  }
  if endian then
    for k,v in ripairs(bytes) do
      table.insert(rslt,v)
    end
  else
    rslt = bytes
  end
  
  return rslt

end

-------------------------------------------------------------------------------

function get_bitmap_size_in_bytes()

  return width*height*4

end

-------------------------------------------------------------------------------

function get_total_size_in_bytes()

  local headers_size = 56
  return headers_size + get_bitmap_size_in_bytes()

end

-------------------------------------------------------------------------------
--- return a complete BMP image as table

function create()

  local bitmap = {}

  -- FILE HEADER ----------------------
  
  -- bitmap signature
  bitmap[1] = 'B'
  bitmap[2] = 'M'

  -- file size in bytes 
  
  local size_bytes = split_bits(get_total_size_in_bytes(),true)
  for i = 3, 6 do 
    bitmap[i] = size_bytes[i-2]
  end
    
  -- reserved fields
  for i = 7, 10 do bitmap[i] = 0 end
  
  -- offset of pixel data
  for i = 11, 14 do bitmap[i] = 0 end  

  -- BITMAP HEADER --------------------

  -- header size
  bitmap[15] = 40
  for i = 16, 18 do bitmap[i] = 0 end

  -- width of the image
  local width_bytes = split_bits(width,true)
  for i = 19, 22 do 
    bitmap[i] = width_bytes[i-18]
  end
  
  -- height of the image
  local height_bytes = split_bits(height,true)
  for i = 23, 26 do 
    bitmap[i] = height_bytes[i-22]
  end

  -- reserved field
  bitmap[27] = 1
  bitmap[28] = 0

  -- number of bits per pixel
  bitmap[29] = bit_count
  bitmap[30] = 0

  -- compression method (no compression here)
  for i = 31, 34 do bitmap[i] = 0 end

  -- size of pixel data
  for i = 35, 38 do 
    bitmap[i] = size_bytes[i-34]
  end  

  -- horizontal resolution of the image - pixels per meter (2835)
  bitmap[39] = 0
  bitmap[40] = 0
  bitmap[41] = 0 --0b00110000
  bitmap[42] = 0 --0b10110001

  -- vertical resolution of the image - pixels per meter (2835)
  bitmap[43] = 0
  bitmap[44] = 0
  bitmap[45] = 0 -- 0b00110000
  bitmap[46] = 0 -- 0b10110001

  -- color palette 
  for i = 47, 50 do bitmap[i] = 0 end
  
  -- # important colors
  for i = 51, 54 do bitmap[i] = 0 end


  -- PIXEL DATA -----------------------
  
  local num_pixel_bytes = get_bitmap_size_in_bytes()
  for i = 55, 55+num_pixel_bytes do 
    bitmap[i] = pixels[i-54]
  end

  return bitmap      


end

-------------------------------------------------------------------------------

function save_bmp(bitmap,file_path)

  local fh = io.open(file_path,'wb')
  
  for k,v in ipairs(bitmap) do
    if (type(v)=="string") then
      fh:write(string.char(string.byte(v)))
    else
      fh:write(string.char(v))
    end
  end
  
  fh:close()

end

-------------------------------------------------------------------------------

flood({0xff,0xff,0xff})
bmp = create()

local file_path = 'C:/Users/Bjørn/Desktop/vgraph img/test.bmp'

save_bmp(bmp,file_path)



