include $(TOPDIR)/rules.mk

PKG_NAME:=ffsw-ssid-changer
PKG_VERSION:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/ffsw-ssid-changer
  SECTION:=gluon
  CATEGORY:=Gluon
  TITLE:=SSID Changer
  DEPENDS:=+gluon-core
endef

define Build/Prepare
        mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/ffsw-ssid-changer/install
        $(CP) ./files/* $(1)/
endef

$(eval $(call BuildPackage,ffsw-ssid-changer))
