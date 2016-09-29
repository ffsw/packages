include $(TOPDIR)/rules.mk

PKG_NAME:=ffsw-keyupl
PKG_VERSION:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/ffsw-keyupl
  SECTION:=gluon
  CATEGORY:=Gluon
  TITLE:=VPN-Key-Upload
  DEPENDS:=
endef

define Package/ffsw-keyupl/description
	Key Upload:
	Key Upload every Hour
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/ffsw-keyupl/install
	$(CP) ./files/* $(1)/
endef

$(eval $(call BuildPackage,ffsw-keyupl))
