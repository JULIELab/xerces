#!/bin/bash

if [[ -d "upload" ]]; then
	echo "Removing directory 'upload' for fresh file creation"
	rm -r upload
fi

mkdir upload

VERSION=2.11

cp pom.xml upload/xercesImpl-$VERSION.pom
cp ../build/xercesImpl.jar upload/xercesImpl-$VERSION.jar
jar cf upload/xercesImpl-$VERSION-sources.jar -C ../build/src/ .
jar cf upload/xercesImpl-$VERSION-javadoc.jar ../build/docs/ .

gpg --output upload/xercesImpl-$VERSION.pom.asc --detach-sign upload/pom.xml
gpg --output upload/xercesImpl-$VERSION.jar.asc --detach-sign upload/xercesImpl-$VERSION.jar
gpg --output upload/xercesImpl-$VERSION-sources.jar.asc --detach-sign upload/xercesImpl-$VERSION-sources.jar
gpg --output upload/xercesImpl-$VERSION-javadoc.jar.asc --detach-sign upload/xercesImpl-$VERSION-javadoc.jar