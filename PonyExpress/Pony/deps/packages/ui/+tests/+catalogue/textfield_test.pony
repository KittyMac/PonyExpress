use "yoga"
use "utility"
use "collections"

primitive PerformLogIn is Action

actor TextFieldTest is Controllerable

  let font:Font = Font(TestFontJson())
  
  let emailKey:String = "email"
  let passwordKey:String = "password"
    
	fun ref mainNode():YogaNode iso^ =>
    
    recover iso 
      YogaNode.>center().>paddingAll(6).>safeBottom()
              .>view( Color.>color(RGBA(0.98,0.98,0.98,1)) )
              .>addChildren( [
                                                
            YogaNode.>heightAuto().>maxWidth(600).>minWidth(260).>columns().>center().>paddingAll(40)
                    .>view( Image.>path("dialog_background").>stretchAll(12) )
                    .>addChildren( [
                      
                      YogaNode.>view( Label.>value("Email").>font(font, 18).>sizeToFit() )
                      YogaNode.>height(44).>marginBottom(16)
                              .>focusIdx(0)
                              .>view( Image.>path("dialog_field").>pathFocused("dialog_field_focused").>stretchAll(5) )
                              .>view( TextField.>placeholder("enter your email here").>font(font, 18).>renderInset(2,12,2,12).>eventInsetAll(-6).>sync(this, emailKey) )
                      
                      YogaNode.>view( Label.>value("Password").>font(font, 18).>sizeToFit() )
                      YogaNode.>height(44).>marginBottom(36)
                              .>focusIdx(1)
                              .>view( Image.>path("dialog_field").>pathFocused("dialog_field_focused").>stretchAll(5) )
                              .>view( TextField.>placeholder("enter your password here").>font(font, 18).>secure().>renderInset(2,12,2,12).>eventInsetAll(-12).>action(this, PerformLogIn).>sync(this, passwordKey) )
                      
                      YogaNode.>height(50)
                              .>view( ImageButton( "dialog_button", "dialog_button" ).>stretchAll(12).>pressedColor(RGBA.u32(0x6eb8e5ff)).>eventInsetAll(-12).>action(this, PerformLogIn) )
                              .>view( Label.>value("Continue").>font(font, 24).>center() )
                      
              ])
             
          ])
      end

    be action(evt:Action) =>
      if engine as RenderEngine then
          match evt
          | PerformLogIn => performLogInToServer()
          end
      end
    
    fun ref performLogInToServer() =>
      try
        let email = syncData(emailKey)?
        let password = syncData(passwordKey)?
        
        if (email as String) and (password as String) then
          Log.println("Log into the server. Email is [%s] and password is [%s]", email, password)
        end
      end
      