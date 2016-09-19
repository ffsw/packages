include $(TOPDIR)/rules.mk

PKG_NAME:=ffsw_reboot
PKG_VERSION:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/ffsw_reboot
  SECTION:=gluon
  CATEGORY:=Gluon
  TITLE:=Reboot
  DEPENDS:=
endef

define Package/ffsw_reboot/description
	Reboot Node:
	Reboot Node
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/ffsw_reboot/install
	$(CP) ./files/* $(1)/
endef

$(eval $(call BuildPackage,ffsw_reboot))
