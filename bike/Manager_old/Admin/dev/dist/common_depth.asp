<%

  if iDepth = 0 then
    global_depth = "."
  elseif iDepth = 1 then
    global_depth = ".."
  elseif iDepth = 2 then
    global_depth = "../.."
  elseif iDepth = 3 then
    global_depth = "../../.."
  elseif iDepth = 4 then
    global_depth = "../../../.."
  elseif iDepth = 5 then
    global_depth = "../../../../.."
  else
    global_depth = "."
  end if
 
 %>