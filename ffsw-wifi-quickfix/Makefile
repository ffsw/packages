include $(TOPDIR)/rules.mk

PKG_NAME:=gluon-quickfix
PKG_VERSION:=1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/ffsw-wifi-quickfix
  SECTION:=gluon
  CATEGORY:=Workaround
  TITLE:=Reboot under certain conditions (loss of mesh neighbours, broken client wifi, unsuccessful anycast ping)
  DEPENDS:=+gluon-core +micrond
endef

define Build/Prepare
        mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/ffsw-wifi-quickfix/install
        $(CP) ./files/* $(1)/
endef

$(eval $(call BuildPackage,ffsw-wifi-quickfix))

