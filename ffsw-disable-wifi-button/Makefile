include $(TOPDIR)/rules.mk

PKG_NAME:=ffsw-disable-wifi-button
PKG_VERSION:=2

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(GLUONDIR)/include/package.mk

PKG_CONFIG_DEPENDS += $(GLUON_I18N_CONFIG)


define Package/ffsw-disable-wifi-button
  SECTION:=gluon
  CATEGORY:=Gluon
  TITLE:=Enable/Disable WiFi Button
  DEPENDS:=gluon-luci-wifi-config
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
	$(call GluonBuildI18N,ffsw-disable-wifi-button,i18n)
	$(call GluonSrcDiet,./luasrc,$(PKG_BUILD_DIR)/luadest/)
endef

define Package/ffsw-disable-wifi-button/install
	$(CP) $(PKG_BUILD_DIR)/luadest/* $(1)/
	$(call GluonInstallI18N,ffsw-disable-wifi-button,$(1))
endef

$(eval $(call BuildPackage,ffsw-disable-wifi-button))
