use "linal"
use "utility"
use "easings"

primitive ScrollState
  let idle:U32 = 0
  let dragging:U32 = 1
  let decelerating:U32 = 2
  let animating:U32 = 3

primitive DeceleratingState
  let idle:U32 = 0
  let bouncing:U32 = 1
  let returningFromEdge:U32 = 2
  let scrolling:U32 = 3


trait Scrollable is (Viewable & Actionable)
  """
  For things whose visual content may be larger than their layout'd size, we allow the user to scroll around nicely. Our content size
  is always the combined size of our children?
  """
  
  let edgeBounceDuration:F32 = 0.5
  let edgeBounceEaseTimePercent:F32 = 0.2
  let bungeeStretchCoefficient:F32 = 0.35
  let minCancelTouchesVelocity:F32 = 3
  let scrollTouchDuration:F32 = 2.75
  let scrollWheelDuration:F32 = 0.75
  let pageVelocity:F32 = 400.0
  let swipeDistancePerVelocity:F32 = 0.4
  let bounceDistancePerVelocity:F32 = 0.03
  let animationDuration:F32 = 0.5
  let minScrollSpeed:F32 = 1.0
  
  var scrollDuration:F32 = 0
  
  var scrollEnabled:Bool = true
  
  var ignoreTouches:Array[USize] = Array[USize](32)
  var trackingTouches:Array[USize] = Array[USize](32)
  
  var previousPosition:V2 = V2fun.zero()
  
  var velocityX:F32 = 0
  var velocityY:F32 = 0
  
  var touchEdgeOffsetX:F32 = 0
  var touchEdgeOffsetY:F32 = 0
  
  var prevScrollX:F32 = 0
  var prevScrollY:F32 = 0
  
  var scrollX:F32 = 0
  var scrollY:F32 = 0
  
  var animStartScrollX:F32 = 0
  var animStartScrollY:F32 = 0
  
  var animEndScrollX:F32 = 0
  var animEndScrollY:F32 = 0
  
  var animStartVelocityX:F32 = 0
  var animStartVelocityY:F32 = 0
  
  var contentWidth:F32 = 0
  var contentHeight:F32 = 0
  
  var myWidth:F32 = 0
  var myHeight:F32 = 0
  
  var scrollHorizontal:Bool = true
  var scrollVertical:Bool = true
  
  var horizontalDecelerationState:U32 = DeceleratingState.idle
  var verticalDecelerationState:U32 = DeceleratingState.idle
  
  var scrollState:U32 = ScrollState.idle
  var scrollStateTime:F32 = 0.0
  var horizontalDecelerationTime:F32 = 0.0
  var verticalDecelerationTime:F32 = 0.0
  
  var touchTimestamp:U64 = 0
  
  be horizontal(v:Bool) =>
    scrollHorizontal = v
  
  be vertical(v:Bool) =>
    scrollVertical = v
  
  fun ref scrollable_render(frameContext:FrameContext val, bounds:R4) =>
    myWidth = R4fun.width(bounds)
    myHeight = R4fun.height(bounds)
    
    contentWidth = frameContext.contentSize._1
    contentHeight = frameContext.contentSize._2
        
  fun ref scrollable_event(frameContext:FrameContext val, anyEvent:AnyEvent val, bounds:R4) =>
    match anyEvent
    | let e:ScrollEvent val =>
      if scrollEnabled == false then
        trackingTouches.clear()
        return
      end
      
      let inside = pointInBounds(frameContext, bounds, e.position)
      
      if inside and (scrollState != ScrollState.dragging) then
        if scrollHorizontal then
          velocityX = e.delta._1 * 200.0
        end
        if scrollVertical then
          velocityY = e.delta._2 * -200.0
        end
        
        scrollDuration = scrollWheelDuration
        
        setScrollState(ScrollState.dragging)
        oneShotScrollingPush(0)
        
        if engine as RenderEngine then
          engine.setNeedsRendered()
        end
      end
    
    | let e:TouchEvent val =>
    
      if scrollEnabled == false then
        trackingTouches.clear()
        return
      end
      
      let inside = pointInBounds(frameContext, bounds, e.position)
      let wasTrackingTouches = (trackingTouches.size() > 0)
            
      // touches must originate inside of our button to be tracked
      if ignoreTouches.contains(e.id) then
        if (e.pressed == false) then
          ignoreTouches.deleteOne(e.id)
        end
        return
      end
      
      if e.pressed and (trackingTouches.contains(e.id) == false) then
        // This is an untracked touch.
        if inside then
        
          if trackingTouches.size() == 0 then
            previousPosition = inverseTransformPoint(frameContext, e.position)
          end
          
          trackingTouches.push(e.id)
        else
          ignoreTouches.push(e.id)
          return
        end
      else        
        // check when it goes away entirely
        if e.pressed == false then
          trackingTouches.deleteOne(e.id)
        end
      end
      
      let touchPosition = inverseTransformPoint(frameContext, e.position)
      
      // TODO: all touch positions should be the average of all active touches
      var shouldRender:Bool = false
      
      scrollDuration = scrollTouchDuration
      
      if (wasTrackingTouches == false) and (trackingTouches.size() > 0) then
        handleTouchBegan(e, touchPosition)
        shouldRender = true
      elseif (wasTrackingTouches == true) and (trackingTouches.size() == 0) then
        handleTouchEnded(e, touchPosition)
        shouldRender = true
      elseif trackingTouches.size() > 0 then
        try
          let touchID = trackingTouches(0)?
          if touchID == e.id then
            handleTouchMoved(e, touchPosition)
            shouldRender = true
          end
        end
      end
      
      if shouldRender then
        previousPosition = touchPosition
        if engine as RenderEngine then
          engine.setNeedsRendered()
        end
      end
      
      
    else
      None
    end
    
    fun ref calcMaxScrollX():F32 => (contentWidth - myWidth).max(0.0)
    fun ref calcMaxScrollY():F32 => (contentHeight - myHeight).max(0.0)
    fun ref bounceEdgeX():F32 => let m = calcMaxScrollX(); if prevScrollX < (m/2) then 0.0 else m end
    fun ref bounceEdgeY():F32 => let m = calcMaxScrollY(); if prevScrollY < (m/2) then 0.0 else m end
    fun ref bungee(stretchDist:F32, contentSize:F32):F32 => (1.0 - (1.0 / (((stretchDist * bungeeStretchCoefficient) / contentSize) + 1.0))) * contentSize
    
    // stubs to be overridden by Scrollables. TODO: change ponyc to optimize these out
    fun ref scrollViewWillBeginDragging() => None
    fun ref scrollViewWillBeginDecelerating() => None
    fun ref scrollViewWillBeginAnimating() => None
    fun ref scrollViewWillEndDragging() => None
    fun ref scrollViewDidEndDragging() => None
    fun ref scrollViewDidEndDecelerating() => None
    fun ref scrollViewDidEndAnimating() => None
        
    fun ref setScrollState(newState:U32) =>
      if scrollState != newState then
        // TODO: should we alert someone that things are happening?
        if newState == ScrollState.dragging then
          scrollViewWillBeginDragging()
        elseif newState == ScrollState.decelerating then
          scrollViewWillBeginDecelerating()
        elseif newState == ScrollState.animating then
          scrollViewWillBeginAnimating()
        end
        
        if scrollState == ScrollState.dragging then
          scrollViewWillEndDragging()
        end
    
        if (newState == ScrollState.animating) or (newState == ScrollState.decelerating) then
          animStartScrollX = prevScrollX
          animStartScrollY = prevScrollY
          animStartVelocityX = velocityX
          animStartVelocityY = velocityY
          horizontalDecelerationState = DeceleratingState.scrolling
          verticalDecelerationState = DeceleratingState.scrolling
        end
    
        let oldState = scrollState
        scrollState = newState
        scrollStateTime = 0.0
    
        if oldState == ScrollState.dragging then
          scrollViewDidEndDragging()
        elseif oldState == ScrollState.decelerating then
          scrollViewDidEndDecelerating()
        elseif oldState == ScrollState.animating then
          scrollViewDidEndAnimating()
        end
      end
    
    fun ref commitScrollToYogaNode(x:F32, y:F32) =>
      prevScrollX = x
      prevScrollY = y
      
      if engine as RenderEngine then
          engine.getNodeByID(nodeID, { (node) =>
            if node as YogaNode then
              node.setContentOffset(prevScrollX, prevScrollY)
              return RenderNeeded
            end        
            None
          })
      end
    
    fun ref handleTouchBegan(e:TouchEvent val, touchPosition:V2) =>
      //we have some touches that will stop this scroll view in it's tracks
      velocityX = 0
      velocityY = 0
      
      //make sure we know the timestep
      touchTimestamp = @ponyint_cpu_tick()
    
      //update state
      setScrollState(ScrollState.dragging)
    
    fun ref handleTouchMoved(e:TouchEvent val, touchPosition:V2) =>
      //get the timestep since the last touch event
      let touchPrevTimestamp = touchTimestamp
      touchTimestamp = @ponyint_cpu_tick()
      
      var touchDt = ((touchTimestamp - touchPrevTimestamp).f32() / 1_000_000_000.0).max(0)
      if touchDt == 0 then
        return
      end
  
      //calculate the touch velocity
      let dLoc = V2fun.sub(touchPosition, previousPosition)
      if scrollHorizontal then
        velocityX = (velocityX + (dLoc._1 / touchDt)) * 0.5
      else
        velocityX = 0.0
      end
      if scrollVertical then
        velocityY = (velocityY + (dLoc._2 / touchDt)) * 0.5
      else
        velocityY = 0.0
      end
        
      //we might need to cancel touches on inner nodes when we start a scroll, which is expensive. 
      //avoid this if we can by not cancelling when the user touches, but doesn't actually scroll
      if (velocityX.abs() < minCancelTouchesVelocity) and (velocityY.abs() < minCancelTouchesVelocity) then
        return
      end
  
      //update the scroll
      if scrollHorizontal then
        scrollX = scrollX + dLoc._1
      end
      if scrollVertical then
        scrollY = scrollY + dLoc._2
      end
  
      //TODO: we want to "capture" this touch so no one else can use it.  Need to implement... somewhere.
      //CCDirector::sharedDirector()->getTouchDispatcher()->cancelTouches(relevantTouches, this);
    
    
    fun ref oneShotScrollingPush(localMinScrollSpeed:F32) =>
      let isPastHorizontalEdge:Bool = ((scrollX < 0.0) or (scrollX > calcMaxScrollX())) and (localMinScrollSpeed > 0)
      let isPastVerticalEdge:Bool = ((scrollY < 0.0) or (scrollY > calcMaxScrollY())) and (localMinScrollSpeed > 0)
      let isMoving:Bool = (velocityX.abs() > localMinScrollSpeed) or (velocityY.abs() > localMinScrollSpeed)
      
      if isMoving or isPastHorizontalEdge or isPastVerticalEdge then
        //switch to decelerating
        setScrollState(ScrollState.decelerating)

        //we should scroll, calculate where our scroll should end
        horizontalDecelerationTime = 0.0
        if isPastHorizontalEdge then
          //animate back to the edge instead of scrolling
          horizontalDecelerationState = DeceleratingState.returningFromEdge
          animEndScrollX = bounceEdgeX()
        else
          animEndScrollX = scrollX + (swipeDistancePerVelocity * velocityX)
        end
                
        verticalDecelerationTime = 0.0
        if isPastVerticalEdge then
          //animate back to the edge instead of scrolling
          verticalDecelerationState = DeceleratingState.returningFromEdge
          animEndScrollY = bounceEdgeY()
        else
          animEndScrollY = scrollY + (swipeDistancePerVelocity * velocityY)
        end
        
      else
        //we're not moving or past the edge of the scroll, just idle
        setScrollState(ScrollState.idle)
      end    
    
    fun ref handleTouchEnded(e:TouchEvent val, touchPosition:V2) =>
      //check if we flicked the scroll view
      if velocityX.abs() < minCancelTouchesVelocity then
        velocityX = 0
      end
      if velocityY.abs() < minCancelTouchesVelocity then
        velocityY = 0
      end
      
      scrollX = prevScrollX
      scrollY = prevScrollY
      
      oneShotScrollingPush(minScrollSpeed)
    
    fun ref scrollable_animate(delta:F32 val) =>
      scrollStateTime = scrollStateTime + delta
      
      var assignScrollX = scrollX
      var assignScrollY = scrollY
      
      var updateScroll = false
            
      match scrollState
      | ScrollState.decelerating =>
        //update the horizontal deceleration
        if scrollHorizontal then
        
          if horizontalDecelerationState == DeceleratingState.returningFromEdge then
            //we're returning from being scrolled past the edge
            horizontalDecelerationTime = horizontalDecelerationTime + delta
            assignScrollX = Easing.tweenCubicEaseOut(animStartScrollX, animEndScrollX, horizontalDecelerationTime / animationDuration)

            //are we done animating?
            if horizontalDecelerationTime >= animationDuration then
              velocityX = 0.0
              assignScrollX = animEndScrollX
              horizontalDecelerationState = DeceleratingState.idle
            end
          else
            //we were not scrolled past the edge, scroll normally
            if horizontalDecelerationState == DeceleratingState.scrolling then
              //we're scrolling, and have not yet hit the edge
              let deceleratingPercent = scrollStateTime / scrollDuration
              assignScrollX = Easing.tweenQuinticEaseOut(animStartScrollX, animEndScrollX, deceleratingPercent)
              velocityX = Easing.tweenQuinticEaseOut(animStartVelocityX, 0.0, deceleratingPercent)

              //check if we've hit the edge
              if (scrollX < 0.0) or (scrollX > calcMaxScrollX()) then
                horizontalDecelerationState = DeceleratingState.bouncing
                horizontalDecelerationTime = 0.0
              elseif scrollStateTime > scrollDuration then
                velocityX = 0.0
                assignScrollX = animEndScrollX
                horizontalDecelerationState = DeceleratingState.idle
              end
            end
          
            if horizontalDecelerationState == DeceleratingState.bouncing then
              horizontalDecelerationTime = horizontalDecelerationTime + delta

              //which edge are we bouncing from?
              let edge = bounceEdgeX()

              //are we done bouncing?
              if horizontalDecelerationTime >= edgeBounceDuration then
                assignScrollX = edge
                velocityX = 0.0
                horizontalDecelerationState = DeceleratingState.idle
              else
                //assign the bounce position
                let bounceDistPastEdge = edge + (velocityX * bounceDistancePerVelocity)
                if horizontalDecelerationTime < (edgeBounceEaseTimePercent * edgeBounceDuration) then
                  assignScrollX = Easing.tweenQuadraticEaseOut(edge, bounceDistPastEdge, horizontalDecelerationTime / (edgeBounceEaseTimePercent * edgeBounceDuration))
                else
                  assignScrollX = Easing.tweenQuadraticEaseOut(bounceDistPastEdge, edge, (horizontalDecelerationTime - (edgeBounceEaseTimePercent * edgeBounceDuration)) / ((1.0 - edgeBounceEaseTimePercent) * edgeBounceDuration))
                end
              end
            end
          end
        end
        
        
        //update the vertical deceleration
        if scrollVertical then
          if verticalDecelerationState == DeceleratingState.returningFromEdge then
            //we're returning from being scrolled past the edge
            verticalDecelerationTime = verticalDecelerationTime + delta
            assignScrollY = Easing.tweenCubicEaseOut(animStartScrollY, animEndScrollY, verticalDecelerationTime / animationDuration)

            //are we done animating?
            if verticalDecelerationTime >= animationDuration then
              velocityY = 0.0
              assignScrollY = animEndScrollY
              verticalDecelerationState = DeceleratingState.idle
            end
          else
            //we were not scrolled past the edge, scroll normally
            if verticalDecelerationState == DeceleratingState.scrolling then              
              //we're scrolling, and have not yet hit the edge
              let deceleratingPercent = scrollStateTime / scrollDuration
              assignScrollY = Easing.tweenQuinticEaseOut(animStartScrollY, animEndScrollY, deceleratingPercent)
              velocityY = Easing.tweenQuinticEaseOut(animStartVelocityY, 0.0, deceleratingPercent)

              //check if we've hit the edge
              if (scrollY < 0.0) or (scrollY > calcMaxScrollY()) then
                verticalDecelerationState = DeceleratingState.bouncing
                verticalDecelerationTime = 0.0
              elseif scrollStateTime > scrollDuration then
                velocityY = 0.0
                assignScrollY = animEndScrollY
                verticalDecelerationState = DeceleratingState.idle
              end
            end
        
            if verticalDecelerationState == DeceleratingState.bouncing then
              verticalDecelerationTime = verticalDecelerationTime + delta

              //which edge are we bouncing from?
              let edge = bounceEdgeY()

              //are we done bouncing?
              if verticalDecelerationTime >= edgeBounceDuration then
                assignScrollY = edge
                velocityY = 0.0
                verticalDecelerationState = DeceleratingState.idle
              else
                //assign the bounce position
                let bounceDistPastEdge = edge + (velocityY * bounceDistancePerVelocity)
                if verticalDecelerationTime < (edgeBounceEaseTimePercent * edgeBounceDuration) then
                  assignScrollY = Easing.tweenQuadraticEaseOut(edge, bounceDistPastEdge, verticalDecelerationTime / (edgeBounceEaseTimePercent * edgeBounceDuration))
                else
                  assignScrollY = Easing.tweenQuadraticEaseOut(bounceDistPastEdge, edge, (verticalDecelerationTime - (edgeBounceEaseTimePercent * edgeBounceDuration)) / ((1.0 - edgeBounceEaseTimePercent) * edgeBounceDuration))
                end
              end
            end
          end
        end
      
        //check if we're done decelerating
        if (horizontalDecelerationState == DeceleratingState.idle) and
           (verticalDecelerationState == DeceleratingState.idle) then
           setScrollState(ScrollState.idle)
        end
        
        updateScroll = true
      
      | ScrollState.dragging =>
        //account for touch offset
        assignScrollX = assignScrollX + touchEdgeOffsetX
        assignScrollY = assignScrollY + touchEdgeOffsetY
  
        //do bungee effect horizontally
        if assignScrollX < 0 then
          assignScrollX = -bungee(assignScrollX.abs(), contentWidth)
        else
          let maxScroll = calcMaxScrollX()
          if assignScrollX > maxScroll then
            assignScrollX = maxScroll + bungee((assignScrollX - maxScroll), contentWidth)
          end
        end
  
        //do bungee effect vertically
        if assignScrollY < 0 then
          assignScrollY = -bungee(assignScrollY.abs(), contentHeight)
        else
          let maxScroll = calcMaxScrollY()
          if assignScrollY > maxScroll then
            assignScrollY = maxScroll + bungee((assignScrollY - maxScroll), contentHeight)
          end
        end
      
      | ScrollState.animating =>
        //animate horizontally
        if scrollHorizontal then
          //animate towards our desired scroll position
          assignScrollX = Easing.tweenCubicEaseOut(animStartScrollX, animEndScrollX, scrollStateTime / animationDuration)
        end

        //animate vertically
        if scrollVertical then
          //animate towards our desired scroll position
          assignScrollY = Easing.tweenCubicEaseOut(animStartScrollY, animEndScrollY, scrollStateTime / animationDuration)
        end

        //ready to switch states?
        if scrollStateTime >= animationDuration then
          assignScrollX = animEndScrollX
          assignScrollY = animEndScrollY
          velocityX = 0.0
          velocityY = 0.0
          setScrollState(ScrollState.idle)
        end
        
        updateScroll = false
      
      end
      
      //update the scroll position
      if (prevScrollX != assignScrollX) or (prevScrollY != assignScrollY) then
        //perform the scroll
        commitScrollToYogaNode(assignScrollX, assignScrollY)
        
        // scrollViewDidScroll ?
        if updateScroll then
          scrollX = assignScrollX
          scrollY = assignScrollY
        end
        
      end










