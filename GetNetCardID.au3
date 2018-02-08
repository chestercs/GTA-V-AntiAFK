$CMD = 'wmic nic get name, index'
Run('"' & @ComSpec & '" /k ' & $CMD, @SystemDir)