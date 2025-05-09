repeat task.wait(0.65) until game:IsLoaded()
local HttpService = game:GetService("HttpService")
local function try(fn, ...)
    return (pcall(fn, ...))
end
game.CoreGui:SetCore("SendNotification", {
	Title = "[STALE]";
	Text = "pwned by stale";
	Duration = 2;
})
for _, con in next, getconnections(game:GetService("LogService").MessageOut) do
    con:Disable()
end
getgenv().httppost = function(URL, body, contenttype) 
    return game:HttpPostAsync(URL, body, contenttype)
end
getgenv().identifyexecutor = function()
    return "Stale v2.0.0"
end
getgenv().executorname = identifyexecutor
getgenv().whatexecutorname = identifyexecutor
getgenv().getconnections(rl) = function()
    if type(rl) ~= "userdata" then
        error("expected userdata as the first argument", 2)
    end
    local connect = rl.connect
    if not connect then
        error("userdata does not have a 'connect' method", 2)
    end
    local signal = connect(rl, function() end)
    local next = signal.nextsignal
    local connections = {}
    local count = 1
    while next ~= 0 do
        if connection_environment.connections[next] then
            table.insert(connections, connection_environment.connections[next])
        else
            local new_connection = {
                object = next,
                oldstate = next.state
            }
            table.insert(connections, new_connection)
            connection_environment.connections[next] = new_connection
        end
        next = next.nextsignal
        count = count + 1
    end
    signal:disconnect()
    return connections
end
local oldr = request
getgenv().request = function(options)
	if options.Headers then
		options.Headers["User-Agent"] = "STL/RobloxApp/2.1"
	else
		options.Headers = {["User-Agent"] = "STL/RobloxApp/2.1"}
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
local libs = {
    {
        ['name'] = "Environment Wrapper",
        ['url'] = "http://luau-executors.github.io/assets/Security.luau"
    }
}
local function load_lib(libName)
    for _, lib in ipairs(libs) do
        if lib.name == libName then
            local response = game:HttpGet(lib.url)
            return loadstring(response)()
        end
    end
    return nil
end
load_lib("Environment Wrapper")
