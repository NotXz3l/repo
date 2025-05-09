local HttpService = game:GetService("HttpService")
local function try(fn, ...)
    return (pcall(fn, ...))
end
loadstring(game:HttpGet("https://raw.githubusercontent.com/NotXz3l/StaleScripts/refs/heads/main/Drawing.luau"))()
getgenv().httppost = function(URL, body, contenttype) 
    return game:HttpPostAsync(URL, body, contenttype)
end
getgenv().type_check = function(argument_position: number, value: any, allowed_types: {any}, optional: boolean?)
	local formatted_arguments = table.concat(allowed_types, " or ")

	if value == nil and not optional and not table.find(allowed_types, "nil") then
		error(("missing argument #%d (expected %s)"):format(argument_position, formatted_arguments), 0)
	elseif value == nil and optional == true then
		return value
	end

	if not (table.find(allowed_types, typeof(value)) or table.find(allowed_types, type(value)) or table.find(allowed_types, value)) and not table.find(allowed_types, "any") then
		error(("invalid argument #%d (expected %s, got %s)"):format(argument_position, formatted_arguments, typeof(value)), 0)
	end

	return value
end
local oldr = request 
getgenv().request = function(options)
	if options.Headers then
		options.Headers["User-Agent"] = "ST4/RobloxApp/2.1"
	else
		options.Headers = {["User-Agent"] = "ST4/RobloxApp/2.1"}
	end
	local response = oldr(options)
	return response
end 
getgenv().hookmetamethod = function(obj, method, hook)
    assert(type(obj) == "table" or type(obj) == "userdata", "Argument #1 (obj) must be a table or userdata")
    assert(type(method) == "string", "Argument #2 (method) must be a string")
    assert(type(hook) == "function", "Argument #3 (hook) must be a function")

    local mt = getmetatable(obj)
    if not mt then
        error("Cannot hook metamethod: object has no metatable", 2)
    end
    local original = mt[method]
    if not original or type(original) ~= "function" then
        error(`Cannot hook metamethod: '{method}' is not a function in the metatable`, 2)
    end
    local is_writable = pcall(function()
        mt[method] = hook
    end)

    if is_writable then
        return original
    else
        local old_environment = getfenv(original)
        local is_hookable = pcall(setfenv, original, old_environment)

        if is_hookable then
            return hookfunction(original, hook, old_environment)
        else
            warn(`Unable to hook metamethod '{method}': metatable is not writable and function is not hookable`)
            return nil
        end
    end
end

getgenv().cclosure = function(f)
    return coroutine.wrap(function(...)
        while true do
            coroutine.yield(f(...))
        end
    end)
end

local function setreadonly(obj, value)
    local mt = getmetatable(obj)
    
    if mt and type(mt) == "table" then
        if value == true then
            mt.__oldindex = mt.__newindex
            mt.__newindex = cclosure(function() error("attempt to modify a readonly table", 0) end)
        else
            if mt.__oldindex then
                mt.__newindex = mt.__oldindex
                mt.__oldindex = nil
            elseif mt.__readonly then
                mt.__newindex = nil
                mt.__readonly = nil
            end
        end
    elseif not mt then
        setmetatable(obj, {
            __newindex = cclosure(function() error("attempt to modify a readonly table", 0) end),
            __readonly = true
        })
    else
        error("unable to safely freeze table")
    end
end

getgenv().getthreadidentity = function()
	local securityChecks = {
		{
			name = "None",
			number = 0,
			canAccess = try(function() return game.Name end)
		},
		{
			name = "PluginSecurity",
			number = 1,
			canAccess = try(function() return game:GetService("CoreGui").Name end)
		},
		{
			name = "LocalUserSecurity",
			number = 3,
			canAccess = try(function() return game.DataCost end)
		},
		{
			name = "WritePlayerSecurity",
			number = 4,
			canAccess = try(Instance.new, "Player")
		},
		{
			name = "RobloxScriptSecurity",
			number = 5,
			canAccess = try(function() return game:GetService("CorePackages").Name end)
		},
		{
			name = "RobloxSecurity",
			number = 6,
			canAccess = try(function() return Instance.new("SurfaceAppearance").TexturePack end)
		},
		{
			name = "NotAccessibleSecurity",
			number = 7,
			canAccess = try(function() Instance.new("MeshPart").MeshId = "" end)
		}
	}
	local lasti = 1
	for i = 1, #securityChecks do
		if securityChecks[i].canAccess then
			lasti = i
		else
			return lasti
		end
	end
	return lasti
end
loadstring(game:HttpGet("http://luau-executors.github.io/assets/Security.luau"))()
