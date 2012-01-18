#export THEOS_DEVICE_IP=192.168.0.9
SDKVERSION = 5.0
include theos/makefiles/common.mk

LIBRARY_NAME = SlideCenter
SlideCenter_FILES = SlideCenter.m TouchFix/TouchFix.m SCInfoView.m SCSlideView.m
SlideCenter_INSTALL_PATH = /System/Library/WeeAppPlugins/SlideCenter.bundle
SlideCenter_FRAMEWORKS = UIKit CoreGraphics QuartzCore AssetsLibrary
SlideCenter_PRIVATE_FRAMEWORKS = BulletinBoard

include $(THEOS_MAKE_PATH)/library.mk

after-install::
	mv _/System/Library/WeeAppPlugins/SlideCenter.bundle/SlideCenter.dylib _/System/Library/WeeAppPlugins/SlideCenter.bundle/SlideCenter