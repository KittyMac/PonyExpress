use "files"
use "flow"

actor FileExtFlowPassthru is Flowable
  
  let target:Flowable tag
  
  fun _tag():USize => 108

  new create(target':Flowable tag) =>
    target = target'
  
  be flowFinished() =>
    target.flowFinished()
  
  be flowReceived(dataIso:Any iso) =>
    target.flowReceived(consume dataIso)