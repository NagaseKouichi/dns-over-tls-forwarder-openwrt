include $(TOPDIR)/rules.mk

PKG_NAME:=dns-over-tls-forwarder
PKG_VERSION:=0.1.0
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/mikispag/dns-over-tls-forwarder.git
PKG_SOURCE_VERSION:=ca30beb409a6553250d738c89b123eb1c26fba28

PKG_SOURCE_SUBDIR:=$(PKG_NAME)
PKG_SOURCE:=$(PKG_SOURCE_SUBDIR)-$(PKG_VERSION)-$(PKG_SOURCE_VERSION).tar.gz
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_SOURCE_SUBDIR)

PKG_BUILD_DEPENDS:=golang/host
PKG_BUILD_PARALLEL:=1
PKG_USE_MIPS16:=0

GO_PKG:=github.com/mikispag/dns-over-tls-forwarder
GO_PKG_LDFLAGS:=-s -w
GO_PKG_LDFLAGS_X:= \
	$(GO_PKG)/version.Version=$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/golang/golang-package.mk

define Package/$(PKG_NAME)
	SECTION:=net
	CATEGORY:=Network
	TITLE:=A DNS-over-TLS forwarder written in Go
	DEPENDS:=$(GO_ARCH_DEPENDS)
	URL:=https://github.com/mikispag/dns-over-tls-forwarder
endef

define Package/$(PKG_NAME)/description
  A simple, fast DNS-over-TLS forwarding server with hybrid LRU/MFA caching written in Go.
  The server forwards to an user-specified list of upstream DNS-over-TLS servers in parallel, returning and caching the first result received.
endef

define Build/Prepare
	tar -zxvf $(DL_DIR)/$(PKG_SOURCE) -C $(BUILD_DIR)/$(PKG_NAME) --strip-components 1
endef

define Build/Configure
  
endef

define Build/Compile
	$(eval GO_PKG_BUILD_PKG:=$(GO_PKG))
	$(call GoPackage/Build/Configure)
	$(call GoPackage/Build/Compile)
	$(STAGING_DIR_HOST)/bin/upx --lzma --best $(GO_PKG_BUILD_BIN_DIR)/dns-over-tls-forwarder || true
	chmod +wx $(GO_PKG_BUILD_BIN_DIR)/dns-over-tls-forwarder
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(GO_PKG_BUILD_BIN_DIR)/dns-over-tls-forwarder $(1)/usr/bin/dns-over-tls-forwarder
endef
$(eval $(call GoBinPackage,$(PKG_NAME)))
$(eval $(call BuildPackage,$(PKG_NAME)))
