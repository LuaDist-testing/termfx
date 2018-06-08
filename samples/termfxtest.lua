tfx = require "termfx"

tfx.init()
tfx.inputmode(tfx.input.ALT)
tfx.outputmode(tfx.output.COL256)

function draw_box(x, y, w, h)
	local ccell = tfx.newcell('+')
	local hcell = tfx.newcell('-')
	local vcell = tfx.newcell('|')

	for i = x, x+w do
		tfx.setcell(i, y-1, hcell)
		tfx.setcell(i, y+h, hcell)
	end
	for i = y, y+h do
		tfx.setcell(x-1, i, vcell)
		tfx.setcell(x+w, i, vcell)
	end
	tfx.setcell(x-1, y-1, ccell)
	tfx.setcell(x-1, y+h, ccell)
	tfx.setcell(x+w, y-1, ccell)
	tfx.setcell(x+w, y+h, ccell)
	
	tfx.rect(x, y, w, h, ' ', fg, bg)
end

function box(w, h)
	local tw, th = tfx.width(), tfx.height()
	if w + 2 > tw then w = tw - 2 end
	if h + 2 > th then h = th - 2 end
	local x = math.floor((tw - w) / 2)
	local y = math.floor((th - h) / 2)
	
	draw_box(x, y, w, h)
	
	return x, y, w, h
end

function ask(msg)
	local mw = #msg
	if mw < 6 then mw = 6 end
	local x, y, w, h = box(mw, 3)
	tfx.printat(x, y, msg, w)
	local p = x + math.floor((w - 6) / 2)
	tfx.attributes(tfx.color.BLACK, tfx.color.GREEN)
	tfx.printat(p, y+2, "Yes")
	tfx.attributes(tfx.color.BLACK, tfx.color.RED)
	tfx.printat(p+4, y+2, "No")
	tfx.present()
	
	local answer = nil
	while answer == nil do
		local evt = tfx.pollevent()
		if evt.char == 'y' or evt.char == 'Y' then
			answer = true
		elseif evt.char == 'n' or evt.char == 'N' then
			answer = false
		end
	end
	return answer
end

function select(msg, tbl)
	local mw = #msg
	local mh = #tbl
	if mh > 9 then mh = 9 end
	for i=1, mh do
		if mw < #tbl[i] + 2 then mw = #tbl[i] + 2 end
	end

	local x, y, w, h = box(mw, mh+2)
	tfx.printat(x, y, msg, w)
	for i=1, mh do
		tfx.printat(x, y+1+i, i.." "..tbl[i])
	end
	tfx.present()
	
	local answer = nil
	while answer == nil do
		local evt = tfx.pollevent()
		if evt.char >= '1' and evt.char <= tostring(mh) then
			answer = tbl[tonumber(evt.char)]
		end
	end
	return answer
end

function pr_event(x, y, evt)
	evt = evt or {}

	tfx.attributes(tfx.color.BLUE, tfx.color.WHITE)
	tfx.printat(x, y, "Event:")
	tfx.printat(x+7, y, evt.type)
	
	tfx.attributes(tfx.color.WHITE, tfx.color.BLACK)
	if evt.type == "key" then
		tfx.printat(x, y+1, "mod")
		tfx.printat(x+7, y+1, evt.mod)
		tfx.printat(x, y+2, "key")
		tfx.printat(x+7, y+2, evt.key)
		tfx.printat(x, y+3, "ch")
		tfx.printat(x+7, y+3, evt.ch)
		tfx.printat(x, y+4, "char")
		tfx.printat(x+7, y+4, evt.char)
	elseif evt.type == "resize" then
		tfx.printat(x, y+1, "w")
		tfx.printat(x+7, y+1, evt.w)
		tfx.printat(x, y+2, "h")
		tfx.printat(x+7, y+2, evt.h)
	end
end

function pr_colors(x, y, w)
	tfx.attributes(tfx.color.WHITE, tfx.color.BLACK)
	tfx.printat(x, y, "BLACK", w)
	tfx.attributes(tfx.color.WHITE, tfx.color.RED)
	tfx.printat(x, y+1, "RED", w)
	tfx.attributes(tfx.color.WHITE, tfx.color.GREEN)
	tfx.printat(x, y+2, "GREEN", w)
	tfx.attributes(tfx.color.BLACK, tfx.color.YELLOW)
	tfx.printat(x, y+3, "YELLOW", w)
	tfx.attributes(tfx.color.WHITE, tfx.color.BLUE)
	tfx.printat(x, y+4, "BLUE", w)
	tfx.attributes(tfx.color.BLACK, tfx.color.MAGENTA)
	tfx.printat(x, y+5, "MAGENTA", w)
	tfx.attributes(tfx.color.BLACK, tfx.color.CYAN)
	tfx.printat(x, y+6, "CYAN", w)
	tfx.attributes(tfx.color.BLACK, tfx.color.WHITE)
	tfx.printat(x, y+7, "WHITE", w)
end

function find_name(tbl, val)
	for k, v in pairs(tbl) do
		if val == v then return k end
	end
	return nil
end

function tbl_keys(tbl)
	local res = {}
	for k, v in pairs(tbl) do
		res[#res+1] = k
	end
	table.sort(res, function(i, k) return tbl[i] < tbl[k] end)
	return res
end

function pr_stats(x, y)
	local tw, th = tfx.width(), tfx.height()
	local im = tfx.inputmode()
	local om = tfx.outputmode()
	
	tfx.attributes(tfx.color.WHITE, tfx.color.BLACK)
	tfx.printat(x, y, "Size:")
	tfx.printat(x+8, y, tw .. " x " .. th)
	tfx.printat(x, y+1, "Input: ")
	tfx.printat(x+8, y+1, find_name(tfx.input, im))
	tfx.printat(x, y+2, "Output: ")
	tfx.printat(x+8, y+2, find_name(tfx.output, om))
end

function pr_coltbl(x, y)
	local i = 0
	local om = tfx.outputmode()
	
	if om == tfx.output.NORMAL or om == tfx.output.COL256 then
		for j=i, i+7 do
			tfx.attributes(tfx.color.WHITE, j)
			tfx.printat(x, y+j, string.format("%02X", j), 2)
			tfx.attributes(tfx.color.WHITE, j+8)
			tfx.printat(x+3, y+j, string.format("%02X", j+8), 2)
		end
		i = 16
		x = x+6
	end
	
	if om == tfx.output.COL216 or om == tfx.output.COL256 then
		for j=0, 11 do
			for k=0, 15 do
				local col = k*12+j+i
				tfx.attributes(tfx.color.WHITE, col)
				tfx.printat(x+k*3, y+j, string.format("%02X", col), 2)
			end
		end
		x = x+48
		i=i+216
	end
	
	if om == tfx.output.GRAYSCALE or om == tfx.output.COL256 then
		for j=0, 11 do
			for k=0, 1 do
				local col = k*12+j+i
				tfx.attributes(tfx.color.WHITE, col)
				tfx.printat(x+k*3, y+j, string.format("%02X", col), 2)
			end
		end
	end
end

function pr_formats(x, y)
	local fg, bg = tfx.attributes()
	
	tfx.printat(x, y, "Normal")
	x = x + 7
	tfx.attributes(fg + tfx.format.BOLD, bg)
	tfx.printat(x, y, "Bold")
	x = x + 5
	tfx.attributes(fg + tfx.format.UNDERLINE, bg)
	tfx.printat(x, y, "Under")
	x = x + 6
	tfx.attributes(fg + tfx.format.REVERSE, bg)
	tfx.printat(x, y, "Reverse")
	
	tfx.attributes(fg, bg)
end

function blit_a_bit(x, y, w, h)
	tfx.attributes(tfx.color.WHITE, tfx.color.BLACK)
	draw_box(x, y, w, h)
	
	local buf = tfx.newbuffer(8, 6)
	buf:clear(tfx.color.WHITE, tfx.color.BLACK)
	
	local cell = tfx.newcell('#', tfx.color.YELLOW, tfx.color.GREEN)
	local eye = tfx.newcell('O', tfx.color.BLACK, tfx.color.GREEN)
	local mouth = tfx.newcell('X', tfx.color.BLACK, tfx.color.GREEN)
	
	for i=3, 6 do
		buf:setcell(i, 1, cell)
		buf:setcell(i, 6, cell)
	end
	buf:rect(1, 2, 8, 4, cell)
	
	buf:setcell(3, 3, eye)
	buf:setcell(6, 3, eye)
	buf:setcell(2, 4, mouth)
	buf:setcell(7, 4, mouth)
	for i=3, 6 do
		buf:setcell(i, 5, mouth)
	end
	
	tfx.blit(x, y, buf)
	tfx.blit(x+w-8, y+6, buf)
	tfx.blit(x+w-8, y+h-6, buf)
	tfx.blit(x, y+h-12, buf)
end

function select_inputmode()
	local which = select("select input mode", tbl_keys(tfx.input))
	tfx.inputmode(tfx.input[which])
end

function select_outputmode()
	local which = select("select output mode", tbl_keys(tfx.output))
	tfx.outputmode(tfx.output[which])
end

ok, err = pcall(function()

	local quit = false
	local evt
	repeat
		
		tfx.clear(tfx.color.WHITE, tfx.color.BLACK)
		tfx.printat(1, tfx.height(), "press I to select input mode, O to select output mode, Q to quit")
		
		tfx.printat(1, 1, _VERSION)
		pr_event(1, 3, evt)
		pr_stats(25, 1)
		pr_formats(1, 10)
		pr_colors(50, 1, 10)
		pr_coltbl(1, 12)
		blit_a_bit(62, 2, 18, 21)
		
		tfx.present()
		evt = tfx.pollevent()
		
		tfx.attributes(tfx.color.WHITE, tfx.color.BLUE)
		if evt.char == "q" or evt.char == "Q" then
			quit = ask("Really quit?")
		elseif evt.char == "i" or evt.char == "I" then
			select_inputmode()
		elseif evt.char == "o" or evt.char == "O" then
			select_outputmode()
		end

	until quit

end)
tfx.shutdown()
if not ok then print("Error: "..err) end
