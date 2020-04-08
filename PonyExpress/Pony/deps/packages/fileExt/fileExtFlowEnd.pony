use "files"
use "flow"


actor FileExtFlowEnd is Flowable

  fun _tag():USize => 106
  
  be flowFinished() =>
    true
  
  be flowReceived(dataIso:Any iso) =>
    consume dataIso
  