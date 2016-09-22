--[[
  Copy-paste from http://www.gamedev.net/topic/572784-lua-read-bitmap/
]]

function error(err)
	-- Replace with your own error output method:
	println(err);
end

-- Helper function: Parse a 16-bit WORD from the binary string
function ReadWORD(str, offset)
	local loByte = str:byte(offset);
	local hiByte = str:byte(offset+1);
	return hiByte*256 + loByte;
end

-- Helper function: Parse a 32-bit DWORD from the binary string
function ReadDWORD(str, offset)
	local loWord = ReadWORD(str, offset);
	local hiWord = ReadWORD(str, offset+2);
	return hiWord*65536 + loWord;
end

-- Process a bitmap file in a string, and call DrawPoint for each pixel
function DrawBitmap(bytecode)
	-------------------------
	-- Parse BITMAPFILEHEADER
	-------------------------
	local offset = 1;
	local bfType = ReadWORD(bytecode, offset);
	if(bfType ~= 0x4D42) then
		error("Not a bitmap file (Invalid BMP magic value)");
		return;
	end
	local bfOffBits = ReadWORD(bytecode, offset+10);

	-------------------------
	-- Parse BITMAPINFOHEADER
	-------------------------
	offset = 15; -- BITMAPFILEHEADER is 14 bytes long
	local biWidth = ReadDWORD(bytecode, offset+4);
	local biHeight = ReadDWORD(bytecode, offset+8);
	local biBitCount = ReadWORD(bytecode, offset+14);
	local biCompression = ReadDWORD(bytecode, offset+16);
	if(biBitCount ~= 24) then
		error("Only 24-bit bitmaps supported (Is " .. biBitCount .. "bpp)");
		return;
	end
	if(biCompression ~= 0) then
		error("Only uncompressed bitmaps supported (Compression type is " .. biCompression .. ")");
		return;
	end

	---------------------
	-- Parse bitmap image
	---------------------
	for y = biHeight-1, 0, -1 do
		offset = bfOffBits + (biWidth*biBitCount/8)*y + 1;
		for x = 0, biWidth-1 do
			local b = bytecode:byte(offset);
			local g = bytecode:byte(offset+1);
			local r = bytecode:byte(offset+2);
			offset = offset + 3;

			DrawPoint(x, biHeight-y-1, r, g, b);
		end
	end
end


function testBmp(args)
	local f = assert(io.open(args, "rb"));
	local bmp = f:read("*a");
	f:close();

	DrawBitmap(bmp);
end