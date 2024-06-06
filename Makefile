PHP_VERSION := 8.3.7

IMAGE := php$(PHP_VERSION)-builder

MOUNT := -v ./rpmbuild/SOURCES:/root/rpmbuild/SOURCES \
         -v ./rpmbuild/SPECS:/root/rpmbuild/SPECS \
         -v ./rpmbuild/RPMS:/root/rpmbuild/RPMS \
         -v ./rpmbuild/SRPMS:/root/rpmbuild/SRPMS

SOURCES := rpmbuild/SOURCES/php-$(PHP_VERSION).tar.xz \
           rpmbuild/SOURCES/php-$(PHP_VERSION).tar.xz.asc

TARGET := build-arm64 \
          build-amd64

all: build

build: $(SOURCES) $(TARGET)

rpmbuild/SOURCES/php-$(PHP_VERSION).tar.xz:
	curl -f -o $@ -LO https://www.php.net/distributions/$(@F)

rpmbuild/SOURCES/php-$(PHP_VERSION).tar.xz.asc:
	curl -f -o $@ -LO https://www.php.net/distributions/$(@F)

build-%:
	docker build --build-arg PLATFORM=linux/$* -t $(IMAGE):$* .
	docker run --rm $(MOUNT) $(IMAGE):$*

clean:
	-$(RM) -r rpmbuild/{RPMS,SRPMS}
	-$(RM) rpmbuild/SOURCES/php-$(PHP_VERSION).tar.xz
	-$(RM) rpmbuild/SOURCES/php-$(PHP_VERSION).tar.xz.asc

clean-image:
	-docker rmi $(shell docker images --filter=reference="$(IMAGE):*" -q)

.PHONY: all build clean clean-image
