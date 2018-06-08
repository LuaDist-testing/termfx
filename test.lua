tfx = require "termfx"

tfx.init()

tfx.attributes(tfx.color.WHITE, tfx.color.BLACK)
tfx.printat(1, 10, "TESTTESTTEST")
i = 1
j = 15
tfx.attributes(i, j)
tfx.printat(1, 20, "TESTTESTTEST")

tfx.present()
tfx.pollevent()
tfx.shutdown()
