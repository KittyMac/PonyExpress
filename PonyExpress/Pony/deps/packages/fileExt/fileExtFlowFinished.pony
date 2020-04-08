use "files"
use "flow"

interface FlowFinished  
  fun flowFinished()

actor FileExtFlowFinished is Flowable
  
  let target:Flowable tag
  let sender:FlowFinished val
  
  fun _tag():USize => 107

  new create(sender':FlowFinished val, target':Flowable tag) =>
    target = target'
    sender = sender'

  be flowFinished() =>
    sender.flowFinished()
    
  be flowReceived(dataIso:Any iso) =>
    target.flowReceived(consume dataIso)
  