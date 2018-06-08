tfx = require "termfx"

tfx.init()

ok, err = pcall(function()
---------- vvv draw here vvv ----------

tfx.outputmode(tfx.output.COL256)
tfx.clear(tfx.color.WHITE, tfx.color.BLACK)

tfx.rect(10, 10, tfx.width()-19, tfx.height()-19, '*', tfx.color.RED, tfx.color.BLUE)

buf = tfx.newbuffer(tfx.width() / 2, tfx.height() - 10)
buf:clear(tfx.color.WHITE, tfx.color.GREEN)
buf:rect(2,2,buf:width()-2,buf:height()-2, '#', tfx.color.YELLOW, tfx.color.CYAN)
tfx.blit((tfx.width() - buf:width()) / 2, (tfx.height() - buf:height()) / 2, buf)

---------- ^^^ draw here ^^^ ----------
tfx.present()
tfx.pollevent()
end)

tfx.shutdown()
if not ok then print("Error: "..err) end
