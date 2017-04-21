#!/bin/bash

if [[ -d "upload" ]]; then
	echo "Removing directory 'upload' for fresh file creation"
	rm -r upload
fi

mkdir upload

VERSION=2.11.0.1

cp pom.xml upload/xercesImpl-$VERSION.pom
cp ../build/xercesImpl.jar upload/xercesImpl-$VERSION.jar
jar cf upload/xercesImpl-$VERSION-sources.jar -C ../build/src/ .
jar cf upload/xercesImpl-$VERSION-javadoc.jar ../build/docs/ .

gpg --use-agent --output upload/xercesImpl-$VERSION.pom.asc --detach-sign upload/xercesImpl-$VERSION.pom
gpg --use-agent --output upload/xercesImpl-$VERSION.jar.asc --detach-sign upload/xercesImpl-$VERSION.jar
gpg --use-agent --output upload/xercesImpl-$VERSION-sources.jar.asc --detach-sign upload/xercesImpl-$VERSION-sources.jar
gpg --use-agent --output upload/xercesImpl-$VERSION-javadoc.jar.asc --detach-sign upload/xercesImpl-$VERSION-javadoc.jar