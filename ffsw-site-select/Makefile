include $(TOPDIR)/rules.mk

PKG_NAME:=gluon-config-mode-site-select
PKG_VERSION:=0.2
PKG_RELEASE:=1

PKG_BUILD_DEPENDS := lua-cjson/host

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

PKG_CONFIG_DEPENDS += $(GLUON_I18N_CONFIG)

define Package/gluon-config-mode-site-select
  SECTION:=gluon
  CATEGORY:=Gluon
  TITLE:=UI for changing the node-config
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
	$(call GluonBuildI18N,gluon-config-mode-site-select,i18n)
endef

define Package/gluon-config-mode-site-select/install
	mkdir -p $(1)/etc/config/
	mkdir -p $(1)/lib/gluon/site-select/
	$(CP) ./files/* $(1)/

	lua -e 'print(require("cjson").encode(assert(loadfile("site_config.lua")("$(GLUON_SITEDIR)/extra/ffws.conf"))))' > $(1)/lib/gluon/site-select/ffws.json
	lua -e 'print(require("cjson").encode(assert(loadfile("site_config.lua")("$(GLUON_SITEDIR)/extra/ffwy.conf"))))' > $(1)/lib/gluon/site-select/ffwy.json
	lua -e 'print(require("cjson").encode(assert(loadfile("site_config.lua")("$(GLUON_SITEDIR)/extra/ffvpconf"))))' > $(1)/lib/gluon/site-select/ffvp.json
	lua -e 'print(require("cjson").encode(assert(loadfile("site_config.lua")("$(GLUON_SITEDIR)/extra/ffaw.conf"))))' > $(1)/lib/gluon/site-select/ffaw.json
	lua -e 'print(require("cjson").encode(assert(loadfile("site_config.lua")("$(GLUON_SITEDIR)/extra/ffsl.conf"))))' > $(1)/lib/gluon/site-select/ffsl.json
	DIR=$(1) sh create-config.sh
	
	$(call GluonInstallI18N,gluon-config-mode-site-select,$(1))
endef

$(eval $(call BuildPackage,gluon-config-mode-site-select))
