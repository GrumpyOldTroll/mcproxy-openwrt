#
# Copyright (C) 2014-2015 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=mcproxy
PKG_VERSION:=master
PKG_RELEASE:=39eefadfdcfebeab879db0e7d97f354e1d7b202f

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://github.com/GrumpyOldTroll/mcproxy/archive/$(PKG_VERSION)/$(PKG_RELEASE).tar.gz
PKG_MD5SUM:=5a53c4db42bfd2676f0e99342073625d
PKG_MAINTAINER:=Jake Holland <jholland@akamai.com>
#PKG_MAINTAINER:=Steven Barth <cyrus@openwrt.org>
PKG_LICENSE:=GPL-2.0+

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/mcproxy
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Routing and Redirection
  TITLE:=Multicast Proxy for IGMP/MLD
  URL:=http://mcproxy.realmv6.org
  DEPENDS:=+libpthread +libstdcpp @(!GCC_VERSION_4_4&&!GCC_VERSION_4_6)
endef

define Package/mcproxy/description
 mcproxy is a free & open source implementation of the IGMP/MLD proxy function (see  RFC 4605) for Linux systems.
 It operates on the kernel tables for multicast routing and allows for multiple instantiations,
 as well as dynamically changing downstream interfaces.
endef

define Package/mcproxy/conffiles
/etc/config/mcproxy
endef

define Package/mcproxy/install
	$(INSTALL_DIR) $(1)/etc
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/mcproxy.config $(1)/etc/config/mcproxy
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/mcproxy.init $(1)/etc/init.d/mcproxy
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/mcproxy-bin $(1)/usr/sbin/mcproxy
endef

define Package/mcproxy/postinst
#!/bin/sh
# check if we are on real system
if [ -z "$${IPKG_INSTROOT}" ]; then
        echo "Enabling rc.d symlink for mcproxy"
        /etc/init.d/mcproxy enable
fi
exit 0
endef

define Package/mcproxy/prerm
#!/bin/sh
# check if we are on real system
if [ -z "$${IPKG_INSTROOT}" ]; then
        echo "Removing rc.d symlink for mcproxy"
        /etc/init.d/mcproxy disable
fi
exit 0
endef

$(eval $(call BuildPackage,mcproxy,+libpthread))
