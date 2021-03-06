--------------------------------------------------------------------------------
-- Recursive routine that remove unnecessary data from a network
--------------------------------------------------------------------------------

-- opt is the global option, opt.save store the default saving location
opt = opt or {}
opt.save = opt.save or './'

print '==> generating recursive network cleaning routine'
function nilling(module)
   module.gradBias   = nil
   if module.finput then module.finput = torch.Tensor() end
   module.gradWeight = nil
   module.output     = torch.Tensor()
   module.fgradInput = nil
   module.gradInput  = nil
   if module.indices then module.indices = torch.Tensor() end
end

function netLighter(network)
   nilling(network)
   if network.modules then
      for _,a in ipairs(network.modules) do
         netLighter(a)
      end
   end
end

print '==> generating network saving routine'
function saveNet(name, model)
   local filename = paths.concat(opt.save, name)
   os.execute('mkdir -p ' .. sys.dirname(filename))
   print('==> saving model to '..filename)
   local modelToSave = model:float()
   netLighter(modelToSave)
   torch.save(filename, modelToSave)
end
