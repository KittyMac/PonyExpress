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
    @cp -R $(framework_ponydir)/$(1)/$(2) $(deps_packagesdir)
		@if [ "$(3)" ]; then cp $(framework_ponydir)/$(1)/lib/$(3) $(deps_libdir_ios); fi
		@if [ "$(4)" ]; then cp $(framework_ponydir)/$(1)/lib/$(4) $(deps_libdir_osx); fi
endef




all: ios

clean:
	rm -rf $(builddir)

ios: confirm build_ios build_library_ios

build_ios:
	$(ponyc) -o $(builddir) --extfun -b "$(product_name)_arm64" -p $(deps_packagesdir) -p ../../../PonyExpressDemo/ -p ../../../ --triple aarch64-apple-ios --pic --features +neon $(debug) -robj

build_library_ios:
	@$(iphonesdk_libtool) -static $(builddir)/*.o -o $(deps_libdir_ios)/lib$(product_name).a
	cp $(builddir)/$(product_name).h $(deps_includedir_ios)/$(product_name).h


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
	@cp -r $(framework_ponydir)/ponyc/build $(ponycdir)
	@cp -r $(framework_ponydir)/ponyc/packages $(ponycdir)
	
	@cp $(framework_ponydir)/ponyc/$(libponyrt_ios_library) $(deps_libdir_ios)/libponyrt-ios.a
	@cp $(framework_ponydir)/ponyc/$(libponyrt_osx_library) $(deps_libdir_osx)/libponyrt-osx.a
	
	@sed "s/<pony\/detail\/atomics.h>/\"atomics.h\"/" $(framework_ponydir)/ponyc/$(libponyrt_header1) > $(deps_includedir_ios)/pony.h
	@sed "s/<pony\/detail\/atomics.h>/\"atomics.h\"/" $(framework_ponydir)/ponyc/$(libponyrt_header1) > $(deps_includedir_osx)/pony.h
	@cp $(framework_ponydir)/ponyc/$(libponyrt_header2) $(deps_includedir_ios)/
	@cp $(framework_ponydir)/ponyc/$(libponyrt_header2) $(deps_includedir_osx)/
	
	#@cp ${ui_build_dir}/ui.h $(includedir_ios)
	#@cp ${ui_build_dir}/ui.h $(includedir_osx)
	
	

framework: confirm framework_ponyc framework_packages



#yoga_lib_dir=/Volumes/Development/Development/pony/pony.yoga/lib
#ui_build_dir=/Volumes/Development/Development/pony/pony.ui/build
#
#iphonesdk_libtool=$(shell xcrun --sdk iphoneos --find libtool)
#
#ponysrc="/Volumes/Development/Development/pony/ponyc/"
#
#ifeq ($(CONFIGURATION),Debug)
#libponyrt_ios_library="/build/debug/lib/ios/libponyrt.a"
#libponyrt_osx_library="/build/debug/lib/native/libponyrt.a"
#else
#libponyrt_ios_library="/build/release/lib/ios/libponyrt.a"
#libponyrt_osx_library="/build/release/lib/native/libponyrt.a"
#endif
#libponyrt_header1="/src/libponyrt/pony.h"
#libponyrt_header2="/src/common/pony/detail/atomics.h"
#
#builddir="./build"
#
#
#libdir_ios="./build/ios/lib"
#libdir_osx="./build/osx/lib"
#
#includedir_ios="./build/ios/include"
#includedir_osx="./build/osx/include"
#
#product_name=starbaseorionapp
#
#all: osx ios
#	
#clean:
#	rm -rf $(builddir)
#
#confirm:
#	mkdir -p $(builddir)
#	mkdir -p $(libdir_ios)
#	mkdir -p $(libdir_osx)
#	mkdir -p $(includedir_ios)
#	mkdir -p $(includedir_osx)
#
#
##$(pony_files) $(header_files) $(json_files)
#build_ios:
#	@echo "Compiling aarch64-apple-ios"
#	@corral run -- $(ponyc) -o $(builddir) -V=0 --extfun -b "$(product_name)_arm64" --triple aarch64-apple-ios --pic --features +neon $(debug) -robj
#
#build_library_ios:
#	@$(iphonesdk_libtool) -static $(builddir)/*.o -o $(libdir_ios)/lib$(product_name).a
#	cp $(builddir)/$(product_name).h $(includedir_ios)/$(product_name).h
#	
#
## $(pony_files) $(header_files) $(json_files)
#build_osx:
#	@echo "Compiling native"	
#	@corral run -- $(ponyc) -o $(builddir) --extfun -b "$(product_name)_x86_64" --pic $(debug) -robj
#
#build_library_osx:
#	@$(iphonesdk_libtool) -static $(builddir)/*.o -o $(libdir_osx)/lib$(product_name).a
#	cp $(builddir)/$(product_name).h $(includedir_osx)/$(product_name).h
#
#
#copy_runtime_and_headers:
#	@cp ${yoga_lib_dir}/*-ios.a $(libdir_ios)
#	@cp ${yoga_lib_dir}/*-osx.a $(libdir_osx)
#	
#	@cp $(ponysrc)/$(libponyrt_ios_library) $(libdir_ios)
#	@cp $(ponysrc)/$(libponyrt_osx_library) $(libdir_osx)
#	
#	@sed "s/<pony\/detail\/atomics.h>/\"atomics.h\"/" $(ponysrc)/$(libponyrt_header1) > $(includedir_ios)/pony.h
#	@sed "s/<pony\/detail\/atomics.h>/\"atomics.h\"/" $(ponysrc)/$(libponyrt_header1) > $(includedir_osx)/pony.h
#	@cp $(ponysrc)/$(libponyrt_header2) $(includedir_ios)/
#	@cp $(ponysrc)/$(libponyrt_header2) $(includedir_osx)/
#	
#	@cp ${ui_build_dir}/ui.h $(includedir_ios)
#	@cp ${ui_build_dir}/ui.h $(includedir_osx)
#
#
#ios: confirm build_ios build_library_ios copy_runtime_and_headers
#	
#osx: confirm build_osx build_library_osx copy_runtime_and_headers
#	
#
#.PHONY: corral-fetch
#corral-fetch:
#	@corral clean -q
#	@corral fetch -q
#
#.PHONY: corral-local
#corral-local:
#	-@rm corral.json
#	-@rm lock.json
#	@corral init -q
#	@corral add /Volumes/Development/Development/pony/StarbaseOrionSchema -q
#	@corral add /Volumes/Development/Development/pony/pony.ttimer -q
#	@corral add /Volumes/Development/Development/pony/pony.stringext -q
#	@corral add /Volumes/Development/Development/pony/pony.yoga -q
#	@corral add /Volumes/Development/Development/pony/ponylang-linal -q
#	@corral add /Volumes/Development/Development/pony/pony.utility -q
#	@corral add /Volumes/Development/Development/pony/pony.ui -q
#
#.PHONY: corral-git
#corral-git:
#	rm -rf ./_corral
#	rm -rf ./_repos
#	-@rm corral.json
#	-@rm lock.json
#	@corral init -q
#	@corral add github.com/KittyMac/StarbaseOrionSchema.git -q
#	@corral add github.com/KittyMac/pony.ttimer.git -q
#	@corral add github.com/KittyMac/pony.stringext.git -q
#	@corral add github.com/KittyMac/pony.yoga.git -q
#	@corral add github.com/KittyMac/ponylang-linal.git -q
#	@corral add github.com/KittyMac/pony.utility.git -q
#	@corral add github.com/KittyMac/pony.ui.git -q
#
#ci: ui_build_dir = ./_corral/github_com_KittyMac_pony_ui/build/
#ci: yoga_lib_dir = ./_corral/github_com_KittyMac_pony_yoga/lib/
#ci: corral-git corral-fetch all
#	
#dev: corral-local corral-fetch all
