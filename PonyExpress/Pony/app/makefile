builddir=./build

iphonesdk_libtool=$(shell xcrun --sdk iphoneos --find libtool)

product_name=app

ponycdir=../ponyc

depsdir=../deps
deps_packagesdir=../deps/packages
deps_libdir_ios=../deps/ios/libs
deps_libdir_osx=../deps/osx/libs
deps_includedir_ios=../deps/ios/include
deps_includedir_osx=../deps/osx/include

framework_ponydir=/Volumes/Development/Development/pony

ifeq ($(CONFIGURATION),Debug)
debug="--debug"
ponyc=../ponyc/build/debug/ponyc
else
ponyc=../ponyc/build/release/ponyc
endif

ifeq ($(CONFIGURATION),Debug)
libponyrt_ios_library="/build/debug/lib/ios/libponyrt.a"
libponyrt_osx_library="/build/debug/lib/native/libponyrt.a"
else
libponyrt_ios_library="/build/release/lib/ios/libponyrt.a"
libponyrt_osx_library="/build/release/lib/native/libponyrt.a"
endif
libponyrt_header1="/src/libponyrt/pony.h"
libponyrt_header2="/src/common/pony/detail/atomics.h"


define copy_framework_package
		@rsync -qav --delete $(framework_ponydir)/$(1)/$(2) $(deps_packagesdir)
		@if [ "$(3)" ]; then rsync -qav --delete $(framework_ponydir)/$(1)/lib/$(3) $(deps_libdir_ios); fi
		@if [ "$(4)" ]; then rsync -qav --delete $(framework_ponydir)/$(1)/lib/$(4) $(deps_libdir_osx); fi
endef

all: framework ios osx

lldb: framework confirm
	lldb ../ponyc/build/debug/ponyc -- -o $(builddir) --extfun -b "$(product_name)_x86_64"  -p $(deps_packagesdir) -p ../../../PonyExpressDemo/ -p ../../../  --pic --debug -robj

clean:
	rm -rf $(builddir)

ios: confirm build_ios build_library_ios

build_ios:
	$(ponyc) -o $(builddir) --extfun -b "$(product_name)_arm64" -p $(deps_packagesdir) -p ../../../PonyExpressDemo/ -p ../../../ --triple aarch64-apple-ios --pic --features +neon $(debug) -robj

build_library_ios:
	@$(iphonesdk_libtool) -static $(builddir)/*.o -o $(deps_libdir_ios)/lib$(product_name)-ios.a
	cp -p $(builddir)/$(product_name).h $(deps_includedir_ios)/$(product_name).h


osx: confirm build_osx build_library_osx

build_osx:
	$(ponyc) -o $(builddir) --extfun -b "$(product_name)_x86_64"  -p $(deps_packagesdir) -p ../../../PonyExpressDemo/ -p ../../../  --pic $(debug) -robj

build_library_osx:
	@$(iphonesdk_libtool) -static $(builddir)/*.o -o $(deps_libdir_osx)/lib$(product_name)-osx.a
	cp -p $(builddir)/$(product_name).h $(deps_includedir_osx)/$(product_name).h

confirm:
	@mkdir -p $(builddir)
	
	@mkdir -p $(ponycdir)
	@mkdir -p $(depsdir)
	@mkdir -p $(deps_packagesdir)
	@mkdir -p $(deps_libdir_ios)
	@mkdir -p $(deps_libdir_osx)
	@mkdir -p $(deps_includedir_ios)
	@mkdir -p $(deps_includedir_osx)
	


framework_packages: confirm
	$(call copy_framework_package,pony.fileExt,fileExt)
	$(call copy_framework_package,pony.bitmap,bitmap,libponybitmap-ios.a,libponybitmap-osx.a)
	$(call copy_framework_package,pony.flow,flow)
	$(call copy_framework_package,ponylang-linal,linal)
	$(call copy_framework_package,pony.png,png)
	$(call copy_framework_package,pony.stringExt,stringExt)
	$(call copy_framework_package,pony.ttimer,ttimer)
	$(call copy_framework_package,pony.ui,ui)
	$(call copy_framework_package,pony.utility,utility)
	$(call copy_framework_package,pony.yoga,yoga,libyoga-ios.a,libyoga-osx.a)

.PHONY: framework_packages
.PHONY: confirm

framework_ponyc:
	@rsync -qav --delete $(framework_ponydir)/ponyc/build $(ponycdir)
	@rsync -qav --delete $(framework_ponydir)/ponyc/packages $(ponycdir)
	
	@cp -p $(framework_ponydir)/ponyc/$(libponyrt_ios_library) $(deps_libdir_ios)/libponyrt-ios.a
	@cp -p $(framework_ponydir)/ponyc/$(libponyrt_osx_library) $(deps_libdir_osx)/libponyrt-osx.a
	
	@sed "s/<pony\/detail\/atomics.h>/\"atomics.h\"/" $(framework_ponydir)/ponyc/$(libponyrt_header1) > $(deps_includedir_ios)/pony.h
	@sed "s/<pony\/detail\/atomics.h>/\"atomics.h\"/" $(framework_ponydir)/ponyc/$(libponyrt_header1) > $(deps_includedir_osx)/pony.h
	@cp -p $(framework_ponydir)/ponyc/$(libponyrt_header2) $(deps_includedir_ios)/
	@cp -p $(framework_ponydir)/ponyc/$(libponyrt_header2) $(deps_includedir_osx)/
	
	
ifeq ("$(USER)", "rjbowli")
framework: confirm framework_ponyc framework_packages
else
framework:
endif



