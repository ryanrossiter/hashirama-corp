
local function printUsage()
  print( "Usages:" )
  print( "loader get <code> <filename>" )
  print( "loader run <code> <arguments>" )
end

local tArgs = { ... }
if #tArgs < 2 then
  printUsage()
  return
end

if not http then
  printError( "HTTP API is required" )
  printError( "Set http_enable to true in ComputerCraft.cfg" )
  return
end

local function get(url)
  write( "Downloading..." )
  local response = http.get( url )
      
  if response then
      print( "Success." )
      
      local sResponse = response.readAll()
      response.close()
      return sResponse
  else
      print( "Failed." )
  end
end

local sCommand = tArgs[1]
if sCommand == "get" then
  -- Download a file
  if #tArgs < 3 then
      printUsage()
      return
  end

  -- Determine file to download
  local sCode = tArgs[2]
  local sFile = tArgs[3]
  local sPath = shell.resolve( sFile )
  if fs.exists( sPath ) then
      print( "File already exists" )
      return
  end
  
  -- GET the contents from pastebin
  local res = get(sCode)
  if res then        
      local file = fs.open( sPath, "w" )
      file.write( res )
      file.close()
      
      print( "Downloaded as "..sFile )
  end 
elseif sCommand == "run" then
  local sCode = tArgs[2]

  local res = get(sCode)
  if res then
      local func, err = load(res, sCode, "t", _ENV)
      if not func then
          printError( err )
          return
      end
      local success, msg = pcall(func, table.unpack(tArgs, 3))
      if not success then
          printError( msg )
      end
  end
else
  printUsage()
  return
end
