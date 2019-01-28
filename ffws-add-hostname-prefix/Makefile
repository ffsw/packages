include $(TOPDIR)/rules.mk

PKG_NAME:=ffws-add-hostname-prefix
PKG_VERSION:=1
PKG_RELEASE:=1

include $(TOPDIR)/../package/gluon.mk

define Package/$(PKG_NAME)
  MAINTAINER:=Freifunk Suedwest
  TITLE:=add hostname prefix if non existent
  DEPENDS:=+gluon-core
endef

define Build/Prepare
	$(call Gluon/Build/Prepare)
endef

define Build/Compile
	$(call Gluon/Build/Compile)	
endef

define Package/ffws-add-hostname-prefix/install
	$(Gluon/Build/Install)
	$(CP) $(PKG_BUILD_DIR)/shdest/. $(1)/
endef

define Build/Compile
	$(call GluonSrcDiet,./luasrc,$(PKG_BUILD_DIR)/luadest/)	
endef

define Package/ffho-site-generate/install
	$(CP) $(PKG_BUILD_DIR)/luadest/* $(1)/	
endef

$(eval $(call BuildPackageGluon,$(PKG_NAME)))
