local cbi = require "luci.cbi"
local i18n = require "luci.i18n"
local uci = luci.model.uci.cursor()

local M = {}

function M.section(form)
  
  local f = SimpleForm("wifi", translate("WLAN"))
  f.template = "admin/expertmode"
  
  local s = form:section(cbi.SimpleSection, nil, "WIFI-Button")
  local o
    
  o = s:option(cbi.Flag, "_DisableWifiButton", i18n.translate("Disable WIFI Button"))
  o.default = uci:get_bool("wifi_buttton", "disabled") 
  o.rmempty = true
   
end

function M.handle(data)
  uci:set("wifi_buttton", "disabled", data._meshvpn)
  uci:save("wifi_buttton")
  uci:commit("wifi_buttton")
  
end

return M
